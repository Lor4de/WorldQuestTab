﻿WorldQuestTab = LibStub("AceAddon-3.0"):GetAddon("WorldQuestTab")

local SETTINGS_PADDING_TOP = 5;
local SETTINGS_PADDING_BOTTOM = 15;

--------------------------------
-- WQT_SettingsBaseMixin
--------------------------------

WQT_SettingsBaseMixin = {};

function WQT_SettingsBaseMixin:OnLoad()
	-- Override me
end

function WQT_SettingsBaseMixin:OnEnter(anchorFrame, anchorType)
	if self.showBigTooltip then
		self.showBigTooltip();
		GameTooltip:Show();
		return;
	end

	local tooltipText = not self:IsDisabled() and self.tooltip or self.disabledTooltip;
	if (tooltipText) then
		GameTooltip:SetOwner(anchorFrame or self, anchorType or "ANCHOR_RIGHT");
		if (self.label) then
			GameTooltip:SetText(self.label, 1, 1, 1, true);
		end
		GameTooltip:AddLine(tooltipText, nil, nil, nil, true);
		GameTooltip:Show();
	end
end

function WQT_SettingsBaseMixin:OnLeave()
	GameTooltip:Hide();
end

function WQT_SettingsBaseMixin:Init(data)
	self.label = data.label;
	self.tooltip = data.tooltip;
	self.disabledTooltip = data.disabledTooltip;
	self.valueChangedFunc = data.valueChangedFunc;
	self.isDisabled = data.isDisabled;
	if (self.Label) then
		local labelText = data.label;
		if (data.isNew) then
			labelText = labelText .. " |TInterface\\OPTIONSFRAME\\UI-OptionsFrame-NewFeatureIcon:12|t";
		end
		self.Label:SetText(labelText);
	end
	
	if (self.DisabledOverlay) then
		self.DisabledOverlay:SetFrameLevel(self:GetFrameLevel() + 2)
	end
end

function WQT_SettingsBaseMixin:Reset()
	self.label = nil;
	self.tooltip = nil;
	self.valueChangedFunc = nil;
	if (self.Label and not self.staticLabelFont) then
		self.Label:SetFontObject("GameFontNormal")
	end
end

function WQT_SettingsBaseMixin:IsDisabled()
	if (type(self.isDisabled) == "function") then
		return self.isDisabled();
	end
	return  self.isDisabled;
end

function WQT_SettingsBaseMixin:OnValueChanged(value, userInput, ...)
	if (userInput) then
		if (self.valueChangedFunc) then
			self.valueChangedFunc(value, ...);
		end
		self:GetParent():GetParent():GetParent():UpdateList();
	end
end

function WQT_SettingsBaseMixin:UpdateState()
	self:SetDisabled(self:IsDisabled());
end

function WQT_SettingsBaseMixin:SetDisabled(value)
	if (self.Label and not self.staticLabelFont) then
		self.Label:SetFontObject(value and "GameFontDisable" or "GameFontNormal");
	end
	
	if (self.DisabledOverlay) then
		self.DisabledOverlay:SetShown(value);
	end
end

--------------------------------
-- WQT_SettingsQuestListMixin
--------------------------------

WQT_SettingsQuestListMixin = CreateFromMixins(WQT_SettingsBaseMixin);

function WQT_SettingsQuestListMixin:OnLoad()
	local questFrame = self.Preview;
	questFrame.Faction:SetScript("OnEnter", nil);
	questFrame.Title:SetText("Example Quest Title");
	questFrame.Faction.Icon:SetTexture(2058205);
	local typeFrame = questFrame.Type;
	typeFrame.Texture:Show();
	typeFrame.Elite:SetShown(true);
	typeFrame.Bg:SetAtlas("worldquest-questmarker-rare");
	typeFrame.Bg:SetTexCoord(0, 1, 0, 1);
	typeFrame.Bg:SetSize(18, 18);
	
	typeFrame.Texture:SetAtlas("worldquest-icon-dungeon");
	typeFrame.Texture:SetSize(16, 17);
	typeFrame:Show();
	
	questFrame.Time:SetVertexColor(0, 0.75, 0);
	local mapInfo = WorldQuestTab.WQT_Utils:GetCachedMapInfo(942);
	self.zoneName = mapInfo.name;
	questFrame.Extra:SetText(self.zoneName);
