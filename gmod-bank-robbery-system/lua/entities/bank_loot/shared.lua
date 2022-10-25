ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "Bank Loot"
ENT.Author = "Rage"
ENT.Category = "RP Entities"
ENT.Spawnable = true
ENT.AdminSpawnable = true

function ENT:IsOnCoolDown()
    return self:GetNWBool("BankVaultCooldownActive")
end

function ENT:GetCoolDown()
    if not self:GetNWBool("BankVaultCooldownActive") then return end
    return math.floor(self:GetNWInt("BankVaultCooldownTimer"))
end

function ENT:GetActiveRaidTimer()
    if not self:GetNWBool("ActiveRaid") then return end
    return math.floor(self:GetNWInt("BankVaultRaidActiveTimer"))
end

function ENT:IsActiveRaid()
    return self:GetNWBool("ActiveRaid")
end

function ENT:TotalMoney()
    return self:GetNWBool("BankVaultTotalMoney")
end

function ENT:setTotalMoney(amount)
    return self:SetNWBool("BankVaultTotalMoney", amount)
end