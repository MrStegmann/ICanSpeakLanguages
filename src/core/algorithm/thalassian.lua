local Config = {
    config = {
        preservePunctuation = true
    },
    matrices = {
        consonants = {
            "Th", "Sh", "F", "S", "D", "R", "L", "K", "Z", "M", "N", "B", "V", "C", "G", "P", "T",
            "Quel", "Thal", "Sin", "Sun", "Anar", "Bel", "Lor", "Anu", "Balah", "Shari", "Talah", 
            "Eburi", "Kael", "Fal", "Aman", "Bandu", "Dath", "Diel", "Dieb", "Eth", "Fandu", 
            "Ish", "Man", "Mush", "Neph", "Rini", "Shar", "Thero", "Tur", "Uphol"
        },
        vowels = { "a", "e", "i", "o", "u", "ae", "ai", "ei", "ani", "ë", "ä", "ö", "ëa", "ië", "uë" },
        endings = { 
            "r", "l", "s", "h", "n", "", "sh", "ras", "sil", "dor", "del", "dorei", "ore", "lah", 
            "dar", "nal", "nis", "nad", "mushal", "shando", "therod", "thera", "adune", "badu"
        }
    },
    lexicon = {
        verbs = {
            ["remember"]   = { root = "Anar",   tense = "present" },
            ["remembered"] = { root = "Anar",   tense = "past" },
            ["vanquish"]   = { root = "Bandu",  tense = "present" },
            ["shine"]      = { root = "Belor",  tense = "present" },
            ["protect"]    = { root = "Thera",  tense = "present" },
            ["protected"]  = { root = "Thera",  tense = "past" },
            ["guide"]      = { root = "Shando", tense = "present" },
            ["guided"]     = { root = "Shando", tense = "past" },
            ["endure"]     = { root = "Talah",  tense = "present" },
            ["endured"]    = { root = "Talah",  tense = "past" },
            ["conquer"]    = { root = "Fandu",  tense = "present" },
            ["conquered"]  = { root = "Fandu",  tense = "past" },
            ["honor"]      = { root = "Adore",  tense = "present" },
            ["honored"]    = { root = "Adore",  tense = "past" },
            ["bless"]      = { root = "Balah",  tense = "present" },
            ["blessed"]    = { root = "Balah",  tense = "past" },
            ["illuminate"] = { root = "Dath",   tense = "present" },
            ["fight"]      = { root = "Shar",   tense = "present" },
            ["fought"]     = { root = "Shar",   tense = "past" }
        },
        nouns = {
            ["sun"]          = { root = "Anar",        gender = "masculine", isPlural = false },
            ["suns"]         = { root = "Anar",        gender = "masculine", isPlural = true },
            ["blood"]        = { root = "Sin",         gender = "neutral",   isPlural = false },
            ["elf"]          = { root = "Dorei",       gender = "neutral",   isPlural = false },
            ["elves"]        = { root = "Dorei",       gender = "neutral",   isPlural = true },
            ["day"]          = { root = "Belore",      gender = "masculine", isPlural = false },
            ["days"]         = { root = "Belore",      gender = "masculine", isPlural = true },
            ["master"]       = { root = "Shando",      gender = "masculine", isPlural = false },
            ["masters"]      = { root = "Shando",      gender = "masculine", isPlural = true },
            ["student"]      = { root = "Thero",       gender = "neutral",   isPlural = false },
            ["students"]     = { root = "Thero",       gender = "neutral",   isPlural = true },
            ["friend"]       = { root = "Elun",        gender = "neutral",   isPlural = false },
            ["friends"]      = { root = "Elun",        gender = "neutral",   isPlural = true },
            ["glory"]        = { root = "Alcar",       gender = "feminine",  isPlural = false },
            ["light"]        = { root = "Cálë",        gender = "feminine",  isPlural = false },
            ["star"]         = { root = "Elen",        gender = "neutral",   isPlural = false },
            ["stars"]        = { root = "Elen",        gender = "neutral",   isPlural = true },
            ["gold"]         = { root = "Laur",        gender = "neutral",   isPlural = false },
            ["heart"]        = { root = "Öre",         gender = "neutral",   isPlural = false },
            ["hearts"]       = { root = "Öre",         gender = "neutral",   isPlural = true },
            ["kingdom"]      = { root = "Nórë",        gender = "feminine",  isPlural = false },
            ["kingdoms"]     = { root = "Nórë",        gender = "feminine",  isPlural = true },
            ["shadow"]       = { root = "Lóme",        gender = "masculine", isPlural = false },
            ["shadows"]      = { root = "Lóme",        gender = "masculine", isPlural = true },
            ["flame"]        = { root = "Nár",         gender = "masculine", isPlural = false },
            ["flames"]       = { root = "Nár",         gender = "masculine", isPlural = true }
        },
        fallbacks = {
            short = { 
                "Anar", "Balah", "Bel", "Dath", "Dore", "Fandu", "Ishnu", "Shano", "Talah",
                "Adore", "Ainu", "Aman", "Andu", "Anu", "Bandu", "Dieb", "Diel", "Eburi",
                "Fulo", "Mush", "Rini", "Shar", "Shari", "Terro", "Thera", "Thus", "Turus"
            },
            medium = { 
                "Belore", "Dorini", "Ethala", "Fallah", "Ishura", "Shando", "Thera", "Turus",
                "Aican", "Alcara", "Almári", "Anaróre", "Asto're", "Anoduna", "Alah'ni", "Carnil",
                "Dor'Ano", "Eldali", "Isilme", "Laurëa", "Máriëa", "Mandalas", "Nórëa", "Quessëa",
                "Ranyali", "Silmari", "Shan're", "Tirino", "Thero'shan", "U'phol"
            },
            long = { 
                "Sin'dorei", "Quel'dorei", "Anu'dorannador", "Shindu'fallah'na", "Thoribas'no'thera",
                "Alcarinqandaro", "Almáriëandaro", "Anarórëandaron", "Ando'meth'derador",
                "Anu'dorinni'talah", "Ash'therod", "Banthalos", "Dath'anar", "Dor'ana'badu",
                "Dorados'no", "Dune'adah", "Eraburis", "Esh'thero'mannash", "Fala'andu", "Fandu'talah",
                "Il'amare", "Isera'duna", "Neph'anis", "Shar'adore", "Shari'adune", "Shari'fal",
                "T'ase'mushal", "Thori'dal", "Turus'il'amare", "U'phol'belore"
            }
        }
    },
    grammar = {
        tensePrefixes = {
            ["present"]    = "",
            ["past"]       = "Anu-",
            ["future"]     = "Shari-",
            ["imperative"] = "Bandu-"
        },
        personSuffixes = {
            [1] = "ne",
            [2] = "na",
            [3] = "dal",
            [4] = "dor",
            [5] = "duna"
        }
    }
}

local addonName, addon = ...
local Engine = addon.AlgorithmEngine
local Hasher = {}
function Hasher.ProcessText(text)
    return Engine.ProcessText(text, Config)
end
addon.ThalassianHasher = Hasher
_G.ThalassianHasher = Hasher
return Hasher