end

function WQT_SettingsQuestListMixin:UpdateState()
	local questFrame = self.Preview;
	questFrame.Title:ClearAllPoints()
	questFrame.Title:SetPoint("RIGHT", questFrame.Rewards, "LEFT", -5, 0);
	if (WorldQuestTab.settings.list.factionIcon) then
		questFrame.Title:SetPoint("BOTTOMLEFT", questFrame.Faction, "RIGHT", 5, 1);
	elseif (WorldQuestTab.settings.list.typeIcon) then
		questFrame.Title:SetPoint("BOTTOMLEFT", questFrame.Type, "RIGHT", 5, 1);
	else
		questFrame.Title:SetPoint("BOTTOMLEFT", questFrame, "LEFT", 10, 0);
	end

	-- Faction Icon
	if (WorldQuestTab.settings.list.factionIcon) then
		questFrame.Faction:Show();
		questFrame.Faction:SetWidth(questFrame.Faction:GetHeight());
	else
		questFrame.Faction:Hide();
		questFrame.Faction:SetWidth(0.1);
	end
	
	-- Type icon
	if (WorldQuestTab.settings.list.typeIcon) then
		questFrame.Type:Show();
		questFrame.Type:SetWidth(questFrame.Type:GetHeight());
	else
		questFrame.Type:Hide();
		questFrame.Type:SetWidth(0.1);
	end
	
	-- Zone name
	questFrame.Extra:SetText(WorldQuestTab.settings.list.showZone and self.zoneName or "");

	-- Adjust time and zone sizes
	local extraSpace = WorldQuestTab.settings.list.factionIcon and 0 or 14;
	extraSpace = extraSpace + (WorldQuestTab.settings.list.typeIcon and 0 or 14);
	local timeWidth = extraSpace + (WorldQuestTab.settings.list.fullTime and 70 or 60);
	local zoneWidth = extraSpace + (WorldQuestTab.settings.list.fullTime and 80 or 90);
	if (not WorldQuestTab.settings.list.showZone) then
		timeWidth = timeWidth + zoneWidth;
		zoneWidth = 0.1;
	end
	questFrame.Time:SetWidth(timeWidth);
	questFrame.Extra:SetWidth(zoneWidth);
	
	-- Time display
	-- 74160s == 20h 36m
	local timeString;
	if (WorldQuestTab.settings.list.fullTime) then
		timeString = SecondsToTime(74160, true, false);
	else
		timeString = D_HOURS:format(74160 / SECONDS_PER_HOUR);
	end
	questFrame.Time:SetText(timeString);
	if (WorldQuestTab.settings.list.colorTime) then
		local color = WorldQuestTab.WQT_Utils:GetColor(WorldQuestTab.Variables["COLOR_IDS"].timeMedium)
		questFrame.Time:SetVertexColor(color:GetRGB());
	else
		questFrame.Time:SetVertexColor(WorldQuestTab.Variables["WQT_WHITE_FONT_COLOR"]:GetRGB());
	end
	
	-- Warband bonus
	if (WorldQuestTab.settings.list.showWarbandBonus) then
		questFrame.WarbandBonus:Show();
	else
		questFrame.WarbandBonus:Hide();
	end
	
	-- Fake rewards
	questFrame.Rewards:Reset();
	questFrame.Rewards:AddReward(WQT_REWARDTYPE.equipment, 1733697, 3, 410, WorldQuestTab.Variables["WQT_COLOR_ARMOR"], true);
	questFrame.Rewards:AddReward(WQT_REWARDTYPE.gold, 133784, 1, 1320000, WorldQuestTab.Variables["WQT_COLOR_GOLD"], false);
	questFrame.Rewards:AddReward(WQT_REWARDTYPE.xp, 894556, 1, 34000, WorldQuestTab.Variables["WQT_COLOR_ITEM"], false);
end

--------------------------------
-- WQT_SettingsCheckboxMixin
--------------------------------

WQT_SettingsCheckboxMixin = CreateFromMixins(WQT_SettingsBaseMixin);

function WQT_SettingsCheckboxMixin:Init(data)
	WQT_SettingsBaseMixin.Init(self, data);
	self.getValueFunc = data.getValueFunc;
	self:UpdateState();
