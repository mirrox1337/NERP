local uniforms = {x = -1105.4434814453, y = 4889.6362304688, z = 214.52072143555}
local deliverPoint = {x = 1436.4710693359, y = 3657.7209472656, z = 33.231868743896}

Quest.AddQuest('dmitri', 2, function()
	SetNewWaypoint(uniforms.x, uniforms.y)

	Markers.AddMarker('quest_dmitri', uniforms, 'Tryck ~INPUT_CONTEXT~ för att få uniformerna.', function()
		Markers.RemoveMarker('quest_dmitri')
		
		local blip = CreateBlip(deliverPoint, 'Deliver Point', 1, 5, true)

		TriggerServerEvent('never-quests:giveItem', 'gruppe6', 1)

		Markers.RemoveMarker('quest_dmitri_deliver')
		Markers.AddMarker('quest_dmitri_deliver', deliverPoint, 'Tryck ~INPUT_CONTEXT~ för att spara uniformerna.', function()
			ESX.TriggerServerCallback('never-quests:hasItem', function(has)
				if has then
					TriggerServerEvent('never-quests:removeItem', 'gruppe6', 1)

					RemoveBlip(blip)

					Quest.FinishQuest('dmitri', 3)

					Notifications.PlaySpecialNotification('Completed quest - Uniforms')
					
					Markers.RemoveMarker('quest_dmitri_deliver')
					Markers.RemoveMarker('quest_dmitri')
				else
					ESX.ShowNotification('~r~Du har inte hämtat uniformerna.')
				end
			end, 'gruppe6', 1)
		end)
	end)
end)