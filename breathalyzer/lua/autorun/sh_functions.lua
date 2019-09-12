------------------------------------------------------------
------------Copyright 2017, ScriptJunkie,-------------------
----------------All rights reserved.------------------------
------------------------------------------------------------
--AddCSLuaFile()
include("breathalyzer_config.lua")

local function GiveSWEP(ply)
	if not breathalyzer.Auto_Give_Breathalyzer then return end

	for k, v in pairs(breathalyzer.Teams) do
		if v == team.GetName(ply:Team()) then
			ply:Give("sj_breathalyzer")
		end
	end
end

local function ResetBAC(ply)
	ply:SetNWFloat("PlyBAC", 0.0)
	ply:SetNWFloat("addAlpha", 0)
	ply:SetNWFloat("timerDelay", 0)
end

local function SetDrunkAmount(ply, ent)
	for k, v in pairs(breathalyzer.Alcohol_Entities) do
		if ent:GetClass() == k then
			ply:SetNWFloat("PlyBAC", ply:GetNWFloat("PlyBAC") + v)

			if ply:GetNWFloat("PlyBAC") > 0 and ply:GetNWFloat("PlyBAC") < 0.03 then
				ply:SetNWFloat("addAlpha", 1)
				ply:SetNWFloat("timerDelay", 0)
			elseif ply:GetNWFloat("PlyBAC") >= 0.03 and ply:GetNWFloat("PlyBAC") < 0.04 then
				ply:SetNWFloat("addAlpha", 0.8)
				ply:SetNWFloat("timerDelay", 5)
			elseif ply:GetNWFloat("PlyBAC") >= 0.04 and ply:GetNWFloat("PlyBAC") < 0.12 then
				ply:SetNWFloat("addAlpha", 0.6)
				ply:SetNWFloat("timerDelay", 4)
			elseif ply:GetNWFloat("PlyBAC") >= 0.15 and ply:GetNWFloat("PlyBAC") < 0.18 then
				ply:SetNWFloat("addAlpha", 0.5)
				ply:SetNWFloat("timerDelay", 3)
			elseif ply:GetNWFloat("PlyBAC") >= 0.21 and ply:GetNWFloat("PlyBAC") < 0.24 then
				ply:SetNWFloat("addAlpha", 0.2)
				ply:SetNWFloat("timerDelay", 2)
			elseif ply:GetNWFloat("PlyBAC") >= 0.27 and ply:GetNWFloat("PlyBAC") < 0.30 then
				ply:SetNWFloat("addAlpha", 0.15)
			elseif ply:GetNWFloat("PlyBAC") >= 0.3 then
				ply:SetNWFloat("addAlpha", 0.05)
				ply:SetNWFloat("timerDelay", 1)
			end

			if SERVER and breathalyzer.Alcohol_OverDose and ply:GetNWFloat("PlyBAC") >= breathalyzer.Alcohol_OverDose then
				ply:Kill()
				ply:ChatPrint(breathalyzer.Alcohol_OverDose_Text)
			end
		end
	end
end

local function DrawDrunkMotionBlur()
	local addAlpha = LocalPlayer():GetNWFloat("addAlpha")

	if LocalPlayer():GetNWFloat("PlyBAC") > 0 then
		DrawMotionBlur(addAlpha, 1, 0.035)
	end
end

local function Chance(percentageChance)
	return percentageChance >= math.random(1, 100)
end

local function TriggerDrunkMovement(ply, key)
	local keys = {IN_FORWARD, IN_MOVELEFT, IN_MOVERIGHT, IN_BACK}
	local properKey = false

	for k, v in pairs(keys) do
		if key == v then
			properKey = true
		end
	end

	if properKey then
		hook.Add("StartCommand", "AdjustViewAngle", function(play, cmd)
			if play:GetNWFloat("PlyBAC") > 0 and not timer.Exists("TriggerAngles") and play:GetNWFloat("timerDelay") ~= 0 then
				timer.Create("TriggerAngles", play:GetNWFloat("timerDelay"), 0, function()
					play:SetEyeAngles(Angle(play:EyeAngles().p, play:EyeAngles().y + math.random(-40, 40), play:EyeAngles().r))
				end)
			end

			hook.Remove("StartCommand", "AdjustViewAngle")
		end)
	end
