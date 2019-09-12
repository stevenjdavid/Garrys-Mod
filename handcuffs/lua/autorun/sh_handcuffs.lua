------------------------------------------------------------
------------Copyright 2016, ScriptJunkie,-------------------
----------------All rights reserved.------------------------
------------------------------------------------------------
include("sh_handcuffs_config.lua")

if CLIENT then
	surface.CreateFont("HandcuffsFont", {
		font = "Trebuchet24",
		size = 200
	})

	hook.Add("PlayerBindPress", "disallowUseArrested", function(ply, bind)
		if (string.find(bind, "+use")) then
			if ply:GetNWBool("isHandcuffed") then
				local trace = ply:GetEyeTrace().Entity
				if ply:InVehicle() then end

				if (IsValid(trace) or IsEntity(trace)) then
					return false
				else
					return true
				end
			end
		end
	end)
end

hook.Add("PostDrawOpaqueRenderables", "InfoAboveHead", function()
	for k, v in pairs(player.GetAll()) do
		if v ~= LocalPlayer() and v:Alive() and LocalPlayer():EyePos():Distance(v:GetPos()) < 1500 and v:GetNWBool("isHandcuffed") == true then
			for k1, v1 in pairs(handcuffs.Who_Can_See_3d2d) do
				if not handcuffs.Can_All_See_3d2d and LocalPlayer():getDarkRPVar("job") == v1 then
					if handcuffs.UI_LogoImage_Enabled then
						cam.Start3D2D(v:GetPos() + Vector(0, 0, 56.5) - LocalPlayer():GetForward() * 20, Angle(0, LocalPlayer():GetAngles().y - 90, 90), 0.03)
						surface.SetDrawColor(255, 255, 255, 255)
						surface.SetMaterial(Material("vgui/handcuffs.png"))
						surface.DrawTexturedRect(-150, 0, 300, 300)
						cam.End3D2D()
					end

					if handcuffs.UI_3d2d_Enabled then
						cam.Start3D2D(v:GetPos() + Vector(0, 0, 55) - LocalPlayer():GetForward() * 20, Angle(0, LocalPlayer():GetAngles().y - 90, 90), 0.03)
						draw.DrawText(handcuffs.UI_3d2d_Text, "HandcuffsFont", 0, 400, Color(TextGlow(5, 255, 0, 0)), TEXT_ALIGN_CENTER)
						cam.End3D2D()
					end
				else
					if handcuffs.UI_LogoImage_Enabled then
						cam.Start3D2D(v:GetPos() + Vector(0, 0, 56.5) - LocalPlayer():GetForward() * 20, Angle(0, LocalPlayer():GetAngles().y - 90, 90), 0.03)
						surface.SetDrawColor(255, 255, 255, 255)
						surface.SetMaterial(Material("vgui/handcuffs.png"))
						surface.DrawTexturedRect(-150, 0, 300, 300)
						cam.End3D2D()
					end

					if handcuffs.UI_3d2d_Enabled then
						cam.Start3D2D(v:GetPos() + Vector(0, 0, 55) - LocalPlayer():GetForward() * 20, Angle(0, LocalPlayer():GetAngles().y - 90, 90), 0.03)
						draw.DrawText(handcuffs.UI_3d2d_Text, "HandcuffsFont", 0, 400, Color(TextGlow(5, 255, 0, 0)), TEXT_ALIGN_CENTER)
						cam.End3D2D()
					end
				end
			end
		end
	end
end)

hook.Add("HUDPaint", "ArrestedPlayerText", function()
	if LocalPlayer():GetNWBool("isHandcuffed") then
		draw.DrawText(handcuffs.Handcuffed_Player_Text, "DermaLarge", ScrW() / 2, ScrH() / 1.2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
	end
end)

function TextGlow(speed, r, g, b, a)
	if speed then
		color = {}
		color.r = math.sin(RealTime() * (speed or 1)) * r
		color.b = math.sin(RealTime() * (speed or 1)) * g
		color.g = math.sin(RealTime() * (speed or 1)) * b
		color.a = a or 255

		return color.r, color.b, color.g, color.a
	end
end

hook.Add( "SetupMove", "DragCuffer", function( ply, mv, cmd )
	if ply:GetNWBool("isHandcuffed") == true and ply:GetNWBool("beingDragged") == true then
		mv:SetVelocity(ply:GetNWVector("handcuffedVector"))
	end
end )