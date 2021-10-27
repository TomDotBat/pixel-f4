
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

local material = Material("vgui/gradient-l", "smooth")
local colors = PIXEL.F4.Colors.Item

local PANEL = {}

AccessorFunc(PANEL, "sModel", "Model", FORCE_STRING)
AccessorFunc(PANEL, "tTitle", "Title")
AccessorFunc(PANEL, "tSubText", "SubText")

PIXEL.RegisterFont("F4.ItemTitle", "Open Sans Bold", 22)
PIXEL.RegisterFont("F4.ItemSubText", "Open Sans SemiBold", 16)

function PANEL:Init()
    self.Model = vgui.Create("ModelImage", self)
    self.Model:SetMouseInputEnabled(false)
    self.Model:SetKeyboardInputEnabled(false)

    self.Model.Paint = function(s, w, h)
        surface.SetDrawColor(self.ModelBackgroundCol)
        surface.SetMaterial(material)
        surface.DrawTexturedRectRotated(5, 5, w * 3, h * 2, -45)
    end

    self.Model.PaintOver = function(s, w, h)
        render.ClearStencil()
        render.SetStencilEnable(true)
        render.SetStencilReferenceValue(1)

        render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)

        PIXEL.DrawFullRoundedBoxEx(PIXEL.Scale(4), 0, 0, w, h, color_white, true, true, true, true)

        render.SetStencilFailOperation(STENCILOPERATION_KEEP)
        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NOTEQUAL)

        surface.SetDrawColor(self.BackgroundCol)
        surface.DrawRect(0, 0, w, h)

        render.SetStencilEnable(false)
        render.ClearStencil()
    end

    self.BackgroundCol = PIXEL.CopyColor(colors.Background)
    self.ModelBackgroundCol = colors.ModelBackground
end

function PANEL:SetTitle(text, font, col)
    self.tTitle = {text, font, col, nil, 0}
end

function PANEL:SetSubText(text, font, col)
    self.tSubText = {text, font, col, nil, 0}
end

function PANEL:SetModel(mdl)
    self.Model:SetModel(mdl)
end

function PANEL:SetRankTag(rankTag)
    self.RankTag = rankTag
end

function PANEL:GetRankTag()
    return self.RankTag or false
end

function PANEL:Paint(w, h)
    self.BackgroundCol = PIXEL.LerpColor(FrameTime() * 8, self.BackgroundCol, self:IsHovered() and colors.BackgroundHover or colors.Background)

    PIXEL.DrawRoundedBox(PIXEL.Scale(6), 0, 0, w, h, self.BackgroundCol)
    PIXEL.DrawDualText(self:GetTitle(), self:GetSubText(), h, h * .5)

    if self.RankTag then
        local tag = self.RankTag[1]
        local tagCol = self.RankTag[2] == "rainbow" and PIXEL.GetRainbowColor() or self.RankTag[2]

        local nameW, nameH = PIXEL.GetTextSize(self.tTitle[1], self.tTitle[2])

        local boxW, boxH = PIXEL.GetTextSize(tag, "F4.JobTag")
        local xPad, yPad = PIXEL.Scale(4), 0
        local tagX, tagY = h + nameW + PIXEL.Scale(10), h * .5 - nameH + PIXEL.Scale(6)

        PIXEL.DrawRoundedBox(PIXEL.Scale(6), tagX - xPad, tagY - yPad, boxW + xPad * 2, boxH + yPad * 2, tagCol)
        PIXEL.DrawShadowText(tag, "F4.JobTag", tagX, tagY, PIXEL.Colors.PrimaryText, nil, nil, PIXEL.Scale(2))
    end

    self:PaintExtra(w, h)
end

function PANEL:PaintExtra(w, h) end

function PANEL:PerformLayout(w, h)
    local modelSize = h * .8 - PIXEL.Scale(4)
    local modelPad = (h - modelSize) / 2
    self.Model:SetSize(modelSize, modelSize)
    self.Model:SetPos(modelPad, modelPad)
end

vgui.Register("PIXEL.F4.Item", PANEL, "PIXEL.Button")