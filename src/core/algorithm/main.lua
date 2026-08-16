--[[
    ICanSpeakLanguages - Unified Algorithm Engine
    Centralized hash string engine applying Data-Driven configurations.
]]
local addonName, addon = ...

addon.AlgorithmEngine = addon.AlgorithmEngine or {}
local Engine = addon.AlgorithmEngine

-- Local Caching of Globals for GC Prevention and Performance
local string_byte = string.byte
local string_sub = string.sub
local string_lower = string.lower
local string_upper = string.upper
local string_find = string.find
local string_match = string.match
local math_floor = math.floor
local math_max = math.max
local table_concat = table.concat
local tostring = tostring
local type = type
local wipe = wipe

-- File-scoped buffer to prevent GC spikes during high-traffic chat parsing
local tokenBuffer = {}

-- Pure algorithmic core functions
local function hashString(str)
    if not str or str == "" then return 0 end
    local hash = 5381
    for i = 1, #str do
        local byte = string_byte(str, i)
        hash = ((hash * 33) + byte) % 4294967296
    end
    return hash
end

local function LCG(seed)
    return (seed * 1103515245 + 12345) % 4294967296
end

local function endsInVowel(word, vowelMap)
    if not word or word == "" then return false end
    local lastChar = string_sub(word, -1)
    return vowelMap[lastChar] == true
end

local function generate2SyllableRoot(seed, matrices)
    local CONSONANTS = matrices.consonants
    local VOWELS = matrices.vowels
    local ENDINGS = matrices.endings
    local nC, nV, nE = #CONSONANTS, #VOWELS, #ENDINGS
    
    local idxC1 = (seed % nC) + 1;        local s1 = math_floor(seed / nC)
    local idxV1 = (s1 % nV) + 1;          local s2 = math_floor(s1 / nV)
    local idxC2 = (s2 % nC) + 1;          local s3 = math_floor(s2 / nV)
    local idxV2 = (s3 % nV) + 1;          local s4 = math_floor(s3 / nV)
    local idxEnd = (s4 % nE) + 1

    local c1 = CONSONANTS[idxC1] or ""
    local v1 = VOWELS[idxV1] or ""
    local c2 = string_lower(CONSONANTS[idxC2] or "")
    local v2 = VOWELS[idxV2] or ""
    local e = ENDINGS[idxEnd] or ""

    return c1 .. v1 .. c2 .. v2 .. e
end

local function applyNounEnclitic(root, gender, isPlural, isDefinite, grammar, matrices)
    if grammar and grammar.applyNounEnclitic then
        -- We'll assume the callback expects (root, gender, isPlural, isDefinite, endsInVowelBool)
        local isVowel = endsInVowel(root, matrices.vowelMap)
        return grammar.applyNounEnclitic(root, gender, isPlural, isDefinite, isVowel)
    end
    return root
end

local function conjugateVerb(root, tense, personIndex, grammar)
    if not root or root == "" then return "" end
    tense = tense or "present"
    personIndex = personIndex or 4

    if not grammar then return root end

    local prefix = (grammar.tensePrefixes and grammar.tensePrefixes[tense]) or ""
    local suffix = (grammar.personSuffixes and grammar.personSuffixes[personIndex]) or ""

    if suffix ~= "" then
        return prefix .. root .. "-" .. suffix
    else
        return prefix .. root
    end
end

