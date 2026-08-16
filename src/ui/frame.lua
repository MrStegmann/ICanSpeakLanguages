local addonName, addon = ...

addon.UI = {}
local UI = addon.UI
local Utils = addon.Utils

function UI.Toggle()
    local targetFrame = ICanSpeakLanguagesMainFrame or ICanSpeakLanguagesFrame
    if targetFrame then
        if targetFrame:IsShown() then
            targetFrame:Hide()
        else
            targetFrame:Show()
        end
    end
end

-- Slash commands registration
SLASH_ICANSPEAKLANGUAGES1 = "/icsl"
SLASH_ICANSPEAKLANGUAGES2 = "/icanspeak"

SlashCmdList["ICANSPEAKLANGUAGES"] = function(msg)
    local cmd = Utils.Trim(msg):lower()
    if cmd == "toggle" or cmd == "" then
        UI.Toggle()
    else
        Utils.Print("Usage: /icsl or /icanspeak to toggle UI frame.")
    end
end
