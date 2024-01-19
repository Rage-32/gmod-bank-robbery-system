hook.Add("PlayerDeath", "RemoveRaidTimer_Death", function(ply)
    if not ply:GetNWBool("ActiveBankRaid") then return end
    if not WKBankLootSystem.EndOnDeath then return end

    for k, v in ipairs(ents.FindByClass("bank_loot")) do
        v:SetNWBool("ActiveRaid", false)
        v:SetNWBool("BankVaultCooldownActive", true)
        v:setTotalMoney(WKBankLootSystem.MaxReward)
        timer.Create("BankVaultCooldownTimer", WKBankLootSystem.RobberyCooldown, 0, function()
            v:SetNWBool("BankVaultCooldownActive", false)
        end)
    end

    WKBankLootSystem.RunEveryoneConsole("stopsound")
    ply:SetNWBool("ActiveBankRaid", false)
    DarkRP.notify(ply, 1, 4, WKBankLootSystem.Phrases.DEATH)
end)

hook.Add("PlayerChangedTeam", "RemoveRaidTimer_TeamChange", function(ply)
    if not ply:GetNWBool("ActiveBankRaid") then return end
    if not WKBankLootSystem.EndOnChangeTeam then return end

    for k, v in ipairs(ents.FindByClass("bank_loot")) do
        v:SetNWBool("ActiveRaid", false)
        v:SetNWBool("BankVaultCooldownActive", true)
        v:setTotalMoney(WKBankLootSystem.MaxReward)
        timer.Create("BankVaultCooldownTimer", WKBankLootSystem.RobberyCooldown, 0, function()
            v:SetNWBool("BankVaultCooldownActive", false)
        end)
    end

    WKBankLootSystem.RunEveryoneConsole("stopsound")
    ply:SetNWBool("ActiveBankRaid", false)
    DarkRP.notify(ply, 1, 4, WKBankLootSystem.Phrases.SWITCHTEAM)
end)

hook.Add("playerArrested", "RemoveRaidTimer_Arrested", function(ply)
    if not ply:GetNWBool("ActiveBankRaid") then return end
    if not WKBankLootSystem.EndOnArrest then return end

    for k, v in ipairs(ents.FindByClass("bank_loot")) do
        v:SetNWBool("ActiveRaid", false)
        v:SetNWBool("BankVaultCooldownActive", true)
        v:setTotalMoney(WKBankLootSystem.MaxReward)
        timer.Create("BankVaultCooldownTimer", WKBankLootSystem.RobberyCooldown, 0, function()
            v:SetNWBool("BankVaultCooldownActive", false)
        end)
    end

    WKBankLootSystem.RunEveryoneConsole("stopsound")
    ply:SetNWBool("ActiveBankRaid", false)
    DarkRP.notify(ply, 1, 4, WKBankLootSystem.Phrases.ARRESTED)
end)

hook.Add("PlayerSay", "BankRobberyEndCooldown", function(ply, text)
    if (string.lower(text) == "/" .. WKBankLootSystem.EndCooldownCommand) or (string.lower(text) == "!" .. WKBankLootSystem.EndCooldownCommand) then
        if not WKBankLootSystem.EndCooldownCommandEnabled then return end
        for k, v in ipairs(ents.FindByClass("bank_loot")) do
            v:SetNWBool("BankVaultCooldownActive", false)
        end
        DarkRP.notify(ply, 0, 4, "You have ended all bank robbery cooldowns.")
        return ""
    end
end)