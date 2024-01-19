include("shared.lua")

surface.CreateFont("TheDefaultSettings", {
	font = "Arial", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 85,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

local function formatRelativeTime(seconds)
    local minute = 60
    local hour = 60 * minute
    local day = 24 * hour

    if seconds < minute then
        return seconds .. " second" .. (seconds ~= 1 and "s" or "")
    elseif seconds < hour then
        local minutes = math.floor(seconds / minute)
        return minutes .. " minute" .. (minutes ~= 1 and "s" or "")
    elseif seconds < day then
        local hours = math.floor(seconds / hour)
        return hours .. " hour" .. (hours ~= 1 and "s" or "")
    else
        local days = math.floor(seconds / day)
        return days .. " day" .. (days ~= 1 and "s" or "")
    end
end

function ENT:Draw()
    self:DrawModel()
    if self:GetPos():DistToSqr(LocalPlayer():GetPos()) > 1010000 then return end
    local eye_angles = LocalPlayer():EyeAngles()
    local posx = 850
    local posy = 200
    cam.Start3D2D(self:GetPos(), Angle(0, eye_angles.y - 90, 90), 0.1)
    draw.RoundedBox(0, -250, 100 / 100 - 990, 510, posy, Color(10, 10, 10, 230))

    if self:IsActiveRaid() then
        draw.RoundedBox(0, -270, 100 / 100 - 1200, 550, posy, Color(10, 10, 10, 230))
        draw.SimpleText("Active Raid", "TheDefaultSettings", 0, 100 / 100 - 1135, Color(255, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(formatRelativeTime(self:GetActiveRaidTimer()), "TheDefaultSettings", 0, 100 / 100 - 1050, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    if self:IsOnCoolDown() then
        draw.RoundedBox(0, -350, 100 / 100 - 1200, 715, posy, Color(10, 10, 10, 230))
        draw.SimpleText("Robbery Cooldown", "TheDefaultSettings", 0, 100 / 100 - 1135, Color(255, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        local length = self:GetCoolDown()
        draw.SimpleText(formatRelativeTime(length), "TheDefaultSettings", 0, 100 / 100 - 1050, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    draw.SimpleText(DarkRP.formatMoney(self:GetNWInt("BankVaultTotalMoney")), "TheDefaultSettings", 0, 100 / 100 - posx, Color(0, 230, 64), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    posx = posx + 90
    draw.SimpleText("Bank Vault", "TheDefaultSettings", 0, 100 / 100 - posx, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    cam.End3D2D()
end