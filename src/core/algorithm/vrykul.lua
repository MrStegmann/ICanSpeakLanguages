-- Vrykul Language Config Matrix for ICanSpeakLanguages Engine
local Config = {
    config = {
        preservePunctuation = true
    },
    matrices = {
        consonants = { 
            "B", "D", "F", "G", "H", "J", "K", "L", "M", "N", "P", "R", "S", "T", "V", "Þ", "Ð",
            "Sk", "Br", "Dr", "St", "Fl", "Gr", "Hr", "Kl", "Skj", "Svr", "Þr", "Ðr"
        },
        vowels = { "a", "e", "i", "o", "u", "y", "á", "ó", "æ", "ö", "ú", "ý", "í" },
        endings = { "r", "n", "l", "s", "k", "t", "d", "m", "rr", "nn", "ð", "þ", "" }
    },
    lexicon = {
        verbs = {
            ["burn"]     = { root = "Brenn", tense = "present" },
            ["burns"]    = { root = "Brenn", tense = "present" },
            ["burning"]  = { root = "Brenn", tense = "present" },
            ["burned"]   = { root = "Brenn", tense = "past" },
            ["cleave"]   = { root = "Hogg",  tense = "present" },
            ["cleaves"]  = { root = "Hogg",  tense = "present" },
            ["cleaved"]  = { root = "Hogg",  tense = "past" },
            ["strike"]   = { root = "Hogg",  tense = "present" },
            ["strikes"]  = { root = "Hogg",  tense = "present" },
            ["struck"]   = { root = "Hogg",  tense = "past" },
            ["guard"]    = { root = "Vaka",  tense = "present" },
            ["guards"]   = { root = "Vaka",  tense = "present" },
            ["guarded"]  = { root = "Vaka",  tense = "past" },
            ["watch"]    = { root = "Vaka",  tense = "present" },
            ["watches"]  = { root = "Vaka",  tense = "present" },
            ["break"]    = { root = "Rjúf",  tense = "present" },
            ["breaks"]   = { root = "Rjúf",  tense = "present" },
            ["broke"]    = { root = "Rjúf",  tense = "past" },
            ["shatter"]  = { root = "Rjúf",  tense = "present" },
            ["shatters"] = { root = "Rjúf",  tense = "present" },
            ["slay"]     = { root = "Drekka", tense = "present" },
            ["slays"]    = { root = "Drekka", tense = "present" },
            ["slew"]     = { root = "Drekka", tense = "past" }
        },
        nouns = {
            ["dragon"]   = { root = "Drak",   gender = "masculine", isPlural = false },
            ["drake"]    = { root = "Drak",   gender = "masculine", isPlural = false },
            ["dragons"]  = { root = "Drak",   gender = "masculine", isPlural = true },
            ["sword"]    = { root = "Sverd",  gender = "masculine", isPlural = false },
            ["blade"]    = { root = "Sverd",  gender = "masculine", isPlural = false },
            ["swords"]   = { root = "Sverd",  gender = "masculine", isPlural = true },
            ["shield"]   = { root = "Skjöld", gender = "feminine",  isPlural = false },
            ["shields"]  = { root = "Skjöld", gender = "feminine",  isPlural = true },
            ["rune"]     = { root = "Rún",    gender = "feminine",  isPlural = false },
            ["runes"]    = { root = "Rún",    gender = "feminine",  isPlural = true },
            ["king"]     = { root = "Konung", gender = "masculine", isPlural = false },
            ["leader"]   = { root = "Konung", gender = "masculine", isPlural = false },
            ["hall"]     = { root = "Halla",  gender = "feminine",  isPlural = false },
            ["hold"]     = { root = "Halla",  gender = "feminine",  isPlural = false },
            ["warrior"]  = { root = "Vargr",  gender = "masculine", isPlural = false },
            ["frost"]    = { root = "Vetrn",  gender = "masculine", isPlural = false },
            ["winter"]   = { root = "Vetrn",  gender = "masculine", isPlural = false },
            ["fire"]     = { root = "Eld",    gender = "masculine", isPlural = false },
            ["flame"]    = { root = "Eld",    gender = "masculine", isPlural = false },
            ["storm"]    = { root = "Storm",  gender = "masculine", isPlural = false },
            ["sea"]      = { root = "Hav",    gender = "feminine",  isPlural = false },
            ["hammer"]   = { root = "Hamar",  gender = "masculine", isPlural = false },
            ["spear"]    = { root = "Geir",   gender = "masculine", isPlural = false },
            ["night"]    = { root = "Nótt",   gender = "feminine",  isPlural = false }
        },
        fallbacks = {
            short = {
                "Ás", "Þór", "Öll", "Hrim", "Örn", "Ýr", "Úlf", "Blóð", "Jarl", "Rán"
            },
            medium = {
                "Fornan", "Valkyr", "Stálmår", "Drakar", "Skjöldr", "Hrímdal", "Grommår", "Kaldþor"
            },
            long = {
                "Yggdrasil", "Fjörgardr", "Vetrgrímr", "Brakarstaðr", "Örmundrinn", "Þundarbrekr"
            }
        }
    },
    grammar = {
        tensePrefixes = {
            ["present"]    = "",
            ["past"]       = "for-",
            ["future"]     = "skal-",
            ["imperative"] = "bakk-"
        },
        personSuffixes = {
            [1] = "ir", -- 1st Person Sing
            [2] = "um", -- 1st Person Plur
            [3] = "ar", -- 2nd Person
            [4] = "ur", -- 3rd Person Sing
            [5] = "a"   -- 3rd Person Plur
        },
        applyNounEnclitic = function(root, gender, isPlural, isDefinite)
            if not root or root == "" then return "" end
            if not isDefinite then return root end

            local lastChar = root:sub(-1):lower()
            local endsInVowel = (lastChar == "a" or lastChar == "e" or lastChar == "i" or 
                                 lastChar == "o" or lastChar == "u" or lastChar == "y" or 
                                 lastChar == "á" or lastChar == "ó" or lastChar == "æ" or 
                                 lastChar == "ö" or lastChar == "ú" or lastChar == "ý" or lastChar == "í")

            if gender == "masculine" then
                if isPlural then
                    return root .. "arnir"
                else
                    return endsInVowel and (root .. "nn") or (root .. "inn")
                end
            else
                if isPlural then
                    return root .. "urnar"
                else
                    return endsInVowel and (root .. "n") or (root .. "an")
                end
            end
        end
    }
}

local addonName, addon = ...
local Engine = addon.AlgorithmEngine
local Hasher = {}
function Hasher.ProcessText(text)
    return Engine.ProcessText(text, Config)
end
addon.VrykulHasher = Hasher
_G.VrykulHasher = Hasher
return Hasher