Performer = LibStub("AceAddon-3.0"):NewAddon("Performer", "AceConsole-3.0", "AceEvent-3.0", "AceComm-3.0", "AceSerializer-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Performer", true);
local AceGUI = LibStub("AceGUI-3.0")
local ACD = LibStub("AceConfigDialog-3.0")

PerformerGlobal_CommPrefix = "Performer"

PerformerNewData = {}

local performerFramePool = {}
PerformerGlobal_BetweenObjectsGap = 15
PerformerGlobal_BetweenLinesGap = 30

function Performer:OnInitialize()
	-- Called when the addon is loaded
end

function Performer:OnEnable()
	-- Called when the addon is enabled
	self:RegisterEvent("GUILD_ROSTER_UPDATE", "ActivateAddOn")
	self:RegisterEvent("CLUB_STREAMS_LOADED", "test")
	--self:RegisterEvent("CLUB_FINDER_RECRUITS_UPDATED", "test")
	self:RegisterEvent("CLUB_MEMBER_ADDED", "test")
	self:RegisterEvent("CLUB_MEMBER_REMOVED", "test")
	self:RegisterEvent("CLUB_MEMBER_UPDATED", "test")
	if not CustomAchiever then
		LoadAddOn("Performer_CustomAchiever")
	end
end

function Performer:test(event)
	self:UnregisterEvent("CLUB_STREAMS_LOADED")
	local clubs = C_Club.GetSubscribedClubs();
	for i, club in ipairs(clubs) do
		local clubInfo = C_Club.GetClubInfo(club.clubId)
		if clubInfo.clubType == Enum.ClubType.Guild then
			self:UnregisterEvent("CLUB_MEMBER_ADDED")
			self:UnregisterEvent("CLUB_MEMBER_REMOVED")
			self:UnregisterEvent("CLUB_MEMBER_UPDATED")
			return
		end
	end
	local clubInfos = {}
	for i, club in ipairs(clubs) do
		local clubInfo = C_Club.GetClubInfo(club.clubId)
		if clubInfo.clubType ~= Enum.ClubType.Guild and clubInfo.clubType ~= Enum.ClubType.BattleNet then
			charInfo = {}
			self.memberIds = CommunitiesUtil.GetMemberIdsSortedByName(club.clubId)
			if not self.allMemberList then
				self.allMemberList = {}
			end
			self.allMemberList[club.clubId] = CommunitiesUtil.GetMemberInfo(club.clubId, self.memberIds)
			for j, member in ipairs(self.allMemberList[club.clubId]) do
				local fullName = Performer_addRealm(member.name)
				if not clubInfos[fullName] then
					clubInfos[fullName] = {}
				end
				clubInfos[fullName]["classFileName"] = C_CreatureInfo.GetClassInfo(member.classID).classFile
				clubInfos[fullName]["rankIndex"] = member.role
				clubInfos[fullName]["level"] = member.level
				if not clubInfos[fullName]["clubId"] then
					clubInfos[fullName]["clubId"] = {}
				end
				tinsert(clubInfos[fullName]["clubId"], club.clubId)
			end
		end
	end
	if countTableElements(clubInfos) > 0 then
		charInfo = clubInfos
		Performer:ActivateAddOn()
	end
end

