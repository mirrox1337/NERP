local vehicle = {x = 2217.8449707031, y = 5621.2065429688, z = 53.485443115234, heading = 95.0}
local vehicleProperties = json.decode('{"modStruts":-1,"plateIndex":0,"windowTint":1,"modSmokeEnabled":1,"modSpoilers":0,"modShifterLeavers":-1,"modFrontBumper":1,"color2":147,"modRightFender":-1,"modSteeringWheel":-1,"modWindows":-1,"modFrontWheels":8,"dirtLevel":0.56793433427811,"modSideSkirt":3,"modAPlate":-1,"modOrnaments":-1,"modRearBumper":3,"modSuspension":3,"modFender":0,"modSpeakers":-1,"modTank":-1,"modBackWheels":-1,"neonColor":[255,0,255],"modAerials":-1,"color1":147,"plate":"09BDL555","modArchCover":-1,"modDial":-1,"modTrimB":-1,"modEngine":3,"modBrakes":2,"tyreSmokeColor":[255,255,255],"modHood":4,"wheelColor":0,"modEngineBlock":-1,"modExhaust":1,"wheels":0,"modDoorSpeaker":-1,"modPlateHolder":-1,"pearlescentColor":111,"model":-1008861746,"modHorns":-1,"modFrame":-1,"modGrille":0,"modTurbo":1,"modVanityPlate":-1,"neonEnabled":[false,false,false,false],"modTrimA":-1,"modLivery":-1,"modSeats":-1,"modDashboard":-1,"modTransmission":2,"health":1000,"modXenon":1,"modAirFilter":-1,"modHydrolic":-1,"modTrunk":-1,"modRoof":-1,"modArmor":4}')
local vehicleDeliverPoint = {x = -68.6435546875, y = 348.13687133789, z = 111.44693756104}
local cartheft = false
local blip = nil

Quest.AddQuest('donvito', 1, function()
	SetNewWaypoint(vehicle.x, vehicle.y)

	Markers.AddMarker('quest_donvito', vehicle, 'Tryck ~INPUT_CONTEXT~ för att stjäla ~b~Pegassi Reaper', function()
		ESX.TriggerServerCallback('cooldowns:getCooldown', function(cooldown)
			if cooldown == 0 then
				ESX.TriggerServerCallback('never-quests:getPolice', function(count)
					if count >= 2 then
						ESX.TriggerServerCallback('cooldowns:setCooldown', function()
						end, 'quest_theft', 3600)

						Markers.RemoveMarker('quest_donvito')
				
						local ped = GetPlayerPed(-1)

						ESX.Game.SpawnVehicle('reaper', vehicle, vehicle.heading, function(callbackVehicle)
							ESX.Game.SetVehicleProperties(callbackVehicle, vehicleProperties)
							
							TaskWarpPedIntoVehicle(ped, callbackVehicle, -1)

							--TriggerServerEvent('esx_addons_gcphone:startCall', 'police', 'Ett elektroniskt billarm har gått igång i en Pegassi Reaper strax norr av Union Road,', {x = 2217.8449707031, y = 5621.2065429688, z = 53.485443115234}, dispatch)
							GlobalEvent('never-quests:alarm', 'theft', GetEntityCoords(ped)["x"], GetEntityCoords(ped)["y"], GetEntityCoords(ped)["z"], 'Det har varit en bilstöld på en ~b~ Pegassi Reaper ~w~ på den markerade GPS-platsen. ', 300000)

							cartheft = true

							blip = CreateBlip(vehicleDeliverPoint, 'Deliver Point', 1, 5, true)
						end)
					else
						ESX.ShowNotification('Det måste vara minst ~b~2 ~w~poliser i staden för att starta en bilstöld.')
					end
				end)
			else
				ESX.ShowNotification('~r~Det har redan varit en bilstöld vänta ~b~' .. cooldown .. ' ~r~sekunder.')
			end
		end, 'quest_theft')
	end)

	Markers.RemoveMarker('quest_donvito_deliver')
	Markers.AddMarker('quest_donvito_deliver', vehicleDeliverPoint, 'Tryck ~INPUT_CONTEXT~ för att leverara fordonet!', function()
		local ped = GetPlayerPed(-1)
		
		if GetEntityModel(GetVehiclePedIsIn(ped)) == GetHashKey("reaper") then
			cartheft = false

			GlobalEvent('never-quests:removeAlarm', 'theft')
			ESX.Game.DeleteVehicle(GetVehiclePedIsIn(ped))

			if blip then RemoveBlip(blip) end

			Quest.FinishQuest('donvito', 2)

			Notifications.PlaySpecialNotification('Completed quest - Preparation')
			Markers.RemoveMarker('quest_donvito_deliver')
		else
			ESX.ShowNotification('~r~Fel bil!')
		end
	end, nil, nil, nil, true)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)

		if cartheft then
			local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))

			if vehicle ~= nil and GetEntityModel(vehicle) == GetHashKey('reaper') then
				GlobalEvent('never-quests:updateAlarm', 'theft', GetEntityCoords(vehicle)["x"], GetEntityCoords(vehicle)["y"], GetEntityCoords(vehicle)["z"])
			end
		end
	end
end)