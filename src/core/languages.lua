local addonName, addon = ...

local wowLanguages = {
    factionLanguages = {
        alliance = {
            { name = "Common", alias = "CO", speakers = "Humans, Gilnean Worgen, Kul Tiran Humans", alphabet = "Common" },
            { name = "Darnassian", alias = "DA", speakers = "Night Elves", alphabet = "Darnassian" },
            { name = "Dwarven", alias = "DW", speakers = "Ironforge Dwarves, Dark Iron Dwarves", alphabet = "Runic" },
            { name = "Gnomish", alias = "GN", speakers = "Gnomes, Mechagnomes", alphabet = "Common" },
            { name = "Draenei", alias = "DR", speakers = "Draenei, Lightforged Draenei", alphabet = "Eredun" },
        },
        horde = {
            { name = "Orcish", alias = "OR", speakers = "Orcs, Mag'har Orcs", alphabet = "Common / Runic" },
            { name = "Zandali", alias = "ZA", speakers = "Darkspear Trolls, Zandalari Trolls", alphabet = "Unknown" },
            { name = "Taur-ahe", alias = "TA", speakers = "Tauren, Highmountain Tauren", alphabet = "Pictoforms" },
            { name = "Gutterspeak", alias = "GU", speakers = "Forsaken Undead", alphabet = "Common" },
            { name = "Thalassian", alias = "TH", speakers = "Blood Elves, High Elves, Void Elves", alphabet = "Darnassian" },
            { name = "Goblin", alias = "GO", speakers = "Bilgewater Goblins", alphabet = "Common" },
            { name = "Shalassian", alias = "SH", speakers = "Nightborne", alphabet = "Darnassian" },
            { name = "Vulpera", alias = "VU", speakers = "Vulpera", alphabet = "Unknown" },
        },
        neutral = {
            { name = "Pandaren", alias = "PA", speakers = "Pandaren (Tushui & Huojin)", alphabet = "Calligraphy" },
        }
    },
    ancientAndCosmic = {
        { name = "Titan", alias = "TI", speakers = "Titans, Titan-forged, Watchers", alphabet = "Runic / Glyphs" },
        { name = "Eredun", alias = "ER", speakers = "Demons, Burning Legion", alphabet = "Eredic" },
        { name = "Shath'Yar", alias = "SY", speakers = "Old Gods, Voidborn, Faceless Ones", alphabet = "Unknown" },
        { name = "Draconic", alias = "DC", speakers = "Dragons, Dracthyr, Dragonkin", alphabet = "Runic" },
        { name = "Nathrezim", alias = "NA", speakers = "Dreadlords", alphabet = "Eredic / Unknown" },
    },
    elemental = {
        { name = "Kalimag", alias = "KA", speakers = "Elementals (General)", alphabet = "Runic" },
    },
    mortalRacesAndSpecies = {
        { name = "Nerglish", alias = "NE", speakers = "Murlocs, Makrura, Mur'gul", alphabet = "Pictoforms" },
        { name = "Nazja", alias = "NZ", speakers = "Naga", alphabet = "Darnassian" },
        { name = "Nerubian", alias = "NR", speakers = "Nerubians", alphabet = "Runic" },
        { name = "Qiraji", alias = "QI", speakers = "Qiraji, Silithid", alphabet = "Unknown" },
        { name = "Mantid", alias = "MA", speakers = "Mantid", alphabet = "Unknown" },
        { name = "Hozen", alias = "HO", speakers = "Hozen", alphabet = "None" },
        { name = "Furbolg (Ursine)", alias = "FU", speakers = "Furbolgs", alphabet = "Pictoforms" },
        { name = "Gnoll", alias = "GL", speakers = "Gnolls", alphabet = "Pictoforms" },
        { name = "Mogu", alias = "MO", speakers = "Mogu", alphabet = "Calligraphy" },
        { name = "Ogre", alias = "OG", speakers = "Ogres", alphabet = "Unknown" },
        { name = "Ravenspeech", alias = "RA", speakers = "Arakkoa", alphabet = "Unknown" },
        { name = "Tuskarr", alias = "TU", speakers = "Tuskarr", alphabet = "Pictoforms" },
        { name = "Vrykul", alias = "VR", speakers = "Vrykul", alphabet = "Runic" },
        { name = "Drogbar", alias = "DB", speakers = "Drogbar", alphabet = "Unknown" },
        { name = "Drust", alias = "DT", speakers = "Drust", alphabet = "Runic" },
        { name = "Tol'vir", alias = "TV", speakers = "Tol'vir", alphabet = "Runic" },
        { name = "Pygmy", alias = "PY", speakers = "Pygmies", alphabet = "Unknown" },
        { name = "Sprite", alias = "SP", speakers = "Sprites, Pixies", alphabet = "Unknown" },
        { name = "Wildkin", alias = "WI", speakers = "Moonkin, Wildkin", alphabet = "Unknown" },
    }
}

addon.Languages = wowLanguages
return wowLanguages