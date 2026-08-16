local addonName, addon = ...
local pcall = pcall
local ChatFrame_AddMessageEventFilter = ChatFrame_AddMessageEventFilter
local UnitName = UnitName

addon.Channels = addon.Channels or {}
local Channels = addon.Channels
local RegExp = addon.RegExp
local Language = addon.Language
local Validators = addon.Validators
local Text = addon.Text
local Broadcast = addon.Broadcast

Channels.originalSendChatMessage = _G.SendChatMessage
Channels.isSendingHookedMessage = false

Channels.lastMessageTick = 0
Channels.lastCmdPrefix = ""
Channels.lastSpokenLang = ""

function Channels.hookedSendChatMessage(text, chatType, languageID, target, ...)
    if Channels.isSendingHookedMessage or not Channels.originalSendChatMessage then
        if Channels.originalSendChatMessage then
            return Channels.originalSendChatMessage(text, chatType, languageID, target, ...)
        end
        return
    end

    local currentTick = GetTime()
    if currentTick == Channels.lastMessageTick and Channels.lastCmdPrefix ~= "" then
        -- This message was fired in the exact same tick. It is a continuation chunk from the Blizzard client's native >255 string splitter (or UCM).
        if not text:find(RegExp.NPC_SAY) and not text:find(RegExp.NPC_YELL) and not text:find(RegExp.CMD_IGNORE) then
            -- We must NOT prepend the command prefix here! Epsilon server natively concatenates these raw chunks.
            -- If we mutate it, we ruin the server's concatenation. Send it completely unmodified!
            Channels.isSendingHookedMessage = true
            local success, err = pcall(Channels.originalSendChatMessage, text, chatType, languageID, target, ...)
            Channels.isSendingHookedMessage = false
            return
        end
    end

    local isNpcSay = text and text:find(RegExp.NPC_SAY)
    local isNpcYell = text and text:find(RegExp.NPC_YELL)
    local spokenLang
    local formattedText = text

    if isNpcSay or isNpcYell then
        local cmdPrefix, payload
        if isNpcSay then
            cmdPrefix, payload = text:match(RegExp.NPC_SAY_CAPTURE)
        else
            cmdPrefix, payload = text:match(RegExp.NPC_YELL_CAPTURE)
        end

        if payload and payload ~= "" then
            local tagMatch = payload:match(RegExp.TAG_CAPTURE)
            if tagMatch then
                spokenLang = Language.ResolveLanguageTag(tagMatch)
                if spokenLang then
                    local cleanPayload = payload:gsub("^" .. RegExp.TAG_PATTERN, "")
                    formattedText = cmdPrefix .. "[" .. spokenLang .. "] " .. cleanPayload
                    Broadcast.BroadcastCapabilities()
                    
                    -- Save state for immediate continuation chunks
                    Channels.lastMessageTick = currentTick
                    Channels.lastCmdPrefix = cmdPrefix
                    Channels.lastSpokenLang = spokenLang
                end
            end
        end
    else
        if text and text:find(RegExp.CMD_IGNORE) then
            return Channels.originalSendChatMessage(text, chatType, languageID, target, ...)
        end

        if not Validators.IsChannelEnabled(chatType) then
            return Channels.originalSendChatMessage(text, chatType, languageID, target, ...)
        end

        local db = ICanSpeakLanguagesDB
        if db and db.enabled ~= false then
            spokenLang = Language.GetLanguageTyped(text)
            local cleanText = text:gsub(RegExp.TAG_PATTERN, "")

            local colonIdx = cleanText:find(":%s")
            if colonIdx then
                local beforeColon = cleanText:sub(1, colonIdx)
                local afterColon = cleanText:sub(colonIdx + 1)
                formattedText = beforeColon .. " [" .. spokenLang .. "] " .. (addon.Utils and addon.Utils.Trim and addon.Utils.Trim(afterColon) or afterColon)
            else
                formattedText = "[" .. spokenLang .. "] " .. cleanText
            end

            Broadcast.BroadcastCapabilities()
        end
    end

    if formattedText and string.len(formattedText) > 255 and addon.ChatSplitter then
        local chunks = addon.ChatSplitter.SplitLanguageMessage(formattedText, spokenLang or "Common")
        Channels.isSendingHookedMessage = true
        
        for i = 1, #chunks do
            local chunk = chunks[i]
            Channels.originalSendChatMessage(chunk, chatType, languageID, target, ...)
        end
        
        Channels.isSendingHookedMessage = false
        return
    end

    Channels.isSendingHookedMessage = true
    local success, err = pcall(Channels.originalSendChatMessage, formattedText, chatType, languageID, target, ...)
    Channels.isSendingHookedMessage = false

    if not success then
        Channels.originalSendChatMessage(formattedText, chatType, languageID, target, ...)
    end
