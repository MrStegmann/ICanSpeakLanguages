local addonName, addon = ...

local Utils = addon.Utils
local Engine = addon.Engine

local function printMsg(msg)
    if Utils and Utils.Print then
        Utils.Print(msg)
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99[ICanSpeakLanguages]|r " .. tostring(msg))
    end
end

local function getDB()
    ICanSpeakLanguagesDB = ICanSpeakLanguagesDB or {}
    ICanSpeakLanguagesDB.channels = ICanSpeakLanguagesDB.channels or {
        whisper = true,
        say = true,
        yell = true,
        group = false,
        raid = false,
        raidWarning = false
    }
    ICanSpeakLanguagesDB.savedLanguages = ICanSpeakLanguagesDB.savedLanguages or {}
    return ICanSpeakLanguagesDB
end

local function getAllLanguages()
    local list = {}
    local seen = {}

    local function addLang(name)
        if name and type(name) == "string" and not seen[name:lower()] then
            seen[name:lower()] = name
            table.insert(list, name)
        end
    end

    local langData = addon.Languages or (addon.Engine and addon.Engine.Languages) or _G.wowLanguages
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
    return list, seen
end

local function findMatchingLanguage(input)
    if not input or input == "" then return nil end
    local cleanInput = input:lower():gsub("[%s%-%']", "")
    local allLangs = getAllLanguages()

    for _, langName in ipairs(allLangs) do
        local cleanLang = langName:lower():gsub("[%s%-%']", "")
        if cleanLang == cleanInput then
            return langName
        end
    end
    return nil
end

local function refreshUI()
    if ICanSpeakLanguagesMainFrame and ICanSpeakLanguagesMainFrame:IsShown() then
        ICanSpeakLanguagesMainFrame:Hide()
        ICanSpeakLanguagesMainFrame:Show()
    end
end

local function getL()
    return addon.L or {}
end

local function getStateStr(enabled)
    local L = getL()
    if enabled then
        return "|cff33ff99" .. (L.STATE_ENABLED or "Enabled") .. "|r"
    else
        return "|cffff5555" .. (L.STATE_DISABLED or "Disabled") .. "|r"
    end
end

-------------------------------------------------------------------------------
-- 1. /SpeakP -> Toggle Party Checkbox channel
-------------------------------------------------------------------------------
SLASH_ICSL_SPEAKP1 = "/SpeakP"
SLASH_ICSL_SPEAKP2 = "/speakp"
SLASH_ICSL_SPEAKP3 = "/SPEAKP"
SlashCmdList["ICSL_SPEAKP"] = function()
    local db = getDB()
    db.channels.group = not db.channels.group
    printMsg((getL().CMD_SPEAKP_MSG or "Party Channel: ") .. getStateStr(db.channels.group))
    refreshUI()
end

-------------------------------------------------------------------------------
-- 2. /SpeakR -> Toggle Raid Checkbox channel
-------------------------------------------------------------------------------
SLASH_ICSL_SPEAKR1 = "/SpeakR"
SLASH_ICSL_SPEAKR2 = "/speakr"
SLASH_ICSL_SPEAKR3 = "/SPEAKR"
SlashCmdList["ICSL_SPEAKR"] = function()
    local db = getDB()
    db.channels.raid = not db.channels.raid
    printMsg((getL().CMD_SPEAKR_MSG or "Raid Channel: ") .. getStateStr(db.channels.raid))
    refreshUI()
end

-------------------------------------------------------------------------------
-- 3. /SpeakRW -> Toggle Raid Warning Checkbox channel
-------------------------------------------------------------------------------
SLASH_ICSL_SPEAKRW1 = "/SpeakRW"
SLASH_ICSL_SPEAKRW2 = "/speakrw"
SLASH_ICSL_SPEAKRW3 = "/SPEAKRW"
SlashCmdList["ICSL_SPEAKRW"] = function()
    local db = getDB()
    db.channels.raidWarning = not db.channels.raidWarning
    printMsg((getL().CMD_SPEAKRW_MSG or "Raid Warning Channel: ") .. getStateStr(db.channels.raidWarning))
    refreshUI()
end

