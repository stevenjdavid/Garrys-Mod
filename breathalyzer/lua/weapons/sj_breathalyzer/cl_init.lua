------------------------------------------------------------
------------Copyright 2017, ScriptJunkie,-------------------
----------------All rights reserved.------------------------
------------------------------------------------------------
include("shared.lua")
SWEP.PrintName = "Breathalyzer"
SWEP.Slot = 2
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
if SERVER then return end

surface.CreateFont("scriptjunkie_num", {
	font = "SF Digital Readout",
	extended = false,
	size = 45,
	bold = true
})

function SWEP:PostDrawViewModel()
	local vm = LocalPlayer():GetViewModel()
	local temppos, tempang = vm:GetBonePosition(vm:LookupBone("breath"))
	local pos, ang = LocalToWorld(Vector(22, -2.25, -2.12), Angle(-10, 250, 90), temppos, tempang)

	if not self:GetPrimaryAttackInitiated() then
		cam.Start3D2D(pos, ang, 0.015)
		draw.DrawText(self:GetBAC(), "scriptjunkie_num", 0, 0, Color(0, 128, 0), TEXT_ALIGN_CENTER)
		cam.End3D2D()
	end
end

function SWEP:DrawHUD()
	if not self:GetPrimaryAttackInitiated() then return end
	draw.RoundedBox(10, ScrW() / 2.5, ScrH() / 1.4, 235, 40, Color(75, 75, 75, 200))
	draw.SimpleText(self:GetChatText(), "DermaLarge", ScrW() / 2.03, ScrH() / 1.35, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end