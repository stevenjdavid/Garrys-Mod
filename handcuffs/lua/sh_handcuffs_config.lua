------------------------------------------------------------
------------Copyright 2016, ScriptJunkie,-------------------
----------------All rights reserved.------------------------
------------------------------------------------------------

AddCSLuaFile()
handcuffs = {}

/*---------------------

		Config
 Edit to your liking

---------------------*/
/*
DarkRP.createShipment("Counterfeit Handcuff Keys", {
    model = "models/weapons/w_pist_deagle.mdl",
    entity = "weapon_deagle2",
    price = 215,
    amount = 10,
    separate = true,
    pricesep = 215,
    noship = true,
    allowed = {TEAM_GUN}, --Add which team you want to be able to spawn counterfeit handcuff keys
    category = "Pistols",
})
*/

handcuffs.Allow_All_Teams = true --Allow all jobs to use handcuffs? If false, modify Allow_Teams below

handcuffs.Allow_Teams = {"Police Officer", "Swat", "Mayor"} --Which jobs spawn with/can use handcuffs? 
													--If above is true, these are the jobs that will spawn with handcuffs. 
													--Exact name as found in F4 Menu, NO TEAM_ETC

handcuffs.Allow_Team_Detain = false --Can jobs from above be handcuffed?

handcuffs.Teleport_Jail = false --When cuffed, should suspect be teleported to jail or only be detained?

handcuffs.Arrest_Distance = 150 --How close do you need to be to be able to arrest someone.

handcuffs.Allow_Suicide = false --When handcuffed, allow suspect to kill themselves?

handcuffs.Allow_TextChat = false --When handcuffed, allow suspect to type text in chat?

handcuffs.Allow_VoiceChat = false --When handcuffed, allow suspect to use voice chat?

handcuffs.AutoWant_EscapedSuspect = true --When a criminal unhandcuffs a suspect, set the suspect's wanted status to true?

handcuffs.AutoWant_EscapeHelper = true -- When a criminal unhandcuffs a suspect, set the person who unhandcuffed them wanted status to true

handcuffs.Allow_Arrest_Without_Detain = false -- Can a cop use the arrest baton on a criminal who is not handcuffed?

--User Interface Stuff-- 

handcuffs.UI_3d2d_Enabled = true --Enable the 3D2D Text on a person when arrested?
								 --EX: https://gyazo.com/1a76fc9b717eec4cc1651e68210c44b1

handcuffs.UI_LogoImage_Enabled = true --Enable the Logo above the text
									  --EX: https://gyazo.com/1a76fc9b717eec4cc1651e68210c44b1

handcuffs.UI_3d2d_Text = "Handcuffed" --The text seen on a player when handcuffed. 
									  --Ex: https://gyazo.com/1a76fc9b717eec4cc1651e68210c44b1

handcuffs.Can_All_See_3d2d = true --Can all players regardless of job see the UI on player? 
								  --EX: https://gyazo.com/1a76fc9b717eec4cc1651e68210c44b1

handcuffs.Who_Can_See_3d2d = {"Police", "Swat", "Mayor", "Mobboss"} --If above is false, which jobs can see the 3D2D Text and Image on Player? 
																	--EX: https://gyazo.com/1a76fc9b717eec4cc1651e68210c44b1
handcuffs.Handcuffed_Player_Text = "You are Handcuffed"

/*---------------------

		Config
 Edit to your liking

---------------------*/