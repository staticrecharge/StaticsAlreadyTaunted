--[[----------------------------------------------
Static's Already Taunted
Author: Static_Recharge
Version: 1.0.0
Description: Indicates if a target is already
taunted by another source.
----------------------------------------------]]--


--[[----------------------------------------------
Addon Information
----------------------------------------------]]--
local SAT = {
  addonName = "StaticsAlreadyTaunted",
  addonVersion = "1.0.0",
  author = "Static_Recharge",
  varsVersion = 1,
}


--[[----------------------------------------------
Aliases
----------------------------------------------]]--
local EM = EVENT_MANAGER
local CM = CALLBACK_MANAGER
local CS = CHAT_SYSTEM
local LAM2 = LibAddonMenu2
local SM = SCENE_MANAGER
local WM = WINDOW_MANAGER


--[[----------------------------------------------
Variable, Table and Constant Declarations
----------------------------------------------]]--
SAT.Defaults = {
  color = {a = 1, r = 1, g = 0, b = 0},
  icon = "/esoui/art/tutorial/gamepad/gp_lfg_tank.dds",
  size = 64,
}

SAT.Const = {
  chatPrefix = "|cFFFFFF[SAT]: |cFFFFFF",
  chatSuffix = "|r",
  tauntAbilityID = 38254,
  targetUnitTag = "reticleover",
}

SAT.Icons = {
  [1] = "/esoui/art/tutorial/gamepad/gp_lfg_tank.dds",
  [2] = "/esoui/art/tribute/tributecarddefeatbanner_taunt.dds",
  [3] = "/art/fx/texture/shield_outline.dds",
  [4] = "/esoui/art/hud/gamepad/gp_radialicon_cancel_down.dds",
  [5] = "/esoui/art/notifications/gamepad/gp_notificationicon_duel.dds",
  [6] = "/art/fx/texture/whitesquare.dds",
  [7] = "/esoui/art/targetmarkers/target_blue_square_64.dds",
  [8] = "/esoui/art/targetmarkers/target_gold_star_64.dds",
  [9] = "/esoui/art/targetmarkers/target_green_circle_64.dds",
  [10] = "/esoui/art/targetmarkers/target_orange_triangle_64.dds",
  [11] = "/esoui/art/targetmarkers/target_pink_moons_64.dds",
  [12] = "/esoui/art/targetmarkers/target_red_weapons_64.dds",
  [13] = "/esoui/art/targetmarkers/target_purple_oblivion_64.dds",
  [14] = "/esoui/art/targetmarkers/target_white_skull_64.dds",
}

SAT.unlocked = false


--[[----------------------------------------------
General Functions
----------------------------------------------]]--
function SAT.SendToChat(text)
  if text ~= nil then
    CS:AddMessage(SAT.Const.chatPrefix .. text .. SAT.Const.chatSuffix)
  else
    CS:AddMessage(SAT.Const.chatPrefix .. "nil string" .. SAT.Const.chatSuffix)
  end
end

function SAT.Debug()
  d("Debug")
end


--[[----------------------------------------------
Icon Control Functions
----------------------------------------------]]--
function SAT_ON_MOVE_STOP()
  SAT.SavedVars.left = SAT_Panel:GetLeft()
  SAT.SavedVars.top = SAT_Panel:GetTop()
end

function SAT.RestorePanel()
	local left = SAT.SavedVars.left
	local top = SAT.SavedVars.top
	if left ~= nil and top ~= nil then
		SAT_Panel:ClearAnchors()
		SAT_Panel:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, left, top)
	end
end

function SAT.Unlock()
  SAT.unlocked = not SAT.unlocked
  SAT.ShowIcon(SAT.unlocked)
  if SAT.unlocked then
    SAT_Panel:SetMovable(true)
    SAT.SendToChat("Window unlocked.")
  else
    SAT_Panel:SetMovable(false)
    SAT.SendToChat("Window locked.")
  end
end

function SAT.UpdateIcon()
  local window = WM:GetControlByName("SAT_Panel")
  local icon = WM:GetControlByName("SAT_PanelIcon")
  window:SetDimensions(SAT.SavedVars.size, SAT.SavedVars.size)
  icon:SetColor(SAT.SavedVars.color.r, SAT.SavedVars.color.g, SAT.SavedVars.color.b, SAT.SavedVars.color.a)
  icon:SetTexture(SAT.SavedVars.icon)
