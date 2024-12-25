include("shared.lua")

surface.CreateFont("BANK_SYSTEM.Font", {
	font = "Arial",
	extended = false,
	size = 85,
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

    if self:GetIsActiveRaid() and self:GetActiveRaidTimer() - CurTime() >= 0 then
        draw.RoundedBox(0, -270, 100 / 100 - 1200, 550, posy, Color(10, 10, 10, 230))
        draw.SimpleText("Active Raid", "BANK_SYSTEM.Font", 0, 100 / 100 - 1135, Color(255, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        local length = math.floor(self:GetActiveRaidTimer() - CurTime())
        draw.SimpleText(formatRelativeTime(length), "BANK_SYSTEM.Font", 0, 100 / 100 - 1050, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    if self:GetIsCoolDown() and self:GetCoolDown() - CurTime() >= 0 then
        draw.RoundedBox(0, -350, 100 / 100 - 1200, 715, posy, Color(10, 10, 10, 230))
        draw.SimpleText("Robbery Cooldown", "BANK_SYSTEM.Font", 0, 100 / 100 - 1135, Color(255, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        local length = math.ceil(self:GetCoolDown() - CurTime())
        draw.SimpleText(formatRelativeTime(length), "BANK_SYSTEM.Font", 0, 100 / 100 - 1050, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    draw.SimpleText(DarkRP.formatMoney(self:GetTotalMoney()), "BANK_SYSTEM.Font", 0, 100 / 100 - posx, Color(0, 230, 64), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    
    posx = posx + 90
    draw.SimpleText("Bank Vault", "BANK_SYSTEM.Font", 0, 100 / 100 - posx, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    cam.End3D2D()
end