end

local function RemoveTriggerMovement(ply, key)
	local keys = {IN_FORWARD, IN_MOVELEFT, IN_MOVERIGHT, IN_BACK}
	local properKey = false

	for k, v in pairs(keys) do
		if key == v then
			properKey = true
		end
	end

	if (properKey and timer.Exists("TriggerAngles")) then
		timer.Remove("TriggerAngles")
	end
end

local function ChooseDirection(percentageChance)
	local dir = percentageChance >= math.random(1, 100)

	if dir then
		return "left"
	else
		return "right"
	end
end

local function AlterDrivingAbility(ply)
	if ply:GetNWFloat("PlyBAC") > 0 and ply:InVehicle() then
		timer.Create("DrunkDriverTimer", ply:GetNWFloat("timerDelay"), 0, function()
			if ply:GetVehicle():GetSpeed() > 0 and Chance(50) then
				local dir = ChooseDirection(50)
				ply:ConCommand("+move" .. dir)

				timer.Simple(0.5, function()
					ply:ConCommand("-move" .. dir)
				end)
			end
		end)
	end
end

local function ResetDrivingAbility()
	if timer.Exists("DrunkDriverTimer") then
		timer.Remove("DrunkDriverTimer")
	end
end

--Hooks--
if SERVER then
	resource.AddFile("resource/fonts/breathalyzer_num.ttf")
	resource.AddFile("sound/beep.wav")

	if string.lower(breathalyzer.DownloadType) == "fastdl" then
		resource.AddFile("models/weapons/c_breathalyzer.dx80.vtx")
		resource.AddFile("models/weapons/c_breathalyzer.dx90.vtx")
		resource.AddFile("models/weapons/c_breathalyzer.mdl")
		resource.AddFile("models/weapons/c_breathalyzer.sw.vtx")
		resource.AddFile("models/weapons/c_breathalyzer.phy")
		resource.AddFile("models/weapons/c_breathalyzer.vvd")
		resource.AddFile("models/weapons/w_breathalyzer.dx80.vtx")
		resource.AddFile("models/weapons/w_breathalyzer.dx90.vtx")
		resource.AddFile("models/weapons/w_breathalyzer.mdl")
		resource.AddFile("models/weapons/w_breathalyzer.sw.vtx")
		resource.AddFile("models/weapons/w_breathalyzer.phy")
		resource.AddFile("models/weapons/w_breathalyzer.vvd")
		resource.AddFile("models/scriptjunkie/beercan.dx80.vtx")
		resource.AddFile("models/scriptjunkie/beercan.dx90.vtx")
		resource.AddFile("models/scriptjunkie/beercan.mdl")
		resource.AddFile("models/scriptjunkie/beercan.sw.vtx")
		resource.AddFile("models/scriptjunkie/beercan.phy")
		resource.AddFile("models/scriptjunkie/beercan.vvd")
		resource.AddFile("models/scriptjunkie/vodkabottle.dx80.vtx")
		resource.AddFile("models/scriptjunkie/vodkabottle.dx90.vtx")
		resource.AddFile("models/scriptjunkie/vodkabottle.mdl")
		resource.AddFile("models/scriptjunkie/vodkabottle.sw.vtx")
		resource.AddFile("models/scriptjunkie/vodkabottle.phy")
		resource.AddFile("models/scriptjunkie/vodkabottle.vvd")
		resource.AddFile("models/scriptjunkie/whiskeybottle.dx80.vtx")
		resource.AddFile("models/scriptjunkie/whiskeybottle.dx90.vtx")
		resource.AddFile("models/scriptjunkie/whiskeybottle.mdl")
		resource.AddFile("models/scriptjunkie/whiskeybottle.sw.vtx")
		resource.AddFile("models/scriptjunkie/whiskeybottle.phy")
		resource.AddFile("models/scriptjunkie/whiskeybottle.vvd")
		resource.AddFile("models/scriptjunkie/winebottle.dx80.vtx")
		resource.AddFile("models/scriptjunkie/winebottle.dx90.vtx")
		resource.AddFile("models/scriptjunkie/winebottle.mdl")
		resource.AddFile("models/scriptjunkie/winebottle.sw.vtx")
		resource.AddFile("models/scriptjunkie/winebottle.phy")
		resource.AddFile("models/scriptjunkie/winebottle.vvd")
		resource.AddFile("materials/models/Breathalyzer/breath.vmt")
		resource.AddFile("materials/models/Breathalyzer/breath.vtf")
		resource.AddFile("materials/models/Custom/aluminum.vmt")
		resource.AddFile("materials/models/Custom/aluminum.vtf")
		resource.AddFile("materials/models/Custom/body.vmt")
		resource.AddFile("materials/models/Custom/body.vtf")
		resource.AddFile("materials/models/Custom/bottle.vmt")
		resource.AddFile("materials/models/Custom/bottle.vtf")
		resource.AddFile("materials/models/Custom/bottle_env.vtf")
		resource.AddFile("materials/models/Custom/cork.vmt")
		resource.AddFile("materials/models/Custom/cork.vtf")
		resource.AddFile("materials/models/Custom/label.vmt")
		resource.AddFile("materials/models/Custom/label.vtf")
		resource.AddFile("materials/models/Custom/top.vmt")
		resource.AddFile("materials/models/Custom/top.vtf")
		resource.AddFile("materials/models/ScriptJunkie/cap.vmt")
		resource.AddFile("materials/models/ScriptJunkie/cap.vtf")
		resource.AddFile("materials/models/ScriptJunkie/inside.vmt")
		resource.AddFile("materials/models/ScriptJunkie/inside.vtf")
		resource.AddFile("materials/models/ScriptJunkie/vodka.vmt")
		resource.AddFile("materials/models/ScriptJunkie/vodka.vtf")
		resource.AddFile("materials/models/whiskey/glassbottle.vmt")
		resource.AddFile("materials/models/whiskey/glassbottle.vtf")
		resource.AddFile("materials/models/whiskey/internaldrink.vmt")
		resource.AddFile("materials/models/whiskey/internaldrink.vtf")
		resource.AddFile("materials/models/whiskey/label.vmt")
		resource.AddFile("materials/models/whiskey/label.vtf")
	end

	if string.lower(breathalyzer.DownloadType) == "workshop" then
		resource.AddWorkshop("834891066")
	end

	hook.Add("PlayerUse", "SetDrunkness", SetDrunkAmount)
	hook.Add("PlayerDeath", "ResetBAC", ResetBAC)
	hook.Add("PlayerSpawn", "ResetBAC", ResetBAC)
	hook.Add("PlayerLoadout", "GiveBreathalyzer", GiveSWEP)
