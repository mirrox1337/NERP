ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


ESX.RegisterServerCallback('esx_scoreboard:copscount', function(source, cb)

    local xPlayer  = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()

    local cops = 0
      for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

        if xPlayer.job.name == 'police' then
            cops = cops + 1
        end
    end

    cb(cops)

end)

RegisterServerEvent('kulangive:item')
AddEventHandler('kulangive:item', function(item, source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer ~= nil then
        
       xPlayer.addInventoryItem(item, 1)

    end
end)

