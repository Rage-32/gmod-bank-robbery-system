ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "Bank Loot"
ENT.Author = "Rage"
ENT.Category = "RP Entities"
ENT.Spawnable = true
ENT.AdminSpawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "IsCoolDown")
	self:NetworkVar("Int", 1, "CoolDown")
	self:NetworkVar("Int", 2, "ActiveRaidTimer")
	self:NetworkVar("Bool", 1, "IsActiveRaid")
	self:NetworkVar("Int", 3, "TotalMoney")
	self:NetworkVar("Entity", 1, "RobberyStarter")
end