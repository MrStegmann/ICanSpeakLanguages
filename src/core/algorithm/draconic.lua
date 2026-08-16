local Config = {
    config = {
        preservePunctuation = true
    },
    matrices = {
        consonants = {
            -- Basic Consonants
            "B", "D", "F", "G", "H", "J", "K", "L", "M", "N", "P", "R", "S", "T", "V", "W", "Y", "Z",
            -- Dovahzul Syllables & Word Stems
            "Dah", "Dov", "Fus", "Gol", "Kah", "Lok", "Nahl", "Od", "Rah", "Sah", "Strun", "Tiid", "Yoor",
            "Ah", "Bahl", "Cor", "Dir", "Ein", "Feim", "Grah", "Haas", "Iiz", "Joor", "Krii", "Laas",
            "Maan", "Nok", "Oda", "Prah", "Qo", "Raan", "Slen", "Toor", "Ul", "Viik", "Wahl", "Zul",
            -- WoW Draconic Syllables & Phonemes
            "Brak", "Gazz", "Koz", "Mazz", "Razz", "Thor", "Zal", "Asz", "Balth", "Drak", "Gorm",
            "Kras", "Maly", "Nef", "Onyx", "Rath", "Sin", "Syr", "Vael", "Ys", "Zar", "Alextr"
        },
        vowels = {
            "a", "e", "i", "o", "u", "y", "ah", "al", "ey", "ii", "oor", "uu", "ae", "ai", "ei", "oi", "aa", "ea"
        },
        endings = {
            "ah", "al", "ar", "d", "ein", "h", "k", "l", "m", "n", "ok", "r", "ro", "s", "st", "t", "th", "ul", "us", "v", "z",
            "aar", "aak", "aan", "ag", "ak", "ax", "eim", "ex", "iin", "ir", "iz", "on", "or", "osz", "oth", "ox", "un", "ur", "uz"
        }
    },
    lexicon = {
        verbs = {
            ["burn"]      = { root = "Yoor",     tense = "present" },
            ["burned"]    = { root = "Yoor",     tense = "past" },
            ["fly"]       = { root = "Bo",       tense = "present" },
            ["flew"]      = { root = "Bo",       tense = "past" },
            ["speak"]     = { root = "Tinvaak",  tense = "present" },
            ["spoke"]     = { root = "Tinvaak",  tense = "past" },
            ["kill"]      = { root = "Krii",     tense = "present" },
            ["killed"]    = { root = "Krii",     tense = "past" },
            ["die"]       = { root = "Dir",      tense = "present" },
            ["died"]      = { root = "Dir",      tense = "past" },
            ["fight"]     = { root = "Grah",     tense = "present" },
            ["fought"]    = { root = "Grah",     tense = "past" },
            ["make"]      = { root = "Wahl",     tense = "present" },
            ["made"]      = { root = "Wahl",     tense = "past" },
            ["strike"]    = { root = "Koz",      tense = "present" },
            ["struck"]    = { root = "Koz",      tense = "past" },
            ["consume"]   = { root = "Mazz",     tense = "present" },
            ["consumed"]  = { root = "Mazz",     tense = "past" },
            ["command"]   = { root = "Razz",     tense = "present" },
            ["commanded"] = { root = "Razz",     tense = "past" }
        },
        nouns = {
            ["dragon"]    = { root = "Dovah",    gender = "masculine", isPlural = false },
            ["dragons"]   = { root = "Dov",      gender = "masculine", isPlural = true },
            ["fire"]      = { root = "Yoor",     gender = "neutral",   isPlural = false },
            ["force"]     = { root = "Fus",      gender = "neutral",   isPlural = false },
            ["balance"]   = { root = "Krein",    gender = "neutral",   isPlural = false },
            ["time"]      = { root = "Tiid",     gender = "neutral",   isPlural = false },
            ["sky"]       = { root = "Lok",      gender = "neutral",   isPlural = false },
            ["snow"]      = { root = "Iiz",      gender = "neutral",   isPlural = false },
            ["voice"]     = { root = "Zul",      gender = "neutral",   isPlural = false },
            ["life"]      = { root = "Laas",     gender = "feminine",  isPlural = false },
            ["mortal"]    = { root = "Joor",     gender = "masculine", isPlural = false },
            ["mortals"]   = { root = "Joor",     gender = "masculine", isPlural = true },
            ["earth"]     = { root = "Gol",      gender = "neutral",   isPlural = false },
            ["storm"]     = { root = "Strun",    gender = "neutral",   isPlural = false },
            ["power"]     = { root = "Thor",     gender = "neutral",   isPlural = false },
            ["blood"]     = { root = "Brak",     gender = "neutral",   isPlural = false },
            ["wing"]      = { root = "Gazz",     gender = "feminine",  isPlural = false },
            ["wings"]     = { root = "Gazz",     gender = "feminine",  isPlural = true },
            ["shadow"]    = { root = "Zal",      gender = "neutral",   isPlural = false },
            ["flight"]    = { root = "Drak",     gender = "feminine",  isPlural = false }
        },
        fallbacks = {
            short = {
                "Dah", "Fus", "Gol", "Kah", "Lok", "Od", "Rah", "Sah", "Yoor", "Koz",
                "Gazz", "Dir", "Ul", "Zul", "Brak", "Razz", "Thor", "Zal", "Qo", "Iiz"
            },
            medium = {
                "Dovah", "Tiid", "Strun", "Nahl", "Krein", "Tinvaak", "Grah", "Feim", "Viik",
                "Wahl", "Laas", "Joor", "Slen", "Toor", "Balthaz", "Drakos", "Krasus", "Mazzor"
            },
            long = {
                "Dovahkiin", "Alduin", "Paarthurnax", "Malygos", "Alexstrasza", "Nozdormu",
                "Ysera", "Neltharion", "Onyxia", "Nefarian", "Kalecgos", "Wrathion", "Chromie"
            }
        }
    },
    grammar = {
        tensePrefixes = {
            ["present"]    = "",
            ["past"]       = "dreh-",
            ["future"]     = "fen-",
            ["imperative"] = "kiin-"
        },
        personSuffixes = {
            [1] = "iin", -- 1st Person Sing
            [2] = "he",  -- 1st Person Plur
            [3] = "ex",  -- 2nd Person
            [4] = "ax",  -- 3rd Person Sing
            [5] = "or"   -- 3rd Person Plur
        },
        applyNounEnclitic = function(root, gender, isPlural, isDefinite)
            if isPlural then
                root = root .. "he"
            end
            if not isDefinite then 
                return root 
            end
            return root .. (gender == "masculine" and "iin" or "ah")
        end
    }
}

local addonName, addon = ...
local Engine = addon.AlgorithmEngine
local Hasher = {}
function Hasher.ProcessText(text)
    return Engine.ProcessText(text, Config)
end
addon.DraconicHasher = Hasher
_G.DraconicHasher = Hasher
return Hasher