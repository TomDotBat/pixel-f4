
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

AccessorFunc(PANEL, "sItemType", "ItemType", FORCE_STRING)
AccessorFunc(PANEL, "tItems", "Items")

function PANEL:Init()
    self.Items = {}
    self.Rows = {}
end

function PANEL:RemoveItems()
    for k,v in ipairs(self.Items) do
        v:Remove()
    end

    for k,v in ipairs(self.Rows) do
        v:Remove()
    end

    table.Empty(self.Items)
    table.Empty(self.Rows)
end

function PANEL:SetItems(items, searchTerm)
    self:RemoveItems()
    self.ItemData = items

    local curRow
    local nextRow = true
    local itemType = self:GetItemType()

    for k,v in SortedPairsByMemberValue(items, "sortOrder") do
        if searchTerm and not string.find(string.lower(v.name), searchTerm) then continue end
        if self.ShouldShow and not self.ShouldShow(v) then continue end

        if nextRow then
            curRow = table.insert(self.Rows, vgui.Create("Panel", self))
        end

        local item = vgui.Create("PIXEL.F4." .. itemType, self.Rows[curRow])
        item:Dock(nextRow and LEFT or RIGHT)
        item:SetItem(v)
        self:SetExtraItemData(item, v)
        table.insert(self.Items, item)

        nextRow = not nextRow
    end
end

function PANEL:SetExtraItemData(item, itemData) end

function PANEL:LayoutContent(w, h)
    local pad = PIXEL.Scale(6)
    self:DockPadding(0, 0, 0, pad)

    local itemH = PIXEL.Scale(70)
    for k,v in ipairs(self.Rows) do
        v:Dock(TOP)
        v:DockMargin(pad, k == 1 and pad or 0, pad, pad)
        v:SetTall(itemH)
    end

    local itemW = w / 2 - PIXEL.Scale(9)
    for k,v in ipairs(self.Items) do
        v:SetSize(itemW, itemH)
    end
end

vgui.Register("PIXEL.F4.ItemCategory", PANEL, "PIXEL.Category")