end

function SAT.UpdateMenuIcon()
  local menuIcon = WM:GetControlByName("SATMenuIcon").texture
  menuIcon:SetDimensions(SAT.SavedVars.size, SAT.SavedVars.size)
  menuIcon:SetColor(SAT.SavedVars.color.r, SAT.SavedVars.color.g, SAT.SavedVars.color.b, SAT.SavedVars.color.a)
  menuIcon:SetTexture(SAT.SavedVars.icon)
end

function SAT.HUDSceneChange(oldState, newState)
  if (newState == SCENE_SHOWN) then
    SAT_Panel:SetHidden(false)
  elseif (newState == SCENE_HIDDEN) then
    SAT_Panel:SetHidden(true)
  end
end

function SAT.HUDUISceneChange(oldState, newState)
  if (newState == SCENE_SHOWN) then
    SAT_Panel:SetHidden(false)
  elseif (newState == SCENE_HIDDEN) then
    SAT_Panel:SetHidden(true)
  end
end

function SAT.ShowIcon(show) -- The icon is controlled independantly from the panel itself.
  SAT_PanelIcon:SetHidden(not show)
end


--[[----------------------------------------------
Settings Menu
----------------------------------------------]]--
function SAT.CreateSettingsWindow()
	local panelData = {
		type = "panel",
		name = "Static's Already Taunted",
		displayName = "Static's Already Taunted",
		author = SAT.author,
		--website = "https://www.esoui.com/downloads/info1604-GoHome.html",
		--feedback = "https://www.esoui.com/portal.php?&uid=6533",
		slashCommand = "/satmenu",
		registerForRefresh = true,
		registerForDefaults = true,
		version = SAT.addonVersion,
	}
	
	local optionsData = {}
	local i = 1
  optionsData[i] = {
    type = "header",
    name = "Icon Settings", -- or string id or function returning a string
    width = "full", -- or "half" (optional)
  }

  i = i+1
  optionsData[i] = {
    type = "checkbox",
    name = "Lock", -- or string id or function returning a string
    getFunc = function() return not SAT.unlocked end,
    setFunc = function(value) SAT.Unlock() end,
    tooltip = "Unlocks and shows the icon for moving around the screen. It must be locked again for proper operation.", -- or string id or function returning a string (optional)
    width = "full", -- or "half" (optional)
  }

  i = i+1
	optionsData[i] = {
    type = "colorpicker",
    name = "Color & Opacity", -- or string id or function returning a string
    getFunc = function() return SAT.SavedVars.color.r, SAT.SavedVars.color.g, SAT.SavedVars.color.b, SAT.SavedVars.color.a end, -- (alpha is optional)
    setFunc = function(r,g,b,a) SAT.SavedVars.color = {a = a, r = r, g = g, b = b} SAT.UpdateIcon() SAT.UpdateMenuIcon() end, -- (alpha is optional)
    width = "full", -- or "half" (optional)
    default = SAT.Defaults.color, -- (optional) table of default color values (or default = defaultColor, where defaultColor is a table with keys of r, g, b[, a]) or a function that returns the color
  }

  i = i+1
  optionsData[i] = {
    type = "iconpicker",
    name = "Icon", -- or string id or function returning a string
    choices = SAT.Icons,
    getFunc = function() return SAT.SavedVars.icon end,
    setFunc = function(icon) SAT.SavedVars.icon = icon SAT.UpdateIcon() SAT.UpdateMenuIcon() end,
    maxColumns = 7, -- number of icons in one row (optional)
    visibleRows = 2, -- number of visible rows (optional)
    iconSize = 32, -- size of the icons (optional)
    defaultColor = ZO_ColorDef:New("FFFFFF"), -- default color of the icons (optional)
    width = "full", --or "half" (optional)
    default = SAT.Defaults.icon, -- default value or function that returns the default value (optional)
  }

  i = i+1
  optionsData[i] = {
    type = "slider",
    name = "Size", -- or string id or function returning a string
    getFunc = function() return SAT.SavedVars.size end,
    setFunc = function(size) SAT.SavedVars.size = size SAT.UpdateIcon() SAT.UpdateMenuIcon() end,
    min = 8,
    max = 128,
    step = 4, -- (optional)
    clampInput = true, -- boolean, if set to false the input won't clamp to min and max and allow any number instead (optional)
    autoSelect = true, -- boolean, automatically select everything in the text input field when it gains focus (optional)
    width = "full", -- or "half" (optional)
    default = SAT.Defaults.size, -- default value or function that returns the default value (optional)
  }

  i = i+1
  optionsData[i] = {
    type = "header",
    name = "Preview", -- or string id or function returning a string
    width = "full", -- or "half" (optional)
  }
  
  i = i+1
  optionsData[i] = {
    type = "texture",
    image = SAT.SavedVars.icon,
    imageWidth = SAT.SavedVars.size, -- max of 250 for half width, 510 for full
    imageHeight = SAT.SavedVars.size, -- max of 100
    width = "full", -- or "half" (optional)
    reference = "SATMenuIcon" -- unique global reference to control (optional)
  }