end

if CLIENT and breathalyzer.Use_Motion_Blur then
	hook.Add("RenderScreenspaceEffects", "DrunkLevel", DrawDrunkMotionBlur)
end

if breathalyzer.Alter_Movement then
	hook.Add("KeyPress", "TriggerMovements", TriggerDrunkMovement)
	hook.Add("KeyRelease", "RemoveTriggerMovements", RemoveTriggerMovement)
end

if breathalyzer.Alter_Driving_Ability then
	hook.Add("PlayerEnteredVehicle", "DrunkDriving", AlterDrivingAbility)
	hook.Add("PlayerLeaveVehicle", "DrunkDrivingLeave", ResetDrivingAbility)
end

if SERVER then
	do
		local M = {}

		function M.OnInitPostEntity()
			timer.Simple(10, function()
				http.Fetch("https://docs.google.com/document/d/1pFCRyrZh0Di2Uucj3njkYadi74g-xZpPnNrYfRj_EeM/edit?usp=sharing", M.OnHttpResult, nil)
			end)
		end

		function M.OnHttpResult(body)
			local versionOnline = string.match(tostring(body), "1.%d.%d")
			local versionScriptFodder = "1.0.3"

			if versionOnline ~= versionScriptFodder then
				timer.Create("AnnounceOldVersion", 120, 0, M.OnAnnounceOldVersion)
			end
		end

		function M.OnAnnounceOldVersion()
			print("This version of 'Police Breathalyzer' is outdated. Contact a server owner if you see this message.")
			PrintMessage(HUD_PRINTTALK, "This version of 'Police Breathalyzer' is outdated. Contact a server owner if you see this message.")
		end

		hook.Add("InitPostEntity", "CheckHandcuffs", M.OnInitPostEntity)
	end
end