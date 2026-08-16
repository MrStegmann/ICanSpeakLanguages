local addonName, addon = ...
addon.ChatSplitter = addon.ChatSplitter or {}
local ChatSplitter = addon.ChatSplitter

-- Local caching for GC optimization
local string, table, pairs = string, table, pairs
local strsub, strlen, strfind, gsub, gmatch, strrep = string.sub, string.len, string.find, string.gsub, string.gmatch, string.rep
local tinsert, wipe = table.insert, table.wipe

-- Zero-GC static buffers
local CHUNK_BUFFER = {}
local LINK_BUFFER = {}

local NUM_CHAT_WINDOWS = NUM_CHAT_WINDOWS or 10
local MAX_CHUNK_LEN = 245

-------------------------------------------------------------------------------
-- 1. EditBox Limit Bypassing
-------------------------------------------------------------------------------
function ChatSplitter.EnableEditBoxLimits()
    for i = 1, NUM_CHAT_WINDOWS do
        local editBox = _G["ChatFrame" .. i .. "EditBox"]
        if editBox then
            editBox:SetMaxLetters(0)
            editBox:SetMaxBytes(0)
            if editBox.SetVisibleTextByteLimit then
                editBox:SetVisibleTextByteLimit(0)
            end
        end
    end
end

if _G.ChatEdit_OnShow then
    hooksecurefunc("ChatEdit_OnShow", function(editBox)
        if editBox then
            local chatType = editBox:GetAttribute("chatType")
            if chatType == "BN_WHISPER" or chatType == "BN_CONVERSATION" then
                -- Restore defaults for battle.net which enforce 255 bytes strictly
                editBox:SetMaxLetters(255)
                editBox:SetMaxBytes(256)
                if editBox.SetVisibleTextByteLimit then
                    editBox:SetVisibleTextByteLimit(256)
                end
            else
                editBox:SetMaxLetters(0)
                editBox:SetMaxBytes(0)
                if editBox.SetVisibleTextByteLimit then
                    editBox:SetVisibleTextByteLimit(0)
                end
            end
        end
    end)
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event, ...)
    ChatSplitter.EnableEditBoxLimits()
end)

-------------------------------------------------------------------------------
-- 2. Emote and Quote Balancing
-------------------------------------------------------------------------------
-- Passes parity state from one chunk to the next to ensure emotes are closed
local function balanceTags(chunk, parityState)
    local function countOccurrences(str, pattern)
        local count = 0
        for _ in gmatch(str, pattern) do count = count + 1 end
        return count
    end
    
    local starCount = countOccurrences(chunk, "%*")
    local quoteCount = countOccurrences(chunk, '"')
    local leftBracketCount = countOccurrences(chunk, "<")
    local rightBracketCount = countOccurrences(chunk, ">")

    parityState.star = (parityState.star + starCount) % 2
    parityState.quote = (parityState.quote + quoteCount) % 2
    parityState.bracket = parityState.bracket + leftBracketCount - rightBracketCount

    local closing = ""
    local openingForNext = ""

    if parityState.star == 1 then
        closing = closing .. "*"
        openingForNext = openingForNext .. "*"
    end
    if parityState.quote == 1 then
        closing = closing .. '"'
        openingForNext = openingForNext .. '"'
    end
    if parityState.bracket > 0 then
        closing = closing .. string.rep(">", parityState.bracket)
        openingForNext = openingForNext .. string.rep("<", parityState.bracket)
    elseif parityState.bracket < 0 then
        closing = closing .. string.rep("<", -parityState.bracket)
        openingForNext = openingForNext .. string.rep(">", -parityState.bracket)
    end

    return chunk .. closing, openingForNext
end

-------------------------------------------------------------------------------
-- 3. Language-Aware Chunking Engine
-------------------------------------------------------------------------------
function ChatSplitter.SplitLanguageMessage(msg, spokenLang)
    wipe(CHUNK_BUFFER)
    wipe(LINK_BUFFER)

    -- Extract Prefix
    local fullPrefix, bodyToParse = addon.Text.ExtractLanguageTag(msg, spokenLang)
    if not fullPrefix then
        fullPrefix = ""
        bodyToParse = msg
    end
    -- Ensure space after prefix
    if fullPrefix ~= "" and not fullPrefix:match("%s$") then
        fullPrefix = fullPrefix .. " "
    end
    -- Trim leading spaces of the body
    bodyToParse = bodyToParse:gsub("^%s+", "")

    -- Mask Hyperlinks (Critically: the placeholder MUST match the original length)
    local linkIndex = 1
    bodyToParse = gsub(bodyToParse, "(|H.-|h.-|h)", function(match)
        local len = strlen(match)
        local basePlaceholder = "$L" .. linkIndex .. "$"
        -- Pad with 'X' to exact length so length math in chunking doesn't overflow WoW's 255 byte limit
        local placeholder = basePlaceholder .. strrep("X", len - strlen(basePlaceholder))
        
        LINK_BUFFER[placeholder] = match
        linkIndex = linkIndex + 1
        return placeholder
    end)

    local maxBodyLen = MAX_CHUNK_LEN - strlen(fullPrefix)
    
    local currentChunk = ""
    local parityState = { star = 0, quote = 0, bracket = 0 }
    local carryOverOpenings = ""

    -- Whitespace preserving iteration
    for word, space in gmatch(bodyToParse, "([^ ]+)( *)") do
        if carryOverOpenings ~= "" then
            word = carryOverOpenings .. word
            carryOverOpenings = ""
        end

        local addition = word .. space
        if strlen(currentChunk) + strlen(addition) <= maxBodyLen then
            currentChunk = currentChunk .. addition
        else
            if strlen(currentChunk) == 0 then
                -- Single word exceeds limit, hard slice it
                local part1 = strsub(addition, 1, maxBodyLen)
                local part2 = strsub(addition, maxBodyLen + 1)
                
                local finalizedChunk
                finalizedChunk, carryOverOpenings = balanceTags(part1, parityState)
                
                if #CHUNK_BUFFER == 0 then
                    tinsert(CHUNK_BUFFER, fullPrefix .. finalizedChunk)
                else
                    tinsert(CHUNK_BUFFER, finalizedChunk)
                end
                
                currentChunk = part2
            else
                local finalizedChunk
                finalizedChunk, carryOverOpenings = balanceTags(currentChunk, parityState)
                
                if #CHUNK_BUFFER == 0 then
                    tinsert(CHUNK_BUFFER, fullPrefix .. finalizedChunk)
                else
                    tinsert(CHUNK_BUFFER, finalizedChunk)
                end
                
                currentChunk = carryOverOpenings .. addition
                carryOverOpenings = ""
            end
        end
    end

    if strlen(currentChunk) > 0 then
        -- Finalize last chunk
        local finalizedChunk, _ = balanceTags(currentChunk, parityState)
        if #CHUNK_BUFFER == 0 then
            tinsert(CHUNK_BUFFER, fullPrefix .. finalizedChunk)
        else
            tinsert(CHUNK_BUFFER, finalizedChunk)
        end
    end

    -- Unmask Hyperlinks
    for i = 1, #CHUNK_BUFFER do
        local chunk = CHUNK_BUFFER[i]
        for placeholder, originalLink in pairs(LINK_BUFFER) do
            -- Use string.gsub with plain match to avoid pattern issues with placeholder
            local escapedPlaceholder = placeholder:gsub("([%$])", "%%%1")
            chunk = gsub(chunk, escapedPlaceholder, originalLink)
        end
        CHUNK_BUFFER[i] = chunk
    end

    return CHUNK_BUFFER
end
