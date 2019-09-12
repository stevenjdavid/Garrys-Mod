------------------------------------------------------------
------------Copyright 2017, ScriptJunkie,-------------------
----------------All rights reserved.------------------------
------------------------------------------------------------

AddCSLuaFile()
breathalyzer = {}
/*---------------------

		Config
 Edit to your liking

---------------------*/
breathalyzer.DownloadType = "workshop" --Use "workshop", "fastdl", or "none". This is the method of download models/materials
									   --NOTE: workshop will only download materials, while fastdl will download both models/materails. Use workshopfastdl to download both models/materials!

breathalyzer.Auto_Give_Breathalyzer = true --If true, the jobs below will automatically spawn 

breathalyzer.Teams = {"Citizen"}

breathalyzer.Wanted_On_Illegal_BAC_Breathalyze = true --Automatically use the "DarkRP Wanted" to make someone with a BAC of 0.08 or greater. 
												  --NOTE: They will only be wanted after they are breathalyzed

breathalyzer.Legal_Limit = 0.08 --This only applies if "breathalyzer.Wanted_On_Illegal_BAC_Breathalyze" is true
								--The BAC amount that is considered over the legal limit.

breathalyzer.Alcohol_OverDose = nil --How much of a BAC until a player dies. Set to nil if you do not want to overdose ever.

breathalyzer.Alcohol_OverDose_Text = "You have overdosed on alcohol! Make better choices next time"

breathalyzer.Use_Motion_Blur = true --If true, all entities set below will create a motion blur effect.

breathalyzer.Alter_Movement = true --If true, being drunk will cause you to be tipsy and move left and right and move your mouse

breathalyzer.Alter_Driving_Ability = true --If true, driver's will swerve left and right depending on level of BAC

breathalyzer.Alcohol_Entities = {
	["sj_beer"] = 0.03, --This means drinking 1 beer will add 0.01 to your BAC. 0.08 is the legal limit. 8 beers = legal limit
	["sj_vodka"] = 0.02, -- 
	["sj_wine"] = 0.005,
	["sj_cocktail"] = 0.02,
	["sj_whiskey"] = 0.02
} --If you already have an Alcohol script, enter all the entities that are alcohol and should affect your BAC Level.