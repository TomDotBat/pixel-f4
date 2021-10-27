
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

AccessorFunc(PANEL, "sFont", "Font")
AccessorFunc(PANEL, "cDefaultTextColor", "DefaultTextColor")

PIXEL.RegisterFont("PieChartLabel", "Open Sans SemiBold", 17)

function PANEL:Init()
    self:SetDefaultTextColor(Color(255, 255, 255))

    self.AnimProg = 0
    self.CachedDrawSegments = {}
    self.Segments = {}
end

function PANEL:AddSegment(text, degrees, color, textColor)
    table.insert(self.Segments, {
        text = text,
        segSize = degrees,
        color = color,
        textColor = textColor
    })
end

function PANEL:ClearSegments()
    table.Empty(self.Segments)
    self.AnimProg = 0
end

function PANEL:PerformLayout(w, h)
    local centerX, centerY = w / 2, h / 2
    local segRadius = math.min(centerX, centerY)

    table.Empty(self.CachedDrawSegments)

    local offset = 0
    for k,v in ipairs(self.Segments) do
        self.CachedDrawSegments[k] = PIXEL.PrecacheArc(centerX, centerY, segRadius, segRadius, offset, v.segSize + offset, 1)
        v.textPosX = centerX + math.cos(-math.rad(offset + v.segSize / 2)) * segRadius / 2
        v.textPosY = centerY + math.sin(-math.rad(offset + v.segSize / 2)) * segRadius / 2
        offset = offset + v.segSize
    end
end

local lerp = Lerp
local whiteTexture = surface.GetTextureID("vgui/white")
function PANEL:Paint(w, h)
    if self.AnimProg >= .99 then
        local defaultLabelCol = self:GetDefaultTextColor()

        surface.SetTexture(whiteTexture)

        for k,v in ipairs(self.CachedDrawSegments) do
            local col = self.Segments[k].color
            surface.SetDrawColor(col.r, col.g, col.b, col.a)

            PIXEL.DrawArc(v)

            local text = self.Segments[k].text
            if not text then continue end
            PIXEL.DrawSimpleText(text, "PieChartLabel", self.Segments[k].textPosX, self.Segments[k].textPosY, self.Segments[k].textColor or defaultLabelCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        return
    end

    self.AnimProg = lerp(FrameTime() * 6, self.AnimProg, 1)

    local centerX, centerY = w / 2, h / 2
    local segRadius = math.min(centerX, centerY) * self.AnimProg
    local offset = 0

    surface.SetTexture(whiteTexture)

    for k,v in ipairs(self.Segments) do
        local col = self.Segments[k].color
        surface.SetDrawColor(col.r, col.g, col.b, col.a)

        PIXEL.DrawArc(PIXEL.PrecacheArc(centerX, centerY, segRadius, segRadius, offset, v.segSize + offset, 1))

        offset = offset + v.segSize
    end
end

vgui.Register("PIXEL.PieChart", PANEL, "Panel")