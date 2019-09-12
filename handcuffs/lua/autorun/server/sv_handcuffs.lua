------------------------------------------------------------
------------Copyright 2016, ScriptJunkie,-------------------
----------------All rights reserved.------------------------
------------------------------------------------------------
include("sh_handcuffs_config.lua")
resource.AddWorkshop("656972770")

hook.Add("PlayerSpawn", "GiveCuffs", function(ply)
	for k, v in pairs(handcuffs.Allow_Teams) do
		if ply:getDarkRPVar("job") == v and not ply:GetNWBool("isHandcuffed") then
			ply:Give("sj_handcuffs")
		end
	end
end)

--//////HOOKS////////
if handcuffs.Allow_Suicide then
	hook.Add("CanPlayerSuicide", "DisallowSuicide", function(ply)
		if (ply:GetNWBool("isHandcuffed") == true) then return true end
	end)
else
	hook.Add("CanPlayerSuicide", "DisallowSuicide", function(ply)
		if ply:GetNWBool("isHandcuffed") == true then return false end
	end)
end

if not handcuffs.Allow_TextChat then
	hook.Add("PlayerSay", "DisallowText", function(ply, _, _, _)
		if ply:GetNWBool("isHandcuffed") == true then return "" end
	end)
end

if not handcuffs.Allow_VoiceChat then
	hook.Add("PlayerCanHearPlayersVoice", "DisallowVoice", function(_, talker)
		if talker:GetNWBool("isHandcuffed") == true then return false end
	end)
end

hook.Add("PostPlayerDeath", "ResetPlayer", function(ply)
	if ply:GetNWBool("isHandcuffed") == true then
		ply:SetNWBool("isHandcuffed", false)
		ply:SetNWBool("isLockpicking", false)
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_UpperArm"), Angle(0, 0, 0)) -- Left UpperArm
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Forearm"), Angle(0, 0, 0)) -- Left ForeArm
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Hand"), Angle(0, 0, 0)) -- Left Hand
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Forearm"), Angle(0, 0, 0)) -- Right Forearm
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Hand"), Angle(0, 0, 0)) -- Right Hand
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_UpperArm"), Angle(0, 0, 0)) -- Right Upperarm
	end
end)

hook.Add("PlayerInitialSpawn", "ResetPlayerOnJoin", function(ply)
	if ply:GetNWBool("isHandcuffed") == true then
		ply:SetNWBool("isHandcuffed", false)
		ply:SetNWBool("isLockpicking", false)
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_UpperArm"), Angle(0, 0, 0)) -- Left UpperArm
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Forearm"), Angle(0, 0, 0)) -- Left ForeArm
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Hand"), Angle(0, 0, 0)) -- Left Hand
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Forearm"), Angle(0, 0, 0)) -- Right Forearm
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Hand"), Angle(0, 0, 0)) -- Right Hand
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_UpperArm"), Angle(0, 0, 0)) -- Right Upperarm
	end
end)

hook.Add("playerUnArrested", "ResetPlayerOnUnarrest", function(ply)
	if ply:GetNWBool("isHandcuffed") == true then
		ply:SetNWBool("isHandcuffed", false)
		ply:SetNWBool("isLockpicking", false)
		ply:SetWalkSpeed(GAMEMODE.Config.walkspeed)
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_UpperArm"), Angle(0, 0, 0)) -- Left UpperArm
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Forearm"), Angle(0, 0, 0)) -- Left ForeArm
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Hand"), Angle(0, 0, 0)) -- Left Hand
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Forearm"), Angle(0, 0, 0)) -- Right Forearm
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Hand"), Angle(0, 0, 0)) -- Right Hand
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_UpperArm"), Angle(0, 0, 0)) -- Right Upperarm
	end
end)

if not handcuffs.Allow_Arrest_Without_Detain then
	hook.Add("canArrest", "Preventarrest", function(_, arrestee)
		if arrestee:GetNWBool("isHandcuffed") then
			return true
		else
			return false
		end
	end)
end

--Checks if you are running the current version.
do
	local M = {}

	function M.OnInitPostEntity()
		timer.Simple(10, function()
			http.Fetch("https://docs.google.com/document/d/1UmcuEeH3ihsuI0pC2BbETjUgvmjOtcDKR_Ep22Lpwi8/edit", M.OnHttpResult, nil)
		end)
	end

	function M.OnHttpResult(body)
		local versionOnline = string.match(tostring(body), "1.%d.%d")
		local versionScriptFodder = "1.0.7"

		if versionOnline and versionOnline ~= versionScriptFodder then
			timer.Create("AnnounceOldVersion", 120, 0, M.OnAnnounceOldVersion)
		end
	end

	function M.OnAnnounceOldVersion()
		print("This version of The Ultimate Handcuff Script is outdated. Contact a server owner if you see this message.")
		PrintMessage(HUD_PRINTTALK, "This version of The Ultimate Handcuff Script is outdated. Contact a server owner if you see this message.")
	end

	hook.Add("InitPostEntity", "CheckHandcuffs", M.OnInitPostEntity)
end
