local L = LibStub("AceLocale-3.0"):GetLocale("Performer", true);

function Performer_SendCommMessage(text, distribution, target, aChar)
	if IsInGuild() or distribution == "WHISPER" or not aChar then
		Performer:SendCommMessage(PerformerGlobal_CommPrefix, text, distribution, target)
	else
		if aChar and charInfo[aChar] and countTableElements(charInfo[aChar]["clubId"]) > 0 then
			local alreadySend = {}
			for i, clubId in ipairs(charInfo[aChar]["clubId"]) do
				for j, member in ipairs(Performer.allMemberList[clubId]) do
					local fullName = Performer_addRealm(member.name)
					if not alreadySend[fullName] then
						alreadySend[fullName] = true
						Performer:SendCommMessage(PerformerGlobal_CommPrefix, text, "WHISPER", fullName)
					end
				end
			end
		end
	end
end

function encodeAndSendGuildInfo(aData, aTarget, aMessageTime)
	--Performer:Print(time().." - Preparing message.")
	local s = Performer:Serialize(aData)
	--Performer:Print(time().." - Message OK.")
	if aTarget and aMessageTime then
		Performer_SendCommMessage("P1_Data#"..aMessageTime.."#"..s, "WHISPER", aTarget)
		--Performer:Print(time().." - Message envoye.")
		--Performer:Print("Sent data to "..aTarget..".")
	else
		Performer_SendCommMessage("P1_Data#"..GetTime().."#"..s, "GUILD")
		--Performer:Print("Sent data to guild.")
	end
end

function encodeAndSendSimpleData(aData)
	local t = aData
	local s = Performer:Serialize(t)
	Performer_SendCommMessage("P1_SimpleData#"..GetTime().."#"..s, "GUILD", nil, Performer_playerCharacter())
end

function Performer:ReceiveDataFrame_OnEvent(prefix, message, distribution, sender)
	if prefix == PerformerGlobal_CommPrefix then
		--Performer:Print(time().." - Received message from "..sender..".")
		local messageType, messageTime, messageMessage, messageParam = strsplit("#", message, 4)
		if not isPlayerCharacter(sender) then
			if messageType == "P1_Data" or messageType == "P1_SimpleData" then
				local success, o = self:Deserialize(messageMessage)
				if success == false then
					Performer:Print(time().." - Received corrupted data from "..sender..".")
				else
					if PerformerReceivedData
						and PerformerReceivedData["CallTime"]
							and PerformerReceivedData["CallTime"] == messageTime then
						-- do nothing
						--Performer:Print(time().." - Received already processed "..messageType.." from "..sender..".")
					else
						--Performer:Print(time().." - Received "..messageType.." from "..sender..".")
						if not PerformerReceivedData then
							PerformerReceivedData = {}
						end
						PerformerReceivedData[PerformerGlobal_GuildName] = o
						PerformerReceivedData["CallTime"] = messageTime
						PerformerReceivedData["Sender"] = sender
						loadReceivedData(true)
					end
				end
			else
				if messageType == "Call" or messageType == "AdminCall" then
					encodeAndSendGuildInfo(P1_PerformerData[PerformerGlobal_GuildName], sender, messageTime)
				end
				if not isPlayerAdmin() and messageType == "AdminCall" then
					callForData()
				end
			end
		end
		if messageType == "P1_Title" then
			local title = addUpperCaseOnFirstLetter(messageMessage)
			local model = 5208
			if PerformerTitles[messageMessage] then
				title = PerformerTitles[messageMessage]["Title"]
			else
				if messageParam == PerformerGlobal_GuildName then
					model = 6921
				end
			end

			local temp = ACHIEVEMENT_UNLOCKED
			ACHIEVEMENT_UNLOCKED = L["NEW_TITLE_FOR"].." "..messageParam
			if CustomAchiever and isPlayerCharacter(messageParam) and PerformerTitles[messageMessage] then
				CustAc_CompleteAchievement(messageMessage, nil, false, true, PerformerSoundsDisabled)
			else
				EZBlizzUiPop_ToastFakeAchievementNew(Performer, title, tonumber(model), not PerformerSoundsDisabled, 15, ACHIEVEMENT_UNLOCKED, function()  PerformerFrame:Show()  end)
			end
			ACHIEVEMENT_UNLOCKED = temp
			local color = GREEN_FONT_COLOR_CODE
			if charInfo[messageParam] then
				color = "|c"..RAID_CLASS_COLORS[charInfo[messageParam]["classFileName"]].colorStr
			end
			local announcement = GREEN_FONT_COLOR_CODE.."["..color..messageParam..GREEN_FONT_COLOR_CODE.."] "..L["NEW_TITLE_ANNOUNCE"].." "..YELLOW_FONT_COLOR_CODE
			announcement = announcement.."["..title.."]"..GREEN_FONT_COLOR_CODE
			if P1_PerformerData[PerformerGlobal_GuildName]["PerformerSenderInAnnouncement"] then
				announcement = announcement.." "..L["NEW_TITLE_ANNOUNCER"].." ["..sender.."]"
			end
			announcement = announcement..L["SPACE_BEFORE_DOT"].."!"
			Performer:Print(announcement)
		end
		if messageType == "VersionCall" then
			sendVersion(sender)
		end
		if messageType == "Version" then
			Performer:Print(sender..L["SPACE_BEFORE_DOT"]..": "..messageMessage)
		end
	end
end

function callForData()
	--Performer:Print(time().." - Calling data!")
	if isPlayerAdmin() then
		Performer_SendCommMessage("AdminCall#"..GetTime(), "GUILD", nil, Performer_playerCharacter())
	else
		Performer_SendCommMessage("Call#"..GetTime(), "GUILD", nil, Performer_playerCharacter())
	end
end

function checkPerformerVersion()
	Performer_SendCommMessage("VersionCall#"..GetTime(), "GUILD", nil, Performer_playerCharacter())
end

function sendVersion(aSender)
	Performer_SendCommMessage("Version#"..GetTime().."#"..GetAddOnMetadata("Performer", "Version"), "WHISPER", aSender)
end
