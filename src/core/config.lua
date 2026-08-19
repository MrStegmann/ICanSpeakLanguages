local addonName, addon = ...

addon.Config = {
    DEFAULT_MAX_LINE_LENGTH = 255,
    DEFAULT_CHANNELS = {
        whisper = true,
        say = true,
        yell = true,
        group = false,
        raid = false,
        raidWarning = false
    },
    DEFAULT_SETTINGS = {
        enabled = false,
        dungeonMaster = false,
        showLanguageInChat = true
    }
}
