
--[[
    PIXEL F4
    Copyright (C) 2021 Tom O'Sullivan (Tom.bat)

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License.
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
]]

local PANEL = {}

PIXEL.RegisterFont("F4.SelectedJobName", "Open Sans Bold", 30, 600)
PIXEL.RegisterFont("F4.SelectedJobSalary", "Open Sans SemiBold", 18)
PIXEL.RegisterFont("F4.SelectedJobDescription", "Open Sans SemiBold", 18)
PIXEL.RegisterFont("F4.SelectedJobButton", "Open Sans SemiBold", 22)
PIXEL.RegisterFont("F4.SelectedJobWeapons", "Open Sans SemiBold", 18)
PIXEL.RegisterFont("F4.SelectedJobTag", "Open Sans SemiBold", 70)

AccessorFunc(PANEL, "sName", "Name", FORCE_STRING)
AccessorFunc(PANEL, "sSalary", "Salary", FORCE_STRING)
AccessorFunc(PANEL, "sDescription", "Description", FORCE_STRING)
AccessorFunc(PANEL, "bVote", "Vote", FORCE_BOOL)
AccessorFunc(PANEL, "sCommand", "Command", FORCE_STRING)
AccessorFunc(PANEL, "nTeamNo", "TeamNo", FORCE_NUMBER)
AccessorFunc(PANEL, "rRankTag", "RankTag")

