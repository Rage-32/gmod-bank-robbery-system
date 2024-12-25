BANK_SYSTEM.Config = BANK_SYSTEM.Config or {}

BANK_SYSTEM.Config.MaxReward = 100000 -- Max reward a player can get from robbing a bank

BANK_SYSTEM.Config.OnlineCops = 5 -- How many cops have to be online in order for a player to start a robbery

BANK_SYSTEM.Config.RobberyTime = 300 -- Seconds until the bank robbery ends 
BANK_SYSTEM.Config.RobberyCooldown = 600 -- Seconds until another robbery can be started

BANK_SYSTEM.Config.NotifyCops = true -- Notify all online cops that the bank is being robbed
BANK_SYSTEM.Config.EndOnDeath = true -- End the robbery if the person who started it dies?
BANK_SYSTEM.Config.EndOnChangeTeam = true -- End the robbery if the person who started it switches teams?
BANK_SYSTEM.Config.EndOnArrest = true -- End the robbery if the person who started it gets arrested?

BANK_SYSTEM.EndCooldownCommandEnabled = true -- Enable/disable the end cooldown command
BANK_SYSTEM.EndCooldownCommand = "/endcooldown" -- Command to end the cooldown
BANK_SYSTEM.EndCooldownCommandUsergroups = {
    ["superadmin"] = true
}

BANK_SYSTEM.Config.CopJobs = { -- Jobs that count as police (count towards BANK_SYSTEM.Config.OnlineCops)
    [TEAM_POLICE] = true
}

BANK_SYSTEM.Config.AllowedJobs = { -- Allowed jobs to start a robbery
    [TEAM_CITIZEN] = true
}

BANK_SYSTEM.Config.Phrases = {
    INCORRECT_JOB = "You are the incorrect job for this.",
    TOOFEWCOPS = "Must be atleast %s cops online to rob the bank.",
    BANKRAID = "The bank is being raided! Go try and save it from those criminals!",
    PAID = "You have been paid %s for successfully robbing the bank vault!",
    STARTED = "You have started a bank raid!",

    DEATH = "You died! You have failed the bank raid.",
    SWITCHTEAM = "You switched teams! You have failed the bank raid.",
    ARRESTED = "You have been arrested! You have failed the bank raid."
}