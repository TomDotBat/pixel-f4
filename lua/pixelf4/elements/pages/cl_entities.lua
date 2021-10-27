
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

local localPly

local function canBuyEntity(item)
    if istable(item.allowed) and not table.HasValue(item.allowed, localPly:Team()) then return false, true end
    if item.customCheck and not item.customCheck(localPly) then return false, true end

    local canbuy, suppress, message, price = hook.Call("canBuyCustomEntity", nil, localPly, item)
    local cost = price or item.getPrice and item.getPrice(localPly, item.price) or item.price
    if not localPly:canAfford(cost) then return false, false, message, cost end

    if canbuy == false then
        return false, suppress, message, cost
    end

    return true, nil, message, cost
end

local function shouldShow(item)
    local canBuy, important = canBuyEntity(item)
    return not ((not canBuy) and (GAMEMODE.Config.hideNonBuyable or (important and GAMEMODE.Config.hideTeamUnbuyable)))
end

function PANEL:Init()
    localPly = LocalPlayer()
    self:Populate(self.Scroller:GetCanvas())

    hook.Add("OnPlayerChangedTeam", self, function(s, ply)
        if ply ~= localPly then return end
        self:Populate(self.Scroller:GetCanvas())
    end)
end

function PANEL:Populate(canvas, searchTerm)
    canvas:Clear()
    table.Empty(self.Categories)

    for k,v in SortedPairsByMemberValue(DarkRP.getCategories().entities, "sortOrder") do
        if #v.members < 1 then continue end
        if isfunction(v.canSee) and not v.canSee(localPly) then continue end

        local cat = vgui.Create("PIXEL.F4.ItemCategory", canvas)
        cat:SetTitle(v.name)
        cat:Dock(TOP)
        cat:SetExpanded(v.startExpanded)

        cat.ShouldShow = shouldShow

        cat:SetItemType("Entity")
        cat:SetItems(v.members, searchTerm)

        if #cat.Items < 1 then cat:Remove() continue end

        table.insert(self.Categories, cat)
    end
end

vgui.Register("PIXEL.F4.Entities", PANEL, "PIXEL.F4.ItemPage")