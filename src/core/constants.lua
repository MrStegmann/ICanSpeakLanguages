local addonName, addon = ...

addon.Constants = {
    ADDON_PREFIX = "ICSL_LANG",
    
    PARSER_GLOBAL_NAMES = {
        ["common"]      = "CommonLanguageParser",
        ["draconic"]    = "DraconicLanguageParser",
        ["draenei"]     = "DraeneiLanguageParser",
        ["dwarven"]     = "DwarvenLanguageParser",
        ["eredun"]      = "EredunLanguageParser",
        ["generic"]     = "GenericFallbackLanguageParser",
        ["gnomish"]     = "GnomishLanguageParser",
        ["gutterspeak"] = "GutterspeakLanguageParser",
        ["kalimag"]     = "KalimagLanguageParser",
        ["orcish"]      = "OrcishLanguageParser",
        ["pandaren"]    = "PandarenLanguageParser",
        ["shathyar"]    = "ShathYarLanguageParser",
        ["sathyar"]     = "SathyarParser",
        ["taurahe"]     = "TauraheLanguageParser",
        ["thalassian"]  = "ThalassianLanguageParser",
        ["zandali"]     = "ZandaliLanguageParser",
    },

    CHAT_EVENTS = {
        "CHAT_MSG_SAY",
        "CHAT_MSG_YELL",
        "CHAT_MSG_WHISPER",
        "CHAT_MSG_PARTY",
        "CHAT_MSG_PARTY_LEADER",
        "CHAT_MSG_RAID",
        "CHAT_MSG_RAID_LEADER",
        "CHAT_MSG_RAID_WARNING",
        "CHAT_MSG_CHANNEL",
        "CHAT_MSG_MONSTER_SAY",
        "CHAT_MSG_MONSTER_YELL",
        "CHAT_MSG_MONSTER_WHISPER",
        "CHAT_MSG_MONSTER_EMOTE"
    }
}
