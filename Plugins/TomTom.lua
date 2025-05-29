WorldQuestTab = LibStub("AceAddon-3.0"):GetAddon("WorldQuestTab")
local L = LibStub("AceLocale-3.0"):GetLocale("WorldQuestTab")

local WQT_Utils;

local _activeSettings;

local _defaultSettings = {	
		useTomTom = true;
		TomTomAutoArrow = true;
		TomTomArrowOnClick = false;
	};

local _settings = {
	{["template"] = "WQT_SettingCheckboxTemplate", ["categoryID"] = "TOMTOM", ["label"] = L["USE_TOMTOM"], ["tooltip"] = L["USE_TOMTOM_TT"]
			, ["valueChangedFunc"] = function(value) 
				_activeSettings.useTomTom = value;
			end
			,["getValueFunc"] = function() return _activeSettings.useTomTom; end
			}
	,{["template"] = "WQT_SettingCheckboxTemplate", ["categoryID"] = "TOMTOM", ["label"] = L["TOMTOM_AUTO_ARROW"], ["tooltip"] = L["TOMTOM_AUTO_ARROW_TT"]
			, ["valueChangedFunc"] = function(value) 
				_activeSettings.TomTomAutoArrow = value;
			end
			,["getValueFunc"] = function() return _activeSettings.TomTomAutoArrow; end
			,["isDisabled"] = function() return not _activeSettings.useTomTom; end
			}	
	,{["template"] = "WQT_SettingCheckboxTemplate", ["categoryID"] = "TOMTOM", ["label"] = L["TOMTOM_CLICK_ARROW"], ["tooltip"] = L["TOMTOM_CLICK_ARROW_TT"]
			, ["valueChangedFunc"] = function(value) 
				_activeSettings.TomTomArrowOnClick = value;
					
				if (not value and WQT_WorldQuestFrame.softTomTomArrow and not WQT_Utils:QuestIsWatchedManual(WQT_WorldQuestFrame.softTomTomArrow)) then
					WQT_Utils:RemoveTomTomArrowbyQuestId(WQT_WorldQuestFrame.softTomTomArrow);
				end
			end
			,["getValueFunc"] = function() return _activeSettings.TomTomArrowOnClick; end
			,["isDisabled"] = function() return not _activeSettings.useTomTom; end
			}		
}

local function QuestListChangedHook(event, ...)
	local questID, added = ...;
	-- We don't have settings (yet?)
	if (not _activeSettings) then return; end
	
	-- Update TomTom arrows when quests change. Might be new that needs tracking or completed that needs removing
	local autoArrow = _activeSettings.TomTomAutoArrow;
	local clickArrow = _activeSettings.TomTomArrowOnClick;
	if (questID and TomTom and _activeSettings.useTomTom and (clickArrow or autoArrow) and QuestUtils_IsQuestWorldQuest(questID)) then
		
		if (added) then
			local questHardWatched = WQT_Utils:QuestIsWatchedManual(questID);
			if (clickArrow or questHardWatched) then
				WQT_Utils:AddTomTomArrowByQuestId(questID);
				--If click arrow is active, we want to clear the previous click arrow
				if (clickArrow and WQT_WorldQuestFrame.softTomTomArrow and not WQT_Utils:QuestIsWatchedManual(WQT_WorldQuestFrame.softTomTomArrow)) then
					WQT_Utils:RemoveTomTomArrowbyQuestId(WQT_WorldQuestFrame.softTomTomArrow);
				end
				
				if (clickArrow and not questHardWatched) then
					WQT_WorldQuestFrame.softTomTomArrow = questID;
				end
			end
			
		else
			WQT_Utils:RemoveTomTomArrowbyQuestId(questID)
		end
	end
end

local function TrackDropDownHook(owner, rootDescription)
	local questInfo = owner.questInfo;
	local questID = questInfo.questID;
	local zoneId = C_TaskQuest.GetQuestZoneID(questID);
	local x, y = C_TaskQuest.GetQuestLocation(questID, zoneId)
	local title = C_TaskQuest.GetQuestInfoByQuestID(questID);
	
	-- TomTom functionality
	if (TomTom and _activeSettings.useTomTom) then
		
		local button = rootDescription:CreateCheckbox(L["TOMTOM_PIN"],
						function()
							return TomTom:WaypointExists(zoneId, x, y, title);
						end,
						function()
							if(TomTom:WaypointExists(zoneId, x, y, title)) then
								WQT_Utils:RemoveTomTomArrowbyQuestId(questID);
							else
								WQT_Utils:AddTomTomArrowByQuestId(questID);
							end
						end);
	end
end

local TomTomExternal = CreateFromMixins(WQT_ExternalMixin);

function TomTomExternal:GetName()
	return "TomTom";
end

function TomTomExternal:Init(utils)
	WQT_Utils = utils;
	
	_activeSettings = WQT_Utils:RegisterExternalSettings("TomTom", _defaultSettings);
	WQT_Utils:AddExternalSettingsOptions(_settings);
	-- Remove point on quest complete
	WQT_WorldQuestFrame:RegisterCallback("WorldQuestCompleted", function(questID) WQT_Utils:RemoveTomTomArrowbyQuestId(questID) end);
	WQT_WorldQuestFrame:RegisterCallback("InitTrackDropDown", TrackDropDownHook);
	-- Hook onto Blizzard's events
	WQT_WorldQuestFrame:HookEvent("QUEST_WATCH_LIST_CHANGED", QuestListChangedHook);
end

WQT_WorldQuestFrame:LoadExternal(TomTomExternal);
