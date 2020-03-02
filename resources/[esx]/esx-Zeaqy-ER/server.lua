--  Made By Zeaqy --

ESX                = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx-Zeaqy-ER:pay')
AddEventHandler('esx-Zeaqy-ER:pay', function()
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    
	if(xPlayer.getMoney() >= 500) then
		xPlayer.removeMoney(500)
    end
end)

ESX.RegisterServerCallback('esx-Zeaqy-ER:money', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local money    = xPlayer.getMoney(source)
    if money >= 500 then
     cb(true)
    else
     cb(false)
     TriggerClientEvent("pNotify:SetQueueMax", -1, hej, 4)
     TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Du har inte tillräckligt med pengar', style = { ['background-color'] = '#b00000', ['color'] = '#fff' } })
    end
end)
                
function sendNotification(xSource, message, messageType, messageTimeout)
    TriggerClientEvent("pNotify:SendNotification", xSource, {
        text = message,
        type = messageType,
        queue = "zeaq",
        timeout = messageTimeout,
        layout = "bottomCenter"
    })
end

RegisterServerEvent('esx-Zeaqy-ER:check')
AddEventHandler('esx-Zeaqy-ER:check', function()
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()

    local ambulance = 0
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if xPlayer.job.name == 'ambulance' then
                    ambulance = ambulance + 1
            end
        end
        if ambulance == 0 then
            TriggerClientEvent('esx-Zeaqy-ER:Last', _source)
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Det finns andra sjukvårdare i tjänst!', style = { ['background-color'] = '#b00000', ['color'] = '#fff' } })
    end
end)
