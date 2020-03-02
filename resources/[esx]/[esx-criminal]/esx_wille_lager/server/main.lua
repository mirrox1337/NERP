ESX = nil
local ItemsLabels = {}
local nice = false


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_wille_lager:add')
AddEventHandler('esx_wille_lager:add', function(storagenumber, keyname)
    local identifier = ESX.GetPlayerFromId(source).identifier
    local _source = source
    local result = MySQL.Sync.fetchAll("SELECT * FROM user_storages", {})
    local xPlayer = ESX.GetPlayerFromId(_source)
    local money = xPlayer.getAccount('bank').money
    if result ~= nil then
        if money >= 5000 then
            MySQL.Async.execute('INSERT INTO user_storages (identifier, storage_unit, storage_key_name) VALUES (@identifier, @storagenumber, @keyname)',
                {
                    ['@identifier']   = identifier,
                    ['@storagenumber']    = storagenumber,
                    ['@keyname']     = keyname,
                }
            )
            --TriggerClientEvent('wille_drugs:plant', _source, x, y, z)
            Wait(10)
            MySQL.Async.execute('INSERT INTO user_keys (identifier, key_name, key_unit) VALUES (@identifier, @keyName, @storage)',
                {
                    ['@identifier']   = identifier,
                    ['@keyName']    = keyname,
                    ['@storage']    = storagenumber,
                }
            )
            xPlayer.removeAccountMoney('bank', 5000)
            sendNotification(_source, 'Du köpte ett Lager', 'success')
        else
            sendNotification(_source, 'Du har ej råd med ett Lager', 'error')
        end
    else
        sendNotification(_source, 'Error', 'error')
    end
end)

Citizen.CreateThread(function()

    MySQL.Async.fetchAll(
        'SELECT * FROM items',
        {},
        function(result)

            for i=1, #result, 1 do
                ItemsLabels[result[i].name] = result[i].label
            end

        end
    )

end)

RegisterServerEvent('esx_wille_lager:giveKey')
AddEventHandler('esx_wille_lager:giveKey', function(keyname, storagenumber, player)
    local _source = source
    local result = MySQL.Sync.fetchAll("SELECT id FROM user_keys WHERE key_name = @keyName", {['@keyName'] = keyname})
    local Player = ESX.GetPlayerFromId(_source)
    local Player2 = ESX.GetPlayerFromId(player)
    if result ~= nil then
        MySQL.Async.execute(
            "DELETE FROM `user_keys` WHERE `key_name` = @name AND `identifier` = @identifier and `id` = @id",
            {
                ['@id'] = result[1].id,
                ['@name'] = keyname,
                ['@identifier'] = Player.identifier
            }
        )
        --TriggerClientEvent('wille_drugs:plant', _source, x, y, z)
        Wait(10)
        MySQL.Async.execute('INSERT INTO user_keys (identifier, key_name, key_unit) VALUES (@identifier, @keyName, @storage)',
            {
                ['@identifier']   = Player2.identifier,
                ['@keyName']    = keyname,
                ['@storage']    = storagenumber,
            }
        )
        sendNotification(_source, 'Du gav iväg nyckel #' ..storagenumber, 'success')
        sendNotification(Player2.source, 'Du tog emot nyckel #'..storagenumber, 'success')
    else
        sendNotification(_source, 'Error', 'error')
    end
end)

RegisterServerEvent('esx_wille_lagerr:stealKey')
AddEventHandler('esx_wille_lager:stealKey', function(player, storagenumber, keyName)
    local _source = source
    local result = MySQL.Sync.fetchAll("SELECT id FROM user_keys WHERE key_name = @keyName", {['@keyName'] = keyName})
    local Player = ESX.GetPlayerFromId(_source)
    local Player2 = ESX.GetPlayerFromId(player)
    if result ~= nil then
        MySQL.Async.execute(
            "DELETE FROM `user_keys` WHERE `key_name` = @name AND `identifier` = @identifier and `id` = @id",
            {
                ['@id'] = result[1].id,
                ['@name'] = keyName,
                ['@identifier'] = Player2.identifier
            }
        )
        Wait(10)
        MySQL.Async.execute('INSERT INTO user_keys (identifier, key_name, key_unit) VALUES (@identifier, @keyName, @storage)',
            {
                ['@identifier']   = Player.identifier,
                ['@keyName']    = keyName,
                ['@storage']    = storagenumber,
            }
        )
        sendNotification(_source, 'Du tog nyckel #' ..storagenumber, 'success')
        sendNotification(Player2.source, 'Du förlorade nyckel #'..storagenumber, 'error')
    else
        sendNotification(_source, 'Error', 'error')
    end
end)

