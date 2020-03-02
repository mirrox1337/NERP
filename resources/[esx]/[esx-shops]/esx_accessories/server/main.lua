ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_accessories:pay')
AddEventHandler('esx_accessories:pay', function(price)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.removeMoney(price)
    TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = _U('you_paid') .. price .. ' SEK', style = { ['background-color'] = '#009c10', ['color'] = '#fff' } })

end)

RegisterServerEvent('esx_accessories:save')
AddEventHandler('esx_accessories:save', function(skin, accessory)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    print(accessory)
    TriggerEvent('esx_datastore:getDataStore', 'user_' .. string.lower(accessory), xPlayer.identifier, function(store)
        
        store.set('has' .. accessory, true)

        local itemSkin = {}
        local item1 = string.lower(accessory) .. '_1'
        local item2 = string.lower(accessory) .. '_2'
        itemSkin[item1] = skin[item1]
        itemSkin[item2] = skin[item2]
        store.set('skin', itemSkin)

    end)

end)

ESX.RegisterServerCallback('esx_accessories:get', function(source, cb, accessory)

    local xPlayer = ESX.GetPlayerFromId(source)

    TriggerEvent('esx_datastore:getDataStore', 'user_' .. string.lower(accessory), xPlayer.identifier, function(store)
        
        local hasAccessory = (store.get('has' .. accessory) and store.get('has' .. accessory) or false)
        local skin = (store.get('skin') and store.get('skin') or {})

        cb(hasAccessory, skin)

    end)

end)

--===================================================================
--===================================================================

ESX.RegisterServerCallback('esx_accessories:checkMoney', function(source, cb, money)
    
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.get('money') >= money then
        cb(true)
    else
        cb(false)
    end

end)