-------------------------------------------------------------------------------
-- 4. /SpeakW -> Toggle Whisper Checkbox channel
-------------------------------------------------------------------------------
SLASH_ICSL_SPEAKW1 = "/SpeakW"
SLASH_ICSL_SPEAKW2 = "/speakw"
SLASH_ICSL_SPEAKW3 = "/SPEAKW"
SlashCmdList["ICSL_SPEAKW"] = function()
    local db = getDB()
    db.channels.whisper = not db.channels.whisper
    printMsg((getL().CMD_SPEAKW_MSG or "Whisper Channel: ") .. getStateStr(db.channels.whisper))
    refreshUI()
end

-------------------------------------------------------------------------------
-- 5. /SpeakS -> Toggle Say Checkbox channel
-------------------------------------------------------------------------------
SLASH_ICSL_SPEAKS1 = "/SpeakS"
SLASH_ICSL_SPEAKS2 = "/speaks"
SLASH_ICSL_SPEAKS3 = "/SPEAKS"
SlashCmdList["ICSL_SPEAKS"] = function()
    local db = getDB()
    db.channels.say = not db.channels.say
    printMsg((getL().CMD_SPEAKS_MSG or "Say Channel: ") .. getStateStr(db.channels.say))
    refreshUI()
end

-------------------------------------------------------------------------------
-- 6. /SpeakY -> Toggle Yell Checkbox channel
-------------------------------------------------------------------------------
SLASH_ICSL_SPEAKY1 = "/SpeakY"
SLASH_ICSL_SPEAKY2 = "/speaky"
SLASH_ICSL_SPEAKY3 = "/SPEAKY"
SlashCmdList["ICSL_SPEAKY"] = function()
    local db = getDB()
    db.channels.yell = not db.channels.yell
    printMsg((getL().CMD_SPEAKY_MSG or "Yell Channel: ") .. getStateStr(db.channels.yell))
    refreshUI()
end

-------------------------------------------------------------------------------
-- 7. /IAmDM -> Toggle Dungeon Master Checkbox
-------------------------------------------------------------------------------
SLASH_ICSL_IAMDM1 = "/IAmDM"
SLASH_ICSL_IAMDM2 = "/iamdm"
SLASH_ICSL_IAMDM3 = "/IAMDM"
SlashCmdList["ICSL_IAMDM"] = function()
    if Engine and Engine.CanUseDungeonMaster and not Engine.CanUseDungeonMaster() then
        printMsg("|cffff5555Only party or raid leaders can use Dungeon Master mode.|r")
        refreshUI()
        return
    end
    local db = getDB()
    db.dungeonMaster = not db.dungeonMaster
    if addon.UI and addon.UI.UpdateMainButtonVisual then
        addon.UI.UpdateMainButtonVisual()
    end
    printMsg((getL().CMD_IAMDM_MSG or "Dungeon Master: ") .. getStateStr(db.dungeonMaster))
    refreshUI()
end

-------------------------------------------------------------------------------
-- 8. /ISpeak -> Toggle Active Language Parse checkbox
-------------------------------------------------------------------------------
SLASH_ICSL_ISPEAK1 = "/ISpeak"
SLASH_ICSL_ISPEAK2 = "/ispeak"
SLASH_ICSL_ISPEAK3 = "/ISPEAK"
SlashCmdList["ICSL_ISPEAK"] = function()
    local db = getDB()
    db.enabled = not db.enabled
    printMsg((getL().CMD_ISPEAK_MSG or "Active Language Parse: ") .. getStateStr(db.enabled))
    refreshUI()
    if addon.UI and addon.UI.UpdateMainButtonVisual then
        addon.UI.UpdateMainButtonVisual()
    end
end

