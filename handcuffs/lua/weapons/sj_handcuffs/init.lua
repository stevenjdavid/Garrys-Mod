------------------------------------------------------------
------------Copyright 2016, ScriptJunkie,-------------------
----------------All rights reserved.------------------------
------------------------------------------------------------
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("sh_handcuffs_config.lua")
include("shared.lua")

function VCModExists()
	if VC_GetHealth then
		return true
	else
		return false
	end
end

function SWEP:SecretPrimaryAttack()
	--if not self:CanPrimaryAttack() then return end
	self.Owner:SetAnimation(ACT_VM_PRIMARYATTACK)
	self:EmitSound(Sound("handcuff_lock.wav"))
	self:SetNextPrimaryFire(CurTime() + 1)
	local tr = self.Owner:GetEyeTraceNoCursor()
	local properJob = false
	local canArrest = false

	if not handcuffs.Allow_Team_Detain then
		for k, v in pairs(handcuffs.Allow_Teams) do
			if (tr.Entity:IsPlayer()) and (tr.Entity:getDarkRPVar("job") ~= v) and self:GetOwner():EyePos():Distance(tr.Entity:GetPos()) < handcuffs.Arrest_Distance then
				canArrest = true
			else
				canArrest = false
			end
		end
	else
		canArrest = true
	end

	if not handcuffs.Allow_All_Teams then
		for k, v in pairs(handcuffs.Allow_Teams) do
			if (self.Owner:getDarkRPVar("job") == v) then
				properJob = true
			end
		end
	else
		properJob = true
	end

	if properJob then
		if tr.Entity:IsVehicle() then
			if VCModExists() then
				for k, v in pairs(tr.Entity:VC_GetPlayers()) do
					if v:GetNWBool("isHandcuffed") == true then
						v:ExitVehicle()
					end
				end

				v:SendLua("GAMEMODE:AddNotify(\"Player successfully kicked out of vehicle!\", NOTIFY_GENERIC, 5)")
				v:SendLua("surface.PlaySound(\"ambient/water/drip2.wav\")")
			else
				if tr.Entity:GetDriver() and tr.Entity:GetDriver():GetNWBool("isHandcuffed") == true  then
					tr.Entity:GetDriver():ExitVehicle()
					self.Owner:SendLua("GAMEMODE:AddNotify(\"Player successfully kicked out of vehicle!\", NOTIFY_GENERIC, 5)")
					self.Owner:SendLua("surface.PlaySound(\"ambient/water/drip2.wav\")")
				else
					self.Owner:SendLua("GAMEMODE:AddNotify(\"No one in this vehicle is handcuffed!\", NOTIFY_ERROR, 5)")
					self.Owner:SendLua("surface.PlaySound(\"ambient/water/drip2.wav\")")
				end


			end
		end

			if canArrest and tr.Entity.IsPlayer() and self:GetOwner():EyePos():Distance(tr.Entity:GetPos()) < 150 and tr.Entity:GetNWBool("isHandcuffed") == false then
				tr.Entity:SetNWBool("isHandcuffed", true)
				tr.Entity:ManipulateBoneAngles(tr.Entity:LookupBone("ValveBiped.Bip01_L_UpperArm"), Angle(20, 8.8, 0)) -- Left UpperArm
				tr.Entity:ManipulateBoneAngles(tr.Entity:LookupBone("ValveBiped.Bip01_L_Forearm"), Angle(15, 0, 0)) -- Left ForeArm
				tr.Entity:ManipulateBoneAngles(tr.Entity:LookupBone("ValveBiped.Bip01_L_Hand"), Angle(0, 0, 75)) -- Left Hand
				tr.Entity:ManipulateBoneAngles(tr.Entity:LookupBone("ValveBiped.Bip01_R_Forearm"), Angle(-15, 0, 0)) -- Right Forearm
				tr.Entity:ManipulateBoneAngles(tr.Entity:LookupBone("ValveBiped.Bip01_R_Hand"), Angle(0, 0, -75)) -- Right Hand
				tr.Entity:ManipulateBoneAngles(tr.Entity:LookupBone("ValveBiped.Bip01_R_UpperArm"), Angle(-20, 16.6, 0)) -- Right Upperarm
				tr.Entity:SetWalkSpeed(GAMEMODE.Config.walkspeed / 2.5)
				tr.Entity:SetRunSpeed(GAMEMODE.Config.runspeed / 2.5)

				if handcuffs.Teleport_Jail then
					tr.Entity:arrest()
				end

				tr.Entity.HandcuffedWeapons = {}
				tr.Entity.HandcuffedWeaponAmmo = {}
				tr.Entity.HandcuffedWeaponAmmoType = {}
				local weps = tr.Entity:GetWeapons()

				for i, v in ipairs(weps) do
					tr.Entity.HandcuffedWeapons[i] = v:GetClass()
					tr.Entity.HandcuffedWeaponAmmo[v:GetPrimaryAmmoType()] = tr.Entity:GetAmmoCount(v:GetPrimaryAmmoType())
				end

				tr.Entity:StripWeapons()
			end
		else
			self:GetOwner():SendLua("GAMEMODE:AddNotify(\"Your job does not allow the use of handcuffs!\", NOTIFY_ERROR, 5)")
			self:GetOwner():SendLua("surface.PlaySound(\"ambient/water/drip2.wav\")")
		end
	end

