# I Can Speak Languages

A lightweight, immersive, per-character language and custom chat obfuscation system for players on the **Epsilon Roleplay Server** (World of Warcraft).

Standard World of Warcraft client language mechanisms are rigid, race-locked, or faction-restricted. Custom roleplay characters on Epsilon often require learning foreign tongues, ancient dialects, or secondary languages as part of their character development. **ICanSpeakLanguages** bridges this gap by introducing a flexible, character-bound language system where language knowledge and active speech are completely customizable by the player.

> [!NOTE]
> This addon is specifically designed for the **Epsilon Roleplay Server** environment and utilizes Epsilon's extended features.

## Features

- **Per-Character Language Knowledge:** Configure and persist known World of Azeroth languages (Thalassian, Darnassian, Orcish, Gutterspeak, Draenei, Draconic, Taurahe, etc.) on a per-character basis.
- **Active Language Selection:** A clean UI frame allows players to designate an active spoken language.
- **Real-Time Outgoing Chat Encryption & Obfuscation:** Intercepts outgoing chat messages. If a nearby player does not know the character's active spoken language, text is realistically scrambled using language-specific dictionaries and word-wrapper algorithms.
- **Cross-Client Verification Protocol:** Uses hidden addon messaging to broadcast language metadata so players who know the active language receive unscrambled, native text.
- **Configurable Channel Filtering:** Choose exactly which chat channels should apply language obfuscation.

## Supported Languages

The addon includes specific algorithmic dictionaries for several languages to provide immersive, linguistically accurate scrambling. Others use a fallback generic algorithm.

### Custom Algorithms
- Common
- Darnassian
- Draconic
- Eredun
- Kalimag
- Orcish
- Pandaren
- Shath'Yar
- Thalassian
- Vrykul

### Generic Algorithm
- Dwarven
- Gnomish
- Draenei
- Zandali
- Taur-ahe
- Gutterspeak
- Goblin
- Shalassian
- Vulpera
- Titan
- Nathrezim
- Nerglish
- Nazja
- Nerubian
- Qiraji
- Mantid
- Hozen
- Furbolg (Ursine)
- Gnoll
- Mogu
- Ogre
- Ravenspeech
- Tuskarr
- Drogbar
- Drust
- Tol'vir
- Pygmy
- Sprite
- Wildkin
## Installation

1. Download the latest version of the addon.
2. Extract the `ICanSpeakLanguages` folder.
3. Place the `ICanSpeakLanguages` folder into your World of Warcraft `_retail_\Interface\AddOns\` directory.
4. Launch World of Warcraft and ensure the addon is enabled in the character selection screen.

## Usage

> [!IMPORTANT]
> Make sure the addon is properly loaded by typing `/reload` if you don't see it in-game.

To open the addon's interface, type the following slash command in your chat window:
```text
/icsl
```
*(or `/icanspeak`)*

### Workflow

1. **Manage Knowledge:** In the UI, select the languages your character has learned. These settings are saved per-character.
2. **Speak a Language:** Choose an **Active Language** from the dropdown selector (this is your default language).
3. **Chat:** With the language parser activated, you have two options for speaking:

   **A. Default Language**
   Type in the chat normally without bracket escapes to use your default language (selected by left-clicking the minimap button or in the UI).
   - Example: A Blood Elf speaking Thalassian types `"Greetings, hero."` into `/say`.
   - Players who **know** Thalassian see: `[Thalassian] Greetings, hero.`
   - Players who **do not know** Thalassian see scrambled text: `[Thalassian] An'aniel, shala.`

   **B. Inline Language Tags (Brackets)**
   You can temporarily override your default language for a single message by placing the language name or its alias in brackets `[]` at the start of your text. Aliases can be found alongside the language names in the interface.
   - Example: `[Vrykul] Hello, my little friend!`
   - Example (using alias): `[da] Hello, but now in darnassian using alias`

## Configuration

You can individually enable or disable chat translation filtering for specific channels via UI checkboxes.

- **Default Enabled Channels:** `SAY`, `YELL`, `WHISPER`
- **Optional Channels:** `PARTY`, `RAID`, `RAID_WARNING`
- **Epsilon Specific:** Advanced interception for custom Epsilon NPC chat (`.npc say`, `.npc yell`) is supported.

## UI Controls

A shortcut button is anchored to the top-right of your main Chat Frame for quick access:
- **Left-Click:** Opens the language selection menu to quickly swap your active language, and provides a shortcut to open the main Interface Frame.
- **Right-Click:** Opens the quick configuration menu where you can toggle the parser, Dungeon Master mode, specific channel filters, and language tags.

## Commands

Here is the full list of slash commands available in-game:

### General & Help
- `/ISpeakHelp` - Displays the in-game command list.
- `/HowToSpeak` - Shows a manual on language syntax, inline tags, and mismatch warnings.

### Language Management
- `/ICanSpeak [langName]` - Learns a new language. 
  - *Syntax:* `/ICanSpeak [Language]`
  - *Example:* `/ICanSpeak Thalassian` adds Thalassian to your character's known languages.
- `/IcannotSpeak [langName]` - Removes a language from your known list.
  - *Syntax:* `/IcannotSpeak [Language]`
  - *Example:* `/IcannotSpeak Orcish`
- `/WhatISpeak` - Lists all languages your character currently knows.
- `/WhatCanISpeak` - Lists all available languages in the addon that you haven't learned yet.

### Toggles & Configuration
- `/ISpeak` - Toggles the Active Language Parse on or off entirely.
- `/IAmDM` - Toggles Dungeon Master mode (only available to party/raid leaders).
- `/ShowLangName` - Toggles whether the language name tag is shown in chat messages.

### Channel Filters
Quickly toggle obfuscation for specific chat channels:
- `/SpeakS` - Toggle Say channel
- `/SpeakY` - Toggle Yell channel
- `/SpeakW` - Toggle Whisper channel
- `/SpeakP` - Toggle Party channel
- `/SpeakR` - Toggle Raid channel
- `/SpeakRW` - Toggle Raid Warning channel

_You can support me in https://ko-fi.com/mrstegmann_