-------------------------------------------------------------------------------
-- 9. /ICanSpeak [langName] -> Save a language
-------------------------------------------------------------------------------
SLASH_ICSL_ICANSPEAK1 = "/ICanSpeak"
SLASH_ICSL_ICANSPEAK2 = "/icanspeak"
SLASH_ICSL_ICANSPEAK3 = "/ICANSPEAK"
SlashCmdList["ICSL_ICANSPEAK"] = function(msg)
    local langInput = msg and msg:match("^%s*(.-)%s*$")
    if not langInput or langInput == "" then
        printMsg(getL().CMD_ICANSPEAK_USAGE or "Usage: /ICanSpeak [langName]")
        return
    end

    local matchedLang = findMatchingLanguage(langInput)
    if not matchedLang then
        printMsg(getL().CMD_ICANSPEAK_NOT_EXISTS or "|cffff5555That Language Does Not Exists. See /WhatCanISpeak to see all availible languages|r")
        return
    end

    local db = getDB()
    local isSaved = false
    for _, saved in ipairs(db.savedLanguages) do
        if saved:lower() == matchedLang:lower() then
            isSaved = true
            break
        end
    end

    if not isSaved then
        table.insert(db.savedLanguages, matchedLang)
        local displayName = (Utils and Utils.GetLanguageDisplayName) and Utils.GetLanguageDisplayName(matchedLang) or matchedLang
        printMsg((getL().CMD_ICANSPEAK_LEARNED or "Learned language: ") .. "|cff33ff99" .. displayName .. "|r")
    else
        local displayName = (Utils and Utils.GetLanguageDisplayName) and Utils.GetLanguageDisplayName(matchedLang) or matchedLang
        printMsg((getL().CMD_ICANSPEAK_KNOWN or "You already know: ") .. "|cff33ff99" .. displayName .. "|r")
    end

    if Engine and Engine.BroadcastSpokenLanguage then
        Engine.BroadcastSpokenLanguage()
    end
    refreshUI()
end

-------------------------------------------------------------------------------
-- 10. /IcannotSpeak [langName] -> Remove saved language
-------------------------------------------------------------------------------
SLASH_ICSL_ICANNOTSPEAK1 = "/IcannotSpeak"
SLASH_ICSL_ICANNOTSPEAK2 = "/icannotspeak"
SLASH_ICSL_ICANNOTSPEAK3 = "/ICANNOTSPEAK"
SlashCmdList["ICSL_ICANNOTSPEAK"] = function(msg)
    local langInput = msg and msg:match("^%s*(.-)%s*$")
    if not langInput or langInput == "" then
        printMsg(getL().CMD_ICANNOTSPEAK_USAGE or "Usage: /IcannotSpeak [langName]")
        return
    end

    local db = getDB()
    local foundIdx = nil
    local removedName = nil

    for idx, saved in ipairs(db.savedLanguages) do
        local cleanSaved = saved:lower():gsub("[%s%-%']", "")
        local cleanInput = langInput:lower():gsub("[%s%-%']", "")
        if cleanSaved == cleanInput then
            foundIdx = idx
            removedName = saved
            break
        end
    end

    if not foundIdx then
        printMsg(getL().CMD_ICANNOTSPEAK_NOT_EXISTS or "|cffff5555That Language Does Not Exists. See /WhatISpeak to see your saved Languages|r")
        return
    end

    table.remove(db.savedLanguages, foundIdx)
    if db.selectedLanguage and db.selectedLanguage:lower() == removedName:lower() then
        db.selectedLanguage = db.savedLanguages[1] or "Common"
    end

    local displayName = (Utils and Utils.GetLanguageDisplayName) and Utils.GetLanguageDisplayName(removedName) or removedName
    printMsg((getL().CMD_ICANNOTSPEAK_REMOVED or "Removed language: ") .. "|cffff5555" .. displayName .. "|r")

    if Engine and Engine.BroadcastSpokenLanguage then
        Engine.BroadcastSpokenLanguage()
    end
    refreshUI()
end

-------------------------------------------------------------------------------
-- 11. /WhatCanISpeak -> Show available languages to learn
-------------------------------------------------------------------------------
SLASH_ICSL_WHATCANISPEAK1 = "/WhatCanISpeak"
SLASH_ICSL_WHATCANISPEAK2 = "/whatcanispeak"
SLASH_ICSL_WHATCANISPEAK3 = "/WHATCANISPEAK"
SlashCmdList["ICSL_WHATCANISPEAK"] = function()
    local db = getDB()
    local savedSet = {}
    for _, lang in ipairs(db.savedLanguages) do
        savedSet[lang:lower()] = true
    end

    local allLangs = getAllLanguages()
    local available = {}

    for _, lang in ipairs(allLangs) do
        if not savedSet[lang:lower()] then
            local displayText = (Utils and Utils.GetLanguageDisplayWithAlias) and Utils.GetLanguageDisplayWithAlias(lang) or lang
            table.insert(available, displayText)
        end
    end

    if #available == 0 then
        printMsg(getL().CMD_WHATCANISPEAK_ALL or "You have learned all available languages!")
    else
        printMsg((getL().CMD_WHATCANISPEAK_LIST or "Available languages to learn: ") .. "|cff33ff99" .. table.concat(available, ", ") .. "|r")
    end
