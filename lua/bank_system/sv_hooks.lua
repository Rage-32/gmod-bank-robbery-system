local endBankRobbery = function()
    for _, ent in ipairs(ents.FindByClass("bank_loot")) do
        BANK_SYSTEM.EndRobbery(ent:GetRobberyStarter(), ent)
        BANK_SYSTEM.StartCooldown(ent)
    end
end

hook.Add("PlayerDeath", "RemoveRaidTimer_Death", function(ply)
    if not ply:GetNWBool("ActiveBankRaid") then return end
    if not BANK_SYSTEM.Config.EndOnDeath then return end

    endBankRobbery()

    DarkRP.notify(ply, 1, 4, BANK_SYSTEM.Config.Phrases.DEATH)
end)

hook.Add("PlayerChangedTeam", "RemoveRaidTimer_TeamChange", function(ply)
    if not ply:GetNWBool("ActiveBankRaid") then return end
    if not BANK_SYSTEM.Config.EndOnChangeTeam then return end

    endBankRobbery()

    DarkRP.notify(ply, 1, 4, BANK_SYSTEM.Phrases.SWITCHTEAM)
end)

hook.Add("playerArrested", "RemoveRaidTimer_Arrested", function(ply)
    if not ply:GetNWBool("ActiveBankRaid") then return end
    if not BANK_SYSTEM.EndOnArrest then return end

    endBankRobbery()

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