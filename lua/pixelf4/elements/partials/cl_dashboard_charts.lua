
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

PIXEL.RegisterFont("F4.ChartsName", "Open Sans SemiBold", 20, 400)
PIXEL.RegisterFont("F4.ChartsStat", "Open Sans SemiBold", 22)
PIXEL.RegisterFont("F4.LocalPlayerName", "Open Sans SemiBold", 21)
PIXEL.RegisterFont("F4.LocalPlayerMoney", "Open Sans SemiBold", 20)

function PANEL:Init()
    self.Charts = {}

    local overlayCol = PIXEL.Colors.Header

    local playersOnline = vgui.Create("PIXEL.PieChart", self)

    local plyCount = player.GetCount()
    local maxPlys = game.MaxPlayers()
    local onlineAng = (plyCount / maxPlys) * 360
    playersOnline.AnimProg = 1

    playersOnline:AddSegment(nil, onlineAng, PIXEL.F4.Colors.PlayersChartOnline)
    playersOnline:AddSegment(nil, 360 - onlineAng, PIXEL.F4.Colors.PlayersChartOffline)

    local plyTitleTable = {"Players Online", "F4.ChartsName", PIXEL.F4.Colors.ChartLabel, 1, PIXEL.Scale(2)}
    local plySubTitleTable = {plyCount .. "/" .. maxPlys, "F4.ChartsStat", PIXEL.F4.Colors.ChartLabel, 1, PIXEL.Scale(2)}

    function playersOnline:PaintOver(w, h)
        local centerX, centerY = w / 2, h / 2
        local diameter = math.min(w, h) - PIXEL.Scale(15)
        PIXEL.DrawCircle(centerX - diameter / 2, centerY - diameter / 2, diameter, diameter, overlayCol)

        PIXEL.DrawDualText(plyTitleTable, plySubTitleTable, w / 2, h / 2)
    end

    table.insert(self.Charts, playersOnline)

    local jobDistribution = vgui.Create("PIXEL.PieChart", self)

    jobDistribution.AnimProg = 1
    for k,v in pairs(team.GetAllTeams()) do
        if k > 1000 then break end

        local teamPlyCount = team.NumPlayers(k)
        if teamPlyCount < 1 then continue end

        jobDistribution:AddSegment(nil, (teamPlyCount / plyCount) * 360, v.Color)
    end

    function jobDistribution:PaintOver(w, h)
        local centerX, centerY = w / 2, h / 2
        local diameter = math.min(w, h) - PIXEL.Scale(15)
        PIXEL.DrawCircle(centerX - diameter / 2, centerY - diameter / 2, diameter, diameter, overlayCol)
        PIXEL.DrawShadowText("Job Distribution", "F4.ChartsName", w / 2, h / 2, PIXEL.F4.Colors.ChartLabel, 1, 1, PIXEL.Scale(2))
    end

    table.insert(self.Charts, jobDistribution)

    local totalMoney = vgui.Create("Panel", self)

    totalMoney.AnimProg = 1

    function totalMoney:PerformLayout(w, h)
        local centerX, centerY = w / 2, h / 2
        local segRadius = math.min(centerX, centerY)
        self.CachedCircle = PIXEL.PrecacheArc(centerX, centerY, segRadius, segRadius, 0, 360, 3)
    end

    local moneyTitleTable = {"Total Money", "F4.ChartsName", PIXEL.F4.Colors.ChartLabel, 1, PIXEL.Scale(2)}
    local moneySubTitleTable = {PIXEL.FormatMoney(0), "F4.ChartsStat", PIXEL.F4.Colors.ChartLabel, 1, PIXEL.Scale(2)}

    local lerp = Lerp
    function totalMoney:Paint(w, h)
        local centerX, centerY = w / 2, h / 2
        local diameter = math.min(w, h) * self.AnimProg
        local diameterInner = math.min(w, h) - PIXEL.Scale(15)

        if self.AnimProg >= .99 then
            PIXEL.DrawCircle(centerX - diameter / 2, centerY - diameter / 2, diameter, diameter, PIXEL.F4.Colors.TotalMoney)
            PIXEL.DrawCircle(centerX - diameterInner / 2, centerY - diameterInner / 2, diameterInner, diameterInner, overlayCol)
            PIXEL.DrawDualText(moneyTitleTable, moneySubTitleTable, w / 2, h / 2)
            return
        end

        self.AnimProg = lerp(FrameTime() * 6, self.AnimProg, 1)

        PIXEL.DrawCircle(centerX - diameter / 2, centerY - diameter / 2, diameter, diameter, PIXEL.F4.Colors.TotalMoney)
        PIXEL.DrawCircle(centerX - diameterInner / 2, centerY - diameterInner / 2, diameterInner, diameterInner, overlayCol)
        PIXEL.DrawDualText(moneyTitleTable, moneySubTitleTable, w / 2, h / 2)
    end

    table.insert(self.Charts, totalMoney)

    local selfInfo = vgui.Create("PIXEL.Avatar", self)

    local oldPerformLayout = selfInfo.PerformLayout
    local yourName = LocalPlayer():Nick()
    local moneyText = PIXEL.FormatMoney(LocalPlayer():getDarkRPVar("money"))
    local overlayCol = Color(0,0,0,200)

    function selfInfo:PerformLayout(w, h)
        yourName = PIXEL.EllipsesText(LocalPlayer():Nick(), w, "F4.ChartsStat")
        self:SetMaskSize(math.min(h,w) * .478)
        self:SetSteamID(LocalPlayer():SteamID64(), h)
        oldPerformLayout(self, w, h)
    end

    function selfInfo:PaintOver(w, h)
        local centerX, centerY = w / 2, h / 2
        local diameter = math.min(w, h) - PIXEL.Scale(26)

        PIXEL.DrawCircle(centerX - diameter / 2, centerY - diameter / 2, diameter, diameter, overlayCol)

        PIXEL.DrawShadowText(yourName,"F4.LocalPlayerName", w / 2, h * .45, PIXEL.F4.Colors.ChartLabel, 1, 1, PIXEL.Scale(2))
        PIXEL.DrawShadowText(moneyText, "F4.LocalPlayerMoney", w / 2, h * .57, PIXEL.F4.Colors.RichestPlayerMoney, 1, 1, PIXEL.Scale(2))
    end

    table.insert(self.Charts, selfInfo)
end

function PANEL:PerformLayout(w, h)
    local pad = PIXEL.Scale(15)
    self:DockPadding(pad, pad, pad, pad)

    local chartCount = #self.Charts
    local spacing = PIXEL.Scale(20)
    local chartWidth = (w - pad * 2 - (spacing * (chartCount - 1))) / chartCount

    for k,v in ipairs(self.Charts) do
        v:SetWide(math.min(chartWidth, h))
        v:Dock(LEFT)
        v:DockMargin(k == 1 and 0 or spacing + chartWidth-math.min(chartWidth,h), 0, 0, 0)
    end
end

function PANEL:Paint(w, h)
    PIXEL.DrawRoundedBox(PIXEL.Scale(6), 0, 0, w, h, PIXEL.F4.Colors.ChartContainer)
end

vgui.Register("PIXEL.F4.DashboardCharts", PANEL, "Panel")

PIXEL.F4.Frame:Remove()