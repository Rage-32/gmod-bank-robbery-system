BANK_SYSTEM = BANK_SYSTEM or {}

function BANK_SYSTEM.Print(msg)
    MsgC(Color(32, 154, 214), "Bank Robbery System | ", color_white, msg, "\n")
end

BANK_SYSTEM.IncludeSV = (SERVER) and include or function() end
BANK_SYSTEM.IncludeSH = function(file) AddCSLuaFile(file) return include(file) end

BANK_SYSTEM.Print("Initializing...")

hook.Add("PostGamemodeLoaded", "BANK_SYSTEM.Load", function()
    BANK_SYSTEM.IncludeSH("config.lua")
    BANK_SYSTEM.IncludeSV("bank_system/sv_bankrobbery.lua")
    BANK_SYSTEM.IncludeSV("bank_system/sv_hooks.lua")
end)

BANK_SYSTEM.Print("Finished loading!")