end

if _G.SendChatMessage then
    _G.SendChatMessage = Channels.hookedSendChatMessage
end

function Channels.parseChatMessage(self, event, msg, sender, ...)
    if not msg or msg == "" then return false, msg, sender, ... end

    if msg:find(RegExp.CMD_IGNORE) then
        return false, msg, sender, ...
    end

    if not Validators.IsChannelEnabled(event) then
        return false, msg, sender, ...
    end

    local db = ICanSpeakLanguagesDB
    if db and db.enabled == false then
        return false, msg, sender, ...
    end

    local senderShort = sender and sender:match("^([^%-]+)") or sender
    local playerShort = UnitName("player")

    if senderShort and playerShort and senderShort == playerShort then
        local strip = db and db.showLanguageInChat == false
        msg = Text.FormatLanguageTag(msg, strip)
        return false, msg, sender, ...
    end

    local spokenLangTag = msg:match("%[([^%]]+)%]")
    local spokenLang = nil
    if spokenLangTag then
        spokenLang = Language.ResolveLanguageTag(spokenLangTag)
    end

    if not spokenLang and senderShort then
        spokenLang = Broadcast.writerSpeaking[senderShort]
    end

    if not spokenLang or spokenLang == "" then
        return false, msg, sender, ...
    end

    local stripTag = db and db.showLanguageInChat == false

    if Validators.IsDungeonMasterActive() then
        if stripTag then
            msg = msg:gsub(RegExp.TAG_PATTERN, "")
        else
            local searchTag = "[" .. spokenLang .. "]"
            if not msg:find(searchTag, 1, true) and not msg:find("^" .. RegExp.TAG_PATTERN) then
                msg = "|cff33ff99[" .. spokenLang .. "]|r " .. msg
            else
                msg = Text.FormatLanguageTag(msg, false)
            end
        end
        return false, msg, sender, ...
    end

    if Language.HasLanguageSaved(spokenLang) then
        msg = Text.FormatLanguageTag(msg, stripTag)
        return false, msg, sender, ...
    end

    local prefix, bodyToParse = Text.ExtractLanguageTag(msg, spokenLang)
    prefix = Text.FormatLanguageTag(prefix, stripTag)

    local EMOTE_BUFFER = {}
    local emoteIndex = 1
    local function maskEmotes(match)
        local placeholder = "#@" .. string.rep("=", emoteIndex) .. "@#"
        EMOTE_BUFFER[placeholder] = match
        emoteIndex = emoteIndex + 1
        return placeholder
    end

    -- Mask asterisks and OOC brackets so the language hashers ignore them
    bodyToParse = bodyToParse:gsub("(%*.-%*)", maskEmotes)
    bodyToParse = bodyToParse:gsub("(<.->)", maskEmotes)

    local parser = Language.GetParser(spokenLang)
    local translatedText = bodyToParse
    if parser and parser.Translate then
        translatedText = parser:Translate(bodyToParse)
    end

    -- Unmask preserved text. Must escape '%' in original text to prevent gsub substitution errors.
    for placeholder, original in pairs(EMOTE_BUFFER) do
        local safeOriginal = original:gsub("%%", "%%%%")
        translatedText = translatedText:gsub(placeholder, safeOriginal)
    end

    local finalMsg = prefix .. translatedText
    return false, finalMsg, sender, ...
end

for _, eventName in ipairs(addon.Constants.CHAT_EVENTS) do
    ChatFrame_AddMessageEventFilter(eventName, Channels.parseChatMessage)
end
