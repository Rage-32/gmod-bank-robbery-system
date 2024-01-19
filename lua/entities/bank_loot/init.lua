AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")
include("config.lua")

WKBankLootSystem = WKBankLootSystem or {}

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

    self:SetNWInt("BankVaultTotalMoney", WKBankLootSystem.MaxReward)
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
    return table.Count(player.GetAll(), function(ply) return WKBankLootSystem.AllowedJobs(ply:Team()) end)
end

function WKBankLootSystem.RunEveryoneConsole(msg)
    for k, v in ipairs(player.GetAll()) do
        v:ConCommand(msg)
    end
end

function ENT:Use(ply)
    if not WKBankLootSystem.AllowedJobs[ply:Team()] then
        DarkRP.notify(ply, 0, 4, WKBankLootSystem.Phrases.INCORRECT_JOB)
        return
    end

    if GetServerCopCount() < WKBankLootSystem.OnlineCops then
        DarkRP.notify(ply, 0, 4, string.format(WKBankLootSystem.Phrases.TOOFEWCOPS, WKBankLootSystem.OnlineCops))
        return
    end

    if self:IsActiveRaid() or self:IsOnCoolDown() then return end

    DarkRP.notify(ply, 0, 4, WKBankLootSystem.Phrases.STARTED)
    if WKBankLootSystem.NotifyCops then
        NotifyAllCops(WKBankLootSystem.Phrases.BANKRAID)
    end
    
    self:EmitSound("ambient/alarms/alarm1.wav")
    self:SetNWBool("ActiveRaid", true)
    ply:SetNWBool("ActiveBankRaid", true)

    timer.Create("BankVaultRaidTimer", WKBankLootSystem.RobberyTime, 0, function()
        if not self:IsActiveRaid() then return end
        self:SetNWBool("ActiveRaid", false)
        ply:SetNWBool("ActiveBankRaid", false)
        self:setTotalMoney(WKBankLootSystem.MaxReward)
        WKBankLootSystem.RunEveryoneConsole("stopsound")
        DarkRP.notify(ply, 0, 4, string.format(WKBankLootSystem.Phrases.PAID, DarkRP.formatMoney(math.floor(self:TotalMoney()))))
        ply:addMoney(self:TotalMoney())
        hook.Run("WKBankRobberyEnded", ply, self, amount)
        self:SetNWBool("BankVaultCooldownActive", true)

        timer.Create("BankVaultCooldownTimer", WKBankLootSystem.RobberyCooldown, 0, function()
            self:SetNWBool("BankVaultCooldownActive", false)
        end)
    end)
end

function ENT:Think()
    if self:IsOnCoolDown() then
        self:SetNWInt("BankVaultCooldownTimer", timer.TimeLeft("BankVaultCooldownTimer"))
    end

    if self:IsActiveRaid() then
        self:SetNWInt("BankVaultRaidActiveTimer", timer.TimeLeft("BankVaultRaidTimer"))
    end
end

function ENT:OnTakeDamage(damageInfo)
    if not self:IsActiveRaid() then return end
    local randomDamage = math.random(1000, 4500)
    self:setTotalMoney(self:GetNWInt("BankVaultTotalMoney") - randomDamage)

    if self:TotalMoney() <= 0 then
        self:SetNWBool("BankVaultCooldownActive", true)
        self:SetNWBool("ActiveRaid", false)
        self:setTotalMoney(WKBankLootSystem.MaxReward)
        WKBankLootSystem.RunEveryoneConsole("stopsound")

        timer.Create("BankVaultCooldownTimer", 1800, 0, function()
            self:SetNWBool("BankVaultCooldownActive", false)
        end)
    end
end