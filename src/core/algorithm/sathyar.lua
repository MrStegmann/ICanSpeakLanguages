local Config = {
    config = {
        preservePunctuation = true
    },
    matrices = {
        consonants = { 
            "A'q", "C'th", "F'h", "G'h", "H'q", "I'k", "I'q", "I'vw", 
            "K'a", "K'th", "L'w", "N'z", "P'th", "Q'u", "Rlh", "Sh'a", 
            "Thar", "U'q", "Xal", "Xor", "Y'g", "Z'a", "Ph'l", "S'lh",
            "Ghul", "Xor'g", "Ix'q", "Z'ro", "Q'xi", "S'go", "V'ho", "Y'lh"
        },
        vowels = { "a", "e", "i", "o", "u", "ag", "al", "eq", "or", "ath", "il", "or", "al", "en", "ag'n" },
        endings = { "n", "q", "th", "r", "goth", "zal", "zaron", "qor", "ag'n", "oth", "l", "th", "zar", "oth'a", "alar", "thar", "" }
    },
    lexicon = {
        verbs = {
            ["consume"]   = { root = "Ix'qor",   tense = "present" },
            ["consumed"]  = { root = "Ix'qor",   tense = "past" },
            ["whisper"]   = { root = "S'goth",   tense = "present" },
            ["whispered"] = { root = "S'goth",   tense = "past" },
            ["die"]       = { root = "Z'roq",    tense = "present" },
            ["died"]      = { root = "Z'roq",    tense = "past" },
            ["corrupt"]   = { root = "Xor'goth", tense = "present" },
            ["corrupted"] = { root = "Xor'goth", tense = "past" },
            ["devour"]    = { root = "Phl'ag",   tense = "present" },
            ["devoured"]  = { root = "Phl'ag",   tense = "past" },
            ["obey"]      = { root = "Rlh'ag'n", tense = "present" },
            ["obeyed"]    = { root = "Rlh'ag'n", tense = "past" },
            ["drown"]     = { root = "V'h'ol",   tense = "present" },
            ["drowned"]   = { root = "V'h'ol",   tense = "past" },
            ["bleed"]     = { root = "Y'lh'a",   tense = "present" },
            ["bled"]      = { root = "Y'lh'a",   tense = "past" }
        },
        nouns = {
            ["void"]        = { root = "Shath",      gender = "neutral",   isPlural = false },
            ["god"]         = { root = "Y'g",        gender = "masculine", isPlural = false },
            ["gods"]        = { root = "Y'g",        gender = "masculine", isPlural = true },
            ["whisper"]     = { root = "S'goth",     gender = "feminine",  isPlural = false },
            ["whispers"]    = { root = "S'goth",     gender = "feminine",  isPlural = true },
            ["shadow"]      = { root = "Xal'qor",    gender = "neutral",   isPlural = false },
            ["shadows"]     = { root = "Xal'qor",    gender = "neutral",   isPlural = true },
            ["madness"]     = { root = "Thar'xil",   gender = "feminine",  isPlural = false },
            ["nightmare"]   = { root = "Ghul'zaron", gender = "masculine", isPlural = false },
            ["nightmares"]  = { root = "Ghul'zaron", gender = "masculine", isPlural = true },
            ["tentacle"]    = { root = "S'lh'oth",   gender = "neutral",   isPlural = false },
            ["tentacles"]   = { root = "S'lh'oth",   gender = "neutral",   isPlural = true },
            ["blood"]       = { root = "Y'lh'aza",   gender = "neutral",   isPlural = false },
            ["eyeball"]     = { root = "Q'xil'th",   gender = "masculine", isPlural = false },
            ["eyeballs"]    = { root = "Q'xil'th",   gender = "masculine", isPlural = true }
        },
        fallbacks = {
            short = { 
                "A'q", "E'q", "F'h", "H'q", "I'q", "N'z", "U'q", "Y'g", "Z'a", 
                "Ix", "R'l", "Xo", "Zh", "G'l", "X'r", "Z'q", "Ph'l", "G'h" 
            },
            medium = { 
                "N'zoth", "C'thun", "Ghul'k", "Thar'q", "Xal'th", "Ix'qor", 
                "Rlh'en", "Z'roq", "Q'xil", "S'goth", "V'h'ol", "Y'lh'a", 
                "K'th'un", "G'h'zar", "S'lh'a", "Phl'ag" 
            },
            long = { 
                "Shath'Yar", "Y'shaarj", "Yogg-Saron", "Xor'goth", "Phl'qoth", 
                "Ghul'zaron", "Xal'qor", "Thar'xil", "S'lh'oth", "Ix'qor'l", 
                "Rlh'ag'n", "Z'roq'al", "Q'xil'th", "S'goth'q", "V'h'olar", "Y'lh'aza" 
            }
        }
    },
    grammar = {
        tensePrefixes = {
            ["present"]    = "",
            ["past"]       = "u'g-",
            ["future"]     = "i'sk-",
            ["imperative"] = "k'al-"
        },
        personSuffixes = {
            [1] = "qor",   -- 1st Person Sing
            [2] = "ag'n",  -- 1st Person Plur
            [3] = "oth",   -- 2nd Person
            [4] = "al",    -- 3rd Person Sing
            [5] = "zaron"  -- 3rd Person Plur
        },
        applyVoidEnclitic = function(root, isPlural)
            return root .. (isPlural and "'qor" or "'al")
        end
    }
}

local addonName, addon = ...
local Engine = addon.AlgorithmEngine
local Hasher = {}
function Hasher.ProcessText(text)
    return Engine.ProcessText(text, Config)
end
addon.SathyarHasher = Hasher
_G.SathyarHasher = Hasher
return Hasher