end

function WQT_SettingsCheckboxMixin:Reset()
	WQT_SettingsBaseMixin.Reset(self);
	self.CheckBox:Enable();
end

function WQT_SettingsCheckboxMixin:UpdateState()
	WQT_SettingsBaseMixin.UpdateState(self);
	if (self.getValueFunc) then
		self.CheckBox:SetChecked(self.getValueFunc());
	end
end

function WQT_SettingsCheckboxMixin:SetDisabled(value)
	WQT_SettingsBaseMixin.SetDisabled(self, value);
	if (value) then
		self.CheckBox:Disable();
	else
		self.CheckBox:Enable();
	end
end

--------------------------------
-- WQT_SettingsSliderMixin
--------------------------------

WQT_SettingsSliderMixin = CreateFromMixins(WQT_SettingsBaseMixin);

function WQT_SettingsSliderMixin:Init(data)
	WQT_SettingsBaseMixin.Init(self, data);
	
	self.getValueFunc = data.getValueFunc;
	self.min = data.min or 0;
	self.max = data.max or 1;
	
	self.SettingSlider.Slider:SetMinMaxValues(self.min, self.max);
	self.SettingSlider.Slider:SetValueStep(data.valueStep);
	self.SettingSlider.Slider:SetObeyStepOnDrag(data.valueStep and true or false)
	self.SettingSlider.Slider:HookScript("OnEnter", function(self) self:GetParent():GetParent():OnEnter(self); end);
	self.SettingSlider.Slider:HookScript("OnLeave", function(self) self:GetParent():GetParent():OnLeave(); end);
	self.SettingSlider.Slider:HookScript("OnValueChanged", function(self, value, userInput) self:GetParent():GetParent():OnValueChanged(value, userInput); end);
	self.SettingSlider.Back:HookScript("OnClick", function(owner) self:OnStepperClicked(false); end);
	self.SettingSlider.Forward:HookScript("OnClick", function(owner) self:OnStepperClicked(true); end);
	
	self:UpdateState();
end

function WQT_SettingsSliderMixin:OnStepperClicked(forward)
	local value = self.SettingSlider.Slider:GetValue();
	local step = self.SettingSlider.Slider:GetValueStep();
	if forward then
		self.SettingSlider.Slider:SetValue(value + step, true);
	else
		self.SettingSlider.Slider:SetValue(value - step, true);
	end
	
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
	self:OnValueChanged(self.SettingSlider.Slider:GetValue(), true);
end

function WQT_SettingsSliderMixin:Reset()
	WQT_SettingsBaseMixin.Reset(self);
end

function WQT_SettingsSliderMixin:UpdateState()
	WQT_SettingsBaseMixin.UpdateState(self);
	if (self.getValueFunc) then
		local currentValue = self.getValueFunc();
		self.SettingSlider.Slider:SetValue(currentValue);
		self.TextBox:SetText(Round(currentValue*100)/100);
		self.current = currentValue;
	end
end

function WQT_SettingsSliderMixin:SetDisabled(value)
	WQT_SettingsBaseMixin.SetDisabled(self, value);
	if (value) then
		self.SettingSlider.Slider:Disable();
		self.TextBox:Disable();
	else
		self.SettingSlider.Slider:Enable();
		self.TextBox:Enable();
	end
end

function WQT_SettingsSliderMixin:OnValueChanged(value, userInput)
	-- Prevent non-number input
	value = tonumber(value);
	if (not value) then 
		-- Reset displayed values
		self:UpdateState();
		return; 
	end

	value = Round(value*100)/100;
	value = min(self.max, max(self.min, value));
	if (userInput and value ~= self.current) then
		WQT_SettingsBaseMixin.OnValueChanged(self, value, userInput);
	end
	self:UpdateState();
end

--------------------------------
-- WQT_SettingsColorMixin
--------------------------------

WQT_SettingsColorMixin = CreateFromMixins(WQT_SettingsBaseMixin);

function WQT_SettingsColorMixin:OnLoad()
	
end

function WQT_SettingsColorMixin:Init(data)
	WQT_SettingsBaseMixin.Init(self, data);
	self.getValueFunc = data.getValueFunc;
	self.defaultColor = data.defaultColor;
	self.colorID = data.colorID;

	CooldownFrame_SetDisplayAsPercentage(self.ExampleRing.Ring, 0.35);
	self.ExampleRing.Pointer:SetRotation(0.65*6.2831);
	self.ExampleRing.Ring:Show();
