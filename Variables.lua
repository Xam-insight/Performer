local L = LibStub("AceLocale-3.0"):GetLocale("Performer", true);

---- Icons ----

PerformerIcons = {
	["Tank"] = {
		{
			["name"]          = "Tank",
			["iconPath"]      = "Interface\\ICONS\\INV_Shield_06",
			["tooltip"]       = L["Tank_tooltip"],
			["tooltipDetail"] = L["Tank_tooltipDetail"],
		},
		{
			["name"]          = "Switch",
			["iconPath"]      = "Interface\\ICONS\\Ability_warrior_charge",
			["tooltip"]       = L["Switch_tooltip"],
			["tooltipDetail"] = L["Switch_tooltipDetail"],
		},
		{
			["name"]          = "Aggro",
			["iconPath"]      = "Interface\\ICONS\\ability_warrior_battleshout",
			["tooltip"]       = L["Aggro_tooltip"],
			["tooltipDetail"] = L["Aggro_tooltipDetail"],
		},
	},
	["Heal"] = {
		{
			["name"]          = "HPS",
			["iconPath"]      = "Interface\\ICONS\\Spell_Holy_Redemption",
			["tooltip"]       = L["HPS_tooltip"],
			["tooltipDetail"] = L["HPS_tooltipDetail"],
		},
		{
			["name"]          = "Debuff",
			["iconPath"]      = "Interface\\ICONS\\INV_Potion_19",
			["tooltip"]       = L["Debuff_tooltip"],
			["tooltipDetail"] = L["Debuff_tooltipDetail"],
		},
		{
			["name"]          = "Cooldown",
			["iconPath"]      = "Interface\\ICONS\\Ability_druid_naturalperfection",
			["tooltip"]       = L["Cooldown_tooltip"],
			["tooltipDetail"] = L["Cooldown_tooltipDetail"],
		},
	},
	["DPS"] = {
		{
			["name"]          = "Rage",
			["iconPath"]      = "Interface\\ICONS\\Ability_Druid_Lacerate",
			["tooltip"]       = L["Rage_tooltip"],
			["tooltipDetail"] = L["Rage_tooltipDetail"],
		},
		{
			["name"]          = "DPS",
			["iconPath"]      = "Interface\\ICONS\\Ability_BackStab",
			["tooltip"]       = L["DPS_tooltip"],
			["tooltipDetail"] = L["DPS_tooltipDetail"],
		},
		{
			["name"]          = "Focus",
			["iconPath"]      = "Interface\\ICONS\\Ability_Hunter_MarkedForDeath",
			["tooltip"]       = L["Focus_tooltip"],
			["tooltipDetail"] = L["Focus_tooltipDetail"],
		},
	},
	["All"] = {
		{
			["name"]          = "Enchant",
			["iconPath"]      = "Interface\\ICONS\\Inv_enchant_shardprismaticsmall",
			["tooltip"]       = L["Enchant_tooltip"],
			["tooltipDetail"] = L["Enchant_tooltipDetail"],
		},
		{
			["name"]          = "AOE",
			["iconPath"]      = "Interface\\ICONS\\Ability_Mage_WorldinFlames",
			["tooltip"]       = L["AOE_tooltip"],
			["tooltipDetail"] = L["AOE_tooltipDetail"],
		},
	},
}

PerformerTitles = {
	["AA_NoTitle"]     = { ["Title"] = "" },
	["TankDammage"] = { ["Title"] = L["TankDammage_Title"], ["desc"] = L["PERFORMER_TITLE"], ["icon"] = "134505", ["points"] = 0 },
	["Dammage"]     = { ["Title"] = L["Dammage_Title"], ["desc"] = L["PERFORMER_TITLE"], ["icon"] = "132162", ["points"] = 0 },
	["Heal"]        = { ["Title"] = L["Heal_Title"], ["desc"] = L["PERFORMER_TITLE"], ["icon"] = "1387612", ["points"] = 0 },
	["Focus"]       = { ["Title"] = L["Focus_Title"], ["desc"] = L["PERFORMER_TITLE"], ["icon"] = "132212", ["points"] = 0 },
	["Listen"]      = { ["Title"] = L["Listen_Title"], ["desc"] = L["PERFORMER_TITLE"], ["icon"] = "133855", ["points"] = 0 },
	["Switch"]      = { ["Title"] = L["Switch_Title"], ["desc"] = L["PERFORMER_TITLE"], ["icon"] = "236372", ["points"] = 0 },
	["Aggro"]       = { ["Title"] = L["Aggro_Title"], ["desc"] = L["PERFORMER_TITLE"], ["icon"] = "132351", ["points"] = 0 },
	["Debuff"]      = { ["Title"] = L["Debuff_Title"], ["desc"] = L["PERFORMER_TITLE"], ["icon"] = "135802", ["points"] = 0 },
	["Cooldown"]    = { ["Title"] = L["Cooldown_Title"], ["desc"] = L["PERFORMER_TITLE"], ["icon"] = "461790", ["points"] = 10 },
	["Rage"]        = { ["Title"] = L["Rage_Title"], ["desc"] = L["PERFORMER_TITLE"], ["icon"] = "135818", ["points"] = 10 },
	["Enchant"]     = { ["Title"] = L["Enchant_Title"], ["desc"] = L["PERFORMER_TITLE"], ["icon"] = "463462", ["points"] = 0 },
	["AOE"]         = { ["Title"] = L["AOE_Title"], ["desc"] = L["PERFORMER_TITLE"], ["icon"] = "132352", ["points"] = 0 },
	["Moving"]      = { ["Title"] = L["Moving_Title"], ["desc"] = L["PERFORMER_TITLE"], ["icon"] = "135239", ["points"] = 0 },
	["Perfect"]     = { ["Title"] = L["Perfect_Title"], ["desc"] = L["PERFORMER_TITLE"], ["icon"] = "236550", ["points"] = 0 },
	["Listening"]   = { ["Title"] = L["Listening_Title"], ["desc"] = L["PERFORMER_TITLE"], ["icon"] = "1044996", ["points"] = 10 },
	["Savior"]      = { ["Title"] = L["Savior_Title"], ["desc"] = L["PERFORMER_TITLE"], ["icon"] = "135955", ["points"] = 10 },
	["Veteran"]     = { ["Title"] = L["Veteran_Title"], ["desc"] = L["PERFORMER_TITLE"], ["icon"] = "236648", ["points"] = 10 },
	["Legendary"]   = { ["Title"] = L["Legendary_Title"], ["desc"] = L["PERFORMER_TITLE"], ["icon"] = "134411", ["points"] = 10 },
	["Funny"]       = { ["Title"] = L["Funny_Title"], ["desc"] = L["PERFORMER_TITLE"], ["icon"] = "237554", ["points"] = 10 },
	["Latecomer"]   = { ["Title"] = L["Latecomer_Title"], ["desc"] = L["PERFORMER_TITLE"], ["icon"] = "1002578", ["points"] = 0 },
	["Death"]       = { ["Title"] = L["Death_Title"], ["desc"] = L["PERFORMER_TITLE"], ["icon"] = "237272", ["points"] = 0 },
	["Death_2"]     = { ["Title"] = L["Death_Title_2"], ["desc"] = L["PERFORMER_TITLE"], ["icon"] = "132205", ["points"] = 0 },
}

