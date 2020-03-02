local farm = {x = 2434.1137695313, y = 4968.7729492188, z = 41.34761428833}
local deliverPoint = {x = 1436.4710693359, y = 3657.7209472656, z = 33.231868743896}

Quest.AddQuest('maggan', 1, function()
	SetNewWaypoint(farm.x, farm.y)

	Markers.AddMarker('quest_maggan', farm, 'Tryck ~INPUT_CONTEXT~ för att ta Meth', function()
		Markers.RemoveMarker('quest_maggan')
		
		local blip = CreateBlip(deliverPoint, 'Deliver Point', 1, 5, true)

		TriggerServerEvent('never-quests:giveItem', 'meth_pooch', 10)
		Markers.RemoveMarker('quest_maggan_deliver')
			Markers.AddMarker('quest_maggan_deliver', deliverPoint, 'Tryck ~INPUT_CONTEXT~ för att leverara Meth', function()
				ESX.TriggerServerCallback('never-quests:hasItem', function(has)
					if has then
						TriggerServerEvent('never-quests:removeItem', 'meth_pooch', 10)

						RemoveBlip(blip)

						Quest.FinishQuest('maggan', 2)

						Notifications.PlaySpecialNotification('Completed quest - Trust')
						
						Markers.RemoveMarker('quest_maggan_deliver')
						Markers.RemoveMarker('quest_maggan')
					else
						ESX.ShowNotification('~r~Du har inte Metamfetaminväskorna!')
					end
				end, 'meth_pooch', 10)
			end)
	end)
end)