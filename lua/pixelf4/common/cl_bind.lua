
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

function PIXEL.F4.ToggleMenu()
    if PIXEL.F4.Fading then return end

    if not IsValid(PIXEL.F4.Frame) then
        PIXEL.F4.Opened = true
        PIXEL.F4.Frame = vgui.Create("PIXEL.F4.Frame")
        PIXEL.F4.Frame:SetRemoveOnClose(false)
        PIXEL.F4.Frame.NextInput = CurTime() + 1
        return
    end

    if PIXEL.F4.Opened then
        PIXEL.F4.Opened = false
        PIXEL.F4.Frame:Close()
        return
    end

    PIXEL.F4.Opened = true
    PIXEL.F4.Frame:MakePopup()
    PIXEL.F4.Frame.NextInput = CurTime() + 1
end

hook.Add("ShowSpare2", "PIXEL.F4.ToggleMenu", PIXEL.F4.ToggleMenu)
hook.Add("PostGamemodeLoaded", "PIXEL.F4.RemoveDefaultF4", function()
    local function doNothing() end
    DarkRP.openF4Menu = doNothing
    DarkRP.closeF4Menu = doNothing
    DarkRP.toggleF4Menu = doNothing
end)