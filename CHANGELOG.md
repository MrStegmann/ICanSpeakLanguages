## 1.0.1 - 2026-08-19

### Fixes
- Fixed a bug where missing saved languages could cause script errors
- Added strict disabled states to "Activate Languages" toggle when zero languages are saved
- Corrected default values and initialization for channels and settings
- Updated README formatting to use tables for language lists

## 1.0.0 - 2026-08-16

### Features
- Initial release of ICanSpeakLanguages addon for Epsilon Roleplay Server
- Per-character language knowledge configuration
- Active language selection UI
- Real-time outgoing chat encryption and obfuscation algorithms
- Custom algorithms for Common, Darnassian, Draconic, Eredun, Kalimag, Orcish, Pandaren, Shath'Yar, Thalassian, and Vrykul
- Fallback generic algorithm for 29+ other Warcraft languages
- Cross-client verification protocol via addon messaging
- Configurable chat channel filtering (Say, Yell, Whisper, Party, Raid, Raid Warning)
- Integration with Epsilon NPC custom chat (`.npc say`, `.npc yell`)
