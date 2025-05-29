WorldQuestTab = LibStub("AceAddon-3.0"):GetAddon("WorldQuestTab")

local _profileReferenceList = {};

local function ReferenceListSort(a, b)
	-- Default always on top, and in case of duplicate labels
	if (a.arg1 == 0 or b.arg1 == 0) then
		return a.arg1 < b.arg1;
	end
	
	if(a.label:lower() == b.label:lower()) then
		if(a.label == b.label) then
			-- Juuuust incase
			return a.arg1 < b.arg1;
		end
		return a.label < b.label;
	end
	
	-- Alphabetical 
	return a.label:lower() < b.label:lower();
end

local function ClearDefaults(a, b)
	if(not a or not b) then return; end
	for k, v in pairs(b) do
		if (type(a[k]) == "table" and type(v) == "table") then
			ClearDefaults(a[k], v);
			if (next(a[k]) == nil) then
				a[k] = nil;
			end
		elseif (a[k] ~= nil and a[k] == v) then
			a[k] = nil;
		end
	end
end

local function ProfileNameIsAvailable(name)
	for k, v in pairs(WorldQuestTab.db.global.profiles) do
		if (v.name == name) then
			return false;
		end
	end
	return true;
end

local function CopyIfNil(a, b)
	for k, v in pairs(b) do
		local curVal = a[k];
		if (curVal == nil) then
			-- No value, add the default one
			if (type(v) == "table") then
				a[k] = CopyTable(v);
			else
				a[k] = v;
			end
		elseif (type(curVal) == "table") then
			CopyIfNil(curVal, v);
		end
	end
end

local function AddCategoryDefaults(category)
	if (not WorldQuestTab.Variables["WQT_DEFAULTS"].global[category]) then
		return;
	end
	-- In case a setting doesn't have a newer category yet
	if (not WorldQuestTab.settings[category]) then
		WorldQuestTab.settings[category] = {};
	end
	
	CopyIfNil(WorldQuestTab.settings[category], WorldQuestTab.Variables["WQT_DEFAULTS"].global[category]);
end

local function GetProfileById(id)
	for index, profile in ipairs(_profileReferenceList) do
		if (profile.arg1 == id) then
			return profile, index
		end
	end
end

local function AddProfileToReferenceList(id, name)
	if (not GetProfileById(id)) then
		tinsert(_profileReferenceList, {["label"] = name, ["arg1"] = id});
	end
end

local function ApplyVersionChanges(profile, version)
	if (version < "8.3.04") then
		profile.pin.numRewardIcons = profile.pin.rewardTypeIcon and 1 or 0;
		profile.pin.rewardTypeIcon = nil;
	end
end

function WorldQuestTab.WQT_Profiles:InitSettings()
	self.externalDefaults = {};

	-- Version checking
	local settingVersion = WorldQuestTab.db.global.versionCheck or"0";
	local currentVersion = C_AddOns.GetAddOnMetadata(WorldQuestTab:GetName(), "version");
	if (settingVersion < currentVersion) then
		WorldQuestTab.db.global.updateSeen = false;
		WorldQuestTab.db.global.versionCheck  = currentVersion;
	end
	
	-- Setup profiles
	WorldQuestTab.settings = {["colors"] = {}, ["general"] = {}, ["list"] = {}, ["pin"] = {}, ["filters"] = {}};
	if (not WorldQuestTab.db.global.profiles[0]) then
		local profile = {
			["name"] = DEFAULT
			,["colors"] = CopyTable(WorldQuestTab.db.global.colors or {})
			,["general"] = CopyTable(WorldQuestTab.db.global.general or {})
			,["list"] = CopyTable(WorldQuestTab.db.global.list or {})
			,["pin"] = CopyTable(WorldQuestTab.db.global.pin or {})
			,["filters"] = CopyTable(WorldQuestTab.db.global.filters or {})
		}
		WorldQuestTab.db.global.colors = nil;
		WorldQuestTab.db.global.general = nil;
		WorldQuestTab.db.global.list = nil;
		WorldQuestTab.db.global.pin = nil;
		WorldQuestTab.db.global.filters = nil;
		
		WorldQuestTab.db.global.profiles[0] = profile;
		self:LoadProfileInternal(0, profile);
	end

	
	for id, profile in pairs(WorldQuestTab.db.global.profiles) do
		ApplyVersionChanges(profile, settingVersion);
		AddProfileToReferenceList(id, profile.name);
	end

	self:Load(WorldQuestTab.db.char.activeProfile);
end