end

function WQT_SettingsColorMixin:UpdateState()
	if (self.getValueFunc) then
		local color = self.getValueFunc(self.colorID);
		self:SetWidgetRGB(color:GetRGB());

		-- Hex is more costly but doesn't have as meany issues 0.001 differences
		local canReset = color:GenerateHexColor() ~= self.defaultColor:GenerateHexColor();
		self:SetResetEnabled(canReset);
	end
	
	self.Label:Show();
	self.ExampleText:Hide();
	self.ExampleRing:Hide();
end

function WQT_SettingsColorMixin:SetResetEnabled(enable)
	self.ResetButton:SetEnabled(enable);
	self.ResetButton.Icon:SetDesaturated(not enable);
	if (enable) then
		self.ResetButton.Icon:SetVertexColor(1, 1, 1);
	else
		self.ResetButton.Icon:SetVertexColor(.7, .7, .7);
	end
end

function WQT_SettingsColorMixin:ResetColor(userInput)
	local r, g, b = self.defaultColor:GetRGB();
	self:SetWidgetRGB(r, g, b);
	self:OnValueChanged(self.colorID, userInput, r, g, b);
end

function WQT_SettingsColorMixin:SetWidgetRGB(r, g, b)
	self.ExampleText:SetVertexColor(r, g, b);
	self.ExampleRing.Ring:SetSwipeColor(r*0.8, g*0.8, b*0.8);
	self.ExampleRing.RingBG:SetVertexColor(r*0.25, g*0.25, b*0.25);
	self.ExampleRing.Pointer:SetVertexColor(r*1.1, g*1.1, b*1.1);
	self.Picker.Color:SetVertexColor(r, g, b);
end

function WQT_SettingsColorMixin:UpdateFromPicker(isConfirmed)
	local r, g, b = ColorPickerFrame:GetColorRGB();
	self:SetWidgetRGB(r, g, b);
	
	if (isConfirmed) then
		self:OnValueChanged(self.colorID, true, r, g, b);
		self:StopPicking();
	end
end

function WQT_SettingsColorMixin:StartPicking()
	if (not self.getValueFunc) then return; end
	
	self:GetParent():GetParent():GetParent():UpdateList();
	
	local color = self.getValueFunc(self.colorID);
	local r, g, b = color:GetRGB();
	
	local info = {
		["swatchFunc"] = function () self:UpdateFromPicker() end,
		["opacityFunc"] = function () self:UpdateFromPicker(true) end,
		["cancelFunc"] = function () self:ResetColor(); self:StopPicking(); end,
		["r"] = r,
		["g"] = g,
		["b"] = b,
		["extraInfo"] = "test"
	}
	
	self.Label:Hide();
	self.ExampleText:Show();
	self.ExampleRing:Show();
	
	OpenColorPicker(info);
end

function WQT_SettingsColorMixin:StopPicking()
	self.Label:Show();
	self.ExampleText:Hide();
	self.ExampleRing:Hide();
	
	self:UpdateState();
end

--------------------------------
-- WQT_SettingsDropDownMixin
--------------------------------

WQT_SettingsDropDownMixin = CreateFromMixins(WQT_SettingsBaseMixin);

function WQT_SettingsDropDownMixin:OnLoad()
	if not self.Dropdown then
		self.isSpecial = true; -- Custom dropdown like in settings
		self.Dropdown = self.Container.Dropdown;
	end
	self.Dropdown:SetWidth(190);
	self.Dropdown:HookScript("OnEnter", function()
			if self.isSpecial then self:UpdateAtlas(); end
			self:OnEnter(self.Dropdown);
		end);
	self.Dropdown:HookScript("OnLeave", function()
			if self.isSpecial then self:UpdateAtlas(); end
			self:OnLeave();
		end);
end

function WQT_SettingsDropDownMixin:UpdateAtlas()
	self.Dropdown.Background:SetAtlas(self:GetBackgroundAtlas(), TextureKitConstants.UseAtlasSize);
end

