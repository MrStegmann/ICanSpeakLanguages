--[[
    ICanSpeakLanguages - Darnassian Language Module Configuration
    Unified Schema-Compliant Data Table & Grammar Callbacks for Darnassian (Darnassae).
--]]

local Darnassian = {
    config = {
        preservePunctuation = true
    },

    matrices = {
        consonants = { 
            "Th", "Sh", "F", "S", "D", "R", "L", "K", "Z", "M", "N",
            "Quel", "Shan", "Rhok", "Lok", "Zin", "Kal", "Dor", "Dore",
            "Bel", "Aear", "Ith", "Cen", "Nost", "Sil", "Thas", "Vor",
            "Sat", "Astr", "Dol", "Sylv", "Thal", "Tor", "Band"
        },
        vowels = { 
            "a", "e", "i", "o", "u", 
            "ae", "ai", "ei", "ani", "ora" 
        },
        endings = { 
            "r", "l", "s", "h", "n", "", 
            "sh", "ras", "sil", "dor", "del", "dorei", "drassil", "naar" 
        }
    },

    lexicon = {
        verbs = {
            ["restore"] = { root = "Falah", tense = "present" },
            ["balance"] = { root = "Falah", tense = "present" },
            ["love"]    = { root = "Surfas", tense = "present" },
            ["cherish"] = { root = "Surfas", tense = "present" },
            ["fight"]   = { root = "Thor", tense = "present" },
            ["struggle"]= { root = "Thor", tense = "present" },
            ["survive"] = { root = "Talah", tense = "present" },
            ["endure"]  = { root = "Talah", tense = "present" },
            ["execute"] = { root = "Karath", tense = "present" },
            ["do"]      = { root = "Karath", tense = "present" },
            ["prepare"] = { root = "Bandu", tense = "imperative" },
            ["kill"]    = { root = "Rifa", tense = "imperative" },
            ["know"]    = { root = "Nal", tense = "present" },
            ["feel"]    = { root = "Nal", tense = "present" }
        },
        nouns = {
            -- Sacred / Animate Nouns
            ["elune"]   = { root = "Elune", gender = "feminine", isPlural = false },
            ["elf"]     = { root = "Kaldorei", gender = "neutral", isPlural = false },
            ["elves"]   = { root = "Kaldorei", gender = "neutral", isPlural = true },
            ["teacher"] = { root = "Shan'do", gender = "masculine", isPlural = false },
            ["student"] = { root = "Thero'shan", gender = "neutral", isPlural = false },
            ["mother"]  = { root = "Minn'do", gender = "feminine", isPlural = false },
            ["father"]  = { root = "An'da", gender = "masculine", isPlural = false },
            ["family"]  = { root = "Dieb", gender = "neutral", isPlural = false },
            ["keeper"]  = { root = "Delar", gender = "neutral", isPlural = false },
            ["hunter"]  = { root = "Mush'a", gender = "neutral", isPlural = false },

            -- Inanimate / Mundane Nouns & Concepts
            ["nature"]  = { root = "Dure", gender = "neutral", isPlural = false },
            ["blade"]   = { root = "Serrar", gender = "neutral", isPlural = false },
            ["sword"]   = { root = "Serrar", gender = "neutral", isPlural = false },
            ["staff"]   = { root = "Lok", gender = "neutral", isPlural = false },
            ["bow"]     = { root = "Rhok", gender = "neutral", isPlural = false },
            ["tree"]    = { root = "Drassil", gender = "neutral", isPlural = false },
            ["realm"]   = { root = "Thalas", gender = "neutral", isPlural = false },
            ["town"]    = { root = "Naar", gender = "neutral", isPlural = false },
            ["truth"]   = { root = "Dora", gender = "neutral", isPlural = false },
            ["glory"]   = { root = "Zin", gender = "neutral", isPlural = false },
            ["starlight"]= { root = "Kal", gender = "neutral", isPlural = false }
        },
        fallbacks = {
            short = { 
                "Lok", "Rhok", "Zin", "Kal", "Dieb", "Thor", "Naar", 
                "Dure", "Dora", "Vor", "Del", "Ash", "Tor", "Min" 
            },
            medium = { 
                "Elune", "Serrar", "Drassil", "Thalas", "Falah", "Talah", 
                "Thera", "Surfas", "Karath", "Ishnu", "Balah", "Delar", 
                "Ilisar", "Surfal", "Anoduna", "Enshu" 
            },
            long = { 
                "Kaldorei", "Quel'dorei", "Sin'dorei", "Shan'do", "Thero'shan", 
                "Minn'do", "Banthalos", "Shal'dorei", "Belore", "Thori'dal", 
                "Andrassil", "Nordrassil", "Teldrassil", "Vordrassil" 
            }
        }
    },

    grammar = {
        tensePrefixes = {
            ["present"]     = "",        -- Present / Imperfective
            ["past"]        = "Az-",     -- Past / Perfective
            ["future"]      = "Anu-",    -- Future / Intentional
            ["subjunctive"] = "Andu-",   -- Subjunctive / Invocation
            ["imperative"]  = "Bandu-"   -- Imperative / Command
        },
        personSuffixes = {
            [1] = "dor",     -- 3rd Person Singular (He/She/It)
            [2] = "duna",    -- 3rd Person Plural (They)
            [3] = "ne",      -- 1st Person Singular (I)
            [4] = "na",      -- 1st Person Plural (We)
            [5] = "dal"      -- 2nd Person (You)
        },

        -- Vowel Helper
        endsInVowel = function(str)
            if not str or str == "" then return false end
            local lastChar = string.sub(str, -1):lower()
            return lastChar == "a" or lastChar == "e" or lastChar == "i" or lastChar == "o" or lastChar == "u"
        end,

        -- Morphological Enclitic: Animate / Sacred Subject (-n / -en)
        applyAnimateEnclitic = function(root)
            if not root or root == "" then return "" end
            if Darnassian.grammar.endsInVowel(root) then
                return root .. "n"
            else
                return root .. "en"
            end
        end,

        -- Morphological Enclitic: Inanimate / Mundane Object (-l / -el)
        applyInanimateEnclitic = function(root)
            if not root or root == "" then return "" end
            if Darnassian.grammar.endsInVowel(root) then
                return root .. "l"
            else
                return root .. "el"
            end
        end,

        -- Verb Conjugation Rule
        conjugateVerb = function(root, tenseMode, personMode)
            if not root or root == "" then return "" end
            personMode = ((personMode or 1) % 5) + 1

            local prefix = Darnassian.grammar.tensePrefixes[tenseMode] or ""
            local suffix = Darnassian.grammar.personSuffixes[personMode] or "dor"
            return prefix .. root .. suffix
        end
    }
}

local addonName, addon = ...
local Engine = addon.AlgorithmEngine
local Hasher = {}
function Hasher.ProcessText(text)
    return Engine.ProcessText(text, Darnassian)
end
addon.DarnassianHasher = Hasher
_G.DarnassianHasher = Hasher
return Hasher