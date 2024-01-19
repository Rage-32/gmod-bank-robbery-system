WKBankLootSystem = WKBankLootSystem or {}

WKBankLootSystem.MaxReward = 10000 -- Max reward a player can get from robbing a bank

WKBankLootSystem.OnlineCops = 3 -- How many cops have to be online in order for a player to start a robbery

WKBankLootSystem.RobberyTime = 180 -- Time until the bank robbery ends
WKBankLootSystem.RobberyCooldown = 900 -- Time until another robbery can be started

WKBankLootSystem.NotifyCops = true -- Notify all online cops that the bank is being robbed
WKBankLootSystem.EndOnDeath = true -- End the robbery if the person who started it dies?
WKBankLootSystem.EndOnChangeTeam = true -- End the robbery if the person who started it switches teams?
WKBankLootSystem.EndOnArrest = true -- End the robbery if the person who started it gets arrested?

WKBankLootSystem.EndCooldownCommandEnabled = true -- Enable/disable the end cooldown command
WKBankLootSystem.EndCooldownCommand = "endcooldown" -- Command to end the cooldown (!!DONT ADD / or !, IT IS AUTOMATICALLY ADDED!!)

WKBankLootSystem.AllowedJobs = { -- Allowed jobs to start a robbery
    [TEAM_CITIZEN] = true,
    [TEAM_GANG] = true,
    [TEAM_MOB] = true,
}

WKBankLootSystem.Phrases = {
    INCORRECT_JOB = "You are the incorrect job for this.",
    TOOFEWCOPS = "Must be atleast %s cops online to rob the bank.",
    BANKRAID = "The bank is being raided! Go try and save it from those criminals!",
    PAID = "You have been paid %s for successfully robbing the bank vault!",
    STARTED = "You have started a bank raid!",

    DEATH = "You died! You have failed the bank raid.",
    SWITCHTEAM = "You switched teams! You have failed the bank raid.",
    ARRESTED = "You have been arrested! You have failed the bank raid."
}