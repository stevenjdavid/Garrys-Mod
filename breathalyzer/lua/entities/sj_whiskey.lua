------------------------------------------------------------
------------Copyright 2017, ScriptJunkie,-------------------
----------------All rights reserved.------------------------
------------------------------------------------------------
AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Category = "ScriptJunkie"
ENT.PrintName = "Whiskey"
ENT.Author = "ScriptJunkie"
ENT.Contact = "Contact via ScriptFodder"
ENT.Purpose = "Get Drunk!"
ENT.Instructions = "Don't go crazy "
ENT.Spawnable = true
ENT.AdminOnly = false

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end

function ENT:Initialize()
	self:SetModel("models/scriptjunkie/whiskeybottle.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:Use()
	self:Remove()
end