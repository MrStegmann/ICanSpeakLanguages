local addonName, addon = ...

addon.Locales = addon.Locales or {}
addon.L = addon.L or {}
local L = addon.L

local function getSavedLocale()
    if ICanSpeakLanguagesDB and ICanSpeakLanguagesDB.uiLocale then
        return ICanSpeakLanguagesDB.uiLocale
    end
    local sysLocale = _G.GetLocale and _G.GetLocale()
    if sysLocale == "esES" or sysLocale == "esMX" then
        return "es_ES"
    end
    return "en_EN"
end

function addon.SetLocale(localeCode)
    localeCode = (localeCode == "es_ES" or localeCode == "esES") and "es_ES" or "en_EN"
    
    if ICanSpeakLanguagesDB then
        ICanSpeakLanguagesDB.uiLocale = localeCode
    end

    local dict = addon.Locales[localeCode] or addon.Locales["es_ES"] or addon.Locales["en_EN"]
    if dict then
        for k in pairs(L) do
            L[k] = nil
        end
        for k, v in pairs(dict) do
            L[k] = v
        end
    end
end

function addon.GetText(key)
    return L[key] or key
end

-- Fallback metatable so L["KEY"] returns key if not found
setmetatable(L, {
    __index = function(_, k)
        return k
    end
})

-- Initialize Locales table when addon loads
local frame = _G.CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 ~= addonName then return end
    local locale = getSavedLocale()
    addon.SetLocale(locale)
    if event == "PLAYER_LOGIN" then
        if addon.Utils and addon.Utils.Print then
            addon.Utils.Print(L.ADDON_LOADED_MSG or "ICanSpeakLanguages loaded. Use /ISpeakHelp to see all commands.")
        end
    end
    self:UnunregisterEvent("ADDON_LOADED")
    self:UnunregisterEvent("PLAYER_LOGIN")
end)
