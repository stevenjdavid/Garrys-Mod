------------------------------------------------------------
------------Copyright 2016, ScriptJunkie,-------------------
----------------All rights reserved.------------------------
------------------------------------------------------------
AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Counterfeit Handcuff Keys"
	SWEP.Slot = 5
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

-- Variables that are used on both client and server
SWEP.Author = "ScriptJunkie"
SWEP.Instructions = "Left click to unlock someone else's handcuffs"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.ViewModelFOV = 40
SWEP.ViewModelFlip = false
SWEP.ViewModel = Model("models/weapons/c_handcuff_keys.mdl")
SWEP.WorldModel = ""
SWEP.UseHands = true
SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Category = "ScriptJunkie"
SWEP.Sound = Sound("physics/wood/wood_box_impact_hard3.wav")
SWEP.Primary.ClipSize = -1 -- Size of a clip
SWEP.Primary.DefaultClip = 0 -- Default number of bullets in a clip
SWEP.Primary.Automatic = false -- Automatic/Semi Auto
SWEP.Primary.Ammo = ""
SWEP.Secondary.ClipSize = -1 -- Size of a clip
SWEP.Secondary.DefaultClip = -1 -- Default number of bullets in a clip
SWEP.Secondary.Automatic = false -- Automatic/Semi Auto
SWEP.Secondary.Ammo = ""

--[[-------------------------------------------------------
Name: SWEP:Initialize()
Desc: Called when the weapon is first loaded
---------------------------------------------------------]]
function SWEP:Initialize()
	self:SetHoldType("knife")
end

--[[-------------------------------------------------------
Name: SWEP:PrimaryAttack()
Desc: +attack1 has been pressed
---------------------------------------------------------]]
function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + 2)
	if self:GetOwner():GetNWBool("isLockpicking") then return end
	local tr = self:GetOwner():GetEyeTrace()

	if tr.Entity:IsPlayer() and tr.Entity:GetNWBool("isHandcuffed") then
		tr.Entity:SetNWBool("isHandcuffed", false)
		tr.Entity:SetWalkSpeed(GAMEMODE.Config.walkspeed)
		tr.Entity:SetRunSpeed(GAMEMODE.Config.runspeed)
		tr.Entity:ManipulateBoneAngles(tr.Entity:LookupBone("ValveBiped.Bip01_L_UpperArm"), Angle(0, 0, 0)) -- Left UpperArm
		tr.Entity:ManipulateBoneAngles(tr.Entity:LookupBone("ValveBiped.Bip01_L_Forearm"), Angle(0, 0, 0)) -- Left ForeArm
		tr.Entity:ManipulateBoneAngles(tr.Entity:LookupBone("ValveBiped.Bip01_L_Hand"), Angle(0, 0, 0)) -- Left Hand
		tr.Entity:ManipulateBoneAngles(tr.Entity:LookupBone("ValveBiped.Bip01_R_Forearm"), Angle(0, 0, 0)) -- Right Forearm
		tr.Entity:ManipulateBoneAngles(tr.Entity:LookupBone("ValveBiped.Bip01_R_Hand"), Angle(0, 0, 0)) -- Right Hand
		tr.Entity:ManipulateBoneAngles(tr.Entity:LookupBone("ValveBiped.Bip01_R_UpperArm"), Angle(0, 0, 0)) -- Right Upperarm
		tr.Entity:PrintMessage(HUD_PRINTTALK, "You were not given your weapons back as you have been illegaly un-handcuffed.")

		if (SERVER) then
			local weaponsToGive = GAMEMODE.Config.DefaultWeapons

			for k, v in pairs(weaponsToGive) do
				tr.Entity:Give(v)
			end

			if handcuffs.AutoWant_EscapedSuspect then
				tr.Entity:wanted("Police", "Escaped Convict")
			end

			if handcuffs.AutoWant_EscapeHelper then
				self:GetOwner():wanted("Police", "Assisted Escape of Convict " .. tr.Entity:Nick())
			end
		end
	end
end

function SWEP:SecondaryAttack()
	self:PrimaryAttack()
end