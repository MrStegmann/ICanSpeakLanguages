local addonName, addon = ...

-- Local API caching for standard WoW globals
local CreateFrame, GameTooltip, ChatFrame1, UIParent = CreateFrame, GameTooltip, ChatFrame1, UIParent
local ipairs, pairs, tostring, _G = ipairs, pairs, tostring, _G

addon.UI = addon.UI or {}
local UI = addon.UI

-------------------------------------------------------------------------------
-- Contextual Dropdown Menu Setup
-------------------------------------------------------------------------------
local menuFrame
local configMenuFrame
local function getSavedLanguagesList()
    local db = ICanSpeakLanguagesDB
    if db and db.savedLanguages then
        return db.savedLanguages
    end
    return {}
end

local function initializeMenu(_self, level, _menuList)
    local createInfo = _G.MSA_DropDownMenu_CreateInfo or _G.UIDropDownMenu_CreateInfo
    local addButton = _G.MSA_DropDownMenu_AddButton or _G.UIDropDownMenu_AddButton

    if not createInfo or not addButton then return end

    -- Title Header
    local info = createInfo()
    info.text = (addon.L and addon.L.SELECT_LANGUAGE_TITLE) or "Select Language"
    info.isTitle = true
    info.notCheckable = true
    addButton(info, level)

    -- Current selected language
    local currentLang = "Common"
    if addon.Engine and addon.Engine.db and addon.Engine.db.selectedLanguage then
        currentLang = addon.Engine.db.selectedLanguage
    end

    -- Real Saved Languages
    local availableLangs = getSavedLanguagesList()
    for _, langName in ipairs(availableLangs) do
        local displayText = (addon.Utils and addon.Utils.GetLanguageDisplayWithAlias) and addon.Utils.GetLanguageDisplayWithAlias(langName) or langName

        info = createInfo()
        info.text = displayText
        info.value = langName
        info.checked = (currentLang == langName)
        info.func = function(btn)
            if addon.Engine and addon.Engine.db then
                addon.Engine.db.selectedLanguage = btn.value
            end
            if addon.Engine and addon.Engine.BroadcastSpokenLanguage then
                addon.Engine.BroadcastSpokenLanguage()
            end
            if addon.Utils and addon.Utils.Print then
                local L = addon.L or {}
                local displayName = (addon.Utils and addon.Utils.GetLanguageDisplayName) and addon.Utils.GetLanguageDisplayName(btn.value) or btn.value
                addon.Utils.Print((L.SELECTED_LANG_PRINT or "Selected language to speak: ") .. "|cff33ff99" .. tostring(displayName) .. "|r")
            end
        end
        addButton(info, level)
    end

    -- Separator
    info = createInfo()
    info.text = ""
    info.disabled = true
    info.notCheckable = true
    addButton(info, level)

    -- Action: Open UI Frame
    info = createInfo()
    info.text = (addon.L and addon.L.OPEN_INTERFACE_FRAME) or "Open Interface Frame"
    info.notCheckable = true
    info.func = function()
        if UI.Toggle then
            UI.Toggle()
        end
    end
    addButton(info, level)
end

