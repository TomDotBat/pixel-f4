
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

local colors = PIXEL.F4.Colors.Search

local PANEL = {}

function PANEL:Init()
    self.Entry = vgui.Create("PIXEL.TextEntry", self)
    self.Entry:SetPlaceholderText("Search...")
    self.Entry.IconCol = PIXEL.CopyColor(colors.Icon)

    function self.Entry:PaintOver(w, h)
        self.IconCol = PIXEL.LerpColor(FrameTime() * 8, self.IconCol, self:IsEditing() and colors.IconSelected or colors.Icon)

        local iconSize = PIXEL.Scale(18)
        local pad = h / 2 - iconSize / 2
        PIXEL.DrawImgur(w - pad - iconSize, pad, iconSize, iconSize, "CBEbuA0", self.IconCol)
    end
end

function PANEL:PerformLayout(w, h)
    local entryH = PIXEL.Scale(32)
    local pad = h / 2 - entryH / 2
    self.Entry:SetSize(PIXEL.Scale(220), entryH)
    self.Entry:SetPos(pad, pad)
end

function PANEL:Paint(w, h)
    PIXEL.DrawRoundedBox(0, 0, 0, w, h, colors.Background)
end

vgui.Register("PIXEL.F4.SearchBar", PANEL, "Panel")