local addonName, addon = ...

addon.RegExp = {
    -- Match [ Language ] and capture the Language name inside
    TAG_CAPTURE = "%[%s*([^%]]+)%s*%]",
    
    -- Match [Language] and any trailing spaces (used for splitting/cleaning)
    TAG_PATTERN = "%[[^%]]+%]%s*",
    
    -- Epsilon NPC commands
    NPC_SAY = "^%s*%.[nN][pP][cC]%s+[sS][aA][yY]%s+",
    NPC_YELL = "^%s*%.[nN][pP][cC]%s+[yY][eE][lL][lL]%s+",
    
    -- Epsilon NPC command capture groups (Prefix, Message)
    NPC_SAY_CAPTURE = "^(%s*%.[nN][pP][cC]%s+[sS][aA][yY]%s+)(.*)$",
    NPC_YELL_CAPTURE = "^(%s*%.[nN][pP][cC]%s+[yY][eE][lL][lL]%s+)(.*)$",
    
    -- Ignore commands starting with . / or !
    CMD_IGNORE = "^[%.%/%!]", 
}
