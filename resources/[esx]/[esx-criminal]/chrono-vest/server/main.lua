ESX               = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('bulletproof_vest', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local vest = xPlayer.getInventoryItem('bulletproof_vest')
	
		if vest.count > 0 then
			xPlayer.removeInventoryItem('bulletproof_vest', 1)
			TriggerClientEvent('chrono:startVest', source)
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Du har ingen skottsäkerväst!', style = { ['background-color'] = '#b00000', ['color'] = '#fff' } })
		end
end)