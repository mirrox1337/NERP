ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj 
end)

ESX.RegisterServerCallback('revenge-weapontransport:buyCargo', function(source, callback, price)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer ~= nil then
		if xPlayer.getMoney() >= price then
			xPlayer.setMoney(xPlayer.getMoney() - price)

			callback(true)
		else
			callback(false)
		end
	end
end)

ESX.RegisterServerCallback('revenge-weapontransport:getPolice', function(source, callback)
	local players = ESX.GetPlayers()
	local copCount = 0

	for i=1, #players, 1 do
		local player = ESX.GetPlayerFromId(players[i])

		if player ~= nil and player.job ~= nil then
			if player.job.name == 'police' then
				copCount = copCount + 1
			end
		end
	end

	callback(copCount)
end)

RegisterServerEvent('revenge-weapontransport:giveRewards')
AddEventHandler('revenge-weapontransport:giveRewards', function(source, rewards)
	local xPlayer = ESX.GetPlayerFromId(source)
	local randomAmmo = math.random(50, 200)
	xPlayer.addInventoryItem('clip', randomAmmo)

	if xPlayer ~= nil then
		for i=1, #rewards, 1 do
			xPlayer.addWeapon(rewards[i], 250)
		end
	end
end)

RegisterServerEvent('revenge-weapontransport:updateBlip')
AddEventHandler('revenge-weapontransport:updateBlip', function(coords)
	local players = ESX.GetPlayers()

	for i=1, #players, 1 do	
		local player = ESX.GetPlayerFromId(players[i])

		if player ~= nil and player.job ~= nil then
			if player.job.name == 'police' then
				TriggerClientEvent('revenge-weapontransport:updatedBlip', players[i], coords)
			end
		end
	end
end)

RegisterServerEvent('revenge-weapontransport:removeBlip')
AddEventHandler('revenge-weapontransport:removeBlip', function(coords)
	local players = ESX.GetPlayers()

	for i=1, #players, 1 do
		local player = ESX.GetPlayerFromId(players[i])

		if player ~= nil and player.job ~= nil then
			if player.job.name == 'police' then
				TriggerClientEvent('revenge-weapontransport:removeBlip', players[i])
			end
		end
	end
end)