
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

PIXEL.F4.Config = {
    MenuTitle = "PIXEL DarkRP",
    SidebarLogo = "YCRtBVO",
    Announcement = false,
    WebsiteLinks = {
        [1] = {
            Name = "Rewards",
            ChatCommand = "!rewards",
            ImgurID = "HxsUUz2"
        },
        [2] = {
            Name = "Rules",
            Link = "https://google.com",
            ImgurID = "0aWOlMI"
        },
        [3] = {
            Name = "Discord",
            Link = "https://google.com",
            ImgurID = "EtvPE3C"
        },
        [4] = {
            Name = "Forum",
            Link = "https://google.com",
            ImgurID = "8ey54bc"
        },
        [5] = {
            Name = "Shop",
            Link = "https://google.com",
            ImgurID = "jbp3ZT5"
        }
    },
    Commands = {
        {
            Name = "Sell All Doors",
            Func = function()
                RunConsoleCommand("say", "/sellalldoors")
            end
        },
        {
            Name = "Drop Money",
            Func = function()
                PIXEL.F4.ToggleMenu()
                Derma_StringRequest("Drop Money", "Drop an amount of money:", "100", function(txt)
                    RunConsoleCommand("say", "/dropmoney " .. txt or "")
                end )
            end
        },
        {
            Name = "Change Name",
            Func = function()
                PIXEL.F4.ToggleMenu()
                Derma_StringRequest("Change Name", "Change your Roleplay name (Leave Blank for your Steam name):", LocalPlayer():Nick(), function(txt)
                    RunConsoleCommand("say", "/rpname " .. Either(#txt >= 2, txt, LocalPlayer():SteamName()))
                end )
            end
        },
        {
            Name = "Broadcast",
            Func = function()
                PIXEL.F4.ToggleMenu()
                Derma_StringRequest("Change Name", "Change your Roleplay name (Leave Blank for your Steam name):", LocalPlayer():Nick(), function(txt)
                    RunConsoleCommand("say", "/rpname " .. Either(#txt >= 2, txt, LocalPlayer():SteamName()))
                end )
            end,
            CanSee = function()
                return LocalPlayer():isMayor()
            end
        }
    },
    WeaponOverrides = {
        ["weapon_bugbait"] = {
            WorldModel = "models/weapons/w_bugbait.mdl",
            PrintName = "Bug Bait"
        }
    }
}

if SERVER then return end

PIXEL.F4.Config.RankTags = {
    [PIXEL.RankTags.VIP] = {"VIP", PIXEL.Colors.Gold},
    [PIXEL.RankTags.VIP_PLUS] = {"VIP+", "rainbow"},
    [PIXEL.RankTags.STAFF] = {"Staff Only", PIXEL.Colors.Negative}
}