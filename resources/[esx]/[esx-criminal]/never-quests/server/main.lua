ESX = nil

TriggerEvent('esx:getSharedObject', function(object)
	ESX = object
end)

ESX.RegisterServerCallback('never-quests:makePayment', function(source, callback, amount)
	local player = ESX.GetPlayerFromId(source)

	if player ~= nil then
		local bank = player.getAccount('bank')

		if bank.money >= amount then
			player.removeAccountMoney('bank', amount)

			callback(true)
		else
			callback(false)
		end
	end
end)

ESX.RegisterServerCallback('never-quests:getPolice', function(source, callback)
	local players = ESX.GetPlayers()
	local copCount = 0

	for i=1, #players, 1 do
		local player = ESX.GetPlayerFromId(players[i])

		if player ~= nil and player.job ~= nil then
			if player.job.name == 'police' then
				if player.job.grade_name == 'securitas' then

				else
					copCount = copCount + 1
				end
			end
		end
	end

	callback(copCount)
end)

ESX.RegisterServerCallback('never-quests:hasItem', function(source, callback, item, count)
	local player = ESX.GetPlayerFromId(source)

	if player ~= nil then
		callback(player.getInventoryItem(item).count >= count)
	end
end)

RegisterServerEvent('never-quests:giveMoney')
AddEventHandler('never-quests:giveMoney', function(account, amount)
	local _source = source
	local player = ESX.GetPlayerFromId(_source)

	if player ~= nil then
		player.addAccountMoney(account, amount)
	end
end)

RegisterNetEvent('never-quests:giveItem')
AddEventHandler('never-quests:giveItem', function(item, count)
	local _source = source
	local player = ESX.GetPlayerFromId(_source)

	if player ~= nil then
		player.addInventoryItem(item, count)
	end
end)

RegisterNetEvent('never-quests:removeItem')
AddEventHandler('never-quests:removeItem', function(item, count)
	local _source = source
	local player = ESX.GetPlayerFromId(_source)

	if player ~= nil then
		player.removeInventoryItem(item, count)
	end
end)

RegisterServerEvent('never-quests:globalEvent')
AddEventHandler('never-quests:globalEvent', function(event, ...)
	TriggerClientEvent(event, -1, ...)
end)