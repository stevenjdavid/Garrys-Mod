------------------------------------------------------------
------------Copyright 2016, ScriptJunkie,-------------------
----------------All rights reserved.------------------------
------------------------------------------------------------
SWEP.Author = "ScriptJunkie"
SWEP.Contact = ""
SWEP.Purpose = "Used around a suspect's wrist to detain/arrest."
SWEP.Instructions = "Left click to detain, right click to release."
SWEP.Category = "ScriptJunkie"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.DrawAmmo = false
SWEP.Base = "weapon_base"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/c_handcuffs.mdl"
SWEP.WorldModel = "models/weapons/w_handcuffs.mdl"
util.PrecacheModel("models/weapons/c_handcuffs.mdl")
util.PrecacheModel("models/weapons/w_handcuffs.mdl")
SWEP.Primary.Sound = Sound("handcuff_lock.wav")
SWEP.ViewModelFlip = false
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.UseHands = true
SWEP.HoldType = "slam"
SWEP.FiresUnderwater = true
SWEP.DrawCrosshair = false

function SWEP:Initialize()
	util.PrecacheSound(self.Primary.Sound)
	self:SetHoldType(self.HoldType)
end

function SWEP:PrimaryAttack()
	if SERVER then return self:SecretPrimaryAttack() end
	if not IsFirstTimePredicted then return end

	if self:GetOwner():GetEyeTraceNoCursor().Entity:IsPlayer() and self:GetOwner():GetEyeTraceNoCursor().Entity:GetNWBool("isHandcuffed") == false then
		self:EmitSound(self.Primary.Sound)
	end
	-- TODO Let's put client-only stuff in here
end

function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + 1.5)
	if SERVER then return self:SecretSecondaryAttack() end

	if self:GetOwner():GetEyeTraceNoCursor().Entity:IsPlayer() and self:GetOwner():GetEyeTraceNoCursor().Entity:GetNWBool("isHandcuffed") == false then
		self:EmitSound(self.Primary.Sound)
	end
	-- TODO Let's put client-only stuff in here
end

function SWEP:Think()
	local tr = self.Owner:GetEyeTrace()
	if not handcuffs.Allow_All_Teams then
		for k, v in pairs(handcuffs.Allow_Teams) do
			if (self.Owner:getDarkRPVar("job") == v) then
				if tr.Entity:IsPlayer() and self:GetOwner():EyePos():Distance(tr.Entity:GetPos()) < handcuffs.Arrest_Distance and (tr.Entity:GetNWBool("isHandcuffed") == true) and self.Owner:KeyDown(IN_USE) then
					tr.Entity:SetNWVector("handcuffedVector", self.Owner:GetPos())
					tr.Entity:SetNWBool("beingDragged", true)
				end

				if not self.Owner:KeyDown(IN_USE) then
					tr.Entity:SetNWBool("beingDragged", false)
				end
			end
		end
	else
		if tr.Entity:IsPlayer() and self:GetOwner():EyePos():Distance(tr.Entity:GetPos()) < handcuffs.Arrest_Distance and (tr.Entity:GetNWBool("isHandcuffed") == true) then
			if tr.Entity:IsPlayer() and self:GetOwner():EyePos():Distance(tr.Entity:GetPos()) < handcuffs.Arrest_Distance and (tr.Entity:GetNWBool("isHandcuffed") == true) and self.Owner:KeyDown(IN_USE) then
				tr.Entity:SetNWVector("handcuffedVector", self.Owner:GetVelocity())
				tr.Entity:SetNWBool("beingDragged", true)
				if CLIENT then
				tr.Entity:Freeze(true)
				end
			end

			if not self.Owner:KeyDown(IN_USE) then
				tr.Entity:SetNWBool("beingDragged", false)
				if CLIENT then
				tr.Entity:Freeze(false)
				end
			end
		end
	end
end