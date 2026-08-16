
local Config = {
    config = {
        preservePunctuation = true
    },
    matrices = {
        consonants = { 
            "K", "Z", "X", "G", "V", "R", "Th", "Sh", "Grom", "Gul", "Kil",
            "Arch", "Man", "Nez", "Raz", "Zil", "Ash", "Gor", "Maw", "Ruk",
            "Ur", "Kresh", "Sk", "Vr", "Kr", "Zh", "Drak", "Bael", "Az",
            "Kza", "Xul", "Vra", "Goth", "Mal", "Teneb", "Infer", "Dra", "Kha",
            "Zul", "Phar", "Baph", "Vor", "Xar", "Slaa", "Nurg", "Khor", "Tzeen"
        },
        vowels = { 
            "a", "e", "i", "o", "u", "aa", "aza", "oth", "uk", "iz", 
            "ae", "ou", "y", "ua", "izh", "ix", "ox", "ul", "esh", "akh" 
        },
        endings = { 
            "rak", "reth", "gosh", "kosh", "zar", "mon", "garr", "oth", "al", "im", "or", 
            "gor", "xis", "ul", "ash", "ag", "ak", "ish", "zhin", "raka", "thul", "vok", "" 
        }
    },
    lexicon = {
        verbs = {
            ["burn"]       = { root = "Ash",     tense = "present" },
            ["burned"]     = { root = "Ash",     tense = "past" },
            ["destroy"]    = { root = "Gul",     tense = "present" },
            ["destroyed"]  = { root = "Gul",     tense = "past" },
            ["kill"]       = { root = "Kresh",   tense = "present" },
            ["killed"]     = { root = "Kresh",   tense = "past" },
            ["command"]    = { root = "Arch",    tense = "present" },
            ["commanded"]  = { root = "Arch",    tense = "past" },
            ["consume"]    = { root = "Vra",     tense = "present" },
            ["consumed"]   = { root = "Vra",     tense = "past" },
            ["corrupt"]    = { root = "Mal",     tense = "present" },
            ["corrupted"]  = { root = "Mal",     tense = "past" },
            ["bleed"]      = { root = "Khor",    tense = "present" },
            ["summon"]     = { root = "Xul",     tense = "present" },
            ["enslave"]    = { root = "Goth",    tense = "present" },
            ["torture"]    = { root = "Pain",    tense = "present" },
            ["suffer"]     = { root = "Slaa",    tense = "present" },
            ["obliterate"] = { root = "Kza",     tense = "present" }
        },
        nouns = {
            ["demon"]      = { root = "Ered'ruin", gender = "neutral", isPlural = false },
            ["demons"]     = { root = "Ered'ruin", gender = "neutral", isPlural = true },
            ["fire"]       = { root = "Nath",      gender = "neutral", isPlural = false },
            ["blood"]      = { root = "Mannor",    gender = "neutral", isPlural = false },
            ["legion"]     = { root = "Argus",     gender = "neutral", isPlural = false },
            ["soul"]       = { root = "Zil",       gender = "neutral", isPlural = false },
            ["souls"]      = { root = "Zil",       gender = "neutral", isPlural = true },
            ["master"]     = { root = "Kil'jae",   gender = "masculine", isPlural = false },
            ["masters"]    = { root = "Kil'jae",   gender = "masculine", isPlural = true },
            ["chaos"]      = { root = " Nether",   gender = "neutral", isPlural = false },
            ["shadow"]     = { root = "Teneb",     gender = "neutral", isPlural = false },
            ["world"]      = { root = "Draen",     gender = "neutral", isPlural = false },
            ["doom"]       = { root = "Kazzak",    gender = "neutral", isPlural = false },
            ["pit"]        = { root = "Annihil",   gender = "neutral", isPlural = false },
            ["abyss"]      = { root = "Avern",     gender = "neutral", isPlural = false },
            ["hellfire"]   = { root = "Teth",      gender = "neutral", isPlural = false },
            ["fiend"]      = { root = "Baatezu",   gender = "neutral", isPlural = false },
            ["tanarri"]    = { root = "Tanar",     gender = "neutral", isPlural = false }
        },
        fallbacks = {
            short = { 
                "Kash", "Grom", "Zin", "Ruk", "Maw", "Ur", "Gore", "Ash", "Lok", 
                "Xul", "Vra", "Gor", "Kza", "Zhax", "Rha", "Phar", "Bael", "Zul" 
            },
            medium = { 
                "Eredar", "Nethrezim", "Annihilan", "Mo'arg", "Gan'arg", "Shivarra", 
                "Infernus", "Abyssal", "Felguard", "Succubus", "Pitlord", "Imp'mother", 
                "Baatezu", "Tanar'ri", "Yugoloth", "Lemure", "Marilith", "Balor" 
            },
            long = { 
                "Kil'jaeden", "Archimonde", "Sargerai", "Man'ari", "Nathrezim", 
                "Abyssal-Lord", "Twisting-Nether", "Kazzak-Noth", "Demogorgon", 
                "Asmodeus", "Mephistopheles", "Beelzebub", "Graz'zt", "Baphomet" 
            }
        }
    },
    grammar = {
        tensePrefixes = {
            ["present"]    = "",
            ["past"]       = "Khel-",
            ["future"]     = "Zaz-",
            ["imperative"] = "Rukh-",
            ["subjunctive"]= "Xar-"
        },
        personSuffixes = {
            [1] = "al",    -- 1st Person Singular
            [2] = "or",    -- 1st Person Plural
            [3] = "eth",   -- 2nd Person
            [4] = "im",    -- 3rd Person Singular
            [5] = "roth"   -- 3rd Person Plural
        },
        applyNounEnclitic = function(root, gender, isPlural, isDefinite)
            if isPlural then
                root = root .. "i"
            end
            if gender == "masculine" then
                root = root .. "'zar"
            elseif gender == "feminine" then
                root = root .. "'vaz"
            end
            if isDefinite then
                return "Arak-" .. root
            end
            return root
        end
    }
}

local addonName, addon = ...
local Engine = addon.AlgorithmEngine
local Hasher = {}
function Hasher.ProcessText(text)
    return Engine.ProcessText(text, Config)
end
addon.EredunHasher = Hasher
_G.EredunHasher = Hasher
return Hasher