function PANEL:Init()
    self.Model = vgui.Create("DModelPanel", self)
    self.Model:SetMouseInputEnabled(true)
    self.Model.LayoutEntity = function() end
    self.Model:SetCamPos(Vector(50, 0, 46))
    self.Model:SetLookAt(Vector(0, 0, 37))
    self.Model:SetFOV(45)

    local oldSetModel = self.Model.SetModel
    function self.Model:SetModel(mdl)
        if IsValid(self.Entity) and IsValid(self.Entity.Weapon) then
            self.Entity.Weapon:Remove()
        end

        oldSetModel(self, mdl)

        self:SetWeapon()
    end

    function self.Model:SetWeapon(weaponClass)
        if not IsValid(self.Entity) then return end
        if IsValid(self.Entity.Weapon) then
            self.Entity.Weapon:Remove()
        end

        self.HeldWeapon = weaponClass

        if not weaponClass then
            local sequence = self.Entity:LookupSequence("walk_all")

            if sequence <= 0 then sequence = self.Entity:LookupSequence("WalkUnarmed_all") end
            if sequence <= 0 then sequence = self.Entity:LookupSequence("walk_all_moderate") end

            if sequence > 0 then self.Entity:ResetSequence(sequence) end

            return
        end

        local sequence = self.Entity:LookupSequence("idle_passive")
        if not sequence then return end
        self.Entity:SetSequence(sequence)

        local attachment = self.Entity:LookupAttachment("anim_attachment_RH")
        if not attachment then return end

        local attachmentPos = (self.Entity:GetAttachment(attachment) or {}).Pos
        if not attachmentPos then return end

        local weaponModel = (weapons.Get(weaponClass) or PIXEL.F4.Config.WeaponOverrides[weaponClass]).WorldModel

        self.Entity.Weapon = ClientsideModel(weaponModel)
        if not IsValid(self.Entity.Weapon) then return end

        self.Entity.Weapon:SetOwner(self.Entity)
        self.Entity.Weapon:SetPos(attachmentPos)
        self.Entity.Weapon:SetSolid(SOLID_NONE)
        self.Entity.Weapon:SetParent(self.Entity)
        self.Entity.Weapon:SetNoDraw(true)
        self.Entity.Weapon:SetIK(false)
        self.Entity.Weapon:AddEffects(EF_BONEMERGE)
        self.Entity.Weapon:SetAngles(self.Entity:GetForward():Angle())

        local matrix = Matrix()
        matrix:Scale(Vector(0.5, 0.5, 0.5))
        self.Entity.Weapon:EnableMatrix("RenderMultiply", matrix)
        self.Entity.Weapon:Spawn()
    end

    function self.Model:GetWeapon()
        return self.HeldWeapon
    end

    function self.Model:OnRemove()
        if not (IsValid(self.Entity) and IsValid(self.Entity.Weapon)) then return end
        self.Entity.Weapon:Remove()
    end

    function self.Model:PostDrawModel()
        if not (IsValid(self.Entity) and IsValid(self.Entity.Weapon)) then return end
        self.Entity.Weapon:DrawModel()
    end

    self.Model.LeftButton = vgui.Create("PIXEL.Button", self.Model)
    self.Model.RightButton = vgui.Create("PIXEL.Button", self.Model)

    self.Model.OldPerformLayout = self.Model.PerformLayout or function() end

    local size = PIXEL.Scale(50)
    function self.Model:PerformLayout(w, h)
        size = PIXEL.Scale(50)
        if not IsValid(self.LeftButton) then return end
        self:OldPerformLayout(w, h)
        self.LeftButton:SetPos(0, 0)
        self.LeftButton:SetSize(w / 2, h)

        self.RightButton:SetPos(w / 2 , 0)
        self.RightButton:SetSize(w / 2, h)
    end

    function self.Model.LeftButton:Paint(w, h)
        local bgCol = PIXEL.Colors.PrimaryText

        if self:IsDown() or self:GetToggle() then
            bgCol = PIXEL.Colors.SecondaryText
        elseif self:IsHovered() then
            bgCol = PIXEL.Colors.Disabled
        end

        self.BackgroundCol = PIXEL.LerpColor(FrameTime() * 12, self.BackgroundCol, bgCol)

        PIXEL.DrawImgurRotated(5 + size / 2, h / 2 - size, size, size, 180, "Dy4zhm7", self.BackgroundCol)
    end

    function self.Model.RightButton:Paint(w, h)
        local bgCol = PIXEL.Colors.PrimaryText

        if self:IsDown() or self:GetToggle() then
            bgCol = PIXEL.Colors.SecondaryText
        elseif self:IsHovered() then
            bgCol = PIXEL.Colors.Disabled
        end

        self.BackgroundCol = PIXEL.LerpColor(FrameTime() * 12, self.BackgroundCol, bgCol)

        PIXEL.DrawImgurRotated(w - size / 2 - 5, h / 2 - size, size, size, 0, "Dy4zhm7", self.BackgroundCol)
    end

    self.CloseBtn = vgui.Create("PIXEL.Button", self)
    self.CloseBtn.Paint = nil
    self.CloseBtn.DoClick = function()
        self:Close()
    end

    self.BecomeBtn = vgui.Create("PIXEL.TextButton", self)
    self.BecomeBtn:SetFont("F4.SelectedJobButton")
    self.BecomeBtn.DoClick = function()
        if self:GetVote() then
            RunConsoleCommand("darkrp", "vote" .. self:GetCommand())
        else
            RunConsoleCommand("darkrp", self:GetCommand())
        end

        self:Close()
        PIXEL.F4.ToggleMenu()
    end

    self.TutorialBtn = vgui.Create("PIXEL.TextButton", self)
    self.TutorialBtn:SetFont("F4.SelectedJobButton")
    self.TutorialBtn:SetText("View Tutorial")
    self.TutorialBtn.DoClick = function()
        local teamConfig = PIXEL.Tutorials[self:GetTeamNo()]
        if not teamConfig then return end

        chat.AddText("Opening the tutorial for " .. teamConfig[1] .. "...")
        gui.OpenURL(teamConfig[2])
    end

    self:SetAlpha(0)
    self:AlphaTo(255, .15, 0)
end

function PANEL:Close()
    self.Model:SetVisible(false)
    self:AlphaTo(0, .15, 0, function(anim, pnl)
        pnl:Remove()
    end)
