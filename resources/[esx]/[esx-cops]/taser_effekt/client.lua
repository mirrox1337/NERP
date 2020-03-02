local stunTid = 30000		-- milisekunder >> 1000 ms = 1sekund		//avg�r hur l�nge man ligger kvar p� marken
local blackScreen = 9000	-- milisekunder >> 1000 ms = 1sekund		//avg�r hur l�nge man �r skr�men �r svart
local groggyTid = 60000		-- milisekunder >> 1000 ms = 1sekund		//avg�r hur l�nge man �r groggy


--effekt
Citizen.CreateThread(function()
if not HasAnimSetLoaded("MOVE_M@DRUNK@VERYDRUNK") then
	RequestAnimSet("MOVE_M@DRUNK@VERYDRUNK")
	while not HasAnimSetLoaded("MOVE_M@DRUNK@VERYDRUNK") do
		Citizen.Wait(0)
	end
end
	while true do
		Citizen.Wait(0)
		if IsPedBeingStunned(GetPlayerPed(-1)) then
		DoScreenFadeOut(800)
		SetPedMinGroundTimeForStungun(GetPlayerPed(-1), stunTid)
		SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@VERYDRUNK", true)
		SetTimecycleModifier("spectator5")
		SetPedIsDrunk(GetPlayerPed(-1), true)
		Wait(blackScreen) --avg�r hur l�nge skr�men ska vara svart
		SetPedMotionBlur(GetPlayerPed(-1), true)
		DoScreenFadeIn(800)
		Wait(groggyTid) --avg�r hur l�nge man ska vara groggy
		ClearTimecycleModifier()
		ResetScenarioTypesEnabled()
		ResetPedMovementClipset(GetPlayerPed(-1), 0)
		SetPedIsDrunk(GetPlayerPed(-1), false)
		SetPedMotionBlur(GetPlayerPed(-1), false)
		end
	end
end)