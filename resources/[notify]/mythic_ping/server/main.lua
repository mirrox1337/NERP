RegisterCommand('ping', function(source, args, rawCommand)
	if args[1] ~= nil then
        if args[1]:lower() == 'accept' then
            TriggerClientEvent('mythic_ping:client:AcceptPing', source)
        elseif args[1]:lower() == 'reject' then
            TriggerClientEvent('mythic_ping:client:RejectPing', source)
        elseif args[1]:lower() == 'remove' then
            TriggerClientEvent('mythic_ping:client:RemovePing', source)
        else
            local tSrc = tonumber(args[1])
			if tSrc ~= nil then
				if source ~= tSrc then
					TriggerClientEvent('mythic_ping:client:SendPing', tSrc, GetPlayerName(source), source)
				else
					TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Du kan ej pinga dig själv.' })
				end
			end
        end
    end
end, false)

RegisterServerEvent('mythic_ping:server:SendPingResult')
AddEventHandler('mythic_ping:server:SendPingResult', function(id, result)
	if result == 'accept' then
		TriggerClientEvent('mythic_notify:client:SendAlert', id, { type = 'inform', text = GetPlayerName(source) .. ' accepterade din ping.' })
	elseif result == 'reject' then
		TriggerClientEvent('mythic_notify:client:SendAlert', id, { type = 'inform', text = GetPlayerName(source) .. ' nekade din ping.' })
	elseif result == 'timeout' then
		TriggerClientEvent('mythic_notify:client:SendAlert', id, { type = 'inform', text = GetPlayerName(source) .. ' svarade inte på din ping.' })
	elseif result == 'unable' then
		TriggerClientEvent('mythic_notify:client:SendAlert', id, { type = 'inform', text = GetPlayerName(source) .. ' kunde ej ta emot din ping.' })
	elseif result == 'received' then
		TriggerClientEvent('mythic_notify:client:SendAlert', id, { type = 'inform', text = 'Du skickade en ping till ' .. GetPlayerName(source) })
	end
end)