function SWEP:SecretSecondaryAttack()
	local tr = self.Owner:GetEyeTraceNoCursor()

	if not handcuffs.Allow_All_Teams then
		for k, v in pairs(handcuffs.Allow_Teams) do
			if (self.Owner:getDarkRPVar("job") == v) then
				if tr.Entity:IsPlayer() and self:GetOwner():EyePos():Distance(tr.Entity:GetPos()) < handcuffs.Arrest_Distance and (tr.Entity:GetNWBool("isHandcuffed") == true) then
					tr.Entity:SetNWBool("isHandcuffed", false)
					self:GiveHandcuffWeaponsBack(tr.Entity)
					self:GiveHandcuffWeaponAmmoBack(tr.Entity)
					tr.Entity:SwitchToDefaultWeapon()
					tr.Entity:SetWalkSpeed(GAMEMODE.Config.walkspeed)
					tr.Entity:SetRunSpeed(GAMEMODE.Config.runspeed)
					tr.Entity:ManipulateBoneAngles(tr.Entity:LookupBone("ValveBiped.Bip01_L_UpperArm"), Angle(0, 0, 0)) -- Left UpperArm
					tr.Entity:ManipulateBoneAngles(tr.Entity:LookupBone("ValveBiped.Bip01_L_Forearm"), Angle(0, 0, 0)) -- Left ForeArm
					tr.Entity:ManipulateBoneAngles(tr.Entity:LookupBone("ValveBiped.Bip01_L_Hand"), Angle(0, 0, 0)) -- Left Hand
					tr.Entity:ManipulateBoneAngles(tr.Entity:LookupBone("ValveBiped.Bip01_R_Forearm"), Angle(0, 0, 0)) -- Right Forearm
					tr.Entity:ManipulateBoneAngles(tr.Entity:LookupBone("ValveBiped.Bip01_R_Hand"), Angle(0, 0, 0)) -- Right Hand
					tr.Entity:ManipulateBoneAngles(tr.Entity:LookupBone("ValveBiped.Bip01_R_UpperArm"), Angle(0, 0, 0)) -- Right Upperarm
				end
			end
		end
		-- Left UpperArm
		-- Left ForeArm
		-- Left Hand
		-- Right Forearm
		-- Right Hand
		-- Right Upperarm
	else
		if tr.Entity:IsPlayer() and self:GetOwner():EyePos():Distance(tr.Entity:GetPos()) < handcuffs.Arrest_Distance and (tr.Entity:GetNWBool("isHandcuffed") == true) then
			tr.Entity:SetNWBool("isHandcuffed", false)
			self:GiveHandcuffWeaponsBack(tr.Entity)
			self:GiveHandcuffWeaponAmmoBack(tr.Entity)

			for k, v in pairs(tr.Entity:GetWeapons()) do
				if v:GetClass() == "keys" then
					tr.Entity:SetActiveWeapon("keys")
					break
				end

				tr.Entity:SwitchToDefaultWeapon()
			end

			tr.Entity:SetWalkSpeed(GAMEMODE.Config.walkspeed)
			tr.Entity:SetRunSpeed(GAMEMODE.Config.runspeed)
			tr.Entity:ManipulateBoneAngles(tr.Entity:LookupBone("ValveBiped.Bip01_L_UpperArm"), Angle(0, 0, 0))
			tr.Entity:ManipulateBoneAngles(tr.Entity:LookupBone("ValveBiped.Bip01_L_Forearm"), Angle(0, 0, 0))
			tr.Entity:ManipulateBoneAngles(tr.Entity:LookupBone("ValveBiped.Bip01_L_Hand"), Angle(0, 0, 0))
			tr.Entity:ManipulateBoneAngles(tr.Entity:LookupBone("ValveBiped.Bip01_R_Forearm"), Angle(0, 0, 0))
			tr.Entity:ManipulateBoneAngles(tr.Entity:LookupBone("ValveBiped.Bip01_R_Hand"), Angle(0, 0, 0))
			tr.Entity:ManipulateBoneAngles(tr.Entity:LookupBone("ValveBiped.Bip01_R_UpperArm"), Angle(0, 0, 0))
		end
	end
end

function SWEP:GiveHandcuffWeaponsBack(ply)
	for i, v in ipairs(ply.HandcuffedWeapons) do
		ply:Give(v)
	end
end

function SWEP:GiveHandcuffWeaponAmmoBack(ply)
	for k, v in ipairs(ply.HandcuffedWeaponAmmo) do
		ply:SetAmmo(v, k)
	end
end

concommand.Add("checkWeapons", function() end)