
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

local itemColors = PIXEL.F4.Colors.Item
local slotsCol = PIXEL.F4.Colors.Jobs.Slots

local PANEL = {}

AccessorFunc(PANEL, "nTeamNo", "TeamNo", FORCE_NUMBER)
AccessorFunc(PANEL, "sSlotText", "SlotText", FORCE_STRING)

PIXEL.RegisterFont("F4.JobSlots", "Open Sans Bold", 24)
PIXEL.RegisterFont("F4.JobTag", "Open Sans Bold", 18)

function PANEL:SetItem(job)
    self:SetModel(istable(job.model) and job.model[math.random(1, #job.model)] or job.model)
    self:SetTitle(job.name, "F4.ItemTitle", itemColors.Title)
    self:SetSubText("Salary: " .. PIXEL.FormatMoney(job.salary), "F4.ItemSubText", itemColors.SubText)
    self.ModelBackgroundCol = job.color

    if not PIXEL.RankTags then return end
    self:SetRankTag(PIXEL.F4.Config.RankTags[job.rankTag])
end

function PANEL:PaintExtra(w, h)
    PIXEL.DrawSimpleText(self:GetSlotText(), "F4.JobSlots", w - PIXEL.Scale(7), h / 2, slotsCol, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
end

vgui.Register("PIXEL.F4.Job", PANEL, "PIXEL.F4.Item")