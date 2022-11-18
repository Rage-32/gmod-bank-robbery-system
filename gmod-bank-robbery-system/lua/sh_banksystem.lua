BANK_SYSTEM = BANK_SYSTEM or {}

function BANK_SYSTEM.Print(msg)
    MsgC(Color(32, 154, 214), "Bank Robbery System | ", color_white, msg, "\n")
end

BANK_SYSTEM.Print("Loaded Shared Core File")