local addonName, addon = ...
local table, ipairs = table, ipairs

addon.Text = addon.Text or {}
local Text = addon.Text
local RegExp = addon.RegExp

function Text.WrapText(text, maxLen)
    maxLen = maxLen or (ICanSpeakLanguagesDB and ICanSpeakLanguagesDB.maxLineLength) or addon.Config.DEFAULT_MAX_LINE_LENGTH
    if not text or text == "" then return {} end

    local words = addon.Utils and addon.Utils.SplitWords and addon.Utils.SplitWords(text) or {}
    if #words == 0 then
        -- fallback if Utils.SplitWords isn't available immediately
        for w in text:gmatch("%S+") do table.insert(words, w) end
    end
    
    local lines = {}
    local currentLine = ""

    for _, word in ipairs(words) do
        if #currentLine == 0 then
            currentLine = word
        elseif #currentLine + 1 + #word <= maxLen then
            currentLine = currentLine .. " " .. word
        else
            table.insert(lines, currentLine)
            currentLine = word
        end
    end

    if #currentLine > 0 then
        table.insert(lines, currentLine)
    end

    return lines
end

function Text.ProcessText(text)
    if not text then return "" end
    local wrappedLines = Text.WrapText(text)
    return table.concat(wrappedLines, "\n")
end

-- Helper to extract a typed [Language] tag prefix and the remaining body text.
function Text.ExtractLanguageTag(text, spokenLang)
    local tagStr = "[" .. spokenLang .. "]"
    local tagStart, tagEnd = text:find(tagStr, 1, true)
    local prefix, bodyToParse

    if tagStart and tagEnd then
        prefix = text:sub(1, tagEnd)
        bodyToParse = text:sub(tagEnd + 1)
    else
        local tagPatternStart, tagPatternEnd = text:find(RegExp.TAG_PATTERN)
        if tagPatternStart and tagPatternEnd then
            prefix = text:sub(1, tagPatternEnd)
            bodyToParse = text:sub(tagPatternEnd + 1)
        else
            prefix = "[" .. spokenLang .. "] "
            bodyToParse = text
        end
    end
    
    return prefix, bodyToParse
end

-- Helper to format the extracted tag prefix: either colored or stripped completely.
function Text.FormatLanguageTag(prefix, stripTag)
    if stripTag then
        return prefix:gsub(RegExp.TAG_PATTERN, "")
    else
        return prefix:gsub("%[([^%]]+)%]", "|cff33ff99[%1]|r")
    end
end
