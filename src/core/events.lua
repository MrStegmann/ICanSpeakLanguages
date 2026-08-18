local addonName, addon = ...
local CreateFrame, C_ChatInfo, C_ChatBubbles = CreateFrame, C_ChatInfo, C_ChatBubbles

local Events = {}
addon.Events = Events

local Constants = addon.Constants
local Broadcast = addon.Broadcast
local RegExp = addon.RegExp
local Validators = addon.Validators
local Language = addon.Language
local Text = addon.Text

if C_ChatInfo and C_ChatInfo.RegisterAddonMessagePrefix then
    C_ChatInfo.RegisterAddonMessagePrefix(Constants.ADDON_PREFIX)
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("CHAT_MSG_ADDON")

eventFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local loadedAddonName = ...
        if loadedAddonName == addonName then
            ICanSpeakLanguagesDB = ICanSpeakLanguagesDB or {}
            ICanSpeakLanguagesDB.channels = ICanSpeakLanguagesDB.channels or addon.Config.DEFAULT_CHANNELS
            
            if addon.Engine then
                addon.Engine.db = ICanSpeakLanguagesDB
            end
            
            if addon.Utils and addon.Utils.Print then
                addon.Utils.Print("I Can Speak Languages loaded. Type /ISpeakHelp to see all commands.")
            end
        end
    elseif event == "CHAT_MSG_ADDON" then
        local prefix, message, _channel, sender = ...
        if prefix == Constants.ADDON_PREFIX and message and sender then
            local senderShort = sender:match("^([^%-]+)") or sender
            if message:find("^SPEAKING:") then
                local lang = message:sub(10)
                if lang and lang ~= "" then
                    Broadcast.writerSpeaking[senderShort] = lang
                end
            elseif message:find("^LANGS:") then
                local langsStr = message:sub(7)
                Broadcast.activeReceivers[senderShort] = Broadcast.activeReceivers[senderShort] or {}
                for lang in langsStr:gmatch("[^,]+") do
                    Broadcast.activeReceivers[senderShort][lang] = true
                end
            end
        end
    end
end)

-- Chat Bubble Scanner
if C_ChatBubbles and C_ChatBubbles.GetAllChatBubbles then
    local bubbleFrame = CreateFrame("Frame")
    local updateTimer = 0

    bubbleFrame:SetScript("OnUpdate", function(self, elapsed)
        updateTimer = updateTimer + elapsed
        if updateTimer < 0.1 then return end
        updateTimer = 0

        local db = ICanSpeakLanguagesDB
        if db and db.enabled == false then return end

        local bubbles = C_ChatBubbles.GetAllChatBubbles()
        for _, bubble in ipairs(bubbles) do
            if not bubble:IsForbidden() then
                local fontString = nil
                for i = 1, bubble:GetNumRegions() do
                    local region = select(i, bubble:GetRegions())
                    if region and region:GetObjectType() == "FontString" then
                        fontString = region
                        break
                    end
                end

                if fontString then
                    local text = fontString:GetText()
                    if text and text ~= "" and text ~= bubble.icslLastParsedText then
                        local tagStart, tagEnd, spokenLang = text:find("%[([^%]]+)%]")
                        
                        if spokenLang and spokenLang ~= "" then
                            local needsParsing = false
                            if not Validators.IsDungeonMasterActive() and not Language.HasLanguageSaved(spokenLang) then
                                needsParsing = true
                            end
                            
                            local stripTag = (db and db.showLanguageInChat == false)

                            local prefix, bodyToParse = Text.ExtractLanguageTag(text, spokenLang)
                            prefix = Text.FormatLanguageTag(prefix, stripTag)

                            local translatedText = bodyToParse
                            if needsParsing then
                                local parseFn = ParseLanguage or (addon.Utils and addon.Utils.ParseLanguage)
                                if parseFn then
                                    translatedText = parseFn(spokenLang, bodyToParse)
                                end
                            end

                            local finalMsg = prefix .. translatedText
                            fontString:SetText(finalMsg)
                            bubble.icslLastParsedText = finalMsg
                        else
                            bubble.icslLastParsedText = text
                        end
                    end
                end
            end
        end
    end)
end
