local addonName, addon = ...

-- Local API caching for performance and GC prevention
local CreateFrame, GameTooltip, UIParent = CreateFrame, GameTooltip, UIParent
local ipairs, pairs, type, table, tostring, _G = ipairs, pairs, type, table, tostring, _G

addon.UI = addon.UI or {}
local UI = addon.UI

local mainFrame = nil
local availableListScrollChild = nil
local savedListScrollChild = nil

local availableButtonsPool = {}
local savedButtonsPool = {}

-------------------------------------------------------------------------------
-- Real Languages Extraction Helper (No Mock Data)
-------------------------------------------------------------------------------
local function getAllRealLanguageNames()
    local list = {}
    local seen = {}

    local function addLang(name)
        if name and type(name) == "string" and not seen[name] then
            seen[name] = true
            table.insert(list, name)
        end
    end

    local langData = addon.Languages or (addon.Engine and addon.Engine.Languages)
    if not langData then
        langData = _G.wowLanguages
    end

    if langData then
        if langData.factionLanguages then
            for _, group in pairs(langData.factionLanguages) do
                if type(group) == "table" then
                    for _, item in ipairs(group) do addLang(item.name) end
                end
            end
        end
        if langData.ancientAndCosmic then
            for _, item in ipairs(langData.ancientAndCosmic) do addLang(item.name) end
        end
        if langData.elemental then
            for _, item in ipairs(langData.elemental) do addLang(item.name) end
        end
        if langData.mortalRacesAndSpecies then
            for _, item in ipairs(langData.mortalRacesAndSpecies) do addLang(item.name) end
        end
        if langData.rpgAndObsolete then
            for _, item in ipairs(langData.rpgAndObsolete) do addLang(item.name) end
        end
    end

    table.sort(list)
    return list
end