function Performer:ActivateAddOn()
	--Performer:Print("Activated")
	if not PerformerFrame and charInfo and countTableElements(charInfo) ~= 0 then
		--Performer:Print("Frame loading")
		loadPerformerOptions()
		initPerformerBusinessObjects()

		--PerformerFrame
		PerformerFrame = CreateFrame("Frame", "PerformerFrame", UIParent, "PerformerFrameTemplate")
		if PerformerPosition then
			PerformerFrame:SetPoint(PerformerPosition["point"], UIParent, PerformerPosition["relativePoint"], PerformerPosition["xOffset"], PerformerPosition["yOffset"])
		end
		
		local fontstring = PerformerFrame:CreateFontString("PerformerLabel", "ARTWORK", "PerformerWindowTitleTemplate")
		fontstring:SetText("Performer".." - "..PerformerGlobal_GuildName)
		fontstring:SetPoint("TOP", 0, -1)

		local setGuildTitleButton = createSetGuildTitleButton(PerformerFrame)
		if not isPlayerAdmin() then
			setGuildTitleButton:Hide()
		else
			setGuildTitleButton:Show()
		end

		local performerOptionsButton = createPerformerOptionsButton(PerformerFrame)
		local performerSearchBox = createPerformerSearchBox(PerformerFrame)

		--PerformerScrollFrame
		local scrollFrame = CreateFrame("ScrollFrame", "PerformerScrollFrame", PerformerFrame, "UIPanelScrollFrameTemplate")
		scrollFrame:SetSize(1, 1)
		scrollFrame:SetAllPoints()
		scrollFrame:SetPoint("TOPLEFT", 2, -23)
		scrollFrame:SetPoint("BOTTOMRIGHT", -26, 5)

		--InsidePerformerScrollFrame
		local content = CreateFrame("Frame", "InsidePerformerScrollFrame", PerformerScrollFrame) 
		content:SetSize(1, 1)
		content:SetAllPoints()
		PerformerScrollFrame.content = content
		PerformerScrollFrame:SetScrollChild(content)

		self:RegisterChatCommand("performer", "PerformerShow")
		self:RegisterComm(PerformerGlobal_CommPrefix, "ReceiveDataFrame_OnEvent")
		Performer:Print(L["PERFORMER_WELCOME"])
	end
	if not charInfo or countTableElements(charInfo) == 0 then
		charInfo = getRosterInfo(PerformerGlobal_GuildName)
		generatePerformerTable()
		callForData()
	end
end

function Performer:OnDisable()
		-- Called when the addon is disabled
end

function Performer:PerformerShow(input)
	if input and input ~= "" then
		if isPlayerAdmin()
			or (P1_PerformerData[PerformerGlobal_GuildName]
				and P1_PerformerData[PerformerGlobal_GuildName]["PerformerAllowCustomAnnouncements"]) then
			name, realm = UnitFullName("target")
			if name then
				--if realm then
				--	name = name.."-"..realm
				--end
				local text = addUpperCaseOnFirstLetter(input)
				Performer_SendCommMessage("P1_Title#"..GetTime().."#"..text.."#"..name, "GUILD", nil, Performer_addRealm(name, realm))
				if GuildChatAnnouncement then
					announceTitleOnGuildChan(text, name)
				end
			end
		end
	else
		generatePerformerTable()
		PerformerFrame:Show()
	end
	
	
end

function IconButtonClick(self)
	if isPlayerAdmin() then
		if PerformerReceivedData and PerformerReceivedData[PerformerGlobal_GuildName]
			and PerformerReceivedData["Sender"] then
			StaticPopup_Show("PROCESS_DIFF", PerformerReceivedData["Sender"])
		else
			local fullName = self:GetAttribute("fullName")
			local icon = self:GetAttribute("icon")
			self:SetAlpha(changeIconInfo(PerformerGlobal_GuildName, fullName, icon))
		end
	end
end

function RoleButtonClick(self)
	if isPlayerAdmin() then
		if PerformerReceivedData and PerformerReceivedData[PerformerGlobal_GuildName]
			and PerformerReceivedData["Sender"] then
			StaticPopup_Show("PROCESS_DIFF", PerformerReceivedData["Sender"])
		else
			local fullName = self:GetAttribute("fullName")
			changeRoleInfo(PerformerGlobal_GuildName, fullName)
		end
	end
end

function SetTitleButtonClick(self)
	if PerformerReceivedData and PerformerReceivedData[PerformerGlobal_GuildName]
		and PerformerReceivedData["Sender"] then
		StaticPopup_Show("PROCESS_DIFF", PerformerReceivedData["Sender"])
	else
		local fullName = self:GetAttribute("fullName")
		announceTitle(PerformerGlobal_GuildName, fullName)
	end
end

function PerformerSetGuildTitleButtonClick(self)
	StaticPopup_Show("SETGUILDTITLE")
end

function PerformerOptionsButtonClick(self)
	ACD:Open("Performer")
	checkPerformerVersion()
end

