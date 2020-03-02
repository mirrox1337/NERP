local rob = false
local robbers = {}
hasItem = false
local CopsConnected  = 0
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("chrono-jewlery:retrieveItem")
AddEventHandler("chrono-jewlery:retrieveItem", function()
	local player = ESX.GetPlayerFromId(source)
	local source = source
	local xPlayers = ESX.GetPlayers()

    math.randomseed(os.time())
    local luck = math.random(0, 100)
    local randomItem = 1

    if luck >= 0 and luck <= 50 then
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Du hittade inget av värde.', length = 8500, style = { ['background-color'] = '#ad0000', ['color'] = '#fff' } })
    else
        player.addInventoryItem("busshammare", randomItem)
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Du hittade en busshammare', length = 8500, style = { ['background-color'] = '#007ecc', ['color'] = '#fff' } })
    end
end)





function get3DDistance(x1, y1, z1, x2, y2, z2)
	return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2) + math.pow(z1 - z2, 2))
end

function CountCops()

	local xPlayers = ESX.GetPlayers()

	CopsConnected = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			CopsConnected = CopsConnected + 1
		end
	end

	SetTimeout(120 * 1000, CountCops)
end

CountCops()

RegisterServerEvent('chrono-jewelry:toofar')
AddEventHandler('chrono-jewelry:toofar', function(robb)
	local source = source
	local xPlayers = ESX.GetPlayers()
	rob = false
	for i=1, #xPlayers, 1 do
 		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
 		print('[chrono-jewelry]' .. ' Player: ' .. xPlayer.getName() .. ' cancelled robbing the jewelry store.')
 		if xPlayer.job.name == 'police' then
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayers[i], { type = 'error', text = _U( 'robbery_cancelled_at'), length = 8500, style = { ['background-color'] = '#ad0000', ['color'] = '#fff' } })
			TriggerClientEvent('chrono-jewelry:killblip', xPlayers[i]) 
		end
	end
	if(robbers[source])then
		TriggerClientEvent('chrono-jewelry:toofarlocal', source)
		robbers[source] = nil
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = _U( 'robbery_has_cancelled'), length = 8500, style = { ['background-color'] = '#ad0000', ['color'] = '#fff' } })
	end
end)

RegisterServerEvent('chrono-jewelry:endrob')
AddEventHandler('chrono-jewelry:endrob', function(robb)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()
	print('[chrono-jewelry]' .. ' Player: ' .. xPlayer.getName() .. ' successfully robbed the jewelry store.')
	rob = false
	for i=1, #xPlayers, 1 do
 		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
 		if xPlayer.job.name == 'police' then
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayers[i], { type = 'error', text = _U( 'end'), length = 8500, style = { ['background-color'] = '#ad0000', ['color'] = '#fff' } })
			TriggerClientEvent('chrono-jewelry:killblip', xPlayers[i])
		end
	end
	if(robbers[source])then
		TriggerClientEvent('chrono-jewelry:robberycomplete', source)
		robbers[source] = nil
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = _U( 'robbery_has_ended'), length = 8500, style = { ['background-color'] = '#007ecc', ['color'] = '#fff' } })
	end
end)

RegisterServerEvent('chrono-jewelry:rob')
AddEventHandler('chrono-jewelry:rob', function(robb)

	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()
	local ItemQuantity = xPlayer.getInventoryItem('busshammare').count

	if ItemQuantity >= 1 then
		hasItem = true
	else
		hasItem = false
	end

	if xPlayer.job.name == 'police' then
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Poliser får inte råna, duh!', length = 8500, style = { ['background-color'] = '#ad0000', ['color'] = '#fff' } })
	end
	--if Stores[robb] and xPlayer.job.name ~= 'police' then
	if Stores[robb] then

		local store = Stores[robb]

		if (os.time() - store.lastrobbed) < Config.SecBetwNextRob and store.lastrobbed ~= 0 then

			timer = (Config.SecBetwNextRob - (os.time() - store.lastrobbed))/60
			print('[chrono-jewelry]' .. ' Player: ' .. xPlayer.getName() .. ' attempted to rob the jewelry store (cooldown).')
            TriggerClientEvent('chrono-jewelry:togliblip', source)
			TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = _U('already_robbed') .. math.floor(timer + 0.5) .. _U('minutes'), length = 8500, style = { ['background-color'] = '#ad0000', ['color'] = '#fff' } })
			return
		end

		if hasItem == true and rob == false then

			rob = true

			for i=1, #xPlayers, 1 do
				local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
				if xPlayer.job.name == 'police' then
					TriggerClientEvent('mythic_notify:client:SendAlert', xPlayers[i], { type = 'error', text = _U( 'rob_in_prog'), length = 8500, style = { ['background-color'] = '#ad0000', ['color'] = '#fff' } })
					TriggerClientEvent('chrono-jewelry:setblip', xPlayers[i], Stores[robb].position)
				end
			end

			local xPlayer = ESX.GetPlayerFromId(source)
			xPlayer.removeInventoryItem('busshammare', 1)
			TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Startar rånet..', length = 10000, style = { ['background-color'] = '#007ecc', ['color'] = '#fff' } })
			TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = _U( 'alarm_triggered'), length = 8500, style = { ['background-color'] = '#ad0000', ['color'] = '#fff' } })
			TriggerClientEvent('chrono-jewelry:currentlyrobbing', source, robb)
			CancelEvent()
			Stores[robb].lastrobbed = os.time()
		else
			print("Du saknar något..")
			TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = _U( 'robbery_already'), length = 3500, style = { ['background-color'] = '#ad0000', ['color'] = '#fff' } })
		end
	end
end)

if rob == true then
	print("Rob is true")
	print('[chrono-jewelry]' .. ' Player: ' .. xPlayer.getName() .. ' is robbing the jewelry store.')
end

RegisterServerEvent('chrono-jewelry:gioielli')
AddEventHandler('chrono-jewelry:gioielli', function()

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.addInventoryItem('jewels', math.random(Config.MinJewels, Config.MaxJewels))
end)


RegisterServerEvent('chrono-jewelry:vendita')
AddEventHandler('chrono-jewelry:vendita', function()

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local reward = math.floor(Config.PriceForOneJewel * Config.MaxJewelsSell)

	xPlayer.removeInventoryItem('jewels', Config.MaxJewelsSell)
	--xPlayer.addAccountMoney('black_money', reward)
	xPlayer.addMoney(reward)
end)

ESX.RegisterServerCallback('chrono-jewelry:conteggio', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	cb(CopsConnected)
end)

ESX.RegisterServerCallback('chrono-jewelry:itemState', function(source, cb)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local getState = xPlayer.getInventoryItem('busshammare').count
	if getState >= 1 then
		itemState = 1
	else
		itemState = 0
	end
	cb(itemState)
end)







