charInfo = {}
local L = LibStub("AceLocale-3.0"):GetLocale("Performer", true);

-- Initialize Performers Objects
function initPerformerBusinessObjects()
	PerformerGlobal_GuildName, guildRankName, guildRankIndex = GetGuildInfo("player")
	if not PerformerGlobal_GuildName then
		PerformerGlobal_GuildName = "No_Guild"
	end

	-- P1_PerformerData
	if not P1_PerformerData then
		P1_PerformerData = {}
	end
	if not P1_PerformerData[PerformerGlobal_GuildName] then
		P1_PerformerData[PerformerGlobal_GuildName] = {}
	end
	if not P1_PerformerData[PerformerGlobal_GuildName]["maxAdminRank"] then
		P1_PerformerData[PerformerGlobal_GuildName]["maxAdminRank"] = 2
	end
	-- PerformerOptionsData
	if not PerformerOptionsData then
		PerformerOptionsData = {}
	end
	if not PerformerOptionsData[PerformerGlobal_GuildName] then
		PerformerOptionsData[PerformerGlobal_GuildName] = {}
	end
	if not PerformerOptionsData[PerformerGlobal_GuildName]["minLevel"] then
		PerformerOptionsData[PerformerGlobal_GuildName]["minLevel"] = GetMaxPlayerLevel()
	end
end

-- Change role value
function changeRoleInfo(aGuildName, aFullName)
	local actualRole = getPData(aGuildName, aFullName, "Role")
	local newRole = nil
	if not actualRole or actualRole == "DPS" then
		newRole = "Tank"
	else
		if actualRole == "Tank" then
			newRole = "Heal"
		else
			newRole = "DPS"
		end
	end

	if newRole then
		setPData(aGuildName, aFullName, "Role", newRole)
		prepareAndSendSimpleDataToGuild(aGuildName, aFullName, "Role")

		generatePerformerTable()
	end
end

function prepareAndSendSimpleDataToGuild(aGuild, aCharacter, anInfo, isOptionData)
	local Temp_PerformerData = {}
	if not isOptionData then
		local value, dataTime = getPData(aGuild, aCharacter, anInfo)
		Temp_PerformerData[aCharacter] = {}
		local infoToSend = value
		if dataTime then
			infoToSend = infoToSend.."|"..dataTime
		end
		Temp_PerformerData[aCharacter][anInfo] = infoToSend
	else
		Temp_PerformerData[aCharacter] = P1_PerformerData[aGuild][aCharacter]
	end
	encodeAndSendSimpleData(Temp_PerformerData)
end

-- Change icon value and return alpha value
function changeIconInfo(aGuildName, aFullName, anIcon)
	local alpha = 0.1
	local actualIconInfo = getPData(aGuildName, aFullName, anIcon)
	if actualIconInfo == "true" then
		setPData(aGuildName, aFullName, anIcon, "false")
	else
		setPData(aGuildName, aFullName, anIcon, "true")
		alpha = 1.0
	end

	prepareAndSendSimpleDataToGuild(aGuildName, aFullName, anIcon)

	return alpha
end

-- Send character title to guild mates
function announceTitle(aGuildName, aFullName)
	local title = getPData(aGuildName, aFullName, "Title")
	if title ~= nil and title ~= "0" and title ~= "AA_NoTitle" and title ~= "" then
		Performer_SendCommMessage("P1_Title#"..GetTime().."#"..title.."#"..aFullName, "GUILD", nil, aFullName)
		if GuildChatAnnouncement then
			local titleLabel = PerformerTitles[title]["Title"]
			announceTitleOnGuildChan(titleLabel, aFullName)
		end
	end
end

function announceTitleOnGuildChan(titleLabel, aFullName)
	local playerFullName, playerRealm = UnitFullName("player")
	local guildAnnouncement = "["..aFullName.."] "..L["NEW_TITLE_ANNOUNCE"].." ".."["..titleLabel.."]"
	if P1_PerformerData[PerformerGlobal_GuildName]["PerformerSenderInAnnouncement"] then
		guildAnnouncement = guildAnnouncement.." "..L["NEW_TITLE_ANNOUNCER"].." ["..playerFullName.."]"
	end
	guildAnnouncement = guildAnnouncement..L["SPACE_BEFORE_DOT"].."!"
	SendChatMessage("Performer: "..guildAnnouncement, "Guild")
end