function WQT_SettingsDropDownMixin:GetBackgroundAtlas()
	if self.Dropdown:IsEnabled() then
		if self.Dropdown:IsDownOver() then
			return "common-dropdown-c-button-pressedhover-1";
		elseif self.Dropdown:IsOver() then
			return "common-dropdown-c-button-hover-1";
		elseif self.Dropdown:IsDown() then
			return "common-dropdown-c-button-pressed-1";
		elseif self.Dropdown:IsMenuOpen() then
			return "common-dropdown-c-button-open";
		else
			return "common-dropdown-c-button";
		end
	end

	return "common-dropdown-c-button-disabled";
end

function WQT_SettingsDropDownMixin:SetDisabled(value)
	WQT_SettingsBaseMixin.SetDisabled(self, value);
	if (value) then
		self.Dropdown:Disable();
	else
		self.Dropdown:Enable();
	end
end

function WQT_SettingsDropDownMixin:Init(data)
	WQT_SettingsBaseMixin.Init(self, data);
	self.getValueFunc = data.getValueFunc;
	
	-- Create a tooltip with every option listed (as in WoW settings)
	if type(data.options) == "table" and self.isSpecial then
		self.showBigTooltip = function()
			local tooltipText = not self:IsDisabled() and self.tooltip or self.disabledTooltip;
			if (tooltipText) then
				GameTooltip:SetOwner(self.Dropdown, "ANCHOR_RIGHT");
				if (self.label) then
					GameTooltip_SetTitle(GameTooltip, self.label);
				end
				GameTooltip_AddNormalLine(GameTooltip, tooltipText);
				
				-- Go through the options	
				if data.options then
					for id, displayInfo in pairs(data.options) do
						local label = displayInfo.label or "Invalid label";
						local combinedLine = WrapTextInColor(label..": ", HIGHLIGHT_FONT_COLOR);
						if displayInfo.tooltip then
							combinedLine = combinedLine..displayInfo.tooltip;
							GameTooltip_AddNormalLine(GameTooltip, "\n"); -- New line
							GameTooltip_AddNormalLine(GameTooltip, combinedLine);
						end
					end
				end
			end
		end
	end
	
	self.Dropdown:SetupMenu(function(dropdown, rootDescription)
		if data.options then
			self.options = data.options;
			
			local options = self.options;
			if type(options) ==  "function" then
				options = options();
			end
						
			for id, displayInfo in pairs(options) do
				local label = displayInfo.label or "Invalid label";
				local menu = rootDescription:CreateRadio(label,
					function() return id == data.getValueFunc(); end,
					function(index) self:OnValueChanged(index, true); end, id);
				
				if displayInfo.tooltip then
					menu:SetTooltip(function(tooltip, elementDescription)
							GameTooltip_SetTitle(tooltip, label);
							GameTooltip_AddNormalLine(tooltip, displayInfo.tooltip);
						end);
				end
			end
		end
	end);
	
	self:UpdateState();
end

function WQT_SettingsDropDownMixin:UpdateState()
	WQT_SettingsBaseMixin.UpdateState(self);
	if (self.getValueFunc and self.options) then
		local options = self.options;
		if (type(options) ==  "function") then
			options = options();
		end
		
		-- Update dropdown
		self.Dropdown:OnShow();
	end
end

--------------------------------
-- WQT_SettingsButtonMixin
--------------------------------

WQT_SettingsButtonMixin = CreateFromMixins(WQT_SettingsBaseMixin);

function WQT_SettingsButtonMixin:OnLoad()
	self.Label = self.Button.Label;
end

function WQT_SettingsButtonMixin:SetDisabled(value)
	WQT_SettingsBaseMixin.SetDisabled(self, value);
	if (value) then
		self.Button:Disable();
	else
		self.Button:Enable();
	end
end

function WQT_SettingsButtonMixin:Init(data)
	WQT_SettingsBaseMixin.Init(self, data);
	self:UpdateState();
end

--------------------------------
-- WQT_SettingsConfirmButtonMixin
--------------------------------

WQT_SettingsConfirmButtonMixin = CreateFromMixins(WQT_SettingsBaseMixin);

function WQT_SettingsConfirmButtonMixin:OnLoad()
	self.Label = self.Button.Label;
end