PerformerHeralds = {
	["Alliance"] = {
		["Default"] = "ALLIANCE_GUILD_HERALD",
		["WARRIOR"] = "VARIAN",
		["HUNTER"] = "HEMET",
		["ROGUE"] = "RAVERHOLDT",
		["PALADIN"] = "UTHER",
		["PRIEST"] = "VELEN",
		["SHAMAN"] = "NOBUNDO",
		["MAGE"] = "KHADGAR",
		["WARLOCK"] = "CHOGALL",
		["MONK"] = "CHEN",
		["DRUID"] = "MALFURION",
		["DEMONHUNTER"] = "ILLIDAN",
		["DEATHKNIGHT"] = "LICH_KING",
	},
	["Horde"] = {
		["Default"] = "HORDE_GUILD_HERALD",
		["WARRIOR"] = nil,
		["HUNTER"] = nil,
		["ROGUE"] = "RAVERHOLDT",
		["PALADIN"] = nil,
		["PRIEST"] = nil,
		["SHAMAN"] = "THRALL",
		["MAGE"] = nil,
		["WARLOCK"] = "CHOGALL",
		["MONK"] = "CHEN",
		["DRUID"] = nil,
		["DEMONHUNTER"] = "ILLIDAN",
		["DEATHKNIGHT"] = "LICH_KING",
	},
}

StaticPopupDialogs["SETGUILDTITLE"] = {
	text = L["SETGUILDTITLEBUTTON_TOOLTIP"],
	button1 = ACCEPT,
	button2 = CANCEL,
	hasEditBox = true,
	maxLetters = 20,
	editBoxWidth = 200,
	editBoxHeight = 50,
	OnShow = function (self)
		self.editBox:SetText("")
	end,
	OnAccept = function (self)
		local text = self.editBox:GetText()
		if strtrim(text) ~= "" then
			text = addUpperCaseOnFirstLetter(text)
			Performer:SendCommMessage(PerformerGlobal_CommPrefix, "P1_Title#"..GetTime().."#"..text.."#"..PerformerGlobal_GuildName, "GUILD")
			if GuildChatAnnouncement then
				announceTitleOnGuildChan(text, PerformerGlobal_GuildName)
			end
		end
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/

}

StaticPopupDialogs["DETAILS"] = {
	text = L["DETAILS_LABEL"],
	button1 = DONE,
	hasEditBox = true,
	maxLetters = 600,
	editBoxWidth = 600,
	editBoxHeight = 50,
	OnShow = function (self, data)
		self.editBox:SetText(data)
		if not isPlayerAdmin() then
			self.editBox:Disable()
		else
			self.editBox:Enable()
		end
	end,
	OnAccept = function (self, PerformerGlobal_GuildName, fullName)
		local text = addUpperCaseOnFirstLetter(self.editBox:GetText())
		local details = getPData(PerformerGlobal_GuildName, fullName, "Details")
		if text ~= details then
			changeDetailsInfo(PerformerGlobal_GuildName, fullName, text)
		end
		if text ~= "" then
			tellDetailsToPayer(charInfo[fullName]["classFileName"], text)
		end
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/

}

StaticPopupDialogs["NOT_ADMIN_ERROR"] = {
	text = L["NOT_ADMIN_ERROR"],
	button1 = OKAY,
	button2 = nil,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
}

StaticPopupDialogs["PROCESS_DIFF"] = {
	text = L["PROCESS_DIFF_TEXT"],
	button1 = L["PROCESS_DIFF_ACCEPT"],
	button2 = L["PROCESS_DIFF_CANCEL"],
	OnAccept = function (self, PerformerGlobal_GuildName, fullName)
		loadReceivedData(true)
	end,
	OnCancel = function (self, PerformerGlobal_GuildName, fullName)
		PerformerReceivedData = {}
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
}