RegisterServerEvent('esx_wille_lager:addKey')
AddEventHandler('esx_wille_lager:addKey', function(keyname, storagenumber)
    local _source = source
    local Player = ESX.GetPlayerFromId(_source)
    local money = Player.getAccount('bank').money
    if Player ~= nil then
        if money >= 5000 then
            MySQL.Async.execute('INSERT INTO user_keys (identifier, key_name, key_unit) VALUES (@identifier, @keyName, @storage)',
                {
                    ['@identifier']   = Player.identifier,
                    ['@keyName']    = keyname,
                    ['@storage']    = storagenumber,
                }
            )
            sendNotification(_source, 'Du köpte en till nyckel #' ..storagenumber, 'success')
            Player.removeAccountMoney('bank', 15000)
        else
            sendNotification(_source, 'Du har ej råd med en nyckel', 'error')
        end
    else
        sendNotification(_source, 'Error', 'error')
    end
end)



AddEventHandler('onMySQLReady', function ()
    MySQL.Async.fetchAll(
        'SELECT * FROM items',
        {},
        function(result)

            for i=1, #result, 1 do
                ItemsLabels[result[i].name] = result[i].label
            end

        end
    )
end)

RegisterServerEvent('esx_wille_lager:putItem')
AddEventHandler('esx_wille_lager:putItem', function(itemName, count, unit)

  local xPlayer = ESX.GetPlayerFromId(source)

    local item = xPlayer.getInventoryItem(itemName)

    if count <= item.count then
        local result = MySQL.Sync.fetchAll("SELECT item, count, weapon FROM user_storages_items WHERE storage_unit = @dn and item = @item", {['@dn'] = unit, ['@item'] = itemName})
        --print(result.item)
        if result[1] ~= nil then
            if result[1].item == itemName then
                MySQL.Async.execute(
                    'UPDATE `user_storages_items` SET count = @count WHERE item = @itemName and count = @oldCount',
                    {
                        ['@itemName'] = itemName,
                        ['@count'] = result[1].count + count,
                        ['@oldCount'] = result[1].count
                    }
                )
            else
                MySQL.Async.execute('INSERT INTO user_storages_items (storage_unit, item, count, weapon) VALUES (@unit, @itemname, @itemcount, @weapon)',
                    {
                        ['@unit']   = unit,
                        ['@itemname']    = itemName,
                        ['@itemcount']    = count,
                        ['@weapon']    = false,
                    }
                )
            end
        else
            MySQL.Async.execute('INSERT INTO user_storages_items (storage_unit, item, count, weapon) VALUES (@unit, @itemname, @itemcount, @weapon)',
                    {
                        ['@unit']   = unit,
                        ['@itemname']    = itemName,
                        ['@itemcount']    = count,
                        ['@weapon']    = false,
                    }
                )
        end
        xPlayer.removeInventoryItem(itemName, count)
        sendNotification(xPlayer.source, 'Du la in '.. count .. 'st ' .. item.label, 'success')
    else
      sendNotification(xPlayer.source, 'Du har inte så många av ' ..item.label, 'error')
    end

end)

RegisterServerEvent('esx_wille_lager:putWeapon')
AddEventHandler('esx_wille_lager:putWeapon', function(weaponName, unit)

    local xPlayer = ESX.GetPlayerFromId(source)

    local result = MySQL.Sync.fetchAll("SELECT weapon FROM user_storages_items WHERE storage_unit = @dn and weapon = @weapon", {['@dn'] = unit, ['@weapon'] = true})

    if result[10] == nil then

        MySQL.Async.execute('INSERT INTO user_storages_items (storage_unit, item, count, weapon) VALUES (@unit, @itemname, @itemcount, @weapon)',
            {
                ['@unit']   = unit,
                ['@itemname']    = weaponName,
                ['@itemcount']    = math.random(0, 3),
                ['@weapon']    = true,
            }
        )
        --end
        xPlayer.removeWeapon(weaponName)
        sendNotification(xPlayer.source, 'Du la in '.. ESX.GetWeaponLabel(weaponName), 'success')
    else
        sendNotification(xPlayer.source, 'Du kan bara ha 10 vapen i ditt Lager', 'error')
    end

end)

RegisterServerEvent('esx_wille_lager:takeItem')
AddEventHandler('esx_wille_lager:takeItem', function(itemName, count, storageUnit)

    local xPlayer = ESX.GetPlayerFromId(source)
    local unitNumber = tonumber(storageUnit)

    local result = MySQL.Sync.fetchAll("SELECT item, count FROM user_storages_items WHERE storage_unit = @dn and item = @itemName", {['@dn'] = unitNumber, ['@itemName'] = itemName})
    --print(result.item)
    if result[1] ~= nil then
        if count <= result[1].count then
            if result[1].count > count then
                MySQL.Async.execute(
                    'UPDATE `user_storages_items` SET count = @count WHERE item = @itemName and storage_unit = @storage_unit',
                    {
                        ['@itemName'] = itemName,
                        ['@count'] = result[1].count - count,
                        ['@storage_unit'] = storageUnit
                    }
                )
            else
                MySQL.Async.execute(
                    "DELETE FROM `user_storages_items` WHERE `storage_unit` = @unit AND `item` = @itemName",
                    {
                        ['@unit'] = unitNumber,
                        ['@itemName'] = itemName
                    }
                )
            end
            xPlayer.addInventoryItem(itemName, count)
            sendNotification(xPlayer.source, 'Du tog ut '.. count .. 'st ' .. ItemsLabels[itemName], 'success')
        else
            sendNotification(xPlayer.source, 'Det finns ej så många '..ItemsLabels[itemName].. ' det finns bara '..result[1].count, 'error')
        end
    else
        --print('error')
        sendNotification(xPlayer.source, 'Något fel inträffade kontakta Admin', 'error')
    end

end)

