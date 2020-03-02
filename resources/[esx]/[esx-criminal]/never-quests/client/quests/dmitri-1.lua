local farm = {x = 1982.37, y = 3052.88, z = 46.34}
local deliverPoint = {x = -227.15, y = -2004.47, z = 23.59}

Quest.AddQuest('dmitri', 1, function()
	SetNewWaypoint(farm.x, farm.y)

	Markers.AddMarker('quest_dmitri', farm, 'Tryck ~INPUT_CONTEXT~ för att ta Vodka', function()
		Markers.RemoveMarker('quest_dmitri')
		
		local blip = CreateBlip(deliverPoint, 'Deliver Point', 1, 5, true)

		TriggerServerEvent('never-quests:giveItem', 'vodka', 10)
		Markers.RemoveMarker('quest_dmitri_deliver')
			Markers.AddMarker('quest_dmitri_deliver', deliverPoint, 'Tryck ~INPUT_CONTEXT~ för att leverara Vodka', function()
				ESX.TriggerServerCallback('never-quests:hasItem', function(has)
					if has then
						TriggerServerEvent('never-quests:removeItem', 'vodka', 10)

						RemoveBlip(blip)

						Quest.FinishQuest('dmitri', 2)

						Notifications.PlaySpecialNotification('Completed quest - Trust')
						
						Markers.RemoveMarker('quest_dmitri_deliver')
						Markers.RemoveMarker('quest_dmitri')
					else
						ESX.ShowNotification('~r~Du har inte Vodkan!')
					end
				end, 'vodka', 10)
			end)
	end)
end)