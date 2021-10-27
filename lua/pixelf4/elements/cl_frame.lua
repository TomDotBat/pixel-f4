
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

function PANEL:Init()
    self:SetSize(PIXEL.Scale(1040), PIXEL.Scale(640))
    self:Center()
    self:MakePopup()

    self:SetSizable(true)
    self:SetDraggable(true)

    self:SetMinWidth(PIXEL.Scale(940))
    self:SetMinHeight(PIXEL.Scale(580))

    self:SetTitle(PIXEL.F4.Config.MenuTitle)

    local sidebar = self:CreateSidebar("Dashboard", PIXEL.F4.Config.SidebarLogo, nil, PIXEL.Scale(10), PIXEL.Scale(20))

    sidebar:AddItem("Dashboard", "Dashboard", "dkErdSv", function() self:ChangeTab("PIXEL.F4.Dashboard", "Dashboard") end)
    sidebar:AddItem("Jobs", "Jobs", "v5e4tGV", function() self:ChangeTab("PIXEL.F4.Jobs", "Jobs") end)
    sidebar:AddItem("Entities", "Entities", "Be1LD3X", function() self:ChangeTab("PIXEL.F4.Entities", "Entities") end)
    sidebar:AddItem("Weapons", "Weapons", "tMz2fGT", function() self:ChangeTab("PIXEL.F4.Weapons", "Weapons") end)

    local add = function(idname, imgur, pnl)
        sidebar:AddItem(idname, idname, imgur, function() self:ChangeTab(pnl, id) end)
    end
    hook.Run("PIXEL.F4.PopulateSidebar", add)

    sidebar.Links = {}

    for k,v in ipairs(PIXEL.F4.Config.WebsiteLinks) do
        local btn = vgui.Create("PIXEL.SidebarItem", sidebar)
        btn:Dock(BOTTOM)
        btn:SetName(v.Name)
        btn:SetImgurID(v.ImgurID)
        btn.DoClick = function()
            if v.Link then
                gui.OpenURL(v.Link)
            end

            if v.ChatCommand then
                RunConsoleCommand("say", v.ChatCommand)
            end
        end

        sidebar.Links[k] = btn
    end

    local oldPerformLayout = sidebar.PerformLayout
    function sidebar:PerformLayout(w, h)
        oldPerformLayout(self, w, h)

        local height = PIXEL.Scale(35)
        local spacing = PIXEL.Scale(8)
        for k,v in ipairs(self.Links) do
            v:SetTall(height)
            v:DockMargin(0, 0, 0, k == 1 and 0 or spacing)
        end
    end

    function self.CloseButton.DoClick()
        PIXEL.F4.ToggleMenu()
    end

    function self:Paint(w, h)
        PIXEL.DrawRoundedBox(PIXEL.Scale(4), 0, 0, w, h, PIXEL.Colors.Background)
        self:PaintHeader(0, 0, w, PIXEL.Scale(30))
    end

    function self:PaintOver(w,h)
        if not self.NeedsToDrawHeaderRedo then return end
        self.NeedsToDrawHeaderRedo = false

        surface.SetDrawColor(PIXEL.Colors.Background)
        surface.DrawRect(0, 0, 5, 5)

        self:PaintHeader(0, 0, w, PIXEL.Scale(30))
    end

    function self:OnChildAdded(ch)
        self.NeedsToDrawHeaderRedo = true
    end
end

function PANEL:ChangeTab(panel)
    if not self.SideBar:IsMouseInputEnabled() then return end

    if not IsValid(self.ContentPanel) then
        self.ContentPanel = vgui.Create(panel, self)
        self.ContentPanel:Dock(FILL)

        function self.ContentPanel.Think(s)
            if not self.DragThink then return end
            if self:DragThink(self) then return end
            if self:SizeThink(self, s) then return end

            self:SetCursor("arrow")

            if self.y < 0 then
                self:SetPos(self.x, 0)
            end
        end

        function self.ContentPanel.OnMousePressed()
            self:OnMousePressed()
        end

        function self.ContentPanel.OnMouseReleased()
            self:OnMouseReleased()
        end

        return
    end

    self.SideBar:SetMouseInputEnabled(false)

    self.ContentPanel:AlphaTo(0, .15, 0, function(anim, pnl)
        self.ContentPanel:Remove()
        self.ContentPanel = vgui.Create(panel, self)
        self.ContentPanel:Dock(FILL)
        self.ContentPanel:AlphaTo(255, .15, 0, function(anim2, pnl2)
            self.SideBar:SetMouseInputEnabled(true)
        end)
    end)
end

function PANEL:LayoutContent(w, h)
    if not IsValid(self.ContentPanel) then return end
    self:DockPadding(PIXEL.Scale(200), PIXEL.Scale(30), 0, 0)
end

function PANEL:OnKeyCodePressed(key)
    if self.NextInput and CurTime() < self.NextInput then return end
    self.NextInput = CurTime() + 1

    if key == KEY_F4 then
        PIXEL.F4.Opened = false
        self:Close()
        return
    end

    if key == KEY_F and input.IsControlDown() then
        if not IsValid(self.ContentPanel) then return end
        if not IsValid(self.ContentPanel.SearchBar) then return end

        TextEntryLoseFocus()
        self.ContentPanel.SearchBar.Entry.TextEntry:RequestFocus()
    end
end

vgui.Register("PIXEL.F4.Frame", PANEL, "PIXEL.Frame")

PIXEL.F4.Frame:Remove()
