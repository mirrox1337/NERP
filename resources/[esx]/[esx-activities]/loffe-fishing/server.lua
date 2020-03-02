ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('loffe-fishing:sellFish')
AddEventHandler('loffe-fishing:sellFish', function()

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	local fishQuantity = xPlayer.getInventoryItem('fish').count
	local randomMoney = math.random(15, 35)
	
	if fishQuantity == 0 then
	TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Du har inga fiskar', style = { ['background-color'] = '#b00000', ['color'] = '#fff' } })
	else
	xPlayer.removeInventoryItem('fish', fishQuantity)
	xPlayer.addAccountMoney('bank', fishQuantity * 50)
	TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Du sålde ' .. fishQuantity .. ' fiskar för ' .. fishQuantity * randomMoney .. ' SEK', style = { ['background-color'] = '#009c10', ['color'] = '#fff' } })
	end

end)

RegisterServerEvent('loffe-fishing:giveFish')
AddEventHandler('loffe-fishing:giveFish', function()

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	local fishQuantity = xPlayer.getInventoryItem('fish').count
	local randomWeight = math.random(700, 5000)
	
	if fishQuantity <= 200 then

		xPlayer.addInventoryItem('fish', 1)
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Du fångade en fisk som vägde ' .. randomWeight .. ' gram.', style = { ['background-color'] = '#009c10', ['color'] = '#fff' } })
	end

end)

RegisterServerEvent('loffe-fishing:buy')
AddEventHandler('loffe-fishing:buy', function(item, price, amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local label = ESX.GetItemLabel(item)
	local itemAmount = xPlayer.getInventoryItem(item).count
	
	if(xPlayer.getMoney() >= price) then
		if item == 'fishingrod' and itemAmount < 1 then 
			xPlayer.removeMoney(price)
			xPlayer.addInventoryItem(item, amount)
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Du köpte ' .. amount .. ' ' .. label  .. ' för ' .. price .. ' SEK', style = { ['background-color'] = '#009c10', ['color'] = '#fff' } })
		elseif item ~= 'fishingrod' and itemAmount < 200 then
			xPlayer.removeMoney(price)
			xPlayer.addInventoryItem(item, amount)
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Du har för många ' .. label .. 'n på dig.', style = { ['background-color'] = '#b00000', ['color'] = '#fff' } })
		end
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Du har inte tillräckligt med pengar', style = { ['background-color'] = '#b00000', ['color'] = '#fff' } })
	end
end)

RegisterServerEvent('loffe-fishing:removeFishbait')
AddEventHandler('loffe-fishing:removeFishbait', function()

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	--local fishQuantity = xPlayer.getInventoryItem('fish').count
	--local randomWeight = math.random(700, 5000)
	
	--if fishQuantity <= 200 then

		xPlayer.removeInventoryItem('fishbait', 1)
		--sendNotification(_source, 'Du fångade en fisk som vägde ' .. randomWeight .. ' gram.', 'success', 3500)
	--end

end)

--notification
function sendNotification(xSource, message, messageType, messageTimeout)
    TriggerClientEvent("pNotify:SendNotification", xSource, {
        text = message,
        type = messageType,
        queue = "lmao",
        timeout = messageTimeout,
        layout = "bottomCenter"
    })
end