end

function PANEL:SelectJob(jobData, teamNo)
    self.jobData = jobData

    self:GenerateWeapons(jobData)

    self:SetName(jobData.name)
    self:SetSalary("Salary: " .. PIXEL.FormatMoney(jobData.salary))
    self:SetDescription(jobData.description)
    self:SetVote(jobData.vote)
    self:SetCommand(jobData.command)
    self:SetTeamNo(teamNo)
    self:SetRankTag(PIXEL.F4.Config.RankTags[jobData.rankTag])

    self.BecomeBtn:SetText(jobData.vote and "Start Vote" or "Become")

    if not (PIXEL.Tutorials and PIXEL.Tutorials[teamNo]) then
        self.TutorialBtn:Remove()
    end

    local models = jobData.model
    if istable(models) and #models ~= 1 then
        self.ModelIndex = math.random(1, #models)
    else
        self.Model:SetModel(istable(models) and models[1] or models)

        self.Model.LeftButton:Remove()
        self.Model.RightButton:Remove()
        return
    end

    DarkRP.setPreferredJobModel(teamNo, models[self.ModelIndex])
    self.Model:SetModel(models[self.ModelIndex])

    self.Model.LeftButton.DoClick = function(s)
        self.ModelIndex = self.ModelIndex - 1

        if self.ModelIndex <= 0 then
            self.ModelIndex = #models
        end

        self.Model:SetModel(models[self.ModelIndex])
        DarkRP.setPreferredJobModel(teamNo, models[self.ModelIndex])
    end

    self.Model.RightButton.DoClick = function(s)
        self.ModelIndex = self.ModelIndex + 1

        if self.ModelIndex > #models then
            self.ModelIndex = 1
        end

        self.Model:SetModel(models[self.ModelIndex])
        DarkRP.setPreferredJobModel(teamNo, models[self.ModelIndex])
    end
end

function PANEL:GenerateWeapons(jobData)
    if not istable(jobData.weapons) then return end

    local wepHeight = PIXEL.Scale(35)
    local pad = PIXEL.Scale(5)

    for i, weaponClass in ipairs(jobData.weapons) do
        if i >= 6 then break end

        local wepMeta = weapons.Get(weaponClass) or PIXEL.F4.Config.WeaponOverrides[weaponClass]
        if not wepMeta then continue end

        local wepBtn = vgui.Create("PIXEL.Button", self.Model)
        wepBtn:Dock(BOTTOM)
        wepBtn:SetTall(wepHeight)
        wepBtn:DockMargin(pad, 0, pad, pad)
        wepBtn.DisplayWidth = 0

        function wepBtn:PerformLayout(w, h)
            self.EllipsesText = PIXEL.EllipsesText(wepMeta.PrintName, w, "F4.SelectedJobWeapons")
        end

        function wepBtn:Paint(w, h)
            PIXEL.DrawRoundedBox(PIXEL.Scale(6), 0, 0, self.DisplayWidth, h, PIXEL.F4.Colors.RecentsBoxes)

            if self.EllipsesText then
                PIXEL.DrawSimpleText(self.EllipsesText, "F4.SelectedJobWeapons", self.DisplayWidth - w + wepHeight + PIXEL.Scale(10), h / 2, PIXEL.Colors.PrimaryText, 0, 1)
            end

            PIXEL.DrawRoundedBox(PIXEL.Scale(6), 0, 0, h, h, PIXEL.F4.Colors.RecentsContainer)
        end

        function wepBtn.Think(s)
            if s:IsHovered() then
                self.HoveredWeapon = weaponClass
                s.DisplayWidth = Lerp(FrameTime() * 10, s.DisplayWidth, s:GetWide())
            else
                if self.HoveredWeapon == weaponClass then self.HoveredWeapon = nil end
                s.DisplayWidth = Lerp(FrameTime() * 10, s.DisplayWidth, 0)
            end
        end

        wepBtn.ModelImage = vgui.Create("ModelImage", wepBtn)
        wepBtn.ModelImage:SetPos(PIXEL.Scale(5), PIXEL.Scale(5))
        wepBtn.ModelImage:SetSize(wepHeight - PIXEL.Scale(10), wepHeight - PIXEL.Scale(10))
        wepBtn.ModelImage:SetModel(wepMeta.WorldModel or "")
        wepBtn.ModelImage:SetMouseInputEnabled(false)
    end
end

function PANEL:Think()
    if self.Model:GetWeapon() ~= self.HoveredWeapon then
        self.Model:SetWeapon(self.HoveredWeapon)
    end
end

function PANEL:Paint(w, h)
    local pad = PIXEL.Scale(24)

    PIXEL.DrawBlur(self, 0, 0, w, h)

    local boxW = math.Round(PIXEL.Scale(300))
    local boxX = math.Round(w - boxW)
    PIXEL.DrawRoundedBoxEx(PIXEL.Scale(6), boxX, 0, boxW, h, PIXEL.F4.Colors.SelectedJob.ModelBackground, false, false, false, true)

    boxW = math.Round(PIXEL.Scale(320))
    boxX = math.Round(boxX - boxW)
    surface.SetDrawColor(PIXEL.F4.Colors.SelectedJob.InfoBackground)
    surface.DrawRect(boxX, 0, boxW, h)

    local nameH = select(2, PIXEL.DrawSimpleText(self:GetName(), "F4.SelectedJobName", boxX + pad, pad, PIXEL.F4.Colors.SelectedJob.Name))

    local salaryY = pad + PIXEL.Scale(2) + nameH
    local salaryH = select(2, PIXEL.DrawSimpleText(self:GetSalary(), "F4.SelectedJobSalary", boxX + pad, salaryY, PIXEL.F4.Colors.SelectedJob.Salary))

    local descX, descY = boxX + pad, salaryY + salaryH + pad
    local descW, descH = boxW - pad * 2, h * .65

    local descPad = PIXEL.Scale(6)

    PIXEL.DrawRoundedBox(PIXEL.Scale(6), descX, descY, descW, descH, PIXEL.F4.Colors.SelectedJob.DescriptionBox)
    PIXEL.DrawText(PIXEL.WrapText(self:GetDescription(), descW - descPad * 2, "F4.SelectedJobDescription"), "F4.SelectedJobDescription", descX + descPad, descY + descPad, PIXEL.F4.Colors.SelectedJob.Description)
end

function PANEL:PerformLayout(w, h)
    local boxW = PIXEL.Scale(300)
    local boxX = math.Round(w - boxW) - math.Round(PIXEL.Scale(320))

    self.Model:SetPos(boxX + math.Round(PIXEL.Scale(320)), 0)
    self.Model:SetSize(boxW, h)

    self.CloseBtn:SetSize(boxX, h)

    local buttonH = PIXEL.Scale(36)

    if IsValid(self.TutorialBtn) then
        local pad = PIXEL.Scale(24)
        local buttonsY = h - PIXEL.Scale(25) - buttonH
        local buttonW = PIXEL.Scale(120)

        self.BecomeBtn:SetPos(boxX + pad, buttonsY)
        self.BecomeBtn:SetSize(buttonW, buttonH)

        self.TutorialBtn:SetPos(boxX + boxW - buttonW - PIXEL.Scale(4), buttonsY)
        self.TutorialBtn:SetSize(buttonW, buttonH)
    else
        local becomeW = PIXEL.Scale(120)
        self.BecomeBtn:SetPos(boxX + PIXEL.Scale(10) + (boxW / 2) - (becomeW / 2), h - PIXEL.Scale(25) - buttonH)
        self.BecomeBtn:SetSize(becomeW, buttonH)
    end
end

vgui.Register("PIXEL.F4.SelectedJob", PANEL, "Panel")
