
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
    self.SearchBar = vgui.Create("PIXEL.F4.SearchBar", self)
    self.SearchBar:Dock(TOP)

    self.SearchBar.Entry:SetUpdateOnType(true)
    self.SearchBar.Entry.OnValueChange = function(s, val)
        if timer.Exists("PIXEL.F4.SearchDebounce") then
            timer.Remove("PIXEL.F4.SearchDebounce")
        end

        timer.Create("PIXEL.F4.SearchDebounce", .3, 1, function()
            if not IsValid(self) then return end
            self:Populate(self.Scroller:GetCanvas(), string.Trim(string.lower(val)))
            self.Scroller:InvalidateLayout(true)
        end)
    end

    self.Scroller = vgui.Create("PIXEL.ScrollPanel", self)
    self.Scroller:Dock(FILL)
    self.Scroller:SetBarDockShouldOffset(true)

    self.Scroller.LayoutContent = function(s, w, h)
        local spacing = PIXEL.Scale(6)
        local barSpacing = s.VBar.Enabled and PIXEL.Scale(6) or 0
        for k,v in ipairs(self.Categories) do
            v:DockMargin(0, k == 1 and 0 or spacing, barSpacing, 0)
        end
    end

    self.Categories = {}
end

function PANEL:Populate(canvas) end

function PANEL:PerformLayout(w, h)
    self.SearchBar:SetTall(PIXEL.Scale(44))

    local scrollPad = PIXEL.Scale(6)
    self.Scroller:DockMargin(scrollPad, scrollPad, scrollPad, scrollPad)

    self:LayoutExtra(w, h)
end

function PANEL:LayoutExtra(w, h) end

vgui.Register("PIXEL.F4.ItemPage", PANEL, "Panel")