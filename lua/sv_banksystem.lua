hook.Add("PlayerDeath", "RemoveRaidTimer_Death", function(ply)
    if not ply:GetNWBool("ActiveBankRaid") then return end
    if not BANK_SYSTEM.Config.EndOnDeath then return end

    for k, v in ipairs(ents.FindByClass("bank_loot")) do
        v:SetNWBool("ActiveRaid", false)
        v:SetNWBool("BankVaultCooldownActive", true)
        v:setTotalMoney(BANK_SYSTEM.Config.MaxReward)
        timer.Create("BankVaultCooldownTimer", BANK_SYSTEM.Config.RobberyCooldown, 0, function()
            v:SetNWBool("BankVaultCooldownActive", false)
        end)
    end

    BANK_SYSTEM.RunEveryoneConsole("stopsound")
    ply:SetNWBool("ActiveBankRaid", false)
    DarkRP.notify(ply, 1, 4, BANK_SYSTEM.Config.Phrases.DEATH)
end)

hook.Add("PlayerChangedTeam", "RemoveRaidTimer_TeamChange", function(ply)
    if not ply:GetNWBool("ActiveBankRaid") then return end
    if not BANK_SYSTEM.Config.EndOnChangeTeam then return end

    for k, v in ipairs(ents.FindByClass("bank_loot")) do
        v:SetNWBool("ActiveRaid", false)
        v:SetNWBool("BankVaultCooldownActive", true)
        v:setTotalMoney(BANK_SYSTEM.Config.MaxReward)
        timer.Create("BankVaultCooldownTimer", BANK_SYSTEM.Config.RobberyCooldown, 0, function()
            v:SetNWBool("BankVaultCooldownActive", false)
        end)
    end

    BANK_SYSTEM.RunEveryoneConsole("stopsound")
    ply:SetNWBool("ActiveBankRaid", false)
    DarkRP.notify(ply, 1, 4, BANK_SYSTEM.Phrases.SWITCHTEAM)
end)

hook.Add("playerArrested", "RemoveRaidTimer_Arrested", function(ply)
    if not ply:GetNWBool("ActiveBankRaid") then return end
    if not BANK_SYSTEM.EndOnArrest then return end

    for k, v in ipairs(ents.FindByClass("bank_loot")) do
        v:SetNWBool("ActiveRaid", false)
        v:SetNWBool("BankVaultCooldownActive", true)
        v:setTotalMoney(BANK_SYSTEM.MaxReward)
        timer.Create("BankVaultCooldownTimer", BANK_SYSTEM.RobberyCooldown, 0, function()
            v:SetNWBool("BankVaultCooldownActive", false)
        end)
    end

    BANK_SYSTEM.RunEveryoneConsole("stopsound")
    ply:SetNWBool("ActiveBankRaid", false)
    DarkRP.notify(ply, 1, 4, BANK_SYSTEM.Phrases.ARRESTED)
end)

hook.Add("PlayerSay", "BankRobberyEndCooldown", function(ply, text)
    if (string.lower(text) == "/" .. BANK_SYSTEM.EndCooldownCommand) or (string.lower(text) == "!" .. BANK_SYSTEM.EndCooldownCommand) then
        if not BANK_SYSTEM.EndCooldownCommandEnabled then return end
        for k, v in ipairs(ents.FindByClass("bank_loot")) do
            v:SetNWBool("BankVaultCooldownActive", false)
        end
        DarkRP.notify(ply, 0, 4, "You have ended all bank robbery cooldowns.")
        return ""
    end
end)