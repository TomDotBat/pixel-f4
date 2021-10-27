
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

local colors = PIXEL.F4.Colors.Item

local PANEL = {}

AccessorFunc(PANEL, "sCommand", "Command", FORCE_STRING)

function PANEL:SetItem(ammo)
    self:SetModel(ammo.model)
    self:SetTitle(ammo.name .. " (x" .. ammo.amountGiven .. ")", "F4.ItemTitle", colors.Title)
    self:SetSubText("Price: " .. PIXEL.FormatMoney(ammo.price), "F4.ItemSubText", colors.SubText)
    self:SetCommand(ammo.id)
    self.ModelBackgroundCol = colors.ModelBackground
end

function PANEL:DoClick()
    RunConsoleCommand("DarkRP", "buyammo", self:GetCommand())
end

vgui.Register("PIXEL.F4.Ammo", PANEL, "PIXEL.F4.Item")