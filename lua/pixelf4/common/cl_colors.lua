
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

PIXEL.F4.Colors = {
    Item = {
        Background = PIXEL.OffsetColor(PIXEL.Colors.Background, 8),
        BackgroundHover = PIXEL.OffsetColor(PIXEL.Colors.Background, 12),
        ModelBackground = PIXEL.OffsetColor(PIXEL.Colors.Background, 6),
        Title = PIXEL.Colors.PrimaryText,
        SubText = PIXEL.Colors.SecondaryText
    },
    Search = {
        Background = PIXEL.Colors.Header,
        Icon = PIXEL.Colors.SecondaryText,
        IconSelected = PIXEL.Colors.PrimaryText,
        NothingFound = Color(120, 120, 120)
    },
    Jobs = {
        Slots = PIXEL.Colors.PrimaryText
    },
    SelectedJob = {
        Name = PIXEL.Colors.PrimaryText,
        Salary = PIXEL.Colors.Positive,
        Description = PIXEL.Colors.SecondaryText,
        DescriptionBox = PIXEL.OffsetColor(PIXEL.Colors.Background, 8),
        ModelBackground = PIXEL.Colors.Background,
        InfoBackground = PIXEL.OffsetColor(PIXEL.Colors.Background, -3)
    }
}

PIXEL.F4.Colors.ChartContainer = PIXEL.OffsetColor(PIXEL.Colors.Background, 4)
PIXEL.F4.Colors.ChartLabel = Color(255, 255, 255)
PIXEL.F4.Colors.PlayersChartOnline = Color(43, 129, 188)
PIXEL.F4.Colors.PlayersChartOffline = Color(44, 44, 44)
PIXEL.F4.Colors.TotalMoney = Color(60, 156, 60)
PIXEL.F4.Colors.RichestPlayerMoney = Color(60, 156, 60)
PIXEL.F4.Colors.SecondaryHeader = PIXEL.OffsetColor(PIXEL.Colors.Background, 6)
PIXEL.F4.Colors.AnnouncementIcon = PIXEL.Colors.PrimaryText

PIXEL.F4.Colors.RecentsContainer = PIXEL.OffsetColor(PIXEL.Colors.Background, 4)
PIXEL.F4.Colors.RecentsBoxes = PIXEL.OffsetColor(PIXEL.Colors.Background, 6)
PIXEL.F4.Colors.RecentsTitle = Color(255, 255, 255)
PIXEL.F4.Colors.RecentsNothingFound = Color(160, 160, 160)

PIXEL.F4.Colors.LawsTitle = Color(255, 255, 255)
PIXEL.F4.Colors.Laws = Color(220, 220, 220)

PIXEL.F4.Colors.SearchIcon = Color(110, 110, 110)
PIXEL.F4.Colors.SearchIconSelected = Color(240, 240, 240)

PIXEL.F4.Colors.ItemBackground = Color(26, 26, 32)
PIXEL.F4.Colors.ItemBackgroundHover = Color(22, 22, 26)
PIXEL.F4.Colors.ItemModelBackground = Color(20, 20, 24)

PIXEL.F4.Colors.ItemTitle = Color(255, 255, 255)
PIXEL.F4.Colors.ItemSubText = Color(180, 180, 180)

PIXEL.F4.Colors.JobSlots = Color(255, 255, 255)

PIXEL.F4.Colors.SelectedJobModelBackground = Color(30, 30, 34)
PIXEL.F4.Colors.SelectedJobInfoBackground = Color(40, 40, 46)

PIXEL.F4.Colors.SelectedJobName = Color(255, 255, 255)
PIXEL.F4.Colors.SelectedJobSalary = Color(200, 200, 200)
PIXEL.F4.Colors.SelectedJobDescription = Color(220, 220, 220)
PIXEL.F4.Colors.SelectedJobDescriptionBox = Color(32, 32, 36)

PIXEL.F4.Colors.EntityModelOutline = Color(46, 46, 50)

PIXEL.F4.Colors.NothingFound = Color(120, 120, 120)

PIXEL.Colors.LineGraphPoint = PIXEL.OffsetColor(PIXEL.Colors.Background, 20)
PIXEL.Colors.LineGraphLine = PIXEL.OffsetColor(PIXEL.Colors.Background, 25)
PIXEL.Colors.LineGraphBackgroundLine = PIXEL.OffsetColor(PIXEL.Colors.Background, 20)
PIXEL.Colors.LineGraphOutline = PIXEL.OffsetColor(PIXEL.Colors.Background, 25)
PIXEL.Colors.LineGraphLabel = PIXEL.Colors.PrimaryText