local function initializeConfigMenu(_self, level, _menuList)
    local createInfo = _G.MSA_DropDownMenu_CreateInfo or _G.UIDropDownMenu_CreateInfo
    local addButton = _G.MSA_DropDownMenu_AddButton or _G.UIDropDownMenu_AddButton
    if not createInfo or not addButton then return end

    local L = addon.L or {}
    local db = ICanSpeakLanguagesDB or {}
    db.channels = db.channels or {}

    local function getStateStr(state)
        return state and ("|cff33ff99" .. (L.STATE_ENABLED or "Enabled") .. "|r") or ("|cffff5555" .. (L.STATE_DISABLED or "Disabled") .. "|r")
    end

    local info = createInfo()
    info.text = L.CONFIGURATION or "Configuration:"
    info.isTitle = true
    info.notCheckable = true
    addButton(info, level)

    -- Option 1: Toggle Activate Language Parse
    local hasLangs = db and db.savedLanguages and #db.savedLanguages > 0
    if not hasLangs then
        db.enabled = false
    end
    info = createInfo()
    info.text = string.format(L.MENU_ACTIVATE_PARSER or "Activate Language Parse: %s", getStateStr(db.enabled == true))
    info.notCheckable = true
    info.keepShownOnClick = true
    info.func = function(self)
        local hasLangsCheck = db and db.savedLanguages and #db.savedLanguages > 0
        if not hasLangsCheck then
            db.enabled = false
            local warnText = L.NO_LANGUAGES_WARNING or "You must have at least One language saved"
            if addon.Utils and addon.Utils.Print then
                addon.Utils.Print("|cffff5555" .. warnText .. "|r")
            end
            return
        end
        db.enabled = not (db.enabled == true)
        if _G.ICanSpeakLanguagesParseCheck then _G.ICanSpeakLanguagesParseCheck:SetChecked(db.enabled) end
        if UI.UpdateMainButtonVisual then UI.UpdateMainButtonVisual() end
        self:SetText(string.format(L.MENU_ACTIVATE_PARSER or "Activate Language Parse: %s", getStateStr(db.enabled)))
    end
    addButton(info, level)

    -- Option 2: Toggle Dungeon Master
    info = createInfo()
    info.text = string.format(L.MENU_DUNGEON_MASTER or "Dungeon Master: %s", getStateStr(db.dungeonMaster == true))
    info.notCheckable = true
    info.keepShownOnClick = true
    info.func = function(self)
        local canUse = not addon.Engine or not addon.Engine.CanUseDungeonMaster or addon.Engine.CanUseDungeonMaster()
        if canUse then
            db.dungeonMaster = not (db.dungeonMaster == true)
            if UI.UpdateMainButtonVisual then UI.UpdateMainButtonVisual() end
            self:SetText(string.format(L.MENU_DUNGEON_MASTER or "Dungeon Master: %s", getStateStr(db.dungeonMaster)))
        end
    end
    addButton(info, level)

    -- Division Header: Channels
    info = createInfo()
    info.text = L.CHANNELS or "Channels:"
    info.isTitle = true
    info.notCheckable = true
    addButton(info, level)

    -- Channel Helper
    local function addChannelToggle(chanKey, locName)
        local cInfo = createInfo()
        cInfo.text = string.format(L.MENU_TRANSLATE_CHANNEL or "Translate %s: %s", locName, getStateStr(db.channels[chanKey] ~= false))
        cInfo.notCheckable = true
        cInfo.keepShownOnClick = true
        cInfo.func = function(self)
            db.channels[chanKey] = not (db.channels[chanKey] ~= false)
            self:SetText(string.format(L.MENU_TRANSLATE_CHANNEL or "Translate %s: %s", locName, getStateStr(db.channels[chanKey])))
        end
        addButton(cInfo, level)
    end

    addChannelToggle("say", L.SAY or "Say")
    addChannelToggle("whisper", L.WHISPER or "Whisper")
    addChannelToggle("yell", L.YELL or "Yell")
    addChannelToggle("group", L.GROUP or "Group")
    addChannelToggle("raid", L.RAID or "Raid")
    addChannelToggle("raidWarning", L.RAID_WARNING or "Raid Warning")

    -- Separator
    info = createInfo()
    info.text = ""
    info.disabled = true
    info.notCheckable = true
    addButton(info, level)

    -- Option 9: Show Language in Chat
    info = createInfo()
    info.text = string.format(L.MENU_SHOW_LANG or "Show Language in Chat: %s", getStateStr(db.showLanguageInChat ~= false))
    info.notCheckable = true
    info.keepShownOnClick = true
    info.func = function(self)
        db.showLanguageInChat = not (db.showLanguageInChat ~= false)
        if _G.ICanSpeakLanguagesShowLangCheck then _G.ICanSpeakLanguagesShowLangCheck:SetChecked(db.showLanguageInChat) end
        self:SetText(string.format(L.MENU_SHOW_LANG or "Show Language in Chat: %s", getStateStr(db.showLanguageInChat)))
    end
    addButton(info, level)
end

-------------------------------------------------------------------------------
-- Main Button Visual State Refresh
-------------------------------------------------------------------------------
local function updateMainButtonVisual()
    local button = UI.MainButton
    if not button then return end

    local db = ICanSpeakLanguagesDB
    local isEnabled = db and (db.enabled == true)

    if button.redOverlay then
        if isEnabled then
            button.redOverlay:Hide()
        else
            button.redOverlay:Show()
        end
    end

    if button.dmLabel then
        local isDM = addon.Validators and addon.Validators.IsDungeonMasterActive and addon.Validators.IsDungeonMasterActive()
        if isDM then
            button.dmLabel:Show()
        else
            button.dmLabel:Hide()
        end
    end
end
UI.UpdateMainButtonVisual = updateMainButtonVisual