function IconButtonEnter(self)
	local tooltip = self:GetAttribute("tooltip")
	local tooltipDetail = self:GetAttribute("tooltipDetail")
	PerformerTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
	PerformerTooltip:SetText(tooltip)
	PerformerTooltip:AddLine(tooltipDetail, 1.0, 1.0, 1.0)
	PerformerTooltip:Show()
end

function IconButtonLeave(self)
	PerformerTooltip:Hide()
end

function getLineFromFramePool(name)
	if not performerFramePool["lines"] then
		performerFramePool["lines"] = {}
	end
	if not performerFramePool["lines"][name] then
		performerFramePool["lines"][name] = CreateFrame("Button", name, InsidePerformerScrollFrame, "LineTemplate")
	end
	return performerFramePool["lines"][name]
end

function getFontStringFromFramePool(id, name, template)
	if not performerFramePool[id] then
		performerFramePool[id] = {}
	end
	if not performerFramePool[id][name] then
		performerFramePool[id][name] = _G["LineFrame"..id]:CreateFontString(name, "ARTWORK", template)
	end
	return performerFramePool[id][name]
end

function getButtonFromFramePool(id, name, template, columnNumber)
	local buttonName = name
	if columnNumber then
		buttonName = columnNumber
	end
	if not performerFramePool[id] then
		performerFramePool[id] = {}
	end
	if not performerFramePool[id][buttonName] then
		performerFramePool[id][buttonName] = CreateFrame("Button", name, _G["LineFrame"..id], template)
	end
	return performerFramePool[id][buttonName]
end

function buildTitlesList()
	local titlesList = {}
	for k,v in pairs(PerformerTitles) do
		titlesList[k] = v["Title"]
	end
	return titlesList
end

function getDropDownMenuFromFramePool(id, name)
	if not performerFramePool[id] then
		performerFramePool[id] = {}
	end
	local dropDownMenu = performerFramePool[id][name]
	if not dropDownMenu then
		dropDownMenu = AceGUI:Create("Dropdown")
		dropDownMenu.frame:SetParent(_G["LineFrame"..id])
		dropDownMenu.frame:SetWidth(200);
		dropDownMenu:SetList(buildTitlesList())
		dropDownMenu:SetCallback("OnValueChanged", function(dropDownMenu, event, value)
			changeTitleInfo(PerformerGlobal_GuildName, dropDownMenu.frame:GetAttribute("fullName"), value)
		end)
		performerFramePool[id][name] = dropDownMenu
	end
	if not isPlayerAdmin() then
		dropDownMenu.SetDisabled(dropDownMenu, true)
	else
		dropDownMenu.SetDisabled(dropDownMenu, false)
	end
	dropDownMenu.button:SetScript("OnEnter", ActionButton_HideOverlayGlow)
	return dropDownMenu
end