-------------------------------------------------------------------------------
-- Dual Column Refresh Handler (Available vs Saved Languages)
-------------------------------------------------------------------------------
local function refreshLanguageLists()
    if not availableListScrollChild or not savedListScrollChild then return end

    local db = ICanSpeakLanguagesDB
    if not db then return end
    db.savedLanguages = db.savedLanguages or {}
    db.selectedLanguage = db.selectedLanguage or "Common"

    local savedSet = {}
    for _, langName in ipairs(db.savedLanguages) do
        savedSet[langName] = true
    end

    local allRealLangs = getAllRealLanguageNames()

    -- 1. Hydrate Column 1: Available Languages (language != saved_language)
    for _, btn in ipairs(availableButtonsPool) do btn:Hide() end

    local availIdx = 0
    for _, langName in ipairs(allRealLangs) do
        if not savedSet[langName] then
            availIdx = availIdx + 1
            local btn = availableButtonsPool[availIdx]
            if not btn then
                btn = CreateFrame("Button", nil, availableListScrollChild)
                btn:SetSize(135, 20)

                local bg = btn:CreateTexture(nil, "BACKGROUND")
                bg:SetAllPoints(btn)
                bg:SetColorTexture(0.2, 0.2, 0.2, 0.3)
                btn.bg = bg

                local addBtn = CreateFrame("Button", nil, btn, "UIPanelButtonTemplate")
                addBtn:SetSize(18, 18)
                addBtn:SetPoint("RIGHT", btn, "RIGHT", -2, 0)
                addBtn:SetText(">")
                btn.addBtn = addBtn

                local lbl = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                lbl:SetPoint("LEFT", btn, "LEFT", 4, 0)
                lbl:SetPoint("RIGHT", addBtn, "LEFT", -2, 0)
                lbl:SetJustifyH("LEFT")
                btn.label = lbl

                availableButtonsPool[availIdx] = btn
            end

            local displayText = (addon.Utils and addon.Utils.GetLanguageDisplayWithAlias) and addon.Utils.GetLanguageDisplayWithAlias(langName) or langName
            btn.label:SetText(displayText)
            btn:SetPoint("TOPLEFT", availableListScrollChild, "TOPLEFT", 0, -(availIdx - 1) * 22)
            btn.addBtn:SetScript("OnClick", function()
                table.insert(db.savedLanguages, langName)
                refreshLanguageLists()
                if addon.Engine and addon.Engine.BroadcastSpokenLanguage then
                    addon.Engine.BroadcastSpokenLanguage()
                end
            end)
            btn:Show()
        end
    end
    availableListScrollChild:SetHeight(math.max(130, availIdx * 22))

    -- 2. Hydrate Column 2: Saved Languages (language == saved_language)
    for _, btn in ipairs(savedButtonsPool) do btn:Hide() end

    local savedIdx = 0
    for _, langName in ipairs(db.savedLanguages) do
        savedIdx = savedIdx + 1
        local btn = savedButtonsPool[savedIdx]
        if not btn then
            btn = CreateFrame("Button", nil, savedListScrollChild)
            btn:SetSize(135, 20)

            local bg = btn:CreateTexture(nil, "BACKGROUND")
            bg:SetAllPoints(btn)
            btn.bg = bg

            local removeBtn = CreateFrame("Button", nil, btn, "UIPanelButtonTemplate")
            removeBtn:SetSize(18, 18)
            removeBtn:SetPoint("RIGHT", btn, "RIGHT", -2, 0)
            removeBtn:SetText("X")
            btn.removeBtn = removeBtn

            local lbl = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            lbl:SetPoint("LEFT", btn, "LEFT", 4, 0)
            lbl:SetPoint("RIGHT", removeBtn, "LEFT", -2, 0)
            lbl:SetJustifyH("LEFT")
            btn.label = lbl

            savedButtonsPool[savedIdx] = btn
        end

        local displayText = (addon.Utils and addon.Utils.GetLanguageDisplayWithAlias) and addon.Utils.GetLanguageDisplayWithAlias(langName) or langName
        btn.label:SetText(displayText)
        btn:SetPoint("TOPLEFT", savedListScrollChild, "TOPLEFT", 0, -(savedIdx - 1) * 22)

        -- Highlight orange background with opacity 0.35 if selected default language
        if db.selectedLanguage == langName then
            btn.bg:SetColorTexture(1.0, 0.5, 0.0, 0.35)
        else
            btn.bg:SetColorTexture(0.2, 0.2, 0.2, 0.3)
        end

        -- Left click selects default language
        btn:SetScript("OnClick", function()
            db.selectedLanguage = langName
            refreshLanguageLists()
            if addon.Engine and addon.Engine.BroadcastSpokenLanguage then
                addon.Engine.BroadcastSpokenLanguage()
            end
        end)

        -- Red X button removes saved language
        btn.removeBtn:SetScript("OnClick", function()
            for idx, item in ipairs(db.savedLanguages) do
                if item == langName then
                    table.remove(db.savedLanguages, idx)
                    break
                end
            end
            if db.selectedLanguage == langName then
                db.selectedLanguage = db.savedLanguages[1] or "Common"
            end
            refreshLanguageLists()
            if addon.Engine and addon.Engine.BroadcastSpokenLanguage then
                addon.Engine.BroadcastSpokenLanguage()
            end
        end)

        btn:Show()
    end
    savedListScrollChild:SetHeight(math.max(130, savedIdx * 22))
end

-------------------------------------------------------------------------------
-- Helper: Channel CheckBox Builder
-------------------------------------------------------------------------------
local function createChannelCheckButton(parent, name, labelTextKey, channelKey, defaultVal, x, y)
    local cb = CreateFrame("CheckButton", name, parent, "UICheckButtonTemplate")
    cb:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
    cb:SetSize(24, 24)

    local lbl = cb:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    lbl:SetPoint("LEFT", cb, "RIGHT", 2, 1)
    local L = addon.L or {}
    lbl:SetText(L[labelTextKey] or labelTextKey)
    cb.label = lbl

    cb:SetScript("OnShow", function(self)
        local db = ICanSpeakLanguagesDB
        if db then
            db.channels = db.channels or {}
            if db.channels[channelKey] == nil then
                db.channels[channelKey] = defaultVal
            end
            self:SetChecked(db.channels[channelKey] == true)
        else
            self:SetChecked(defaultVal)
        end
    end)

    cb:SetScript("OnClick", function(self)
        local isChecked = self:GetChecked()
        if ICanSpeakLanguagesDB then
            ICanSpeakLanguagesDB.channels = ICanSpeakLanguagesDB.channels or {}
            ICanSpeakLanguagesDB.channels[channelKey] = isChecked
        end
    end)

    return cb
