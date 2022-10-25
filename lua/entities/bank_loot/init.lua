AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

WKBankLootSystem = {}

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

    self:SetNWInt("BankVaultTotalMoney", 100000)
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

function WKBankLootSystem.RunEveryoneConsole(msg)
    for k, v in ipairs(player.GetAll()) do
        v:ConCommand(msg)
    end
end

local allowedJobs = {
    [TEAM_PROTHIEF] = true,
    [TEAM_THIEF] = true,
    [TEAM_HACKER] = true,
    [TEAM_FREERUNNER] = true
}

local debugMode = false

function ENT:Use(ply)
    if player.GetCount() <= 3 and not debugMode then
        DarkRP.notify(ply, 0, 4, "Must be atleast 3 cops online to rob the bank.")

        return
    end

    if self:IsActiveRaid() or self:IsOnCoolDown() then return end

    if not allowedJobs[ply:Team()] and not debugMode then
        DarkRP.notify(ply, 0, 4, "You are the incorrect job for this.")

        return
    end

    DarkRP.notify(ply, 0, 4, "You have started a bank raid!")
    NotifyAllCops("The bank is being raided! Go try and save it from those criminals!")
    self:EmitSound("ambient/alarms/alarm1.wav")
    self:SetNWBool("ActiveRaid", true)
    ply:SetNWBool("ActiveBankRaid", true)
    hook.Run("WKBankRobberyStarted", ply, self)

    timer.Create("BankVaultRaidTimer", 300, 0, function()
        if not self:IsActiveRaid() then return end
        self:SetNWBool("ActiveRaid", false)
        ply:SetNWBool("ActiveBankRaid", false)
        self:SetNWBool("BankVaultCooldownActive", true)
        self:setTotalMoney(100000)
        WKBankLootSystem.RunEveryoneConsole("stopsound")
        local winAmount = self:TotalMoney() / 1.32
        DarkRP.notify(ply, 0, 4, "You have been paid " .. DarkRP.formatMoney(math.floor(winAmount) .. " for successfully robbing the bank vault!"))
        ply:addMoney(math.floor(winAmount))
        hook.Run("WKBankRobberyEnded", ply, self, amount)

        timer.Create("BankVaultCooldownTimer", 1800, 0, function()
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
    local randomDamage = math.random(1000, 4500) -- 1000, 4500
    self:setTotalMoney(self:GetNWInt("BankVaultTotalMoney") - randomDamage)

    if self:TotalMoney() <= 0 then
        self:SetNWBool("BankVaultCooldownActive", true)

        timer.Create("BankVaultCooldownTimer", 1800, 0, function()
            self:SetNWBool("BankVaultCooldownActive", false)
        end)

        self:SetNWBool("ActiveRaid", false)
        self:setTotalMoney(100000)
        -- hook.Run("WKBankRobberyEnded", self)
        WKBankLootSystem.RunEveryoneConsole("stopsound")
    end
end