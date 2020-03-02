ESX = nil
local playersProcessingCannabis = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_drugs:sellDrug')
AddEventHandler('esx_drugs:sellDrug', function(itemName, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = Config.DrugDealerItems[itemName]
	local xItem = xPlayer.getInventoryItem(itemName)

	if not price then
		print(('esx_drugs: %s attempted to sell an invalid drug!'):format(xPlayer.identifier))
		return
	end

	if xItem.count < amount then
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = _U('dealer_notenough'), style = { ['background-color'] = '#b00000', ['color'] = '#fff' } })
		return
	end

	price = ESX.Math.Round(price * amount)

	if Config.GiveBlack then
		xPlayer.addAccountMoney('black_money', price)
	else
		xPlayer.addMoney(price)
	end

	xPlayer.removeInventoryItem(xItem.name, amount)

	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = _U('dealer_sold', amount, xItem.label, ESX.Math.GroupDigits(price)), style = { ['background-color'] = '#009c10', ['color'] = '#fff' } })
end)

ESX.RegisterServerCallback('esx_drugs:buyLicense', function(source, cb, licenseName)
	local xPlayer = ESX.GetPlayerFromId(source)
	local license = Config.LicensePrices[licenseName]

	if license == nil then
		print(('esx_drugs: %s attempted to buy an invalid license!'):format(xPlayer.identifier))
		cb(false)
	end

	if xPlayer.getMoney() >= license.price then
		xPlayer.removeMoney(license.price)

		TriggerEvent('esx_license:addLicense', source, licenseName, function()
			cb(true)
		end)
	else
		cb(false)
	end
end)

RegisterServerEvent('esx_drugs:pickedUpCannabis')
AddEventHandler('esx_drugs:pickedUpCannabis', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('weed')

	--if xItem.limit ~= -1 and (xItem.count + 1) > xItem.limit then
		--TriggerClientEvent('esx:showNotification', _source, _U('weed_inventoryfull'))
	--else
		xPlayer.addInventoryItem(xItem.name, 1)
	--end
end)

ESX.RegisterServerCallback('esx_drugs:anycops',function(source, cb)
	local anycops = 0
	local playerList = ESX.GetPlayers()
	for i=1, #playerList, 1 do
	  local _source = playerList[i]
	  local xPlayer = ESX.GetPlayerFromId(_source)
	  local playerjob = xPlayer.job.name
	  if playerjob == 'police' then
		anycops = anycops + 1
	  end
	end
	cb(anycops)
  end)

ESX.RegisterServerCallback('esx_drugs:canPickUp', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem(item)

	if xItem.limit ~= -1 and xItem.count >= xItem.limit then
		cb(false)
	else
		cb(true)
	end
end)

RegisterServerEvent('esx_drugs:processCannabis')
AddEventHandler('esx_drugs:processCannabis', function()
	if not playersProcessingCannabis[source] then
		local _source = source

		playersProcessingCannabis[_source] = ESX.SetTimeout(Config.Delays.WeedProcessing, function()
			local xPlayer = ESX.GetPlayerFromId(_source)
			local xCannabis, xMarijuana = xPlayer.getInventoryItem('weed'), xPlayer.getInventoryItem('weed_pooch')

			--if xMarijuana.limit ~= -1 and (xMarijuana.count + 1) >= xMarijuana.limit then
				--TriggerClientEvent('esx:showNotification', _source, _U('weed_processingfull'))
			--elseif xCannabis.count < 3 then
				--TriggerClientEvent('esx:showNotification', _source, _U('weed_processingenough'))
			--else
			print(xCannabis.count)

			if xCannabis.count >= 3 then 
			
				xPlayer.removeInventoryItem('weed', 3)
				xPlayer.addInventoryItem('weed_pooch', 1)
				TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = _U('weed_processed'), style = { ['background-color'] = '#009c10', ['color'] = '#fff' } })
			else
				TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Du har inga fler blad', style = { ['background-color'] = '#b00000', ['color'] = '#fff' } })
			end


			playersProcessingCannabis[_source] = nil
		end)
	else
		print(('esx_drugs: %s attempted to exploit weed processing!'):format(GetPlayerIdentifiers(source)[1]))
	end
end)

function CancelProcessing(playerID)
	if playersProcessingCannabis[playerID] then
		ESX.ClearTimeout(playersProcessingCannabis[playerID])
		playersProcessingCannabis[playerID] = nil
	end
end

RegisterServerEvent('esx_drugs:cancelProcessing')
AddEventHandler('esx_drugs:cancelProcessing', function()
	CancelProcessing(source)
end)

AddEventHandler('esx:playerDropped', function(playerID, reason)
	CancelProcessing(playerID)
end)

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
	CancelProcessing(source)
end)
