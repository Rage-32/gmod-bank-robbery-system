AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props/cs_assault/moneypallet.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    local physics = self:GetPhysicsObject()

    if physics:IsValid() then
        physics:Wake()
        physics:EnableMotion(true)
    end
    
    self:SetTotalMoney(BANK_SYSTEM.Config.MaxReward)
end

function ENT:Use(ply)
    if self:GetIsActiveRaid() or self:GetIsCoolDown() then return end

    if not BANK_SYSTEM.Config.AllowedJobs[ply:Team()] then
        DarkRP.notify(ply, 0, 4, BANK_SYSTEM.Config.Phrases.INCORRECT_JOB)
        return
    end

    if BANK_SYSTEM.GetServerCopCount() < BANK_SYSTEM.Config.OnlineCops then
        DarkRP.notify(ply, 0, 4, string.format(BANK_SYSTEM.Config.Phrases.TOOFEWCOPS, BANK_SYSTEM.Config.OnlineCops))
        return
    end

    DarkRP.notify(ply, 0, 4, BANK_SYSTEM.Config.Phrases.STARTED)

    if BANK_SYSTEM.Config.NotifyCops then
        BANK_SYSTEM.NotifyAllCops(BANK_SYSTEM.Config.Phrases.BANKRAID)
    end
    
    BANK_SYSTEM.StartRobbery(ply, self)

    timer.Create("BankVaultRaidTimer." .. self:GetCreationID(), BANK_SYSTEM.Config.RobberyTime, 0, function()
        if not IsValid(self) then return end
        if not self:GetIsActiveRaid() then return end

        if IsValid(ply) then
            DarkRP.notify(ply, 0, 4, string.format(BANK_SYSTEM.Config.Phrases.PAID, DarkRP.formatMoney(math.floor(self:GetTotalMoney()))))
        end

        BANK_SYSTEM.EndRobbery(ply, self)
        BANK_SYSTEM.StartCooldown(self)
    end)
end

function ENT:OnTakeDamage(damageInfo)
    if not self:GetIsActiveRaid() then return end
    if not IsValid(damageInfo:GetAttacker()) then return end

    local randomDamage = math.random(1000, 4500)
    self:SetTotalMoney(math.Clamp(self:GetTotalMoney() - randomDamage, -1, BANK_SYSTEM.Config.MaxReward))

    if self:GetTotalMoney() <= -1 then
        BANK_SYSTEM.EndRobbery(self:GetRobberyStarter(), self)
    end
end