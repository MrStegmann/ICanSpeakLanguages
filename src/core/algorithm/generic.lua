local Config = {
    config = {
        preservePunctuation = true
    },
    matrices = {
        consonants = {
            "B", "C", "D", "F", "G", "H", "J", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "V", "W", "X", "Z",
            "Ash", "Bor", "Dal", "Far", "Gol", "Kar", "Lok", "Mor", "Ras", "Ver",
            "Ador", "Aman", "Bora", "Durn", "Goth", "Kael", "Noth", "Rune", "Thor", "Veld"
        },
        vowels = { "a", "e", "i", "o", "u", "ae", "ea", "io", "ou" },
        endings = { "r", "s", "n", "l", "th", "d", "g", "m", "is", "os", "us", "" }
    },
    lexicon = {
        verbs = {
            ["do"]     = { root = "Ver", tense = "present" },
            ["did"]    = { root = "Ver", tense = "past" },
            ["go"]     = { root = "Lok", tense = "present" },
            ["went"]   = { root = "Lok", tense = "past" },
            ["speak"]  = { root = "Ras", tense = "present" }
        },
        nouns = {
            ["world"]  = { root = "Barad", gender = "neutral", isPlural = false },
            ["worlds"] = { root = "Barad", gender = "neutral", isPlural = true },
            ["friend"] = { root = "Mandos", gender = "masculine", isPlural = false },
            ["power"]  = { root = "Aetwinter", gender = "feminine", isPlural = false }
        },
        fallbacks = {
            -- Lengths 1–3
            short = {
                "A", "E", "I", "O", "U",
                "An", "Ar", "En", "Er", "In", "Is", "Or", "Os", "Un", "Ur",
                "Ash", "Bor", "Dal", "Far", "Gol", "Kar", "Lok", "Mor", "Ras", "Ver"
            },
            -- Lengths 4–6
            medium = {
                "Ador", "Aman", "Bora", "Durn", "Goth", "Kael", "Noth", "Rune", "Thor", "Veld",
                "Algos", "Barad", "Borne", "Garde", "Gloin", "Majis", "Modan", "Regen", "Tiras", "Wirsh",
                "Aesire", "Aziris", "Daegil", "Ealdor", "Mandos", "Nevren", "Rothas", "Valesh", "Vandar", "Waldir"
            },
            -- Lengths 7–12+
            long = {
                "Andovis", "Ewiddan", "Faergas", "Forthis", "Kaelsig", "Lithtos", "Nandige", "Sturume", "Vassild",
                "Aldonoth", "Cynegold", "Endirvis", "Hamerung", "Landowar", "Methrine", "Ruftvess", "Thorniss",
                "Aetwinter", "Danagarde", "Eloderung", "Firalaine", "Gloinador", "Gothalgos", "Regenthor", "Udenmajis",
                "Aelgestron", "Cynewalden", "Danavandar", "Dyrstigost", "Falhedring", "Vastrungen",
                "Agolandovis", "Bornevalesh", "Farlandowar", "Forthasador", "Thorlithtos", "Vassildador",
                "Golveldbarad", "Mandosdaegil", "Nevrenrothas", "Waldirskilde"
            }
        }
    },
    grammar = {
        tensePrefixes = {
            ["present"]    = "",
            ["past"]       = "en-",
            ["future"]     = "ar-",
            ["imperative"] = "or-"
        },
        personSuffixes = {
            [1] = "is",  -- 1st Person Sing
            [2] = "or",  -- 1st Person Plur
            [3] = "en",  -- 2nd Person
            [4] = "as",  -- 3rd Person Sing
            [5] = "um"   -- 3rd Person Plur
        },
        applyNounEnclitic = function(root, gender, isPlural, isDefinite)
            if not isDefinite then return root end
            if isPlural then
                return root .. "en"
            end
            return root .. (gender == "feminine" and "is" or "os")
        end
    }
}

local addonName, addon = ...
local Engine = addon.AlgorithmEngine
local Hasher = {}
function Hasher.ProcessText(text)
    return Engine.ProcessText(text, Config)
end
addon.GenericHasher = Hasher
_G.GenericHasher = Hasher
return Hasher