-- Change character title
function changeTitleInfo(aGuildName, aFullName, title)
	setPData(aGuildName, aFullName, "Title", title)
	
	prepareAndSendSimpleDataToGuild(aGuildName, aFullName, "Title")
end

-- Change details info
function changeDetailsInfo(aGuildName, aFullName, details)
	details = string.gsub(details, "|", "/") -- Char | is used to time data
	setPData(aGuildName, aFullName, "Details", details)

	prepareAndSendSimpleDataToGuild(aGuildName, aFullName, "Details")
end

-- Get Roster Info
function getRosterInfo()
	charInfo = {}
	numGuildMembers, numOnline, numOnlineAndMobile = GetNumGuildMembers()
	for i = 1, numGuildMembers do
		local fullName, rank, rankIndex, level, class, zone,
			note, officernote, online, status, classFileName,
			achievementPoints, achievementRank, isMobile,
			canSoR, reputation = GetGuildRosterInfo(i)
		charInfo[fullName] = {}
		charInfo[fullName]["classFileName"] = classFileName
		charInfo[fullName]["rankIndex"] = rankIndex
		charInfo[fullName]["level"] = level
		charInfo[fullName]["online"] = online
		clearCharacter(fullName)
	end

	return charInfo
end

-- Get Roster Id
function getRosterId(aFullName)
	numGuildMembers, numOnline, numOnlineAndMobile = GetNumGuildMembers()
	for i = 1, numGuildMembers do
		local fullName, rank, rankIndex, level, class, zone,
			note, officernote, online, status, classFileName,
			achievementPoints, achievementRank, isMobile,
			canSoR, reputation = GetGuildRosterInfo(i)
		if fullName == aFullName then
			return i
		end
	end
	return 0
end

-- Load Received Data
function loadReceivedData(force)
	local receivedDataWasObsolete = false
	--Performer:Print(time().." - Processing data.")
	if PerformerReceivedData and PerformerReceivedData[PerformerGlobal_GuildName] then
		for index,value in pairs(PerformerReceivedData[PerformerGlobal_GuildName]) do
			if index == "maxAdminRank" or index == "PerformerSenderInAnnouncement" or index == "PerformerAllowCustomAnnouncements" then -- Update admin config
				P1_PerformerData[PerformerGlobal_GuildName][index] = PerformerReceivedData[PerformerGlobal_GuildName][index]
				PerformerReceivedData[PerformerGlobal_GuildName][index] = nil
			else -- Update characters list data
				if not P1_PerformerData[PerformerGlobal_GuildName][index] 
					and (isPlayerAdmin() or isPlayerCharacter(index)) then -- If player has no data for character
					P1_PerformerData[PerformerGlobal_GuildName][index] = PerformerReceivedData[PerformerGlobal_GuildName][index]
					PerformerReceivedData[PerformerGlobal_GuildName][index] = nil
				else
					for index2,value2 in pairs(PerformerReceivedData[PerformerGlobal_GuildName][index]) do
						--Performer:Print("Admin ? "..tostring(isPlayerAdmin()))
						if isPlayerAdmin() or isPlayerCharacter(index) or index2 == "Title" or index2 == "Role" then
							local actualData, actualDataTime = getPData(PerformerGlobal_GuildName, index, index2)
							if actualDataTime then
								actualData = actualData.."|"..actualDataTime
							end
							--Performer:Print(time().." - actualData "..index.." "..index2)
							--Performer:Print(actualData)
							local newData = tostring(PerformerReceivedData[PerformerGlobal_GuildName][index][index2])
							--Performer:Print(time().." - newData "..index2)
							--Performer:Print(newData)
							if actualData == nil
								or not isPlayerAdmin()
									or (force and actualData ~= newData) then
								local newValue, myValueWasObsolete = getMostRecentValueAndTime(actualData, newData)
								setPData(PerformerGlobal_GuildName, index, index2, newValue)
								if myValueWasObsolete then
									PerformerNewData[PerformerGlobal_GuildName..index..index2] = true
								else
									if actualData ~= newData and not myValueWasObsolete then
										receivedDataWasObsolete = true
									end
								end
								PerformerReceivedData[PerformerGlobal_GuildName][index][index2] = nil
							else
								if actualData == newData then
									PerformerReceivedData[PerformerGlobal_GuildName][index][index2] = nil
								end
							end
						else
							PerformerReceivedData[PerformerGlobal_GuildName][index][index2] = nil
						end
					end
				end
			end
			if PerformerReceivedData[PerformerGlobal_GuildName][index] 
				and countTableElements(PerformerReceivedData[PerformerGlobal_GuildName][index]) == 0 then
				PerformerReceivedData[PerformerGlobal_GuildName][index] = nil
			end
		end
		if countTableElements(PerformerReceivedData[PerformerGlobal_GuildName]) == 0 then
			PerformerReceivedData[PerformerGlobal_GuildName] = nil
		end
	end
	--Performer:Print(time().." - Data processed.")
	if receivedDataWasObsolete then
		encodeAndSendGuildInfo(P1_PerformerData[PerformerGlobal_GuildName], PerformerReceivedData["Sender"], PerformerReceivedData["CallTime"])
	end
	generatePerformerTable()
