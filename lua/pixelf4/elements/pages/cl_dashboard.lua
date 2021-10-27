
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

PIXEL.RegisterFont("F4.DashboardNothingToSeeHere", "Open Sans Bold", 52)

function PANEL:Init()
    self.InfoPanel = vgui.Create("PIXEL.F4.DashboardInfoPanel", self)
    self.StatsPanel = vgui.Create("PIXEL.F4.DashboardCharts", self)
    self.StatsPanel:Dock(BOTTOM)
end

function PANEL:PerformLayout(w, h)
    local selectorH = PIXEL.Scale(50)

    local pad = PIXEL.Scale(6)
    self.StatsPanel:DockMargin(pad, pad, pad, pad)
    self.StatsPanel:SetTall((h - selectorH) * .4)

    self.InfoPanel:Dock(FILL)
    self.InfoPanel:DockMargin(pad, pad, pad, 0)
end

vgui.Register("PIXEL.F4.Dashboard", PANEL, "Panel")

PIXEL.F4.Frame:Remove()