end

-------------------------------------------------------------------------------
-- 12. /WhatISpeak -> Show saved languages
-------------------------------------------------------------------------------
SLASH_ICSL_WHATISPEAK1 = "/WhatISpeak"
SLASH_ICSL_WHATISPEAK2 = "/whatispeak"
SLASH_ICSL_WHATISPEAK3 = "/WHATISPEAK"
SlashCmdList["ICSL_WHATISPEAK"] = function()
    local db = getDB()
    if not db.savedLanguages or #db.savedLanguages == 0 then
        printMsg(getL().CMD_WHATISPEAK_NONE or "You currently do not have any saved languages.")
    else
        local formatted = {}
        for _, lang in ipairs(db.savedLanguages) do
            local displayText = (Utils and Utils.GetLanguageDisplayWithAlias) and Utils.GetLanguageDisplayWithAlias(lang) or lang
            table.insert(formatted, displayText)
        end
        printMsg((getL().CMD_WHATISPEAK_LIST or "Your saved languages: ") .. "|cff33ff99" .. table.concat(formatted, ", ") .. "|r")
    end
end

-------------------------------------------------------------------------------
-- 13. /ShowLangName -> Toggle checkbox "Mostrar idioma en el chat"
-------------------------------------------------------------------------------
SLASH_ICSL_SHOWLANGNAME1 = "/ShowLangName"
SLASH_ICSL_SHOWLANGNAME2 = "/showlangname"
SLASH_ICSL_SHOWLANGNAME3 = "/SHOWLANGNAME"
SlashCmdList["ICSL_SHOWLANGNAME"] = function()
    local db = getDB()
    if db.showLanguageInChat == nil then
        db.showLanguageInChat = true
    end
    db.showLanguageInChat = not db.showLanguageInChat
    printMsg((getL().CMD_SHOWLANGNAME_MSG or "Mostrar Idioma en Chat: ") .. getStateStr(db.showLanguageInChat))
    refreshUI()
end

-------------------------------------------------------------------------------
-- 14. /ISpeakHelp -> Show in chat all commands and what they do
-------------------------------------------------------------------------------
SLASH_ICSL_ISPEAKHELP1 = "/ISpeakHelp"
SLASH_ICSL_ISPEAKHELP2 = "/ispeakhelp"
SLASH_ICSL_ISPEAKHELP3 = "/ISPEAKHELP"
SlashCmdList["ICSL_ISPEAKHELP"] = function()
    local L = getL()
    printMsg(L.CMD_HELP_HEADER or "|cff33ff99=== ICanSpeakLanguages Slash Commands ===|r")
    DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99/SpeakP|r" .. (L.HELP_SPEAKP or " - Toggle Party channel parse"))
    DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99/SpeakR|r" .. (L.HELP_SPEAKR or " - Toggle Raid channel parse"))
    DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99/SpeakRW|r" .. (L.HELP_SPEAKRW or " - Toggle Raid Warning channel parse"))
    DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99/SpeakW|r" .. (L.HELP_SPEAKW or " - Toggle Whisper channel parse"))
    DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99/SpeakS|r" .. (L.HELP_SPEAKS or " - Toggle Say channel parse"))
    DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99/SpeakY|r" .. (L.HELP_SPEAKY or " - Toggle Yell channel parse"))
    DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99/IAmDM|r" .. (L.HELP_IAMDM or " - Toggle Dungeon Master mode"))
    DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99/ISpeak|r" .. (L.HELP_ISPEAK or " - Toggle Active Language Parse"))
    DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99/ICanSpeak [langName]|r" .. (L.HELP_ICANSPEAK or " - Learn/save a language"))
    DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99/IcannotSpeak [langName]|r" .. (L.HELP_ICANNOTSPEAK or " - Remove a saved language"))
    DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99/WhatCanISpeak|r" .. (L.HELP_WHATCANISPEAK or " - List all available languages to learn"))
    DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99/WhatISpeak|r" .. (L.HELP_WHATISPEAK or " - List your saved languages"))
    DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99/ShowLangName|r" .. (L.HELP_SHOWLANGNAME or " - Toggle showing language name tag"))
    DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99/SpeakDa [text]|r" .. (L.HELP_SPEAKDA or " - Hash text to Darnassian VSO sentence"))
    DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99/HowToSpeak|r" .. (L.HELP_HOWTOSPEAK or " - Show guide on language syntax, inline tags & mismatch warnings"))
    DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99/ISpeakHelp|r" .. (L.HELP_ISPEAKHELP or " - Show this command list"))
