include("shared.lua")

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
        draw.SimpleText("Active Raid", "Fontdump", 0, 100 / 100 - 1135, Color(255, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(self:GetActiveRaidTimer() .. " seconds", "Fontdump", 0, 100 / 100 - 1050, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    if self:IsOnCoolDown() then
        draw.RoundedBox(0, -350, 100 / 100 - 1200, 715, posy, Color(10, 10, 10, 230))
        draw.SimpleText("Robbery Cooldown", "Fontdump", 0, 100 / 100 - 1135, Color(255, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        local length = self:GetCoolDown()
        if length > 60 then
            length = sam.format_length(self:GetCoolDown() / 60)
        end
        draw.SimpleText(length, "Fontdump", 0, 100 / 100 - 1050, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    draw.SimpleText(DarkRP.formatMoney(self:GetNWInt("BankVaultTotalMoney")), "Fontdump", 0, 100 / 100 - posx, Color(0, 230, 64), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    posx = posx + 90
    draw.SimpleText("Bank Vault", "Fontdump", 0, 100 / 100 - posx, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    cam.End3D2D()
end