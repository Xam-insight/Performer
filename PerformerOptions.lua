local ACR = LibStub("AceConfigRegistry-3.0")
local ACD = LibStub("AceConfigDialog-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Performer", true);

function loadPerformerOptions()
	local PerformerOptions = {
		type = "group",
		name = format("%s |cffADFF2Fv%s|r", "Performer", GetAddOnMetadata("Performer", "Version")),
		args = {
			general = {
				type = "group", order = 1,
				name = L["GENERAL_SECTION"],
				inline = true,
				args = {
					enable = {
						type = "toggle", order = 1,
						name = L["ENABLE_SOUND"],
								desc = L["ENABLE_SOUND_DESC"],
						set = function(info, val) 
							PerformerSoundsDisabled = not val
						end,
						get = function(info)
							local enabled = true
							if PerformerSoundsDisabled ~= nil then
								enabled = not PerformerSoundsDisabled
							end
							initPerformerBusinessObjects()
							return enabled
						end
					},
				},
			},
			inline = {
				type = "group", order = 2,
				name = L["ROSTER_SECTION"],
				inline = true,
				args = {
					minLevel = {
						type = "range", order = 1,
						width = "full", descStyle = "",
						name = L["CHARACTER_MIN_LEVEL"],
						get = function(i)
							return PerformerOptionsData[PerformerGlobal_GuildName]["minLevel"]
						end,
						set = function(i, v)
							PerformerOptionsData[PerformerGlobal_GuildName]["minLevel"] = v
							generatePerformerTable()
						end,
						min = 1,
						max = GetMaxPlayerLevel(),
						step = 1,
					},
					newline1 = {type = "description", order = 2, name = "\n"},
					inline = {
						type = "group", order = 3,
						name = L["LIST_INCLUDE_RANKS"],
						inline = true,
						args = {
							ignoreRank1 = {
								type = "toggle", order = 1,
								name = GuildControlGetRankName(1),
								desc = L["LIST_INCLUDE_RANKS_DESC"],
								hidden = (not GuildControlGetRankName(1) or GuildControlGetRankName(1) == ""),
								get = function(i)
									local includeRankValue = true
									if PerformerOptionsData[PerformerGlobal_GuildName] and PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"]
										and PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"]["1"] ~= nil then
										includeRankValue = PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"]["1"]
									end
									return includeRankValue
								end,
								set = function(i, v)
									if not PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"] then
										PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"] = {}
									end
									PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"]["1"] = v
									generatePerformerTable()
								end,
							},
							ignoreRank2 = {
								type = "toggle", order = 2,
								name = GuildControlGetRankName(2),
								desc = L["LIST_INCLUDE_RANKS_DESC"],
								hidden = (not GuildControlGetRankName(2) or GuildControlGetRankName(2) == ""),
								get = function(i)
									local includeRankValue = true
									if PerformerOptionsData[PerformerGlobal_GuildName] and PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"]
										and PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"]["2"] ~= nil then
										includeRankValue = PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"]["2"]
									end
									return includeRankValue
								end,
								set = function(i, v)
									if not PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"] then
										PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"] = {}
									end
									PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"]["2"] = v
									generatePerformerTable()
								end,
							},
							ignoreRank3 = {
								type = "toggle", order = 3,
								name = GuildControlGetRankName(3),
								desc = L["LIST_INCLUDE_RANKS_DESC"],
								hidden = (not GuildControlGetRankName(3) or GuildControlGetRankName(3) == ""),
								get = function(i)
									local includeRankValue = true
									if PerformerOptionsData[PerformerGlobal_GuildName] and PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"]
										and PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"]["3"] ~= nil then
										includeRankValue = PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"]["3"]
									end
									return includeRankValue
								end,
								set = function(i, v)
									if not PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"] then
										PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"] = {}
									end
									PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"]["3"] = v
									generatePerformerTable()
								end,
							},
							ignoreRank4 = {
								type = "toggle", order = 4,
								name = GuildControlGetRankName(4),
								desc = L["LIST_INCLUDE_RANKS_DESC"],
								hidden = (not GuildControlGetRankName(4) or GuildControlGetRankName(4) == ""),
								get = function(i)
									local includeRankValue = true
									if PerformerOptionsData[PerformerGlobal_GuildName] and PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"]
										and PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"]["4"] ~= nil then
										includeRankValue = PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"]["4"]
									end
									return includeRankValue
								end,
								set = function(i, v)
									if not PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"] then
										PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"] = {}
									end
									PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"]["4"] = v
									generatePerformerTable()
								end,
							},
							ignoreRank5 = {
								type = "toggle", order = 5,
								name = GuildControlGetRankName(5),
								desc = L["LIST_INCLUDE_RANKS_DESC"],
								hidden = (not GuildControlGetRankName(5) or GuildControlGetRankName(5) == ""),
								get = function(i)
									local includeRankValue = true
									if PerformerOptionsData[PerformerGlobal_GuildName] and PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"]
										and PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"]["5"] ~= nil then
										includeRankValue = PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"]["5"]
									end
									return includeRankValue
								end,
								set = function(i, v)
									if not PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"] then
										PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"] = {}
									end
									PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"]["5"] = v
									generatePerformerTable()
								end,
							},
							ignoreRank6 = {
								type = "toggle", order = 6,
								name = GuildControlGetRankName(6),
								desc = L["LIST_INCLUDE_RANKS_DESC"],
								hidden = (not GuildControlGetRankName(6) or GuildControlGetRankName(6) == ""),
								get = function(i)
									local includeRankValue = true
									if PerformerOptionsData[PerformerGlobal_GuildName] and PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"]
										and PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"]["6"] ~= nil then
										includeRankValue = PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"]["6"]
									end
									return includeRankValue
								end,
								set = function(i, v)
									if not PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"] then
										PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"] = {}
									end
									PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"]["6"] = v
									generatePerformerTable()
								end,
							},
							ignoreRank7 = {
								type = "toggle", order = 7,
								name = GuildControlGetRankName(7),
								desc = L["LIST_INCLUDE_RANKS_DESC"],
								hidden = (not GuildControlGetRankName(7) or GuildControlGetRankName(7) == ""),
								get = function(i)
									local includeRankValue = true
									if PerformerOptionsData[PerformerGlobal_GuildName] and PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"]
										and PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"]["7"] ~= nil then
										includeRankValue = PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"]["7"]
									end
									return includeRankValue
								end,
								set = function(i, v)
									if not PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"] then
										PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"] = {}
									end
									PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"]["7"] = v
									generatePerformerTable()
								end,
							},
							ignoreRank8 = {
								type = "toggle", order = 8,
								name = GuildControlGetRankName(8),
								desc = L["LIST_INCLUDE_RANKS_DESC"],
								hidden = (not GuildControlGetRankName(8) or GuildControlGetRankName(8) == ""),
								get = function(i)
									local includeRankValue = true
									if PerformerOptionsData[PerformerGlobal_GuildName] and PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"]
										and PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"]["8"] ~= nil then
										includeRankValue = PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"]["8"]
									end
									return includeRankValue
								end,
								set = function(i, v)
									if not PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"] then
										PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"] = {}
									end
									PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"]["8"] = v
									generatePerformerTable()
								end,
							},
							ignoreRank9 = {
								type = "toggle", order = 9,
								name = GuildControlGetRankName(9),
								desc = L["LIST_INCLUDE_RANKS_DESC"],
								hidden = (not GuildControlGetRankName(9) or GuildControlGetRankName(9) == ""),
								get = function(i)
									local includeRankValue = true
									if PerformerOptionsData[PerformerGlobal_GuildName] and PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"]
										and PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"]["9"] ~= nil then
										includeRankValue = PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"]["9"]
									end
									return includeRankValue
								end,
								set = function(i, v)
									if not PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"] then
										PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"] = {}
									end
									PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"]["9"] = v
									generatePerformerTable()
								end,
							},
							ignoreRank10 = {
								type = "toggle", order = 10,
								name = GuildControlGetRankName(10),
								desc = L["LIST_INCLUDE_RANKS_DESC"],
								hidden = (not GuildControlGetRankName(10) or GuildControlGetRankName(10) == ""),
								get = function(i)
									local includeRankValue = true
									if PerformerOptionsData[PerformerGlobal_GuildName] and PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"]
										and PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"]["10"] ~= nil then
										includeRankValue = PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"]["10"]
									end
									return includeRankValue
								end,
								set = function(i, v)
									if not PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"] then
										PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"] = {}
									end
									PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"]["10"] = v
									generatePerformerTable()
								end,
							},
						},
					},
					newline2 = {type = "description", order = 4, name = "\n"},
					guildChatAnnounce = {
						type = "toggle", order = 5,
						name = L["GUILD_CHAT_ANNOUNCE"],
						desc = L["GUILD_CHAT_ANNOUNCE_DESC"],
						width = "full",
						set = function(info, val) 
							GuildChatAnnouncement = val
						end,
						get = function(info)
							local enabled = false
							if GuildChatAnnouncement ~= nil then
								enabled = GuildChatAnnouncement
							end
							return enabled
						end
					},
				},
			},
			admin = {
				type = "group", order = 3,
				name = L["ADMIN_SECTION"],
				inline = true,
				args = {
					maxAdminRank = {
						type = "range", order = 1,
						width = "full", descStyle = "",
						name = L["ADMIN_MAX_RANK"],
						get = function(i)
							return P1_PerformerData[PerformerGlobal_GuildName]["maxAdminRank"]
						end,
						set = function(i, v)
							fullName, realm = UnitFullName("player")
							if isPlayerAdmin() 
									and charInfo[fullName.."-"..realm]["rankIndex"] <= v then
								P1_PerformerData[PerformerGlobal_GuildName]["maxAdminRank"] = v
								prepareAndSendSimpleDataToGuild(PerformerGlobal_GuildName, "maxAdminRank", v, true)
								generatePerformerTable()
							else
								StaticPopup_Show("NOT_ADMIN_ERROR")
							end
						end,
						min = 1,
						max = 20, softMax = 10,
						step = 1,
					},
					newline3 = {type = "description", order = 2, name = "\n"},
					tellAnnouncer = {
						type = "toggle", order = 3,
						name = L["TELL_ANNOUNCER"],
						desc = L["TELL_ANNOUNCER_DESC"],
						width = "full",
						set = function(info, val) 
							if isPlayerAdmin() then
								P1_PerformerData[PerformerGlobal_GuildName]["PerformerSenderInAnnouncement"] = val
								prepareAndSendSimpleDataToGuild(PerformerGlobal_GuildName, "PerformerSenderInAnnouncement", val, true)
							else
								StaticPopup_Show("NOT_ADMIN_ERROR")
							end
						end,
						get = function(info)
							local enabled = false
							if P1_PerformerData[PerformerGlobal_GuildName]["PerformerSenderInAnnouncement"] ~= nil then
								enabled = P1_PerformerData[PerformerGlobal_GuildName]["PerformerSenderInAnnouncement"]
							end
							return enabled
						end
					},
					newline4 = {type = "description", order = 4, name = "\n"},
					allowCustomAnnouncement = {
						type = "toggle", order = 5,
						name = L["ALLOW_CUSTOM_ANNOUNCEMENTS"],
						desc = L["ALLOW_CUSTOM_ANNOUNCEMENTS_DESC"],
						width = "full",
						set = function(info, val) 
							if isPlayerAdmin() then
								P1_PerformerData[PerformerGlobal_GuildName]["PerformerAllowCustomAnnouncements"] = val
								prepareAndSendSimpleDataToGuild(PerformerGlobal_GuildName, "PerformerAllowCustomAnnouncements", val, true)
							else
								StaticPopup_Show("NOT_ADMIN_ERROR")
							end
						end,
						get = function(info)
							local enabled = false
							if P1_PerformerData[PerformerGlobal_GuildName]["PerformerAllowCustomAnnouncements"] ~= nil then
								enabled = P1_PerformerData[PerformerGlobal_GuildName]["PerformerAllowCustomAnnouncements"]
							end
							return enabled
						end
					},
				},
			},
		},
	}

	ACR:RegisterOptionsTable("Performer", PerformerOptions)
	ACD:AddToBlizOptions("Performer", "Performer")
	ACD:SetDefaultSize("Performer", 585, 575)
end