end

-------------------------------------------------------------------------------
-- Main Options Panel Creation
-------------------------------------------------------------------------------
local function createMainFrame()
    if mainFrame then return mainFrame end

    local frame = CreateFrame("Frame", "ICanSpeakLanguagesMainFrame", UIParent, "BasicFrameTemplateWithInset")
    frame:SetSize(410, 520)
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:Hide()

    if frame.TitleBg then
        frame.TitleBg:SetHeight(30)
    end

    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    title:SetPoint("TOP", frame, "TOP", 0, -5)
    title:SetText("ICanSpeakLanguages")

    if frame.Bg then
        frame.Bg:SetAlpha(1.0)
    end

    ---------------------------------------------------------------------------
    -- Row 1: Checkbox "Activate Language Parse" (Defaults to FALSE)
    ---------------------------------------------------------------------------
    local checkButton = CreateFrame("CheckButton", "ICanSpeakLanguagesParseCheck", frame, "UICheckButtonTemplate")
    checkButton:SetPoint("TOPLEFT", frame, "TOPLEFT", 16, -32)

    local checkLabel = checkButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    checkLabel:SetPoint("LEFT", checkButton, "RIGHT", 4, 1)

    checkButton:SetScript("OnShow", function(self)
        if ICanSpeakLanguagesDB then
            self:SetChecked(ICanSpeakLanguagesDB.enabled == true)
        else
            self:SetChecked(false)
        end
    end)

    checkButton:SetScript("OnClick", function(self)
        local isChecked = self:GetChecked()
        if ICanSpeakLanguagesDB then
            ICanSpeakLanguagesDB.enabled = isChecked
        end
        if addon.Utils and addon.Utils.Print then
            local L = addon.L or {}
            local stateStr = isChecked and ("|cff33ff99" .. (L.STATE_ENABLED or "Activado") .. "|r") or ("|cffff5555" .. (L.STATE_DISABLED or "Desactivado") .. "|r")
            addon.Utils.Print((L.PARSER_PRINT or "Language Parse: ") .. stateStr)
        end
        if UI.UpdateMainButtonVisual then
            UI.UpdateMainButtonVisual()
        end
    end)

    ---------------------------------------------------------------------------
    -- Row 2: Two Scrollable Columns Layout
    ---------------------------------------------------------------------------
    local columnYOffset = -65

    -- COLUMN 1 (Left Side): Available Languages List Box
    local col1Label = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    col1Label:SetPoint("TOPLEFT", frame, "TOPLEFT", 16, columnYOffset)

    local availContainer = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    availContainer:SetSize(175, 140)
    availContainer:SetPoint("TOPLEFT", frame, "TOPLEFT", 16, columnYOffset - 18)
    availContainer:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 12,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    availContainer:SetBackdropColor(0, 0, 0, 0.8)

    local availScrollFrame = CreateFrame("ScrollFrame", "ICanSpeakLanguagesAvailableListScrollFrame", availContainer, "UIPanelScrollFrameTemplate")
    availScrollFrame:SetPoint("TOPLEFT", availContainer, "TOPLEFT", 4, -4)
    availScrollFrame:SetPoint("BOTTOMRIGHT", availContainer, "BOTTOMRIGHT", -24, 4)

    availableListScrollChild = CreateFrame("Frame", nil, availScrollFrame)
    availableListScrollChild:SetSize(145, 130)
    availScrollFrame:SetScrollChild(availableListScrollChild)

    -- COLUMN 2 (Right Side): Saved Languages List Box
    local col2Label = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    col2Label:SetPoint("TOPLEFT", frame, "TOPLEFT", 210, columnYOffset)

    local savedContainer = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    savedContainer:SetSize(175, 140)
    savedContainer:SetPoint("TOPLEFT", frame, "TOPLEFT", 210, columnYOffset - 18)
    savedContainer:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 12,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    savedContainer:SetBackdropColor(0, 0, 0, 0.8)

    local savedScrollFrame = CreateFrame("ScrollFrame", "ICanSpeakLanguagesSavedListScrollFrame", savedContainer, "UIPanelScrollFrameTemplate")
    savedScrollFrame:SetPoint("TOPLEFT", savedContainer, "TOPLEFT", 4, -4)
    savedScrollFrame:SetPoint("BOTTOMRIGHT", savedContainer, "BOTTOMRIGHT", -24, 4)

    savedListScrollChild = CreateFrame("Frame", nil, savedScrollFrame)
    savedListScrollChild:SetSize(145, 130)
    savedScrollFrame:SetScrollChild(savedListScrollChild)

    ---------------------------------------------------------------------------
    -- Row 3: Channels Selection Grid (2-Columns)
    ---------------------------------------------------------------------------
    local channelsYOffset = -235
    local channelsLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    channelsLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 16, channelsYOffset)

    -- Column 1: Whisper, Say, Yell (Defaults to TRUE)
    local cbWhisper = createChannelCheckButton(frame, "ICSLChanWhisper", "WHISPER", "whisper", true, 16, channelsYOffset - 22)
    local cbSay     = createChannelCheckButton(frame, "ICSLChanSay", "SAY", "say", true, 16, channelsYOffset - 46)
    local cbYell    = createChannelCheckButton(frame, "ICSLChanYell", "YELL", "yell", true, 16, channelsYOffset - 70)

    -- Column 2: Group, Raid, RaidWarning (Defaults to FALSE)
    local cbGroup   = createChannelCheckButton(frame, "ICSLChanGroup", "GROUP", "group", false, 210, channelsYOffset - 22)
    local cbRaid    = createChannelCheckButton(frame, "ICSLChanRaid", "RAID", "raid", false, 210, channelsYOffset - 46)
    local cbRaidRW  = createChannelCheckButton(frame, "ICSLChanRaidWarning", "RAID_WARNING", "raidWarning", false, 210, channelsYOffset - 70)

    ---------------------------------------------------------------------------
    -- Row 4: Checkbox "Dungeon Master"
    ---------------------------------------------------------------------------
    local dmYOffset = channelsYOffset - 105
    local dmCheckButton = CreateFrame("CheckButton", "ICanSpeakLanguagesDMCheck", frame, "UICheckButtonTemplate")
    dmCheckButton:SetPoint("TOPLEFT", frame, "TOPLEFT", 16, dmYOffset)

    local dmLabel = dmCheckButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    dmLabel:SetPoint("LEFT", dmCheckButton, "RIGHT", 4, 1)

    dmCheckButton:SetScript("OnShow", function(self)
        local canUse = not addon.Engine or not addon.Engine.CanUseDungeonMaster or addon.Engine.CanUseDungeonMaster()
        if canUse then
            self:Enable()
            self:SetAlpha(1.0)
            self:SetChecked(ICanSpeakLanguagesDB and ICanSpeakLanguagesDB.dungeonMaster == true)
        else
            self:Disable()
            self:SetAlpha(0.5)
            self:SetChecked(false)
        end
    end)

    dmCheckButton:SetScript("OnClick", function(self)
        local canUse = not addon.Engine or not addon.Engine.CanUseDungeonMaster or addon.Engine.CanUseDungeonMaster()
        if not canUse then
            self:SetChecked(false)
            if addon.Utils and addon.Utils.Print then
                addon.Utils.Print("|cffff5555Only party or raid leaders can activate Dungeon Master mode.|r")
            end
            return
        end
        local isChecked = self:GetChecked()
        if ICanSpeakLanguagesDB then
            ICanSpeakLanguagesDB.dungeonMaster = isChecked
        end
        if addon.UI and addon.UI.UpdateMainButtonVisual then
            addon.UI.UpdateMainButtonVisual()
        end
        if addon.Utils and addon.Utils.Print then
            local L = addon.L or {}
            local stateStr = isChecked and ("|cff33ff99" .. (L.STATE_ENABLED or "Activado") .. "|r") or ("|cffff5555" .. (L.STATE_DISABLED or "Desactivado") .. "|r")
            addon.Utils.Print((L.DM_PRINT or "Dungeon Master: ") .. stateStr)
        end
    end)

    ---------------------------------------------------------------------------
    -- Row 5: Configuration
    ---------------------------------------------------------------------------
    local configYOffset = dmYOffset - 35
    local configLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    configLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 16, configYOffset)

    local showLangCheckButton = CreateFrame("CheckButton", "ICanSpeakLanguagesShowLangCheck", frame, "UICheckButtonTemplate")
    showLangCheckButton:SetPoint("TOPLEFT", frame, "TOPLEFT", 16, configYOffset - 22)

    local showLangLabel = showLangCheckButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    showLangLabel:SetPoint("LEFT", showLangCheckButton, "RIGHT", 4, 1)

    showLangCheckButton:SetScript("OnShow", function(self)
        if ICanSpeakLanguagesDB then
            if ICanSpeakLanguagesDB.showLanguageInChat == nil then
                ICanSpeakLanguagesDB.showLanguageInChat = true
            end
            self:SetChecked(ICanSpeakLanguagesDB.showLanguageInChat == true)
        else
            self:SetChecked(true)
        end
    end)

    showLangCheckButton:SetScript("OnClick", function(self)
        local isChecked = self:GetChecked()
        if ICanSpeakLanguagesDB then
            ICanSpeakLanguagesDB.showLanguageInChat = isChecked
        end
        if addon.Utils and addon.Utils.Print then
            local L = addon.L or {}
            local stateStr = isChecked and ("|cff33ff99" .. (L.STATE_ENABLED or "Activado") .. "|r") or ("|cffff5555" .. (L.STATE_DISABLED or "Desactivado") .. "|r")
            addon.Utils.Print((L.SHOW_LANG_PRINT or "Mostrar Idioma: ") .. stateStr)
        end
    end)

    ---------------------------------------------------------------------------
    -- Row 6: UI Language Selection Dropdown Menu (Spanish & English)
    ---------------------------------------------------------------------------
    local langLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    langLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 16, configYOffset - 54)

    local createDropDown = _G.MSA_DropDownMenu_Create or function(name, parent)
        return CreateFrame("Frame", name, parent, "UIDropDownMenuTemplate")
    end
    local initDropDown = _G.MSA_DropDownMenu_Initialize or _G.UIDropDownMenu_Initialize
    local setDropDownText = _G.MSA_DropDownMenu_SetText or _G.UIDropDownMenu_SetText
    local setDropDownWidth = _G.MSA_DropDownMenu_SetWidth or _G.UIDropDownMenu_SetWidth

    local localeDropDown = createDropDown("ICSL_UILocaleDropDown", frame)
    localeDropDown:SetPoint("TOPLEFT", frame, "TOPLEFT", 150, configYOffset - 48)
    setDropDownWidth(localeDropDown, 130)

    local function getLocaleDisplayText(loc)
        return loc == "en_EN" and "English (Inglés)" or "Español (Spanish)"
    end

    local function updateAllUILabels()
        local L = addon.L or {}
        checkLabel:SetText(L.ACTIVATE_PARSER or "Activate Language Parse")
        col1Label:SetText(L.AVAILABLE_LANGUAGES or "Idiomas Disponibles:")
        col2Label:SetText(L.SAVED_LANGUAGES or "Idiomas Guardados:")
        channelsLabel:SetText(L.CHANNELS or "Channels:")
        dmLabel:SetText(L.DUNGEON_MASTER or "Dungeon Master")
        configLabel:SetText(L.CONFIGURATION or "Configuration:")
        showLangLabel:SetText(L.SHOW_LANG_IN_CHAT or "Mostrar Idioma en el Chat")
        langLabel:SetText(L.UI_LANGUAGE or "UI Language:")

        if cbWhisper and cbWhisper.label then cbWhisper.label:SetText(L.WHISPER or "Whisper") end
        if cbSay and cbSay.label then cbSay.label:SetText(L.SAY or "Say") end
        if cbYell and cbYell.label then cbYell.label:SetText(L.YELL or "Yell") end
        if cbGroup and cbGroup.label then cbGroup.label:SetText(L.GROUP or "Group") end
        if cbRaid and cbRaid.label then cbRaid.label:SetText(L.RAID or "Raid") end
        if cbRaidRW and cbRaidRW.label then cbRaidRW.label:SetText(L.RAID_WARNING or "Raid Warning") end

        local curLoc = (ICanSpeakLanguagesDB and ICanSpeakLanguagesDB.uiLocale) or "es_ES"
        setDropDownText(localeDropDown, getLocaleDisplayText(curLoc))

        if dmCheckButton then
            local canUseDM = not addon.Engine or not addon.Engine.CanUseDungeonMaster or addon.Engine.CanUseDungeonMaster()
            if canUseDM then
                dmCheckButton:Enable()
                dmCheckButton:SetAlpha(1.0)
                dmCheckButton:SetChecked(ICanSpeakLanguagesDB and ICanSpeakLanguagesDB.dungeonMaster == true)
            else
                dmCheckButton:Disable()
                dmCheckButton:SetAlpha(0.5)
                dmCheckButton:SetChecked(false)
            end
        end

        refreshLanguageLists()
    end

    local function initializeLocaleMenu(_self, level, _menuList)
        local createInfo = _G.MSA_DropDownMenu_CreateInfo or _G.UIDropDownMenu_CreateInfo
        local addButton = _G.MSA_DropDownMenu_AddButton or _G.UIDropDownMenu_AddButton

        if not createInfo or not addButton then return end

        local currentLocale = (ICanSpeakLanguagesDB and ICanSpeakLanguagesDB.uiLocale) or "es_ES"

        -- Spanish Option
        local info = createInfo()
        info.text = "Español (Spanish)"
        info.value = "es_ES"
        info.checked = (currentLocale == "es_ES")
        info.func = function(_btn)
            addon.SetLocale("es_ES")
            if addon.Utils and addon.Utils.Print then
                local L = addon.L or {}
                addon.Utils.Print((L.UI_LANG_CHANGED_PRINT or "UI Language changed to: ") .. "Español")
            end
            updateAllUILabels()
        end
        addButton(info, level)

        -- English Option
        info = createInfo()
        info.text = "English (Inglés)"
        info.value = "en_EN"
        info.checked = (currentLocale == "en_EN")
        info.func = function(_btn)
            addon.SetLocale("en_EN")
            if addon.Utils and addon.Utils.Print then
                local L = addon.L or {}
                addon.Utils.Print((L.UI_LANG_CHANGED_PRINT or "UI Language changed to: ") .. "English")
            end
            updateAllUILabels()
        end
        addButton(info, level)
    end

    if initDropDown then
        initDropDown(localeDropDown, initializeLocaleMenu)
    end

    frame:RegisterEvent("GROUP_ROSTER_UPDATE")
    frame:SetScript("OnEvent", function(self, event)
        if event == "GROUP_ROSTER_UPDATE" and self:IsShown() then
            updateAllUILabels()
        end
    end)

    frame:SetScript("OnShow", function()
        updateAllUILabels()
    end)

    mainFrame = frame
    UI.MainFrame = frame
    return frame
end

-------------------------------------------------------------------------------
-- Initialization Event Handler
-------------------------------------------------------------------------------
local initFrame = CreateFrame("Frame")
initFrame:RegisterEvent("PLAYER_LOGIN")
initFrame:SetScript("OnEvent", function(self, _event)
    createMainFrame()
    self:UnunregisterEvent("PLAYER_LOGIN")
end)

function UI.ToggleMainFrame()
    local f = createMainFrame()
    if f:IsShown() then
        f:Hide()
    else
        f:Show()
    end
end
