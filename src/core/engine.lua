local addonName, addon = ...

addon.Engine = addon.Engine or {}
local Engine = addon.Engine

-- Engine namespace proxy for backward compatibility across other UI components
Engine.CanUseDungeonMaster = addon.Validators.CanUseDungeonMaster
Engine.IsDungeonMasterActive = addon.Validators.IsDungeonMasterActive

Engine.ResolveLanguageTag = addon.Language.ResolveLanguageTag
Engine.getLanguageTyped = addon.Language.GetLanguageTyped
Engine.GetLanguageTyped = addon.Language.GetLanguageTyped

Engine.BroadcastSpokenLanguage = addon.Broadcast.BroadcastSpokenLanguage
Engine.WrapText = addon.Text.WrapText
Engine.ProcessText = addon.Text.ProcessText