function WorldQuestTab.WQT_Profiles:GetProfiles()
	-- Make sure names are up to date
	for index, refProfile in ipairs(_profileReferenceList) do
		local profile = WorldQuestTab.db.global.profiles[refProfile.arg1];
		if (profile) then
			refProfile.label = profile.name;
		end
	end
	
	-- Sort
	table.sort(_profileReferenceList, ReferenceListSort);

	return _profileReferenceList;
end

function WorldQuestTab.WQT_Profiles:CreateNew()
	local id = time();
	if (GetProfileById(id)) then
		-- Profile for current timestamp already exists. Don't spam the bloody button
		return;
	end
	
	-- Get current settings to copy over
	local currentSettings = WorldQuestTab.db.global.profiles[WorldQuestTab.db.char.activeProfile];

	if (not currentSettings) then
		return;
	end
	
	-- Create new profile
	local profile = {
		["name"] = self:GetFirstValidProfileName()
		,["colors"] = CopyTable(currentSettings.colors or {})
		,["general"] = CopyTable(currentSettings.general or {})
		,["list"] = CopyTable(currentSettings.list or {})
		,["pin"] = CopyTable(currentSettings.pin or {})
		,["filters"] = CopyTable(currentSettings.filters or {})
	}
	
	WorldQuestTab.db.global.profiles[id] = profile;
	AddProfileToReferenceList(id, profile.name);
	self:Load(id);
end

function WorldQuestTab.WQT_Profiles:LoadIndex(index)
	local profile = _profileReferenceList[index];
	
	if not profile then
		self:LoadDefault();
		return;
	end
	
	self:Load(profile.arg1);
end

function WorldQuestTab.WQT_Profiles:LoadProfileInternal(id, profile)

	WorldQuestTab.db.char.activeProfile = id;
	WorldQuestTab.settings = profile;
	
	-- Add defaults
	AddCategoryDefaults("colors");
	AddCategoryDefaults("general");
	AddCategoryDefaults("list");
	AddCategoryDefaults("pin");
	AddCategoryDefaults("filters");
	
	
	local Externals = WorldQuestTab.settings.External;
	if (not Externals) then
		WorldQuestTab.settings.External = {};
		Externals = WorldQuestTab.settings.External
	end
	
	for External, settings in pairs(self.externalDefaults) do
		local externalSettings = Externals[External];
		if (not externalSettings) then
			Externals[External] = {};
			externalSettings = Externals[External];
		end
		CopyIfNil(externalSettings, settings);
	end
	
	-- Make sure our colors are up to date
	WorldQuestTab.WQT_Utils:LoadColors();
end


function WorldQuestTab.WQT_Profiles:Load(id)
	WorldQuestTab.WQT_Profiles:ClearDefaultsFromActive();

	if (not id or id == 0) then
		self:LoadDefault();
		return;
	end

	local profile = WorldQuestTab.db.global.profiles[id];
	
	if (not profile) then
		-- Profile not found
		self:LoadDefault();
		return;
	end
	self:LoadProfileInternal(id, profile);
	WQT_WorldQuestFrame:TriggerCallback("LoadProfile");
end

function WorldQuestTab.WQT_Profiles:Delete(id)
	if (not id or id == 0) then
		-- Trying to delete the default profile? That's a paddlin'
		return;
	end
	
	local profile, index = GetProfileById(id);
	
	if (index) then
		tremove(_profileReferenceList, index);
		WorldQuestTab.db.global.profiles[id] = nil;
	end

	self:LoadDefault();
end

function WorldQuestTab.WQT_Profiles:LoadDefault()
	self:LoadProfileInternal(0, WorldQuestTab.db.global.profiles[0]);
end

function WorldQuestTab.WQT_Profiles:DefaultIsActive()
	return not WQT or not WorldQuestTab.db.global or not WorldQuestTab.db.char.activeProfile or WorldQuestTab.db.char.activeProfile == 0
end

function WorldQuestTab.WQT_Profiles:IsValidProfileId(id)
	if (not id or id == 0) then 
		return false;
	end
	return WorldQuestTab.db.global.profiles[id] and true or false;
end

function WorldQuestTab.WQT_Profiles:GetFirstValidProfileName(baseName)
	if(not baseName) then
		local playerName = UnitName("player"); -- Realm still returns nill, sick
		local realmName = GetRealmName();
		baseName = ITEM_SUFFIX_TEMPLATE:format(playerName, realmName);
	end
	
	if (ProfileNameIsAvailable(baseName)) then
		return baseName;
	end
	-- Add a number
	local suffix = 2;
	local combinedName = ITEM_SUFFIX_TEMPLATE:format(baseName, suffix);
	
	while (not ProfileNameIsAvailable(combinedName)) do
		suffix = suffix + 1;
		combinedName = ITEM_SUFFIX_TEMPLATE:format(baseName, suffix);
	end
	
	return combinedName;
