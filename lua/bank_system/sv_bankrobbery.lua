function BANK_SYSTEM.StartRobbery(ply, ent)
    ent:EmitSound("ambient/alarms/alarm1.wav")

    ent:SetRobberyStarter(ply)
    ent:SetIsActiveRaid(true)
    ent:SetActiveRaidTimer(CurTime() + BANK_SYSTEM.Config.RobberyTime)
    ply:SetNWBool("ActiveBankRaid", true)

    hook.Run("BANK_ROBBERY.RobberyStarted", ply, self, ent:GetTotalMoney())
end

function BANK_SYSTEM.EndRobbery(ply, ent)
    ent:SetRobberyStarter(nil)
    ent:SetIsActiveRaid(false)
    ent:SetTotalMoney(BANK_SYSTEM.Config.MaxReward)
    
    ent:SetIsCoolDown(true)
    ent:SetCoolDown(CurTime() + BANK_SYSTEM.Config.RobberyCooldown)

    BANK_SYSTEM.RunEveryoneConsole("stopsound")

    if IsValid(ply) then 
        ply:SetNWBool("ActiveBankRaid", false)
        ply:addMoney(ent:GetTotalMoney())
    end

    hook.Run("BANK_ROBBERY.RobberyEnded", ply, ent)
end

function BANK_SYSTEM.StartCooldown(ent)
    timer.Create("BankVaultCooldownTimer." .. ent:GetCreationID(), BANK_SYSTEM.Config.RobberyCooldown, 0, function()
        if not IsValid(ent) then return end 
        ent:SetIsCoolDown(false)
        ent:SetCoolDown(0)
    end)
end

function BANK_SYSTEM.NotifyAllCops(msg)
    local cops = {}
    local copCount = 0

    for k, v in ipairs(player.GetAll()) do
        if not v:isCP() then continue end
        copCount = copCount + 1
        table.insert(cops, 1, v)
    end

    if copCount >= 1 then
        DarkRP.notify(cops, 0, 4, msg)
    end
end

function BANK_SYSTEM.GetServerCopCount()
    return table.Count(player.GetAll(), function(ply) return BANK_SYSTEM.Config.CopJobs(ply:Team()) end)
end

function BANK_SYSTEM.RunEveryoneConsole(msg)
    for k, v in ipairs(player.GetAll()) do
        v:ConCommand(msg)
    end
end