function createLine(aGuildName, fullName, numColumn, indexCharac, xValue)

	local line = getLineFromFramePool("LineFrame"..indexCharac)
	line:SetPoint("TOPLEFT", 0, -5 - (indexCharac-1) * PerformerGlobal_BetweenLinesGap)
	line:Show()

	local xValue = PerformerGlobal_BetweenObjectsGap
	local roleButton, role = createRoleButton(aGuildName, fullName, "RoleButton", indexCharac, xValue)

	xValue = roleButton:GetWidth() + 2*PerformerGlobal_BetweenObjectsGap
	local fontstring = getFontStringFromFramePool(indexCharac, "PlayerLabel", "PlayerLabelTemplate")
	local color = RAID_CLASS_COLORS[charInfo[fullName]["classFileName"]]
	fontstring:SetTextColor(color.r, color.g, color.b, 1.0)
	fontstring:SetText(fullName)
	fontstring:SetPoint("LEFT", xValue, 0)
	
	xValue = xValue + PlayerLabel:GetWidth()
	local columnNumber = 0
	for index,value in pairs(PerformerIcons[role]) do
		columnNumber = columnNumber + 1
		xValue = xValue + 20 + PerformerGlobal_BetweenObjectsGap
		createColumn(aGuildName, fullName, value, indexCharac, xValue, columnNumber)
	end
	for index,value in pairs(PerformerIcons["All"]) do
		columnNumber = columnNumber + 1
		xValue = xValue + 20 + PerformerGlobal_BetweenObjectsGap
		createColumn(aGuildName, fullName, value, indexCharac, xValue, columnNumber)
	end

	local dropDownMenu = getDropDownMenuFromFramePool(indexCharac, "PerformerDropDownMenu"..indexCharac)
	dropDownMenu.frame:ClearAllPoints()
	xValue = xValue + 2*PerformerGlobal_BetweenObjectsGap
	dropDownMenu.frame:SetPoint("LEFT", xValue, 1)
	dropDownMenu.frame:SetAttribute("fullName", fullName)
	local title = getPData(aGuildName, fullName, "Title")
	if title then
		dropDownMenu:SetValue(title)
		if PerformerNewData[aGuildName..fullName.."Title"] then
			ActionButton_ShowOverlayGlow(dropDownMenu.button)
			PerformerNewData[aGuildName..fullName.."Title"] = nil
		else
			ActionButton_HideOverlayGlow(dropDownMenu.button)
		end
	else
		dropDownMenu:SetValue("AA_NoTitle")
	end
	
	xValue = xValue + dropDownMenu.frame:GetWidth() + PerformerGlobal_BetweenObjectsGap
	local setTitleButton = createSetTitleButton(aGuildName, fullName, "SetTitleButton", indexCharac, xValue)
	if not isPlayerAdmin() then
		setTitleButton:Hide()
	else
		setTitleButton:Show()
	end
	
	xValue = xValue + setTitleButton:GetWidth() + PerformerGlobal_BetweenObjectsGap
	local detailsButton = getButtonFromFramePool(indexCharac, "DetailsButton", "DetailsButtonLabelTemplate")
	
	local isFilled = ""
	local details = getPData(aGuildName, fullName, "Details")
	if details and strtrim(details) ~= "" then
		isFilled = "*"
	end
	
	detailsButton:SetText(L["DETAILS_BUTTON"]..isFilled)
	detailsButton:SetPoint("LEFT", xValue, 0)
	detailsButton:SetAttribute("fullName", fullName)
	if PerformerNewData[aGuildName..fullName.."Details"] then
		ActionButton_ShowOverlayGlow(detailsButton)
		PerformerNewData[aGuildName..fullName.."Details"] = nil
	else
		ActionButton_HideOverlayGlow(detailsButton)
	end

	detailsButton:Hide()
	if isPlayerAdmin() then
		detailsButton:Show()
	else
		if isPlayerCharacter(fullName) then
			if details and strtrim(details) ~= "" then
				detailsButton:Show()
			end
		end
	end

	xValue = xValue + detailsButton:GetWidth() + 20 + PerformerGlobal_BetweenObjectsGap
	PerformerFrame:SetWidth(xValue)
	line:SetWidth(xValue - 24)
end

function isPlayerCharacter(aName)
	playerFullName, playerRealm = UnitFullName("player")
	return playerFullName.."-"..playerRealm == aName or playerFullName == aName
end

local Performer_pc
function Performer_playerCharacter()
	if not Performer_pc then
		Performer_pc = Performer_fullName("player")
	end
	return Performer_pc
end

function Performer_fullName(unit)
	local fullName = nil
	if unit then
		local playerName, playerRealm = UnitFullName(unit)
		if playerName and playerName ~= "" and playerName ~= UNKNOWNOBJECT then
			if not playerRealm or playerRealm == "" then
				playerRealm = GetNormalizedRealmName()
			end
			if playerRealm and playerRealm ~= "" then
				fullName = playerName.."-"..playerRealm
			end
		end
	end
	return fullName
end

function DetailsButton_Onclick(self)
	local fullName = self:GetAttribute("fullName")
	local details = getPData(PerformerGlobal_GuildName, fullName, "Details")
	if not details then details = "" end
	if isPlayerAdmin() then
		local detailsDialog = StaticPopup_Show("DETAILS", nil, nil, details)
		if (detailsDialog) then
			detailsDialog.data = PerformerGlobal_GuildName
			detailsDialog.data2 = fullName
		end
	else
		if strtrim(details) ~= "" then
			tellDetailsToPayer(charInfo[fullName]["classFileName"], details)
		end
	end
