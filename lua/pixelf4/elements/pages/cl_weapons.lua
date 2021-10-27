
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

local nothingFoundCol = PIXEL.F4.Colors.Search.NothingFound

local PANEL = {}

PIXEL.RegisterFont("F4.NothingFound", "Open Sans Bold", 30)

local localPly

local canBuyCats = {
    ["weapons"] = function(wep)
        if GAMEMODE.Config.restrictbuypistol and not table.HasValue(wep.allowed, localPly:Team()) then return false, true end
        if wep.customCheck and not wep.customCheck(localPly) then return false, true end

        local canbuy, suppress, message, price = hook.Call("canBuyPistol", nil, localPly, wep)
        local cost = price or wep.getPrice and wep.getPrice(localPly, wep.pricesep) or wep.pricesep

        if not localPly:canAfford(cost) then return false, false, message, cost end

        if canbuy == false then
            return false, suppress, message, cost
        end

        return true, nil, message, cost
    end,
    ["shipments"] = function(ship)
        if not table.HasValue(ship.allowed, localPly:Team()) then return false, true end
        if ship.customCheck and not ship.customCheck(localPly) then return false, true end

        local canbuy, suppress, message, price = hook.Call("canBuyShipment", nil, localPly, ship)
        local cost = price or ship.getPrice and ship.getPrice(localPly, ship.price) or ship.price

        if not localPly:canAfford(cost) then return false, false, message, cost end

        if canbuy == false then
            return false, suppress, message, cost
        end

        return true, nil, message, cost
    end,
    ["ammo"] = function(ammo)
        if ammo.customCheck and not ammo.customCheck(localPly) then return false, true end

        local canbuy, suppress, message, price = hook.Call("canBuyAmmo", nil, localPly, ammo)
        local cost = price or ammo.getPrice and ammo.getPrice(localPly, ammo.price) or ammo.price
        if not localPly:canAfford(cost) then return false, false, message, cost end

        if canbuy == false then
            return false, suppress, message, price
        end

        return true, nil, message, price
    end
}

local function shouldShow(item, itemType)
    if not canBuyCats[itemType] then return true end

    local canBuy, important = canBuyCats[itemType](item)
    return not ((not canBuy) and (GAMEMODE.Config.hideNonBuyable or (important and GAMEMODE.Config.hideTeamUnbuyable)))
end

function PANEL:Init()
    localPly = LocalPlayer()

    self.Navbar = vgui.Create("PIXEL.Navbar", self)
    self.Navbar:Dock(TOP)
    self.Navbar:AddItem("weapons", "Weapons", function() self:SelectCategory("weapons") end)
    self.Navbar:AddItem("shipments", "Shipments", function() self:SelectCategory("shipments") end)
    self.Navbar:AddItem("ammo", "Ammo", function() self:SelectCategory("ammo") end)
    self.Navbar:SelectItem("weapons")

    self:SelectCategory("weapons")

    self.Navbar.SelectionX = 0
    self.Navbar.SelectionW = PIXEL.Scale(108)

    hook.Add("OnPlayerChangedTeam", self, function(s, ply)
        if ply ~= localPly then return end
        self:Populate(self.Scroller:GetCanvas())
    end)
end

function PANEL:SelectCategory(type)
    self.Category = type
    self:Populate(self.Scroller:GetCanvas())
    self.Scroller:InvalidateLayout(true)
end

local catItemNames = {
    ["weapons"] = "Weapon",
    ["shipments"] = "Shipment",
    ["ammo"] = "Ammo"
}

function PANEL:Populate(canvas, searchTerm)
    canvas:Clear()
    table.Empty(self.Categories)

    for k,v in SortedPairsByMemberValue(DarkRP.getCategories()[self.Category], "sortOrder") do
        if #v.members < 1 then continue end
        if isfunction(v.canSee) and not v.canSee(localPly) then continue end

        local cat = vgui.Create("PIXEL.F4.ItemCategory", canvas)
        cat:SetTitle(v.name)
        cat:Dock(TOP)
        cat:SetExpanded(v.startExpanded)

        cat.ShouldShow = function(item)
            return shouldShow(item, self.Category)
        end

        cat:SetItemType(catItemNames[self.Category])
        cat:SetItems(v.members, searchTerm)

        if #cat.Items < 1 then cat:Remove() continue end

        table.insert(self.Categories, cat)
    end
end

function PANEL:LayoutExtra(w, h)
    self.Navbar:SetTall(PIXEL.Scale(50))
end

function PANEL:Paint(w, h)
    if #self.Categories != 0 then return end
    PIXEL.DrawSimpleText("NO " .. string.upper(self.Category) .. " FOUND", "F4.NothingFound", w / 2, h / 2 + PIXEL.Scale(45), nothingFoundCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

vgui.Register("PIXEL.F4.Weapons", PANEL, "PIXEL.F4.ItemPage")