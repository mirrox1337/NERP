ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)

ESX.RegisterUsableItem('ol', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('ol', 1)

	TriggerClientEvent('esx_status:add', source, 'drunk', 250000)
	TriggerClientEvent('esx_optionalneeds:onDrink', source)
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = _U('used_ol'), style = { ['background-color'] = '#009c10', ['color'] = '#fff' } })

end)

ESX.RegisterUsableItem('hembränt', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('hembränt', 1)

	TriggerClientEvent('esx_status:add', source, 'drunk', 500000)
	TriggerClientEvent('esx_optionalneeds:onDrink', source)
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = _U('used_hembränt'), style = { ['background-color'] = '#009c10', ['color'] = '#fff' } })

end)

ESX.RegisterUsableItem('champagne', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('champagne', 1)

	TriggerClientEvent('esx_status:add', source, 'drunk', 250000)
	TriggerClientEvent('esx_optionalneeds:onDrink', source)
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = _U('used_champagne'), style = { ['background-color'] = '#009c10', ['color'] = '#fff' } })

end)

ESX.RegisterUsableItem('redbullvodka', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('redbullvodka', 1)

	TriggerClientEvent('esx_status:add', source, 'drunk', 250000)
	TriggerClientEvent('esx_optionalneeds:onDrink', source)
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = _U('used_redbullvodka'), style = { ['background-color'] = '#009c10', ['color'] = '#fff' } })

end)

ESX.RegisterUsableItem('vittvin', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('vittvin', 1)

	TriggerClientEvent('esx_status:add', source, 'drunk', 250000)
	TriggerClientEvent('esx_optionalneeds:onDrink', source)
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = _U('used_vittvin'), style = { ['background-color'] = '#009c10', ['color'] = '#fff' } })

end)

ESX.RegisterUsableItem('rottvin', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('rottvin', 1)

	TriggerClientEvent('esx_status:add', source, 'drunk', 250000)
	TriggerClientEvent('esx_optionalneeds:onDrink', source)
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = _U('used_rottvin'), style = { ['background-color'] = '#009c10', ['color'] = '#fff' } })

end)

ESX.RegisterUsableItem('whisky', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('whisky', 1)

	TriggerClientEvent('esx_status:add', source, 'drunk', 500000)
	TriggerClientEvent('esx_optionalneeds:onDrink', source)
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = _U('used_whisky'), style = { ['background-color'] = '#009c10', ['color'] = '#fff' } })

end)

ESX.RegisterUsableItem('jager', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('jager', 1)

	TriggerClientEvent('esx_status:add', source, 'drunk', 500000)
	TriggerClientEvent('esx_optionalneeds:onDrink', source)
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = _U('used_jager'), style = { ['background-color'] = '#009c10', ['color'] = '#fff' } })

end)

ESX.RegisterUsableItem('vodka', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('vodka', 1)

	TriggerClientEvent('esx_status:add', source, 'drunk', 500000)
	TriggerClientEvent('esx_optionalneeds:onDrink', source)
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = _U('used_vodka'), style = { ['background-color'] = '#009c10', ['color'] = '#fff' } })

end)

ESX.RegisterUsableItem('redbullvodka', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('redbullvodka', 1)

	TriggerClientEvent('esx_status:add', source, 'drunk', 250000)
	TriggerClientEvent('esx_optionalneeds:onDrink', source)
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = _U('used_redbullvodka'), style = { ['background-color'] = '#009c10', ['color'] = '#fff' } })

end)