function WQT_SettingsConfirmButtonMixin:SetDisabled(value)
	WQT_SettingsBaseMixin.SetDisabled(self, value);
	if (value) then
		self.Button:Disable();
	else
		self.Button:Enable();
	end
end

function WQT_SettingsConfirmButtonMixin:Init(data)
	WQT_SettingsBaseMixin.Init(self, data);
end

function WQT_SettingsConfirmButtonMixin:UpdateState()
	WQT_SettingsBaseMixin.UpdateState(self);
	local width = (self:GetWidth() - 67) / 2;
	self.ButtonConfirm:SetWidth(width);
	
	if (self.isPicking == true) then
		self.Button:Show();
		self.ButtonConfirm:Hide();
		self.ButtonDecline:Hide();
		self.isPicking = false;
	end
end

function WQT_SettingsConfirmButtonMixin:OnValueChanged(value, userInput)
	self:SetPickingState(false);
	WQT_SettingsBaseMixin.OnValueChanged(self, value, userInput);
end

function WQT_SettingsConfirmButtonMixin:SetPickingState(isPicking)
	self.isPicking = isPicking;
	if (self.isPicking) then
		self.Button:Hide();
		self.ButtonConfirm:Show();
		self.ButtonDecline:Show();
		return;
	end
	
	self.Button:Show();
	self.ButtonConfirm:Hide();
	self.ButtonDecline:Hide();
end

--------------------------------
-- WQT_SettingsTextInputMixin
--------------------------------

WQT_SettingsTextInputMixin = CreateFromMixins(WQT_SettingsBaseMixin);

function WQT_SettingsTextInputMixin:Init(data)
	WQT_SettingsBaseMixin.Init(self, data);
	self.getValueFunc = data.getValueFunc;
	self:UpdateState();
end

function WQT_SettingsTextInputMixin:Reset()
	WQT_SettingsBaseMixin.Reset(self);
end

function WQT_SettingsTextInputMixin:UpdateState()
	WQT_SettingsBaseMixin.UpdateState(self);
	if (self.getValueFunc) then
		local currentValue = self.getValueFunc() or "";
		self.TextBox:SetText(currentValue);
		self.current = currentValue;
	end
end

function WQT_SettingsTextInputMixin:SetDisabled(value)
	WQT_SettingsBaseMixin.SetDisabled(self, value);
	if (value) then
		self.TextBox:Disable();
	else
		self.TextBox:Enable();
	end
end

function WQT_SettingsTextInputMixin:OnValueChanged(value, userInput)
	if (not value or value == "") then 
		-- Reset displayed values
		self:UpdateState();
		return; 
	end

	if (userInput and value ~= self.current) then
		WQT_SettingsBaseMixin.OnValueChanged(self, value, userInput);
	end
	self:UpdateState();
end

--------------------------------
-- WQT_SettingsCategoryMixin
--------------------------------

WQT_SettingsCategoryMixin = CreateFromMixins(WQT_SettingsBaseMixin);

function WQT_SettingsCategoryMixin:Init(data)
	WQT_SettingsBaseMixin.Init(self, data);
	self.id = data.id;
	self.isExpanded = data.expanded;
	self.settings = {};
	self.subCategories = {};
end

function WQT_SettingsCategoryMixin:UpdateState()
	WQT_SettingsBaseMixin.UpdateState(self);
	if self.isExpanded then
		if self.SubLeft then
			self.SubLeft:SetAtlas("campaign_headericon_open", true);
		else
			self.Right:SetAtlas("Options_ListExpand_Right_Expanded", true);
			self.HighlightRight:SetAtlas("Options_ListExpand_Right_Expanded", true);
		end
	else
		if self.SubLeft then
			self.SubLeft:SetAtlas("campaign_headericon_closed", true);
		else
			self.Right:SetAtlas("Options_ListExpand_Right", true);
			self.HighlightRight:SetAtlas("Options_ListExpand_Right", true);
		end
	end
end

function WQT_SettingsCategoryMixin:SetExpanded(value)
	self.isExpanded = value;
	self:GetParent():GetParent():GetParent():Refresh();
end

--------------------------------
-- WQT_SettingsFrameMixin
--------------------------------

WQT_SettingsFrameMixin = {};