RegisterServerEvent('esx_wille_lager:takeWeapon')
AddEventHandler('esx_wille_lager:takeWeapon', function(weaponName, storageUnit)

    local xPlayer = ESX.GetPlayerFromId(source)
    local unitNumber = tonumber(storageUnit)
    local result = MySQL.Sync.fetchAll("SELECT item, id FROM user_storages_items WHERE storage_unit = @dn and item = @itemName and weapon = @weapon", {['@dn'] = unitNumber, ['@itemName'] = weaponName, ['@weapon'] = true})
    if result[1] ~= nil then
        MySQL.Async.execute(
            "DELETE FROM `user_storages_items` WHERE `id` = @id",
            {
                ['@id'] = result[1].id
            }
        )
        xPlayer.addWeapon(weaponName, 255)
        sendNotification(xPlayer.source, 'Du tog ut '.. ESX.GetWeaponLabel(weaponName), 'success')
    else
        sendNotification(xPlayer.source, 'Något fel inträffade kontakta Admin', 'error')
    end
end)


--gets drugs
ESX.RegisterServerCallback('esx_wille_lager:getKeys', function(source, cb)
    local identifier = ESX.GetPlayerFromId(source).identifier
    MySQL.Async.fetchAll('SELECT key_name, key_unit FROM user_keys WHERE identifier = @identifier', {['@identifier'] = identifier},
    function(result)
    if identifier ~= nil then
        local keys = {}

        for i=1, #result, 1 do
            table.insert(keys, {
                kN = result[i].key_name,
                kU = result[i].key_unit,
            })
        end
            cb(keys)
        else
            print('error')
        end
    end)
    Citizen.Wait(1000)
end)

ESX.RegisterServerCallback('esx_wille_lager:getKeysSimple', function(source, cb, keyNameClient)
    local identifier = ESX.GetPlayerFromId(source).identifier
    MySQL.Async.fetchAll('SELECT key_name, key_unit FROM user_keys WHERE key_name = @nice and identifier = @identifier', {['@nice'] = keyNameClient, ['@identifier'] = identifier},
    function(result)
        if result[1] ~= nil then
            if identifier ~= nil then
                cb(result[1].key_name)
            else
                print('error')
            end
        else
            cb(false)
        end
    end)
end)

ESX.RegisterServerCallback('esx_wille_lager:getStorages', function(source, cb, owner)
    local identifier = ESX.GetPlayerFromId(source).identifier
    local result = nil

    if owner == nil then
        result = MySQL.Sync.fetchAll("SELECT storage_unit, storage_key_name FROM user_storages", {})
    else
        result = MySQL.Sync.fetchAll("SELECT storage_unit, storage_key_name FROM user_storages WHERE identifier = @identifier", {['@identifier'] = identifier})
    end

    if identifier ~= nil then
        local keys2 = {}


        for i=1, #result, 1 do
            table.insert(keys2, {
                kN = result[i].storage_key_name,
                kU = result[i].storage_unit,
            })
        end
        cb(keys2)
    else
        print('error')
    end
end)

ESX.RegisterServerCallback('esx_wille_lager:getInventory', function(source, cb, storageUnit)
    local identifier = ESX.GetPlayerFromId(source).identifier
    local result = MySQL.Sync.fetchAll("SELECT * FROM user_storages_items WHERE storage_unit = @dn and weapon = @yes", {['@dn'] = storageUnit, ['@yes'] = false})
    local resultWeapons = MySQL.Sync.fetchAll("SELECT * FROM user_storages_items WHERE storage_unit = @dn and weapon = @yes", {['@dn'] = storageUnit, ['@yes'] = true})
    --print(resultWeapons[1].item)
    if identifier ~= nil then
        local items = {}
        local weapons = {}

        for i=1, #resultWeapons, 1 do
            table.insert(weapons, {
                weaponName = resultWeapons[i].item,
            })
        end

        for i=1, #result, 1 do
            table.insert(items, {
                itemName = result[i].item,
                label = ItemsLabels[result[i].item],
                count = result[i].count
            })
        end

        cb({
            items = items, 
            weapons = weapons
        })
    end
end)

ESX.RegisterServerCallback('esx_wille_lager:getPlayerInventory', function(source, cb)

  local xPlayer = ESX.GetPlayerFromId(source)
  local items   = xPlayer.inventory

    cb({
        weapons     = xPlayer.loadout,
        items = items
    })

end)

--notification
function sendNotification(xSource, message, messageType)
    TriggerClientEvent("pNotify:SendNotification", xSource, {text = message, type = messageType, timeout = 5000, layout = "bottomCenter"})
end