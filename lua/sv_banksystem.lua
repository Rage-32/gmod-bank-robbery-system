hook.Add("PlayerDeath", "RemoveRaidTimer_Death", function(ply)
    if not ply:GetNWBool("ActiveBankRaid") then return end

    for k, v in ipairs(ents.FindByClass("bank_loot")) do
        v:SetNWBool("ActiveRaid", false)
    end

    WKBankLootSystem.RunEveryoneConsole("stopsound")
    ply:SetNWBool("ActiveBankRaid", false)
    DarkRP.notify(ply, 1, 4, "You died! You have failed the bank raid.")
end)

hook.Add("PlayerChangedTeam", "RemoveRaidTimer_TeamChange", function(ply)
    if not ply:GetNWBool("ActiveBankRaid") then return end

    for k, v in ipairs(ents.FindByClass("bank_loot")) do
        v:SetNWBool("ActiveRaid", false)
    end

    WKBankLootSystem.RunEveryoneConsole("stopsound")
    ply:SetNWBool("ActiveBankRaid", false)
    DarkRP.notify(ply, 1, 4, "You switched teams! You have failed the bank raid.")
end)

hook.Add("playerArrested", "RemoveRaidTimer_Arrested", function(ply)
    if not ply:GetNWBool("ActiveBankRaid") then return end

    for k, v in ipairs(ents.FindByClass("bank_loot")) do
        v:SetNWBool("ActiveRaid", false)
    end

    WKBankLootSystem.RunEveryoneConsole("stopsound")
    ply:SetNWBool("ActiveBankRaid", false)
    DarkRP.notify(ply, 1, 4, "You have been arrested! You have failed the bank raid.")
end)