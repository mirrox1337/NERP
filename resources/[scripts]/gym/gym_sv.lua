ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)

RegisterServerEvent('esx_gym:checkChip')
AddEventHandler('esx_gym:checkChip', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local oneQuantity = xPlayer.getInventoryItem('gym_membership').count
	
	if oneQuantity > 0 then
		TriggerClientEvent('esx_gym:trueMembership', source) -- true
	else
		TriggerClientEvent('esx_gym:falseMembership', source) -- false
	end
end)

RegisterServerEvent('esx_gym:buyMembership')
AddEventHandler('esx_gym:buyMembership', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= 800) then
		xPlayer.removeMoney(800)
		
		xPlayer.addInventoryItem('gym_membership', 1)		
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You purchased a membership', style = { ['background-color'] = '#009c10', ['color'] = '#fff' } })
		
		TriggerClientEvent('esx_gym:trueMembership', source) -- true
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You do not have enough money', style = { ['background-color'] = '#b00000', ['color'] = '#fff' } })
	end	
end)