SAT.LAMSettingsPanel = LAM2:RegisterAddonPanel(SAT.addonName  .. "_LAM", panelData)
LAM2:RegisterOptionControls(SAT.addonName .. "_LAM", optionsData)
CM:RegisterCallback("LAM-PanelControlsCreated", function(panel) if panel == SAT.LAMSettingsPanel then SAT.UpdateMenuIcon() end end)
end

--[[----------------------------------------------
Target Buff Functions
----------------------------------------------]]--
function SAT.UpdateTarget()
  if SAT.unlocked then return end -- if unlocked ignore reticle changes
  local numBuffs = GetNumBuffs(SAT.Const.targetUnitTag)
  for i=1, numBuffs do
    local _,_,_,_,_,_,_,_,_,_, abilityId,_, castByPlayer = GetUnitBuffInfo(SAT.Const.targetUnitTag, i)
    if abilityId == SAT.Const.tauntAbilityID and not castByPlayer then
      SAT.ShowIcon(true)
      return
    end
  end
  SAT.ShowIcon(false)
end

function SAT.OnReticleTargetChanged(eventCode)
  SAT.UpdateTarget()
end

function SAT.OnEffectChanged(eventCode, changeType, effectSlot, effectName, unitTag, beginTime, endTime, stackCount, iconName, buffType, effectType, abilityType, statusEffectType, unitName, unitId, abilityId, sourceUnitType)
  SAT.UpdateTarget()
end


--[[----------------------------------------------
Initialization
----------------------------------------------]]--
function SAT.OnAddonLoaded(eventCode, addonName)
  if addonName ~= SAT.addonName then return end
  EM:UnregisterForEvent(SAT.addonName, EVENT_ADD_ON_LOADED)

  SAT.SavedVars = ZO_SavedVars:NewAccountWide("StaticsAlreadyTaunted", SAT.varsVersion, nil, SAT.Defaults, nil)

  SAT.CreateSettingsWindow()
  SAT.RestorePanel()
  SAT.UpdateIcon()

  local scene = SM:GetScene("hud")
  scene:RegisterCallback("StateChange", SAT.HUDSceneChange)
  local scene = SM:GetScene("hudui")
  scene:RegisterCallback("StateChange", SAT.HUDUISceneChange)
    
  EM:RegisterForEvent(SAT.addonName, EVENT_RETICLE_TARGET_CHANGED, SAT.OnReticleTargetChanged)
  EM:RegisterForEvent(SAT.addonName, EVENT_EFFECT_CHANGED, SAT.OnEffectChanged)
  EM:AddFilterForEvent(SAT.addonName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_UNIT_TAG, SAT.Const.tagetUnitTag)
  EM:AddFilterForEvent(SAT.addonName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_ABILITY_ID, SAT.Const.tauntAbilityID)
    
  SLASH_COMMANDS["/satunlock"] = SAT.Unlock
  SLASH_COMMANDS["/satdebug"] = SAT.Debug
end


--[[----------------------------------------------
Main Registration
----------------------------------------------]]--
EM:RegisterForEvent(SAT.addonName, EVENT_ADD_ON_LOADED, SAT.OnAddonLoaded)