function WQT_SettingsFrameMixin:OnLoad()
	-- Because we can't destroy frames, keep a pool of each type to re-use
	self.categoryPool = CreateFramePool("BUTTON", self.ScrollFrame.ScrollChild, "WQT_SettingCategoryTemplate");
	self.subCategoryPool = CreateFramePool("BUTTON", self.ScrollFrame.ScrollChild, "WQT_SettingSubCategoryTemplate");
	
	self.templatePools = {};
	
	self.categoryless = {};
	self.categories = {};
	self.categoriesLookup = {};
	
	self.bufferedSettings = {};
	self.bufferedCategories = {};
	
	self.ScrollFrame:RegisterCallback("OnVerticalScroll", function(offset)
		self:UpdateBottomShadow(offset);
	end);

	self.ScrollFrame:RegisterCallback("OnScrollRangeChanged", function(offset)
		self:UpdateBottomShadow(offset);
	end);
	self:UpdateBottomShadow(0);
end

function WQT_SettingsFrameMixin:UpdateBottomShadow(offset)
	local shadow = self:GetParent().BorderFrame.Shadow;
	local height = shadow:GetHeight();
	local delta = self.ScrollFrame:GetVerticalScrollRange() - self.ScrollFrame:GetVerticalScroll();
	local alpha = Clamp(delta/height, 0, 1);
	shadow:SetAlpha(alpha);
end

function WQT_SettingsFrameMixin:Init(categories, settings)
	-- Initialize 'official' settings
	self.isInitialized = true;
	self:RegisterCategories(categories);

	if (settings) then
		self:AddSettingList(settings);
	end

	-- Add buffered settings from other add-ons
	self:RegisterCategories(self.bufferedCategories);
	self:AddSettingList(self.bufferedSettings);
end

function WQT_SettingsFrameMixin:SetCategoryExpanded(id, value)
	local category = self.categoriesLookup[id];
	
	if (category) then
		category:SetExpanded(value);
	end
end

function WQT_SettingsFrameMixin:RegisterCategories(categories)
	if (categories) then
		for k, data in ipairs(categories) do
			self:RegisterCategory(data);
		end
	end
end

function WQT_SettingsFrameMixin:RegisterCategory(data)
	local category = self.categoriesLookup[data.id];
	-- Category already exists
	if (category) then
		-- Update label if provided
		if (data.label) then
			category.Title:SetText(data.label)
		end
		return;
	end
	
	category = self:CreateCategory(data)
	
end

function WQT_SettingsFrameMixin:CreateCategory(data)
	if (not self.isInitialized) then
		tinsert(self.bufferedCategories, data);
		return;
	end

	if (type(data) ~= "table") then
		local temp = {["id"] = data};
		data = temp;
	end
	
	local isSubCategory = data.parentCategory ~= nil;
	
	local category;
	if (isSubCategory) then
		local parent = self.categoriesLookup[data.parentCategory];
		if (not parent) then return; end
		category = self.subCategoryPool:Acquire();
		tinsert(parent.subCategories, category);
	else
		category = self.categoryPool:Acquire();
	end
	
	category:Init(data);
	category.Title:SetText(data.label or data.id)
	
	if (not isSubCategory) then
		tinsert(self.categories, category);
	end
	self.categoriesLookup[data.id] = category;
	return category;
end

function WQT_SettingsFrameMixin:UpdateCategory(category)
	if (category.isExpanded) then
		for k2, setting in ipairs(category.settings) do
			if (setting.UpdateState) then
				setting:UpdateState();
			end
		end
		
		for k2, subCategory in ipairs(category.subCategories) do
			self:UpdateCategory(subCategory);
		end
	end
end

function WQT_SettingsFrameMixin:UpdateList()
	for k, setting in ipairs(self.categoryless) do
		if (setting.UpdateState) then
			setting:UpdateState();
		end
	end
	
	for k, category in ipairs(self.categories) do
		self:UpdateCategory(category);
	end
end

function WQT_SettingsFrameMixin:AcquireFrameOfTemplate(template)
	if not (template) then return; end
	local pool = self.templatePools[template];
	if (not pool and DoesTemplateExist(template)) then
		pool = CreateFramePool("FRAME", self.ScrollFrame.ScrollChild, template, function(pool, frame) frame:Reset(); end);
		self.templatePools[template] = pool;
	end
	
	if (pool) then
		return pool:Acquire();
	end
