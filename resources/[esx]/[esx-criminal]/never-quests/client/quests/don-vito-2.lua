local farm = {x = -2166.9099121094, y = 5197.4765625, z = 15.880641937256}
local deliverPoint = {x = -59.525032043457, y = 359.86416625977, z = 112.0563659668}

Quest.AddQuest('donvito', 2, function()
	SetNewWaypoint(farm.x, farm.y)

	Markers.AddMarker('quest_donvito', farm, 'Tryck ~INPUT_CONTEXT~ för att få kokain.', function()
		Markers.RemoveMarker('quest_donvito')
		
		local blip = CreateBlip(deliverPoint, 'Deliver Point', 1, 5, true)

		TriggerServerEvent('never-quests:giveItem', 'packedcocaine', 10)
		Markers.RemoveMarker('quest_donvito_deliver')
			Markers.AddMarker('quest_donvito_deliver', deliverPoint, 'Tryck ~INPUT_CONTEXT~ För att leverara kokainet.', function()
				ESX.TriggerServerCallback('never-quests:hasItem', function(has)
					if has then
						TriggerServerEvent('never-quests:removeItem', 'packedcocaine', 10)

						RemoveBlip(blip)

						Quest.FinishQuest('donvito', 3)

						Notifications.PlaySpecialNotification('Completed quest - Trust')
						
						Markers.RemoveMarker('quest_donvito_deliver')
						Markers.RemoveMarker('quest_donvito')
					else
						ESX.ShowNotification('~r~Du har inte Kokainväskorna!')
					end
				end, 'packedcocaine', 10)
			end)
	end)
end)