local KalimagConfig = {
    config = {
        preservePunctuation = true
    },
    matrices = {
        consonants = {
            "B", "Ch", "D", "F", "G", "H", "J", "K", "M", "N", "P", "Q", "R", "Sh", "T", "V", "Z",
            "Br", "Dr", "Fm", "Fr", "Gat", "Gut", "Kr", "Ma", "Nuk", "Roc", "Reth", "Shod", "Tch", "Tel", "Tz"
        },
        vowels = { "a", "e", "i", "o", "u", "aa", "ae", "ee", "oo" },
        endings = { "k", "n", "r", "s", "t", "th", "m", "g", "ah", "ak", "ok", "um", "un", "unt", "v" }
    },
    lexicon = {
        verbs = {
            ["burn"]    = { root = "Fiilrok", tense = "present" },
            ["smite"]   = { root = "Gun",     tense = "present" },
            ["crush"]   = { root = "Rok",     tense = "present" }
        },
        nouns = {
            ["fire"]    = { root = "Ignan",   gender = "masculine", isPlural = false },
            ["earth"]   = { root = "Ter'ran", gender = "neutral",   isPlural = false },
            ["water"]   = { root = "Ven'tiro",gender = "feminine",  isPlural = false },
            ["wind"]    = { root = "Aer",     gender = "neutral",   isPlural = false }
        },
        fallbacks = {
            short = {
                "A", "G", "K", "O", "T", "U", "Gi", "Ka", "Ko", "Ma", "Os", "Ra", "Ta", "Tu",
                "Dor", "Dra", "Fel", "Gun", "Kan", "Kir", "Nuk", "Rok", "Sto", "Tas", "Tor", "Von"
            },
            medium = {
                "Brom", "Drae", "Fmer", "Guto", "Kras", "Krin", "Mahn", "Reth", "Toro", "Zoln", "Shin", "Tols",
                "Bromo", "Draek", "Fmerk", "Fraht", "Gatin", "Kranu", "Krast", "Roath", "Shone", "Talsa", "Torin", "Zoern",
                "Ben'nig", "Dratir", "Drinor", "Fel'tes", "For'kin", "Korsul", "Suz'ahn", "Tadrom", "Ter'ran", "Toka'an"
            },
            long = {
                "Chokgan", "Dak'kaun", "Dorvrem", "Fanroke", "Fiilrok", "Kel'shae", "Kis'tean", "Koaresh", "Tchor'ah", "Telsrah",
                "Aasrugel", "Desh'noka", "Gi'azol'em", "Gi'frazsh", "Kilagrin", "Krast'ven", "Nuk'tra'te", "Os'retiak", "Quin'mahk",
                "Ahn'torunt", "Brud'remek", "Dor'dra'tor", "Draemierr", "Gatin'roth", "Gesh'throm", "Mastrosum", "Tae'gel'kir",
                "Aer'rohgmar", "Borg'helmak", "Caus'tearic", "Dalgo'nizha", "Huut'vactah", "Ignan'kitch", "Jolpat'krim",
                "Bach'usiv'hal", "Danal'korang", "Derr'moran'ki", "Kawee'fe'more", "Kis'an'tadrom", "Korsukgrare",
                "Golgo'nishver", "Tagha'senchal"
            }
        }
    },
    grammar = {
        tensePrefixes = {
            ["present"]    = "",
            ["past"]       = "Rohh-",
            ["future"]     = "Gesh-",
            ["imperative"] = "Thukad-"
        },
        personSuffixes = {
            [1] = "aaz",
            [2] = "roth",
            [3] = "unt",
            [4] = "krah",
            [5] = "nakaz"
        },
        applyElementalMarker = function(root, element)
            if element == "fire" then return root .. "'roth" end
            if element == "earth" then return root .. "'rok" end
            if element == "water" then return root .. "'tiro" end
            if element == "air" then return root .. "'aer" end
            return root
        end
    }
}

local addonName, addon = ...
local Engine = addon.AlgorithmEngine
local Hasher = {}
function Hasher.ProcessText(text)
    return Engine.ProcessText(text, KalimagConfig)
end
addon.KalimagHasher = Hasher
_G.KalimagHasher = Hasher
return Hasher