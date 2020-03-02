ESX 						   = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Register Usable Item
ESX.RegisterUsableItem('weed_pooch', function(source)

	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('weed_pooch', 1)

	TriggerClientEvent('wille-smoke:onSmoke', _source)
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Du röker en Joint', style = { ['background-color'] = '#ffffff', ['color'] = '#fff' } })

end)