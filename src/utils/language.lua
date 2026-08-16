local addonName, addon = ...
local type, pairs, ipairs = type, pairs, ipairs

addon.Language = addon.Language or {}
local Language = addon.Language
local Constants = addon.Constants

function Language.GetParser(langName)
    local genericHasher = addon.GenericHasher or _G.GenericHasher
    local genericFallback = {
        Translate = function(self, text)
            if genericHasher and genericHasher.ProcessText then
                return genericHasher.ProcessText(text)
            end
            return text
        end
    }

    if not langName or langName == "" then return genericFallback end
    
    -- Resolve alias to formal name (e.g., Darnassae -> Darnassian)
    local resolvedName = Language.ResolveLanguageTag(langName)
    if not resolvedName then
        resolvedName = langName:gsub("[%s%-%']", "")
    end

    -- Title Case for Hasher lookup
    local capitalizedName = resolvedName:sub(1,1):upper() .. resolvedName:sub(2):lower()
    
    local Hasher = addon[capitalizedName .. "Hasher"] or _G[capitalizedName .. "Hasher"]
    if Hasher and Hasher.ProcessText then
        return { Translate = function(self, text) return Hasher.ProcessText(text) end }
    end

    return genericFallback
end

function Language.HasLanguageSaved(langName)
    if not langName or langName == "" then return false end
    local db = ICanSpeakLanguagesDB
    if not db or not db.savedLanguages then return false end

    local cleanTarget = langName:lower():gsub("[%s%-%']", "")
    for _, saved in ipairs(db.savedLanguages) do
        if type(saved) == "string" then
            if saved:lower():gsub("[%s%-%']", "") == cleanTarget then
                return true
            end
        end
    end
    return false
end

function Language.GetLanguageAlias(langName)
    local langData = addon.Languages or (addon.Engine and addon.Engine.Languages) or _G.wowLanguages
    if not langData then return nil end

    local cleanTarget = langName:lower():gsub("[%s%-%']", "")
    local function checkGroup(group)
        if type(group) == "table" then
            for _, item in ipairs(group) do
                if item.name and item.name:lower():gsub("[%s%-%']", "") == cleanTarget then
                    return item.alias
                end
            end
        end
        return nil
    end

    if langData.factionLanguages then
        for _, group in pairs(langData.factionLanguages) do
            local alias = checkGroup(group)
            if alias then return alias end
        end
    end
    
    local alias = checkGroup(langData.ancientAndCosmic)
    if alias then return alias end
    
    alias = checkGroup(langData.elemental)
    if alias then return alias end
    
    alias = checkGroup(langData.mortalRacesAndSpecies)
    if alias then return alias end

    return nil
end

function Language.ResolveLanguageTag(tag)
    if not tag or tag == "" then return nil end
    local cleanTag = tag:lower():gsub("[%s%-%']", "")

    local db = ICanSpeakLanguagesDB
    local savedLangs = (db and db.savedLanguages) or {}
    for _, saved in ipairs(savedLangs) do
        if type(saved) == "string" then
            local cleanSaved = saved:lower():gsub("[%s%-%']", "")
            if cleanSaved == cleanTag then return saved end
            local alias = Language.GetLanguageAlias(saved)
            if alias and alias:lower():gsub("[%s%-%']", "") == cleanTag then
                return saved
            end
        end
    end

    local langData = addon.Languages or (addon.Engine and addon.Engine.Languages) or _G.wowLanguages
    if langData then
        local function checkGroup(group)
            if type(group) == "table" then
                for _, item in ipairs(group) do
                    if item.name then
                        local cleanName = item.name:lower():gsub("[%s%-%']", "")
                        if cleanName == cleanTag then return item.name end
                        if item.alias and item.alias:lower():gsub("[%s%-%']", "") == cleanTag then return item.name end
                    end
                end
            end
            return nil
        end

        if langData.factionLanguages then
            for _, group in pairs(langData.factionLanguages) do
                local found = checkGroup(group)
                if found then return found end
            end
        end
        local found = checkGroup(langData.ancientAndCosmic)
        if found then return found end
        found = checkGroup(langData.elemental)
        if found then return found end
        found = checkGroup(langData.mortalRacesAndSpecies)
        if found then return found end
        found = checkGroup(langData.rpgAndObsolete)
        if found then return found end
    end

    return nil
end

function Language.GetLanguageTyped(text)
    local db = ICanSpeakLanguagesDB
    local selectedLang = (db and db.selectedLanguage) or "Common"
    local savedLangs = (db and db.savedLanguages) or {}

    if not text or text == "" then return selectedLang end

    local capturedTag = text:match(addon.RegExp.TAG_CAPTURE)
    if not capturedTag then return selectedLang end

    capturedTag = capturedTag:match("^%s*(.-)%s*$")
    local cleanCaptured = capturedTag:lower():gsub("[%s%-%']", "")

    for _, saved in ipairs(savedLangs) do
        if type(saved) == "string" then
            local cleanSaved = saved:lower():gsub("[%s%-%']", "")
            if cleanSaved == cleanCaptured then
                return saved
            end
            
            local alias = Language.GetLanguageAlias(saved)
            if alias and alias:lower() == cleanCaptured then
                return saved
            end
        end
    end

    local L = addon.L or {}
    local msgPrefix = L.TYPED_LANG_MISMATCH or "The language you typed does not match any you know. Using: "
    if addon.Utils and addon.Utils.Print then
        addon.Utils.Print(msgPrefix .. selectedLang)
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99[ICanSpeakLanguages]|r " .. msgPrefix .. selectedLang)
    end

    return selectedLang
end
