local addonName, addon = ...

addon.Utils = {}
local Utils = addon.Utils

-- Print message with addon prefix
function Utils.Print(msg)
    print("|cff33ff99[" .. addonName .. "]|r " .. tostring(msg))
end

-- String trim helper
function Utils.Trim(s)
    if not s then return "" end
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

-- Split string into words by whitespace
function Utils.SplitWords(text)
    local words = {}
    if not text then return words end
    for word in text:gmatch("%S+") do
        table.insert(words, word)
    end
    return words
end

-- Deep copy table helper
function Utils.CopyTable(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = Utils.CopyTable(orig_value)
        end
    else
        copy = orig
    end
    return copy
end

-- Get language alias helper
function Utils.GetLanguageAlias(langName)
    if not langName or langName == "" then return nil end
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

    alias = checkGroup(langData.rpgAndObsolete)
    if alias then return alias end

    return nil
end

-- Get localized language display name helper
function Utils.GetLanguageDisplayName(langName)
    if not langName or langName == "" then return "" end
    local L = addon.L or {}
    local langKey = "LANG_" .. langName
    if L[langKey] then
        return L[langKey]
    end
    return langName
end

-- Get localized language display name with alias helper
function Utils.GetLanguageDisplayWithAlias(langName)
    if not langName or langName == "" then return "" end
    local displayName = Utils.GetLanguageDisplayName(langName)
    local alias = Utils.GetLanguageAlias(langName)
    if alias then
        return displayName .. " (" .. alias:lower() .. ")"
    end
    return displayName
end
