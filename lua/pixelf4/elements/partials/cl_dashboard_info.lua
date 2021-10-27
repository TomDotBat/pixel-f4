
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

local nothingFoundCol = PIXEL.F4.Colors.Search.NothingFound

PIXEL.RegisterFont("F4.DashInfoTitles", "Open Sans Bold", 20)
PIXEL.RegisterFont("F4.DashInfoNothingToSee", "Open Sans Bold", 60)
PIXEL.RegisterFont("F4.DashInfoText", "Open Sans SemiBold", 18)

function PANEL:Init()
	self.ItemsLeft = {} -- Laws
	self.ItemsRight = {} -- Cmds

	self.Announcement = vgui.Create("Panel", self)
	self.LeftPnl = vgui.Create("Panel", self)
	self.RightPnl = vgui.Create("Panel", self)
	self.LeftCat = vgui.Create("PIXEL.ScrollPanel", self.LeftPnl)
	self.RightCat = vgui.Create("PIXEL.ScrollPanel", self.RightPnl)

	self.LeftPnl.Title = "Laws"
	self.RightPnl.Title = "Commands"

	local lawTableIsEmpty = (#DarkRP.getLaws()) == 0
	function self.LeftPnl:Paint(w,h)
		PIXEL.DrawRoundedBox(PIXEL.Scale(6), 0, 0, w, h, PIXEL.F4.Colors.RecentsContainer)
		PIXEL.DrawRoundedBoxEx(PIXEL.Scale(6), 0, 0, w, PIXEL.Scale(27),PIXEL.Colors.Header, true, true)
		PIXEL.DrawText(self.Title, "F4.DashInfoTitles", PIXEL.Scale(13), PIXEL.Scale(4), PIXEL.Colors.PrimaryText, 0, 1)

		if lawTableIsEmpty then
			PIXEL.DrawSimpleText("NOTHING TO SEE HERE", "F4.DashInfoNothingToSee", w / 2, h / 2, nothingFoundCol, 1, 1)
		end
	end

	function self.RightPnl:Paint(w,h)
		PIXEL.DrawRoundedBox(PIXEL.Scale(6), 0, 0, w, h, PIXEL.F4.Colors.RecentsContainer)
		PIXEL.DrawRoundedBoxEx(PIXEL.Scale(6), 0, 0, w, PIXEL.Scale(27),PIXEL.Colors.Header, true, true)
		PIXEL.DrawText(self.Title, "F4.DashInfoTitles", PIXEL.Scale(13), PIXEL.Scale(4), PIXEL.Colors.PrimaryText, 0, 1)
	end

	if PIXEL.F4.Config.Announcement then
		self.Announcement.TextWrap = ""
		self.Announcement.TextHigh = 0

		function self.Announcement:PerformLayout(w,h)
			self.TextWrap = PIXEL.WrapText(PIXEL.F4.Config.Announcement, w - h - 5, "F4.DashInfoText")
			self.TextHigh = select(2, PIXEL.GetTextSize(self.TextWrap, "F4.DashInfoText"))
			if self.TextHigh == h + 20 then return end
			self:SetTall(self.TextHigh + 20)
		end

		function self.Announcement:Paint(w,h)
			PIXEL.DrawRoundedBox(PIXEL.Scale(6), 0, 0, w, h, PIXEL.F4.Colors.RecentsContainer)
			PIXEL.DrawRoundedBoxEx(PIXEL.Scale(6), 0, 0, 0, h, PIXEL.F4.Colors.SecondaryHeader, true, false, true)

			local hh = h / 2.5
			PIXEL.DrawImgur(hh / 2, hh / 2, h-hh, h-hh, "UxDq0Tf", PIXEL.F4.Colors.AnnouncementIcon)
			PIXEL.DrawText(self.TextWrap, "F4.DashInfoText", h + 5, 10, PIXEL.Colors.PrimaryText, 0)
		end
	else
		self.Announcement:SetTall(0)
	end

	self:GenerateItems(self.LeftCat, self.RightCat)

	hook.Add("addLaw", "PIXEL.F4.LawsRefresh", function()
		if not (IsValid(self) and IsValid(self.LeftCat)) then
			hook.Remove("addLaw", "PIXEL.F4.LawsRefresh")
			return
		end

		self:GenerateItems(self.LeftCat, self.RightCat, true)
		self:InvalidateLayout(true)
	end)

	hook.Add("removeLaw", "PIXEL.F4.LawsRefresh", function()
		if not (IsValid(self) and IsValid(self.LeftCat)) then
			hook.Remove("removeLaw", "PIXEL.F4.LawsRefresh")
			return
		end

		self:GenerateItems(self.LeftCat, self.RightCat, true)
		self:InvalidateLayout(true)
	end)

end

function PANEL:PerformLayout(w, h)
	local pad = PIXEL.Scale(6)
	local head = PIXEL.Scale(30)

	self.Announcement:Dock(TOP)
	self.LeftPnl:Dock(LEFT)
	self.RightPnl:Dock(RIGHT)
	self.LeftCat:Dock(FILL)
	self.RightCat:Dock(FILL)

	self.LeftPnl:SetWide(w / 2 + w / 4 - pad / 2)
	self.RightPnl:SetWide(w / 4 - pad / 2)

	self.LeftCat:DockMargin(pad,head,pad,pad)
	self.RightCat:DockMargin(pad,head,pad,pad)

	if PIXEL.F4.Config.Announcement then
		self.Announcement:DockMargin(0, 0, 0, pad)
	end

	for _,v in ipairs(self.ItemsRight) do
		v:Dock(TOP)
		v:DockMargin(pad, pad, pad, pad)
	end

	pad = pad / 2
	for _,v in ipairs(self.ItemsLeft) do
		v:Dock(TOP)
		v:DockMargin(pad * 2, pad * 2, pad * 2, pad)
	end
end

function PANEL:ClearLaws()
	for key,v in ipairs(self.ItemsLeft) do
		if IsValid(v) then
			v:Remove()
			self.ItemsLeft[key] = nil
		end
	end
end

function PANEL:GenerateItems(l, r, dontRefreshCommands)
	self:ClearLaws()

	-- Laws
	for index,v in ipairs(DarkRP.getLaws()) do
		local p = vgui.Create("Panel", self.LeftCat)

		p.TextWrap = ""
		p.TextHigh = 0

		function p:Paint(w,h)
			PIXEL.DrawRoundedBoxEx(PIXEL.Scale(6), 0, 0, 20, h, PIXEL.F4.Colors.SecondaryHeader, true, false, true)
			PIXEL.DrawSimpleText(index, "F4.DashInfoText", 10, h / 2, PIXEL.Colors.PrimaryText, 1, 1)
			PIXEL.DrawText(self.TextWrap, "F4.DashInfoText", 25, 3, PIXEL.Colors.PrimaryText, 0)
		end

		function p:PerformLayout(w,h)
			self.TextWrap = PIXEL.WrapText(v, w - 5, "F4.DashInfoText")
			self.TextHigh = select(2, PIXEL.GetTextSize(self.TextWrap, "F4.DashInfoText"))
			if self.TextHigh == h + 5 then return end
			if self.TextWrap:find("\n") then
				self:SetTall(self.TextHigh + 8)
			else
				self:SetTall(self.TextHigh + 5)
			end
		end

		self.ItemsLeft[#self.ItemsLeft + 1] = p
	end

	-- Commands
	if dontRefreshCommands then return end
	local canUseBackup = function() return true end
	local canSeeBackup = canUseBackup
	for _,v in ipairs(PIXEL.F4.Config.Commands) do
		v.CanUse = v.CanUse or canUseBackup
		v.CanSee = v.CanSee or canSeeBackup
		local p = vgui.Create("PIXEL.Button", self.RightCat)

		p.canUse = v.CanUse()
		function p:IsEnabled()
			return self.canUse
		end

		function p:DoClick()
			v.Func()
			notification.AddLegacy("Ran " .. v.Name, NOTIFY_GENERIC, 3)
		end

		function p:PaintExtra(w,h)
			if not self.canUse then
				PIXEL.DrawSimpleText(v.Name, "F4.DashInfoText", w / 2, h / 2, PIXEL.Colors.DisabledText, 1, 1)
				return
			end
			PIXEL.DrawSimpleText(v.Name, "F4.DashInfoText", w / 2, h / 2, PIXEL.Colors.PrimaryText, 1, 1)
		end

		if not v.CanSee() then
			p:Remove()
			p = nil
		end
		self.ItemsRight[#self.ItemsRight + 1] = p
	end
end


vgui.Register("PIXEL.F4.DashboardInfoPanel", PANEL, "Panel")

PIXEL.F4.Frame:Remove()