end

-------------------------------------------------------------------------------
-- 16. /SpeakDa [text] -> Convert text to Darnassian sentence using HashToDarnassian
-------------------------------------------------------------------------------
SLASH_ICSL_SPEAKDA1 = "/SpeakDa"
SLASH_ICSL_SPEAKDA2 = "/speakda"
SLASH_ICSL_SPEAKDA3 = "/SPEAKDA"
SlashCmdList["ICSL_SPEAKDA"] = function(msg)
    local input = msg and msg:match("^%s*(.-)%s*$")
    if not input or input == "" then
        printMsg(getL().CMD_SPEAKDA_USAGE or "Usage: /SpeakDa [text]")
        return
    end

    local Hasher = addon.DarnassianHasher or _G.DarnassianHasher
    if not Hasher or not Hasher.HashToDarnassian then
        printMsg("|cffff5555Darnassian Hasher module is not available.|r")
        return
    end

    local darnassianSentence = Hasher.HashToDarnassian(input)
    printMsg("|cff33ff99Darnassian:|r " .. darnassianSentence)
end

-------------------------------------------------------------------------------
-- 15. /HowToSpeak -> Syntax manual, language setting, examples & mismatch errors
-------------------------------------------------------------------------------
SLASH_ICSL_HOWTOSPEAK1 = "/HowToSpeak"
SLASH_ICSL_HOWTOSPEAK2 = "/howtospeak"
SLASH_ICSL_HOWTOSPEAK3 = "/HOWTOSPEAK"
SlashCmdList["ICSL_HOWTOSPEAK"] = function()
    local L = getL()
    printMsg(L.MANUAL_HEADER or "|cff33ff99=== ICanSpeakLanguages: How To Speak Manual ===|r")
    DEFAULT_CHAT_FRAME:AddMessage(L.MANUAL_SEC1_TITLE or "|cffffcc001. Setting your active language:|r")
    DEFAULT_CHAT_FRAME:AddMessage(L.MANUAL_SEC1_ITEM1 or "  - Select a language in the |cff33ff99MainButton menu|r or |cff33ff99Interface Frame|r.")
    DEFAULT_CHAT_FRAME:AddMessage(L.MANUAL_SEC1_ITEM2 or "  - Learn languages first with |cff33ff99/ICanSpeak [LanguageName]|r.")
    DEFAULT_CHAT_FRAME:AddMessage(L.MANUAL_SEC2_TITLE or "|cffffcc002. Inline Language Syntax:|r")
    DEFAULT_CHAT_FRAME:AddMessage(L.MANUAL_SEC2_ITEM1 or "  - Type |cff33ff99[LanguageName]|r or |cff33ff99[Alias]|r at the start of your chat message.")
    DEFAULT_CHAT_FRAME:AddMessage(L.MANUAL_SEC3_TITLE or "|cffffcc003. Examples:|r")
    DEFAULT_CHAT_FRAME:AddMessage(L.MANUAL_SEC3_ITEM1 or "  - |cff33ff99[Vrykul] Greetings warrior, welcome to Northrend!|r")
    DEFAULT_CHAT_FRAME:AddMessage(L.MANUAL_SEC3_ITEM2 or "  - |cff33ff99[Draenei] Paktuul Ishnu!|r")
    DEFAULT_CHAT_FRAME:AddMessage(L.MANUAL_SEC3_ITEM3 or "  - |cff33ff99[VR] Prepare for glory!|r (Using language alias)")
    DEFAULT_CHAT_FRAME:AddMessage(L.MANUAL_SEC4_TITLE or "|cffffcc004. Mismatched Language Errors:|r")
    DEFAULT_CHAT_FRAME:AddMessage(L.MANUAL_SEC4_ITEM1 or "  - If you type a tag for a language you haven't saved (e.g., |cffff5555[Orcish]|r when unlearned),")
    DEFAULT_CHAT_FRAME:AddMessage(L.MANUAL_SEC4_ITEM2 or "    you will see: |cffff5555\"The language you typed does not match any you know. Using: Common\"|r")
    DEFAULT_CHAT_FRAME:AddMessage(L.MANUAL_SEC4_ITEM3 or "    and your default selected language will be used as fallback.")
end