local function generateWordForLength(seed, targetLen, role, isFirstWord, isDefinite, config)
    targetLen = math_max(1, targetLen)
    local tenseMode = seed % 4
    local personMode = (math_floor(seed / 4) % 5) + 1
    local gender = (seed % 2 == 0) and "masculine" or "feminine"
    local s1 = LCG(seed)
    local s2 = LCG(s1)

    local CONSONANTS = config.matrices.consonants
    local VOWELS = config.matrices.vowels
    local ENDINGS = config.matrices.endings

    local word = ""

    if targetLen <= 3 then
        local c = CONSONANTS[(seed % #CONSONANTS) + 1] or ""
        local v = VOWELS[(s1 % #VOWELS) + 1] or ""
        word = c .. v
        if targetLen == 3 then
            local endChar = ENDINGS[(s2 % #ENDINGS) + 1] or ""
            word = word .. (endChar ~= "" and string_lower(string_sub(endChar, 1, 1)) or "r")
        end
    elseif targetLen <= 5 then
        local root = generate2SyllableRoot(seed, config.matrices)
        if role == "NOUN" and isDefinite then
            word = applyNounEnclitic(string_sub(root, 1, 3), gender, false, true, config.grammar, config.matrices)
        else
            word = string_sub(root, 1, targetLen)
        end
    elseif targetLen <= 7 then
        local root = generate2SyllableRoot(seed, config.matrices)
        if role == "VERB" then
            word = conjugateVerb(string_sub(root, 1, 4), "present", personMode, config.grammar)
        elseif role == "NOUN" then
            word = applyNounEnclitic(string_sub(root, 1, 4), gender, false, isDefinite, config.grammar, config.matrices)
        else
            word = string_sub(root, 1, targetLen)
        end
        if #word > targetLen + 1 then
            word = string_sub(word, 1, targetLen)
        end
    elseif targetLen <= 11 then
        local root = generate2SyllableRoot(seed, config.matrices)
        if role == "VERB" then
            local tenses = { "present", "past", "future", "imperative" }
            word = conjugateVerb(string_sub(root, 1, 4), tenses[tenseMode + 1] or "present", personMode, config.grammar)
        elseif role == "NOUN" then
            word = applyNounEnclitic(root, gender, false, isDefinite, config.grammar, config.matrices)
        else
            word = root
        end
        if #word > targetLen + 2 then
            word = string_sub(word, 1, targetLen)
        end
    else
        local root1 = generate2SyllableRoot(seed, config.matrices)
        local root2 = generate2SyllableRoot(s1, config.matrices)
        word = root1 .. string_lower(root2)
        if #word > targetLen + 2 then
            word = string_sub(word, 1, targetLen)
        end
    end

    return word
end

-- Capitalization and Punctuation handling
local function cleanToken(token)
    if not token or token == "" then return "", "", "" end
    -- Extract leading punctuation, the core word, and trailing punctuation
    local lead = string_match(token, "^[%p]*") or ""
    local trail = string_match(token, "[%p]*$") or ""
    
    local coreLen = #token - #lead - #trail
    local core = ""
    if coreLen > 0 then
        core = string_sub(token, #lead + 1, #token - #trail)
    end
    
    local casing = "lower"
    if core ~= "" then
        if core == string_upper(core) then
            casing = "upper"
        elseif string_upper(string_sub(core, 1, 1)) == string_sub(core, 1, 1) then
            casing = "title"
        end
    end
    
    return core, lead, trail, casing
end

local function applyCasing(word, casing)
    if not word or word == "" then return word end
    if casing == "upper" then
        return string_upper(word)
    elseif casing == "title" then
        return string_upper(string_sub(word, 1, 1)) .. string_lower(string_sub(word, 2))
    else
        return string_lower(word)
    end
end

-- Tokenize strings while preserving edge-case structures
local function tokenizePreservingBlocks(text)
    wipe(tokenBuffer)
    if not text or text == "" then return 0 end

    local cursor = 1
    local len = #text
    
    while cursor <= len do
        -- Check for UI color tags |c...|r
        if string_sub(text, cursor, cursor+1) == "|c" then
            local endTag = string_find(text, "|r", cursor)
            if endTag then
                tokenBuffer[#tokenBuffer + 1] = { type = "protected", text = string_sub(text, cursor, endTag + 1) }
                cursor = endTag + 2
            else
                tokenBuffer[#tokenBuffer + 1] = { type = "raw", text = string_sub(text, cursor, cursor) }
                cursor = cursor + 1
            end
        -- Check for emotes *...*
        elseif string_sub(text, cursor, cursor) == "*" then
            local endTag = string_find(text, "*", cursor + 1)
            if endTag then
                tokenBuffer[#tokenBuffer + 1] = { type = "protected", text = string_sub(text, cursor, endTag) }
                cursor = endTag + 1
            else
                tokenBuffer[#tokenBuffer + 1] = { type = "raw", text = "*" }
                cursor = cursor + 1
            end
        -- Check for OOC <...>
        elseif string_sub(text, cursor, cursor) == "<" then
            local endTag = string_find(text, ">", cursor + 1)
            if endTag then
                tokenBuffer[#tokenBuffer + 1] = { type = "protected", text = string_sub(text, cursor, endTag) }
                cursor = endTag + 1
            else
                tokenBuffer[#tokenBuffer + 1] = { type = "raw", text = "<" }
                cursor = cursor + 1
            end
        else
            -- Grab next word or whitespace
            local s, e = string_find(text, "^%s+", cursor)
            if s then
                tokenBuffer[#tokenBuffer + 1] = { type = "whitespace", text = string_sub(text, s, e) }
                cursor = e + 1
            else
                s, e = string_find(text, "^[^%s*<|]+", cursor)
                if s then
                    tokenBuffer[#tokenBuffer + 1] = { type = "raw", text = string_sub(text, s, e) }
                    cursor = e + 1
                else
                    -- Fallback 1 char (should not be reached due to pattern above, but safe)
                    tokenBuffer[#tokenBuffer + 1] = { type = "raw", text = string_sub(text, cursor, cursor) }
                    cursor = cursor + 1
                end
            end
        end
    end
    
    return #tokenBuffer
end

function Engine.ProcessText(text, languageConfig)
    if not languageConfig then
        -- Fallback to Generic
        if _G.GenericHasher then
            return _G.GenericHasher.ProcessText(text)
        else
            return text -- Failsafe
        end
    end

    -- Precompute vowel map if not done
    if not languageConfig.matrices.vowelMap then
        languageConfig.matrices.vowelMap = {}
        for _, v in ipairs(languageConfig.matrices.vowels) do
            languageConfig.matrices.vowelMap[v] = true
            languageConfig.matrices.vowelMap[string_lower(v)] = true
            languageConfig.matrices.vowelMap[string_upper(v)] = true
        end
    end

    local numTokens = tokenizePreservingBlocks(text)
    if numTokens == 0 then return text end

    -- Defensive check against .npc say
    if string_match(text, "^%.npc %w+ ") then
        return text
    end

    local outputTokens = {}
    local isNextDefinite = false
    local wordIndex = 1

    for i = 1, numTokens do
        local token = tokenBuffer[i]
        
        if token.type == "protected" or token.type == "whitespace" then
            outputTokens[#outputTokens + 1] = token.text
        else
            local rawToken = token.text
            local core, lead, trail, casing = cleanToken(rawToken)
            
            if core == "" then
                -- Just punctuation
                outputTokens[#outputTokens + 1] = rawToken
            else
                local lowerCore = string_lower(core)
                local targetLen = math_max(1, #core)
                local seed = LCG(hashString(lowerCore .. "_" .. tostring(wordIndex)))
                local outWord = ""

                if lowerCore == "the" or lowerCore == "a" or lowerCore == "an" then
                    isNextDefinite = true
                    if languageConfig.lexicon and languageConfig.lexicon.fallbacks and languageConfig.lexicon.fallbacks[lowerCore] then
                        outWord = languageConfig.lexicon.fallbacks[lowerCore]
                    else
                        outWord = (lowerCore == "the") and "of" or "en"
                    end
                else
                    -- Lexicon Check
                    if languageConfig.lexicon and languageConfig.lexicon.verbs and languageConfig.lexicon.verbs[lowerCore] then
                        local verbInfo = languageConfig.lexicon.verbs[lowerCore]
                        outWord = conjugateVerb(verbInfo.root, verbInfo.tense, 4, languageConfig.grammar)
                    elseif languageConfig.lexicon and languageConfig.lexicon.nouns and languageConfig.lexicon.nouns[lowerCore] then
                        local nounInfo = languageConfig.lexicon.nouns[lowerCore]
                        outWord = applyNounEnclitic(nounInfo.root, nounInfo.gender, nounInfo.isPlural or false, isNextDefinite, languageConfig.grammar, languageConfig.matrices)
                        isNextDefinite = false
                    elseif languageConfig.lexicon and languageConfig.lexicon.fallbacks and languageConfig.lexicon.fallbacks[lowerCore] then
                        outWord = languageConfig.lexicon.fallbacks[lowerCore]
                        isNextDefinite = false
                    else
                        -- Pure algorithmic
                        local role = (wordIndex == 2 or (wordIndex == 1)) and "VERB" or "NOUN"
                        outWord = generateWordForLength(seed, targetLen, role, false, isNextDefinite, languageConfig)
                        isNextDefinite = false
                    end
                end

                outWord = applyCasing(outWord, casing)
                outputTokens[#outputTokens + 1] = lead .. outWord .. trail
                wordIndex = wordIndex + 1
            end
        end
    end

    return table_concat(outputTokens, "")
end

return Engine
