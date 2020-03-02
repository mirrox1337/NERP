local vehicle = {x = -119.72421264648, y = -2668.0812988281, z = 5.0015344619751, heading = 0.0}
local vehicleDeliverPoint = {x = -68.6435546875, y = 348.13687133789, z = 111.44693756104}

Quest.AddQuest('donvito', 3, function()
	SetNewWaypoint(vehicle.x, vehicle.y)

	Markers.AddMarker('quest_donvito', vehicle, 'Tryck ~INPUT_CONTEXT~ för att stjäla ~b~Karin Asterope', function()
		Markers.RemoveMarker('quest_donvito')

		local ped = GetPlayerPed(-1)

		ESX.Game.SpawnVehicle('asterope', vehicle, vehicle.heading, function(callbackVehicle)	
			TaskWarpPedIntoVehicle(ped, callbackVehicle, -1)

			local blip = CreateBlip(vehicleDeliverPoint, 'Deliver Point', 1, 5, true)

			Markers.RemoveMarker('quest_donvito_deliver')
			Markers.AddMarker('quest_donvito_deliver', vehicleDeliverPoint, 'Trycl ~INPUT_CONTEXT~ för att leverera fordonet.', function()
				if GetVehiclePedIsIn(ped) == callbackVehicle then
					ESX.Game.DeleteVehicle(callbackVehicle)

					RemoveBlip(blip)

					Quest.FinishQuest('donvito', 4)

					Notifications.PlaySpecialNotification("Completed quest - Final Task")
					Markers.RemoveMarker('quest_donvito_deliver')
				else
					ESX.ShowNotification('~r~´Fel fordon!')
				end
			end, nil, nil, nil, true)
		end)
	end)
end)