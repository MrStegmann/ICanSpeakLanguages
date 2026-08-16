local Config = {
    config = {
        preservePunctuation = true
    },
    matrices = {
        consonants = { 
            "G", "K", "R", "Z", "Th", "M", "N", "D", "L", "B", "Kh", "S", "Gk", "Rk", "Zr", 
            "Grak", "Krag", "Thrak", "Drak", "Skra", "Throk", "Mogh", "Gruk", "Lok", "Tar", 
            "Karg", "Maug", "Ragh", "Skag", "Thrag", "Zorn", "Drakh", "Grakh", "Kragh", "Maugh"
        },
        vowels = { "a", "o", "u", "i", "e", "aa", "ag", "uk", "ug", "oz", "ur", "ok" },
        endings = { "k", "g", "z", "r", "sh", "th", "gg", "azz", "uk", "og", "or", "ath", "arg", "ur", "az", "osh", "" }
    },
    lexicon = {
        verbs = {
            ["fight"]     = { root = "Lok",    tense = "present" },
            ["fought"]    = { root = "Lok",    tense = "past" },
            ["crush"]     = { root = "Krush",  tense = "present" },
            ["crushed"]   = { root = "Krush",  tense = "past" },
            ["kill"]      = { root = "Kagg",   tense = "present" },
            ["killed"]    = { root = "Kagg",   tense = "past" },
            ["slay"]      = { root = "Thrak",  tense = "present" },
            ["slain"]     = { root = "Thrak",  tense = "past" },
            ["charge"]    = { root = "Skra",   tense = "present" },
            ["charged"]   = { root = "Skra",   tense = "past" },
            ["bleed"]     = { root = "Gash",   tense = "present" },
            ["smash"]     = { root = "Mogh",   tense = "present" },
            ["conquer"]   = { root = "Kazreth", tense = "present" }
        },
        nouns = {
            ["warrior"]   = { root = "Uruk",   gender = "masculine", isPlural = false },
            ["warriors"]  = { root = "Uruk",   gender = "masculine", isPlural = true },
            ["blood"]     = { root = "Gash",   gender = "neutral",   isPlural = false },
            ["honor"]     = { root = "Tar",    gender = "masculine", isPlural = false },
            ["axe"]       = { root = "Grom",   gender = "feminine",  isPlural = false },
            ["axes"]      = { root = "Grom",   gender = "feminine",  isPlural = true },
            ["chief"]     = { root = "Warchief", gender = "masculine", isPlural = false },
            ["clans"]     = { root = "Maka",   gender = "neutral",   isPlural = true },
            ["beast"]     = { root = "Dogg",   gender = "neutral",   isPlural = false },
            ["beasts"]    = { root = "Dogg",   gender = "neutral",   isPlural = true },
            ["spear"]     = { root = "Rega",   gender = "feminine",  isPlural = false },
            ["victory"]   = { root = "Lok'tar", gender = "neutral",  isPlural = false }
        },
        fallbacks = {
            short = { 
                "Lok", "Tar", "Kaz", "Ruk", "Kek", "Mog", "Zug", "Gul", "Nuk", "Grak", 
                "Darg", "Gash", "Karg", "Skra", "Throk", "Mogh", "Gruk", "Aaz", "Kil", "Ogg", 
                "Krush", "Drak", "Krag", "Maug", "Ragh", "Skag", "Thrag", "Zorn" 
            },
            medium = { 
                "Throm'ka", "Lok'Tar", "Moguna", "Revash", "Thrakk", "Nakazz", "Raznos", "Ogerin", 
                "Gul'rok", "Kazreth", "Tov'osh", "Zil'Nok", "Rath'is", "Kil'azi", "Osh'Kava", "Gul'nath", 
                "Kog'zela", "Ragath'a", "Zuggossh", "Moth'aga", "Drak'maug", "Grak'thra", "Krag'zorn" 
            },
            long = { 
                "Lokando'nash", "Golgonnashar", "Ul'gammathar", "Khaz'rogg'ahn", "Dalggo'mazah", "Tov'nokaz", 
                "Osh'kazil", "No'throma", "Gesh'nuka", "Lok'mogul", "Lok'bolar", "Ruk'ka'ha", "Regasnogah", 
                "Kazum'nobu", "Throm'bola", "Gesh'zugas", "Maza'rotha", "Ogerin'naz", "Moth'kazoroth" 
            }
        }
    },
    grammar = {
        tensePrefixes = {
            ["present"]    = "",
            ["past"]       = "az-",
            ["future"]     = "no-",
            ["imperative"] = "zug-"
        },
        personSuffixes = {
            [1] = "a",   -- 1st Person Sing
            [2] = "ka",  -- 1st Person Plur
            [3] = "ur",  -- 2nd Person
            [4] = "osh", -- 3rd Person Sing
            [5] = "az"   -- 3rd Person Plural
        },
        applyNounEnclitic = function(root, gender, isPlural, isDefinite)
            if not isDefinite then return root end
            return root .. (isPlural and "naz" or "gar")
        end
    }
}

local addonName, addon = ...
local Engine = addon.AlgorithmEngine
local Hasher = {}
function Hasher.ProcessText(text)
    return Engine.ProcessText(text, Config)
end
addon.OrcishHasher = Hasher
_G.OrcishHasher = Hasher
return Hasher