end

function WQT_SettingsFrameMixin:GetTemplateFromType(settingType)
	if (settingType == WorldQuestTab.Variables["SETTING_TYPES"].checkBox) then
		return "WQT_SettingCheckboxTemplate";
	elseif (settingType == WorldQuestTab.Variables["SETTING_TYPES"].subTitle) then
		return "WQT_SettingSubTitleTemplate";
	elseif (settingType == WorldQuestTab.Variables["SETTING_TYPES"].slider) then
		return "WQT_SettingSliderTemplate";
	elseif (settingType == WorldQuestTab.Variables["SETTING_TYPES"].dropDown) then
		return "WQT_SettingDropDownTemplate";
	elseif (settingType == WorldQuestTab.Variables["SETTING_TYPES"].button) then
		return "WQT_SettingButtonTemplate";
	end
end

function WQT_SettingsFrameMixin:AddSetting(data, isFromList)
	if (not self.isInitialized) then
		tinsert(self.bufferedSettings, data);
		return;
	end

	-- Support outdated usage of types
	local template = data.template;
	if (data.type) then
		template = self:GetTemplateFromType(data.type);
	end

	-- Get a frame of supplied template, or specific frame from _G
	local frame;
	if (template) then
		frame = self:AcquireFrameOfTemplate(template);
	elseif (data.frameName) then
		frame = _G[data.frameName];
		frame:SetParent(self.ScrollFrame.ScrollChild);
	end

	-- Get a frame from the pool, initialize it, and link it to a category
	if (frame) then
		frame:Init(data);
		local list = self.categoryless;
		local category = self.categoriesLookup[data.categoryID];
		if (category) then
			list = category.settings;
		elseif (data.categoryID) then
			-- Category doesn't exist yet, create a temporary one
			category = self:CreateCategory(data.categoryID);
			list = category.settings;
		end
		tinsert(list, frame);
	end
	if (not isFromList) then
		self:Refresh();
	end
end

function WQT_SettingsFrameMixin:AddSettingList(list)
	for k, setting in ipairs(list) do
		self:AddSetting(setting, true);
	end
	self:Refresh();
end

function WQT_SettingsFrameMixin:PlaceSetting(setting)
	setting:ClearAllPoints();
	if (self.previous) then
		setting:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT");
	else
		setting:SetPoint("TOPLEFT", self.ScrollFrame.ScrollChild, 0, -SETTINGS_PADDING_TOP);
	end
	setting:SetPoint("RIGHT", self.ScrollFrame.ScrollChild);
	setting:Show();
	if (setting.UpdateState) then
		setting:UpdateState();
	end
	
	self.previous = setting;
end

function WQT_SettingsFrameMixin:Refresh()
	self.previous = nil;
	for i = 1, #self.categoryless do
		local current = self.categoryless[i];
		self:PlaceSetting(current);
	end
	
	self:PlaceCategories(self.categories);
	self.ScrollFrame.ScrollChild:Layout();
end

function WQT_SettingsFrameMixin:CategoryTreeHasSettings(category)
	if (#category.settings > 0) then
		return true;
	end
	
	for k, subCategory in ipairs(category.subCategories) do
		if (self:CategoryTreeHasSettings(subCategory)) then
			return true;
		end
	end
	
	return false;
end

function WQT_SettingsFrameMixin:PlaceCategories(categories)
	
	for i = 1, #categories do
		local category = categories[i];
		if (self:CategoryTreeHasSettings(category)) then
			self:PlaceSetting(category);
			
			for k, setting in ipairs(category.settings) do
				if (category.isExpanded) then
					self:PlaceSetting(setting);
				else
					setting:ClearAllPoints();
					setting:Hide();
				end
			end
		end
		
		if (category.isExpanded) then
			self:PlaceCategories(category.subCategories);
		else
			for k, subCategory in ipairs(category.subCategories) do
				self:HideCategory(subCategory);
			end
		end
	end
end

function WQT_SettingsFrameMixin:HideCategory(category)
	for k, setting in ipairs(category.settings) do
		setting:ClearAllPoints();
		setting:Hide();
	end
	for k, subCategory in ipairs(category.subCategories) do
		self:HideCategory(subCategory);
	end
	category:ClearAllPoints();
	category:Hide();
end