end

function clearCharacter(aFullName)
	if aFullName and P1_PerformerData and P1_PerformerData[PerformerGlobal_GuildName]
			and P1_PerformerData[PerformerGlobal_GuildName][aFullName]
				and countTableElements(P1_PerformerData[PerformerGlobal_GuildName][aFullName]) == 0 then
		P1_PerformerData[PerformerGlobal_GuildName][aFullName] = nil
	end
end

function countTableElements(table)
	local count = 0
	if table then
		for _ in pairs(table) do
			count = count + 1
		end
	end
	return count
end

function getPData(aGuild, aChar, anInfo)
	local value = nil
	local dataTime = nil
	if aGuild and aChar and anInfo then
		if P1_PerformerData 
			and P1_PerformerData[aGuild]
				and P1_PerformerData[aGuild][aChar] then
			value = P1_PerformerData[aGuild][aChar][anInfo]
			if value ~= nil then
				value, dataTime = strsplit("|", tostring(value), 2)
				if dataTime and dataTime == "" then
					dataTime = nil
				end
			end
		end
	end
	return value, dataTime
end

function setPData(aGuild, aChar, anInfo, aValue)
	if aGuild and aChar and anInfo then
		local value, dataTime = strsplit("|", tostring(aValue), 2)
		if not P1_PerformerData then
			P1_PerformerData = {}
		end
		if not P1_PerformerData[aGuild] then
			P1_PerformerData[aGuild] = {}
		end
		if not P1_PerformerData[aGuild][aChar] then
			P1_PerformerData[aGuild][aChar] = {}
		end
		if not dataTime or dataTime == "" then
			dataTime = tostring(getTimeUTCinMS())
		end
		P1_PerformerData[aGuild][aChar][anInfo] = value.."|"..dataTime
	end
end

function getTimeUTCinMS()
	return tostring(time(date("!*t")))
end

function getMostRecentValueAndTime(myValueTime, newValueTime)
	local myValue, myDataTime, newValue, newDataTime
	local myValueIsObsolete = false

	if myValueTime then
		myValue, myDataTime = strsplit("|", myValueTime, 2)
	end
	if newValueTime then
		newValue, newDataTime = strsplit("|", newValueTime, 2)
		myValueIsObsolete = true
	end
	if myDataTime and newDataTime and myDataTime ~= "" and newDataTime ~= "" then
		myDataTime = tonumber(myDataTime)
		newDataTime = tonumber(newDataTime)
		if myDataTime >= newDataTime then
			newValue = myValue
			newDataTime = myDataTime
			myValueIsObsolete = false
		end
	end
	
	local returnedValue = newValue
	if newDataTime and newDataTime ~= "" then
		returnedValue = returnedValue.."|"..newDataTime
	end

	return returnedValue, myValueIsObsolete
end

function getTitleLabel(aTitle)
	local label = ""
	if PerformerTitles[aTitle] and PerformerTitles[aTitle]["Title"] then
		label = PerformerTitles[aTitle]["Title"]
	end
	return label
end

function addUpperCaseOnFirstLetter(aText)
	local newText = ""
	if aText then
		retOK, ret = pcall(addUpperCaseOnFirstLetterBusiness, aText)
		if retOK then
			newText = ret
		else
			newText = strtrim(aText)
		end
	end
	return newText
end

function addUpperCaseOnFirstLetterBusiness(aText)
	return string.utf8upper(string.utf8sub(strtrim(aText), 1 , 1))..string.utf8sub(strtrim(aText), 2)
end

function Performer_addRealm(aName, aRealm)
	if aName and not string.match(aName, "-") then
		if aRealm and aRealm ~= "" then
			aName = aName.."-"..aRealm
		else
			local realm = GetNormalizedRealmName() or UNKNOWNOBJECT
			aName = aName.."-"..realm
		end
	end
	return aName
end
