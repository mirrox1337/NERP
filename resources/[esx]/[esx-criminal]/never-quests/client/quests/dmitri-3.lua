local vehicle = {x = -1052.5565185547, y = -846.62860107422, z = 3.8674731254578, heading = 212.68762207031}
local vehicleDeliverPoint = {x = 1434.2526855469, y = 3640.7121582031, z = 33.937133789063}
local trucktheft = false
local blip = nil

Quest.AddQuest('dmitri', 3, function()
	SetNewWaypoint(vehicle.x, vehicle.y)

	Markers.AddMarker('quest_dmitri', vehicle, 'Tryck ~INPUT_CONTEXT~ för att starta ett ~b~värdetransportrån', function()
		ESX.TriggerServerCallback('cooldowns:getCooldown', function(cooldown)
			if cooldown == 0 then
				ESX.TriggerServerCallback('never-quests:getPolice', function(count)
					if count >= 3 then
						ESX.TriggerServerCallback('cooldowns:setCooldown', function()
						end, 'quest_theft', 3600)
						
						Markers.RemoveMarker('quest_dmitri')

						local ped = GetPlayerPed(-1)

						ESX.Game.SpawnVehicle('stockade', vehicle, vehicle.heading, function(callbackVehicle)	
							TaskWarpPedIntoVehicle(ped, callbackVehicle, -1)

							GlobalEvent('never-quests:alarm', 'theft', GetEntityCoords(ped)["x"], GetEntityCoords(ped)["y"], GetEntityCoords(ped)["z"], 'Det har på börjats ett värdetransportrån på en ~b~Gruppe6 Stockade ~w~at den markerade GPS-platsen.')

							trucktheft = true

							blip = CreateBlip(vehicleDeliverPoint, 'Deliver Point', 1, 5, true)
						end)
					else
						ESX.ShowNotification('Det måste vara minst ~b~3 ~w~Poliser i staden för att starta ett värdetransportrån.')
					end
				end)
			else
				ESX.ShowNotification('~r~Det har nyligen varit ett värdetransportrån ~b~' .. cooldown .. ' ~r~sekunder.')
			end
		end, 'quest_theft')
	end)

	Markers.RemoveMarker('quest_dmitri_deliver')
	Markers.AddMarker('quest_dmitri_deliver', vehicleDeliverPoint, 'Tryck ~INPUT_CONTEXT~ för att leverara Transporten.', function()
		local ped = GetPlayerPed(-1)
		
		if GetEntityModel(GetVehiclePedIsIn(ped)) == GetHashKey("stockade") then
			ESX.Game.DeleteVehicle(GetVehiclePedIsIn(ped))

			trucktheft = false

			GlobalEvent('never-quests:removeAlarm', 'theft')
			
			if blip then RemoveBlip(blip) end

			Quest.FinishQuest('dmitri', 4)

			Notifications.PlaySpecialNotification("Completed quest - Final Task")
			Markers.RemoveMarker('quest_dmitri_deliver')
		else
			ESX.ShowNotification('~r~Fel bil')
		end
	end, nil, nil, nil, true)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)

		if trucktheft then
			local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))

			if vehicle ~= nil and GetEntityModel(vehicle) == GetHashKey('stockade') then
				GlobalEvent('never-quests:updateAlarm', 'theft', GetEntityCoords(vehicle)["x"], GetEntityCoords(vehicle)["y"], GetEntityCoords(vehicle)["z"])
			end
		end
	end
end)