end

function createSetTitleButton(aGuildName, fullName, name, indexCharac, xValue)
	local iconPath = "Interface\\BUTTONS\\UI-GuildButton-MOTD-Up"
	local tooltip = L["SETTITLEBUTTON_TOOLTIP"]
	local tooltipDetail = L["SETTITLEBUTTON_TOOLTIPDETAIL"]
	

	local iconButton = getButtonFromFramePool(indexCharac, name, "SetTitleButtonTemplate")
	iconButton:SetPoint("LEFT", xValue, 0)
	iconButton:SetNormalTexture(iconPath)
	iconButton:SetAttribute("icon", name)
	iconButton:SetAttribute("fullName", fullName)
	iconButton:SetAttribute("tooltip", tooltip)
	iconButton:SetAttribute("tooltipDetail", tooltipDetail)

	return iconButton
end

function createSetGuildTitleButton(parent)
	local name = "GuildTitleButton"
	local iconPath = "Interface\\BUTTONS\\UI-GuildButton-MOTD-Up"
	local tooltip = L["SETGUILDTITLEBUTTON_TOOLTIP"]
	local tooltipDetail = L["SETGUILDTITLEBUTTON_TOOLTIPDETAIL"]

	local setGuildTitleButton = CreateFrame("Button", name, parent, "SetGuildTitleButtonTemplate")
	setGuildTitleButton:SetPoint("TOPRIGHT", -160, -3)
	setGuildTitleButton:SetNormalTexture(iconPath)
	setGuildTitleButton:SetAttribute("tooltip", tooltip)
	setGuildTitleButton:SetAttribute("tooltipDetail", tooltipDetail)

	return setGuildTitleButton
end

function createPerformerOptionsButton(parent)
	local name = "PerformerOptionsButton"
	local iconPath = "Interface\\GossipFrame\\BinderGossipIcon"
	local tooltip = L["MENU_OPTIONS"]

	local optionsButton = CreateFrame("Button", name, parent, "PerformerOptionsButtonTemplate")
	optionsButton:SetPoint("TOPRIGHT", -30, -3)
	optionsButton:SetNormalTexture(iconPath)
	optionsButton:SetAttribute("tooltip", tooltip)

	return optionsButton
end

function createPerformerSearchBox(parent)
	local name = "PerformerSearchBox"
	local searchBox = CreateFrame("EditBox", name, parent, "PerformerSearchBoxTemplate")
	searchBox:SetPoint("TOPLEFT", 5, -2)
	
	return searchBox
end

function createRoleButton(aGuildName, fullName, performerIcon, indexCharac, xValue)
	local name = "Role"
	local tooltip = L["ROLEBUTTON_TOOLTIP"]
	local tooltipDetail = L["ROLEBUTTON_TOOLTIPDETAIL"]
	local glow = false
	local role = "DPS"
	local actualRole = getPData(aGuildName, fullName, "Role")
	if actualRole then
		role = actualRole
		if PerformerNewData[PerformerGlobal_GuildName..fullName.."Role"] then
			glow = true
			PerformerNewData[PerformerGlobal_GuildName..fullName.."Role"] = nil
		else
			glow = false
		end
	end

	local roleButton = getButtonFromFramePool(indexCharac, name, "RoleButtonTemplate")
	roleButton:SetPoint("LEFT", xValue, 0)
	roleButton:SetNormalTexture(getRoleTexture(role, roleButton, indexCharac))
	roleButton:SetAttribute("fullName", fullName)
	roleButton:SetAttribute("tooltip", tooltip)
	roleButton:SetAttribute("tooltipDetail", tooltipDetail)
	if glow then
		ActionButton_ShowOverlayGlow(roleButton)
	else
		ActionButton_HideOverlayGlow(roleButton)
	end
	return roleButton, role
end

function getRoleTexture(role, roleButton, indexCharac)
	local texture = _G[role.."RoleTexture"]
	if not texture then
		texture = roleButton:CreateTexture(role.."RoleTexture"..indexCharac, "BACKGROUND", role.."RoleTextureTemplate")
	end
	return texture
end

