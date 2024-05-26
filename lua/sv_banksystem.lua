local endBankRobbery = function()
    for k, v in ipairs(ents.FindByClass("bank_loot")) do
        v:SetIsActiveRaid(false)
        v:SetIsCoolDown(true)
        v:SetTotalMoney(BANK_SYSTEM.Config.MaxReward)

        timer.Create("BankVaultCooldownTimer", BANK_SYSTEM.Config.RobberyCooldown, 0, function()
            if (not IsValid(v)) then return end
            v:SetIsCoolDown(false)
        end)
    end
end

hook.Add("PlayerDeath", "RemoveRaidTimer_Death", function(ply)
    if not ply:GetNWBool("ActiveBankRaid") then return end
    if not BANK_SYSTEM.Config.EndOnDeath then return end

    endBankRobbery()

    BANK_SYSTEM.RunEveryoneConsole("stopsound")
    ply:SetNWBool("ActiveBankRaid", false)
    DarkRP.notify(ply, 1, 4, BANK_SYSTEM.Config.Phrases.DEATH)
end)

hook.Add("PlayerChangedTeam", "RemoveRaidTimer_TeamChange", function(ply)
    if not ply:GetNWBool("ActiveBankRaid") then return end
    if not BANK_SYSTEM.Config.EndOnChangeTeam then return end

    endBankRobbery()

    BANK_SYSTEM.RunEveryoneConsole("stopsound")
    ply:SetNWBool("ActiveBankRaid", false)
    DarkRP.notify(ply, 1, 4, BANK_SYSTEM.Phrases.SWITCHTEAM)
end)

hook.Add("playerArrested", "RemoveRaidTimer_Arrested", function(ply)
    if not ply:GetNWBool("ActiveBankRaid") then return end
    if not BANK_SYSTEM.EndOnArrest then return end

    endBankRobbery()

    BANK_SYSTEM.RunEveryoneConsole("stopsound")
    ply:SetNWBool("ActiveBankRaid", false)
    DarkRP.notify(ply, 1, 4, BANK_SYSTEM.Phrases.ARRESTED)
end)

hook.Add("PlayerSay", "BankRobberyEndCooldown", function(ply, text)
    if (string.lower(text) == string.lower(BANK_SYSTEM.EndCooldownCommand)) and (BANK_SYSTEM.EndCooldownCommandUsergroups[ply:GetUserGroup()]) then
        if not BANK_SYSTEM.EndCooldownCommandEnabled then return end
        for k, v in ipairs(ents.FindByClass("bank_loot")) do
            v:SetIsCoolDown(false)
            v:SetCoolDown(0)
        end
        DarkRP.notify(ply, 0, 4, "You have ended all bank robbery cooldowns.")
        return ""
    end
end)