-------------------------------------------------------------------------------
-- Chat Frame Button Creation & Anchoring
-------------------------------------------------------------------------------
local function createMainButton()
    if UI.MainButton then return UI.MainButton end

    local parentFrame = ChatFrame1 or UIParent
    local button = CreateFrame("Button", "ICanSpeakLanguagesMainButton", parentFrame)
    button:SetSize(26, 26)
    button:SetFrameStrata("MEDIUM")
    button:SetFrameLevel((parentFrame:GetFrameLevel() or 1) + 10)

    -- Lock button into the Chat Frame
    button:SetPoint("TOPRIGHT", parentFrame, "TOPRIGHT", 25, 30)

    -- Valid 9.2.7 Shadowlands Icon Texture (Language Book / Chat Icon)
    local texture = button:CreateTexture(nil, "ARTWORK")
    texture:SetTexture("Interface\\Icons\\INV_Misc_Book_09")
    texture:SetAllPoints(button)
    button.texture = texture

    -- Red Overlay Texture for disabled parser state (currentState == FALSE)
    local redOverlay = button:CreateTexture(nil, "OVERLAY")
    redOverlay:SetColorTexture(0.85, 0.1, 0.1, 0.5)
    redOverlay:SetAllPoints(button)
    button.redOverlay = redOverlay

    -- Dungeon Master Label (DM)
    local dmLabel = button:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
    dmLabel:SetDrawLayer("OVERLAY", 7) -- Ensure it draws above all other overlays
    dmLabel:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
    dmLabel:SetText("DM")
    dmLabel:SetTextColor(1, 0.82, 0) -- High contrast Gold
    dmLabel:SetShadowColor(0, 0, 0, 1)
    dmLabel:SetShadowOffset(1, -1)
    button.dmLabel = dmLabel

    -- Highlight Texture
    local highlight = button:CreateTexture(nil, "HIGHLIGHT")
    highlight:SetTexture("Interface\\Buttons\\UI-Common-MouseHilight")
    highlight:SetBlendMode("ADD")
    highlight:SetAllPoints(button)
    button:SetHighlightTexture(highlight)

    -- Pushed Texture
    local pushed = button:CreateTexture(nil, "PUSHED")
    pushed:SetTexture("Interface\\Buttons\\UI-Quickslot-Depress")
    pushed:SetAllPoints(button)

    -- Contextual Menu Creation using MSA-DropDownMenu-1.0 or Blizzard DropDown
    local createMenu = _G.MSA_DropDownMenu_Create or _G.CreateFrame
    local initMenu = _G.MSA_DropDownMenu_Initialize or _G.UIDropDownMenu_Initialize

    if createMenu then
        menuFrame = createMenu("ICanSpeakLanguagesMainButtonMenu", button)
        configMenuFrame = createMenu("ICanSpeakLanguagesMainButtonConfigMenu", button)
        if initMenu then
            initMenu(menuFrame, initializeMenu, "MENU")
            initMenu(configMenuFrame, initializeConfigMenu, "MENU")
        end
    end

    -- Click Handler (Left Click: Contextual Menu, Right Click: Configuration Menu)
    button:RegisterForClicks("AnyUp")
    button:SetScript("OnClick", function(self, btn)
        local toggleMenu = _G.MSA_ToggleDropDownMenu or _G.ToggleDropDownMenu
        if not toggleMenu then return end
        
        if btn == "RightButton" then
            if configMenuFrame then
                toggleMenu(1, nil, configMenuFrame, self, 0, 0)
            end
        else
            if menuFrame then
                toggleMenu(1, nil, menuFrame, self, 0, 0)
            end
        end
    end)

    -- Tooltip Handlers
    button:SetScript("OnEnter", function(self)
        if GameTooltip then
            local db = ICanSpeakLanguagesDB
            local enabled = db and (db.enabled == true)
            local L = addon.L or {}
            local leftLine = L.LEFT_CLICK_MENU or "Clic Izquierdo abre el menú."
            local rightLine = L.RIGHT_CLICK_MENU or "Clic Derecho abre la configuración."

            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:AddLine("ICanSpeakLanguages", 0.2, 1.0, 0.6)
            GameTooltip:AddLine(leftLine, 1.0, 1.0, 1.0)
            GameTooltip:AddLine(rightLine, 1.0, 1.0, 1.0)
            GameTooltip:Show()
        end
    end)

    button:SetScript("OnLeave", function(_self)
        if GameTooltip then
            GameTooltip:Hide()
        end
    end)

    button:SetScript("OnShow", function(_self)
        updateMainButtonVisual()
    end)

    UI.MainButton = button
    updateMainButtonVisual()
    return button
end

-------------------------------------------------------------------------------
-- Initialization Event Handler
-------------------------------------------------------------------------------
local initFrame = CreateFrame("Frame")
initFrame:RegisterEvent("PLAYER_LOGIN")
initFrame:SetScript("OnEvent", function(self, _event)
    createMainButton()
    self:UnunregisterEvent("PLAYER_LOGIN")
end)
