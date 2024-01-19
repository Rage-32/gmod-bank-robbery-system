if SERVER then
    include("sv_banksystem.lua")
    include("sh_banksystem.lua")
    BANK_SYSTEM.Print("Loaded Server Core Files")
end