function createColumn(aGuildName, fullName, performerIcon, indexCharac, xValue, columnNumber)
	local name = performerIcon["name"]
	local iconPath = performerIcon["iconPath"]
	local tooltip = performerIcon["tooltip"]
	local tooltipDetail = performerIcon["tooltipDetail"]
	

	local iconButton = getButtonFromFramePool(indexCharac, name, "PerformerIconButtonTemplate", columnNumber)
	iconButton:SetPoint("LEFT", xValue, 0)
	iconButton:SetNormalTexture(iconPath)
	iconButton:SetAttribute("icon", name)
	iconButton:SetAttribute("fullName", fullName)
	iconButton:SetAttribute("tooltip", tooltip)
	iconButton:SetAttribute("tooltipDetail", tooltipDetail)
	iconButton:Show()
	ActionButton_HideOverlayGlow(iconButton)
	if not isPlayerAdmin() and not isPlayerCharacter(fullName) then
		iconButton:Hide()
	else
		if getPData(aGuildName, fullName, name) == "true" then
			iconButton:SetAlpha(1.0)
			if PerformerNewData[aGuildName..fullName..name] then
				ActionButton_ShowOverlayGlow(iconButton)
				PerformerNewData[aGuildName..fullName..name] = nil
			else
				ActionButton_HideOverlayGlow(iconButton)
			end
		else
			if isPlayerAdmin() then
				iconButton:SetAlpha(0.1)
			else
				iconButton:Hide()
			end
		end
	end
end

function generatePerformerTable()
	if PerformerFrame and PerformerFrame:IsShown() then
		local searchBoxText = ""
		if _G["PerformerSearchBox"] then
			searchBoxText = string.upper(_G["PerformerSearchBox"]:GetText())
		end

		-- Hide old lines
		if performerFramePool["lines"] then
			for k,v in pairs(performerFramePool["lines"]) do
				v:Hide()
			end
		end

		---- Characters sorting
		local charNames = {}
		charNames[ 1 ] = ""
		for k in pairs(charInfo) do
			if not isPlayerCharacter(k) then
				charNames[ #charNames + 1 ] = k
			end
		end
		table.sort(charNames)

		fullName, realm = UnitFullName("player")
		charNames[ 1 ] = fullName.."-"..realm

		minLevel = PerformerOptionsData[PerformerGlobal_GuildName]["minLevel"]
		includeRank = PerformerOptionsData[PerformerGlobal_GuildName]["includeRank"]
		local indexCharac = 0
		for k,v in pairs(charNames) do
			if string.find(string.upper(v), searchBoxText) -- Search box result
				and (isPlayerCharacter(v) -- A player can see his own character
					or ((not includeRank or includeRank[tostring(charInfo[v]["rankIndex"]+1)] == nil
						or includeRank[tostring(charInfo[v]["rankIndex"]+1)]) -- if the character guild rank is included
							and charInfo[v]["level"] >= minLevel)) then -- and if the character is above the minLevel
				indexCharac = indexCharac + 1
				createLine(PerformerGlobal_GuildName, v, 1, indexCharac, 235)
			end
		end

		PerformerFrame:SetHeight(400)
	end
end

function isPlayerAdmin()
	isPlayerAdmin_ = false
	fullName, realm = UnitFullName("player")
	if PerformerGlobal_GuildName and P1_PerformerData[PerformerGlobal_GuildName] then
		maxAdminRank = P1_PerformerData[PerformerGlobal_GuildName]["maxAdminRank"]
		if charInfo[fullName.."-"..realm] and charInfo[fullName.."-"..realm]["rankIndex"] then
			isPlayerAdmin_ = charInfo[fullName.."-"..realm]["rankIndex"] <= maxAdminRank
		end
	end
	return isPlayerAdmin_
end

function tellDetailsToPayer(aCreature, text)
	if text then
		factionGroup, factionName = UnitFactionGroup("player")
		local creature = aCreature	
		if not creature or not PerformerHeralds[factionGroup][creature] then
			creature = "Default"
		end

		local creatureName = PerformerHeralds[factionGroup][creature][math.random(1, #PerformerHeralds[factionGroup][creature])]
		EZBlizzUiPop_npcDialog(creatureName, text)
	end
end
