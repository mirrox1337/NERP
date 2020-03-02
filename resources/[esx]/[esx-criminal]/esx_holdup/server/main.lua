local rob = false
local robbers = {}
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_holdup:tooFar')
AddEventHandler('esx_holdup:tooFar', function(currentStore)
	local _source = source
	local xPlayers = ESX.GetPlayers()
	rob = false

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayers[i], { type = 'inform', text = _U('robbery_cancelled_at', Stores[currentStore].nameOfStore), style = { ['background-color'] = '#b00000', ['color'] = '#fff' } })
			TriggerClientEvent('esx_holdup:killBlip', xPlayers[i])
		end
	end

	if robbers[_source] then
		TriggerClientEvent('esx_holdup:tooFar', _source)
		robbers[_source] = nil
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = _U('robbery_cancelled_at', Stores[currentStore].nameOfStore), style = { ['background-color'] = '#b00000', ['color'] = '#fff' } })
	end
end)

ESX.RegisterServerCallback('esx_holdup:anycops',function(source, cb)
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

RegisterServerEvent('esx_holdup:robberyStarted')
AddEventHandler('esx_holdup:robberyStarted', function(currentStore)
	local _source  = source
	local xPlayer  = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()

	if Stores[currentStore] then
		local store = Stores[currentStore]

		if (os.time() - store.lastRobbed) < Config.TimerBeforeNewRob and store.lastRobbed ~= 0 then
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = _U('recently_robbed', Config.TimerBeforeNewRob - (os.time() - store.lastRobbed)), style = { ['background-color'] = '#b00000', ['color'] = '#fff' } })
			return
		end

		local cops = 0
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == 'police' then
				cops = cops + 1
			end
		end

		if not rob then
			if cops >= Config.PoliceNumberRequired then
				rob = true

				for i=1, #xPlayers, 1 do
					local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
					if xPlayer.job.name == 'police' then
						TriggerClientEvent('mythic_notify:client:SendAlert', xPlayers[i], { type = 'inform', text = _U('rob_in_prog', store.nameOfStore), style = { ['background-color'] = '#b00000', ['color'] = '#fff' } })
						TriggerClientEvent('esx_holdup:setBlip', xPlayers[i], Stores[currentStore].position)
					end
				end

				TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = _U('started_to_rob', store.nameOfStore), style = { ['background-color'] = '#009c10', ['color'] = '#fff' } })
				TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = _U('alarm_triggered'), style = { ['background-color'] = '#009c10', ['color'] = '#fff' } })
				
				TriggerClientEvent('esx_holdup:currentlyRobbing', _source, currentStore)
				TriggerClientEvent('esx_holdup:startTimer', _source)
				
				Stores[currentStore].lastRobbed = os.time()
				robbers[_source] = currentStore

				SetTimeout(store.secondsRemaining * 1000, function()
					if robbers[_source] then
						rob = false
						if xPlayer then
							TriggerClientEvent('esx_holdup:robberyComplete', _source, store.reward)

							if Config.GiveBlackMoney then
								xPlayer.addAccountMoney('black_money', store.reward)
							else
								xPlayer.addMoney(store.reward)
							end
							
							local xPlayers, xPlayer = ESX.GetPlayers(), nil
							for i=1, #xPlayers, 1 do
								xPlayer = ESX.GetPlayerFromId(xPlayers[i])

								if xPlayer.job.name == 'police' then
									TriggerClientEvent('mythic_notify:client:SendAlert', xPlayers[i], { type = 'inform', text = _U('robbery_complete_at', store.nameOfStore), style = { ['background-color'] = '#009c10', ['color'] = '#fff' } })
									TriggerClientEvent('esx_holdup:killBlip', xPlayers[i])
								end
							end
						end
					end
				end)
			else
				TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = _U('min_police', Config.PoliceNumberRequired), style = { ['background-color'] = '#b00000', ['color'] = '#fff' } })
			end
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = _U('robbery_already'), style = { ['background-color'] = '#b00000', ['color'] = '#fff' } })
		end
	end
end)
