------------------------------------------------------------
------------Copyright 2017, ScriptJunkie,-------------------
----------------All rights reserved.------------------------
------------------------------------------------------------
if SERVER then
	AddCSLuaFile("cl_init.lua")
	AddCSLuaFile("shared.lua")
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
	resource.AddFile("resource/fonts/breathalyzer_num.ttf")
end

------------------------------------------------
--Author Info
------------------------------------------------
SWEP.Author = "ScriptJunkie"
SWEP.Contact = "Contact via ScriptFodder"
SWEP.Purpose = "For use by police to breathalyze a suspect"
SWEP.Instructions = "Left click on another player to breathalyze"
------------------------------------------------
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
-- First person Model
SWEP.ViewModel = "models/weapons/c_breathalyzer.mdl"
-- Third Person Model
SWEP.WorldModel = "models/weapons/w_breathalyzer.mdl"
-- Weapon Details
SWEP.Primary.Clipsize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.Clipsize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.UseHands = true
SWEP.Category = "ScriptJunkie"

function SWEP:Initialize()
	self:SetChatText("Breathalyzing")
	if SERVER then return end
	if LocalPlayer():GetViewModel():LookupBone("breath") == nil then return end
	hook.Add("HUDPaint", "DrawBACNumber", self:PostDrawViewModel())
end

function SWEP:SetupDataTables()
	self:NetworkVar("String", 0, "BAC")
	self:NetworkVar("Bool", 0, "PrimaryAttackInitiated")
	self:NetworkVar("String", 1, "ChatText")
end

function SWEP:PrimaryAttack()
	local ply = self.Owner
	local traceply = ply:GetEyeTrace().Entity
	self:SetNextPrimaryFire(CurTime() + 1)
	if not IsFirstTimePredicted() then return end

	if traceply:IsPlayer() then
		if ply:GetPos():Distance(traceply:GetPos()) > 100 then return end
		self:SetPrimaryAttackInitiated(true)
		self:SetChatText("Breathalyzing")

		timer.Simple(1, function()
			self:SetChatText("Breathalyzing.")
		end)

		timer.Simple(2, function()
			self:SetChatText("Breathalyzing..")
		end)

		timer.Simple(3, function()
			self:SetChatText("Breathalyzing...")
		end)

		if SERVER then
			timer.Simple(4, function()
				ply:SendLua("notification.AddLegacy('Done!', NOTIFY_GENERIC, 3)")
				ply:SendLua("surface.PlaySound(\"beep.wav\")")
				sound.Play("beep.wav", ply:GetPos())
			end)
		end

		timer.Simple(4, function()
			self:SetPrimaryAttackInitiated(false)
		end)

		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

		timer.Simple(4, function()
			self:SendWeaponAnim(ACT_VM_IDLE)

			if SERVER and math.Round(traceply:GetNWFloat("PlyBAC"), 2) >= breathalyzer.Legal_Limit and DarkRP ~= nil then
				traceply:wanted(ply, "Exceed Legal BAC Limit")
			end
		end)
		self:SetBAC(tostring(math.Round(traceply:GetNWFloat("PlyBAC"), 2)))
	else
		self:SetBAC("ERR")

		if SERVER then
			ply:SendLua("notification.AddLegacy('You must aim at a player!', NOTIFY_GENERIC, 3)")
		end
	end
end

function SWEP:Reload()
	self:SetBAC("0.0")
end