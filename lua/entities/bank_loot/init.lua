AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")
include("config.lua")

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

local function NotifyAllCops(msg)
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

local function GetServerCopCount()
    return table.Count(player.GetAll(), function(ply) return BANK_SYSTEM.Config.CopJobs(ply:Team()) end)
end

function BANK_SYSTEM.RunEveryoneConsole(msg)
    for k, v in ipairs(player.GetAll()) do
        v:ConCommand(msg)
    end
end

function ENT:Use(ply)
    if not BANK_SYSTEM.Config.AllowedJobs[ply:Team()] then
        DarkRP.notify(ply, 0, 4, BANK_SYSTEM.Config.Phrases.INCORRECT_JOB)
        return
    end

    if GetServerCopCount() < BANK_SYSTEM.Config.OnlineCops then
        DarkRP.notify(ply, 0, 4, string.format(BANK_SYSTEM.Config.Phrases.TOOFEWCOPS, BANK_SYSTEM.Config.OnlineCops))
        return
    end

    if self:GetIsActiveRaid() or self:GetIsCoolDown() then return end

    DarkRP.notify(ply, 0, 4, BANK_SYSTEM.Config.Phrases.STARTED)
    if BANK_SYSTEM.Config.NotifyCops then
        NotifyAllCops(BANK_SYSTEM.Config.Phrases.BANKRAID)
    end
    
    self:EmitSound("ambient/alarms/alarm1.wav")
    self:SetIsActiveRaid(true)
    ply:SetNWBool("ActiveBankRaid", true)

    timer.Create("BankVaultRaidTimer", BANK_SYSTEM.Config.RobberyTime, 0, function()
        if not self:GetIsActiveRaid() then return end

        self:SetIsActiveRaid(false)
        ply:SetNWBool("ActiveBankRaid", false)
        self:SetTotalMoney(BANK_SYSTEM.Config.MaxReward)

        BANK_SYSTEM.RunEveryoneConsole("stopsound")
        DarkRP.notify(ply, 0, 4, string.format(BANK_SYSTEM.Config.Phrases.PAID, DarkRP.formatMoney(math.floor(self:GetTotalMoney()))))
        
        ply:addMoney(self:GetTotalMoney())
        hook.Run("WKBankRobberyEnded", ply, self, amount)
        
        self:SetIsCoolDown(true)

        timer.Create("BankVaultCooldownTimer", BANK_SYSTEM.Config.RobberyCooldown, 0, function()
            self:SetIsCoolDown(false)
        end)
    end)
end

function ENT:Think()
    if self:GetIsCoolDown() then
        self:SetCoolDown(timer.TimeLeft("BankVaultCooldownTimer"))
    end

    if self:GetIsActiveRaid() then
        self:SetActiveRaidTimer(timer.TimeLeft("BankVaultRaidTimer"))
    end
end

function ENT:OnTakeDamage(damageInfo)
    if not self:GetIsActiveRaid() then return end

    local randomDamage = math.random(1000, 4500)
    self:SetTotalMoney(math.Clamp(self:GetTotalMoney() - randomDamage, -1, 100000))

    if self:GetTotalMoney() == -1 then
        self:SetIsActiveRaid(false)
        self:SetIsCoolDown(true)
        self:SetTotalMoney(BANK_SYSTEM.Config.MaxReward)

        timer.Create("BankVaultCooldownTimer", BANK_SYSTEM.Config.RobberyCooldown, 0, function()
            self:SetIsCoolDown(false)
        end)

        BANK_SYSTEM.RunEveryoneConsole("stopsound")
    end
end