end

function WorldQuestTab.WQT_Profiles:ChangeActiveProfileName(newName)
	local profileId = self:GetActiveProfileId();
	if (not profileId or profileId == 0) then
		-- Don't change the default profile name
		return;
	end
	-- Add suffix number in case of duplicate
	newName = WorldQuestTab.WQT_Profiles:GetFirstValidProfileName(newName);
	
	local profile = GetProfileById(profileId);
	if(profile) then
		profile.label = newName;
		WorldQuestTab.db.global.profiles[profileId].name = newName;
	end
end

function WorldQuestTab.WQT_Profiles:GetActiveProfileId()
	return WorldQuestTab.db.char.activeProfile;
end

function WorldQuestTab.WQT_Profiles:GetIndexById(id)
	local profile, index = GetProfileById(id);
	return index or 0;
end

function WorldQuestTab.WQT_Profiles:GetActiveProfileName()
	local activeProfile = WorldQuestTab.db.char.activeProfile;
	if(activeProfile == 0) then
		return DEFAULT;
	end
	
	local profile = WorldQuestTab.db.global.profiles[activeProfile or 0];
	
	return profile and profile.name or "Invalid Profile";
end

function WorldQuestTab.WQT_Profiles:ClearDefaultsFromActive()
	local category = "general";
	
	ClearDefaults(WorldQuestTab.settings[category], WorldQuestTab.Variables["WQT_DEFAULTS"].global[category]);
	category = "list";
	ClearDefaults(WorldQuestTab.settings[category], WorldQuestTab.Variables["WQT_DEFAULTS"].global[category]);
	category = "pin";
	ClearDefaults(WorldQuestTab.settings[category], WorldQuestTab.Variables["WQT_DEFAULTS"].global[category]);
	category = "filters";
	ClearDefaults(WorldQuestTab.settings[category], WorldQuestTab.Variables["WQT_DEFAULTS"].global[category]);
	category = "colors";
	ClearDefaults(WorldQuestTab.settings[category], WorldQuestTab.Variables["WQT_DEFAULTS"].global[category]);
	
	--External
	local Externals = WorldQuestTab.settings.External;
	for External, settings in pairs(self.externalDefaults) do
		ClearDefaults(Externals[External], settings);
	end
	
	WQT_WorldQuestFrame:TriggerCallback("ClearDefaults");
end

function WorldQuestTab.WQT_Profiles:ResetActive()
	local category = "general";
	wipe(WorldQuestTab.settings[category]);
	WorldQuestTab.settings[category]= CopyTable(WorldQuestTab.Variables["WQT_DEFAULTS"].global[category]);
	category = "list";
	wipe(WorldQuestTab.settings[category]);
	WorldQuestTab.settings[category]= CopyTable(WorldQuestTab.Variables["WQT_DEFAULTS"].global[category]);
	category = "pin";
	wipe(WorldQuestTab.settings[category]);
	WorldQuestTab.settings[category]= CopyTable(WorldQuestTab.Variables["WQT_DEFAULTS"].global[category]);
	category = "filters";
	wipe(WorldQuestTab.settings[category]);
	WorldQuestTab.settings[category]= CopyTable(WorldQuestTab.Variables["WQT_DEFAULTS"].global[category]);
	category = "colors";
	wipe(WorldQuestTab.settings[category]);
	WorldQuestTab.settings[category]= CopyTable(WorldQuestTab.Variables["WQT_DEFAULTS"].global[category]);
	
	-- Make sure our colors are up to date
	WorldQuestTab.WQT_Utils:LoadColors();
	
	--External
	local Externals = WorldQuestTab.settings.External;
	for External, settings in pairs(self.externalDefaults) do
		if (Externals[External]) then
			wipe(Externals[External]);
			-- The external has a direct reference to this table, so don't replace it
			CopyIfNil(Externals[External], settings);
		end
	end
	
	WQT_WorldQuestFrame:TriggerCallback("ResetActive");
end

function WorldQuestTab.WQT_Profiles:RegisterExternalSettings(key, settings)
	local list = self.externalDefaults[key];
	if (not list) then
		list = {};
		self.externalDefaults[key] = list;
	end
	
	CopyIfNil(list, settings);
	self:Load(WorldQuestTab.db.char.activeProfile);
	
	return WorldQuestTab.settings.External[key];
end
