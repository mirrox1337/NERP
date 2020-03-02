ESX                = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
  TriggerEvent('esx_service:activateService', 'bennys', Config.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'bennys', _U('bennys_customer'), false, false)
TriggerEvent('esx_society:registerSociety', 'bennys', 'Bennys', 'society_bennys', 'society_bennys', 'society_bennys', {type = 'private'})

ESX.RegisterServerCallback('esx_bennysjob:getFineList', function(source, cb, category)

  MySQL.Async.fetchAll(
    'SELECT * FROM fine_types_bennys WHERE category = @category',
    {
      ['@category'] = category
    },
    function(fines)
      cb(fines)
    end
  )

end)

RegisterServerEvent('esx_bennysjob:getStockItem')
AddEventHandler('esx_bennysjob:getStockItem', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mecano', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= count then
      inventory.removeItem(itemName, count)
      xPlayer.addInventoryItem(itemName, count)
    else
      TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = _U('invalid_quantity'), style = { ['background-color'] = '#b00000', ['color'] = '#fff' } })
    end

    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = _U('you_removed') .. count .. ' ' .. item.label, style = { ['background-color'] = '#009c10', ['color'] = '#fff' } })

  end)

end)

ESX.RegisterServerCallback('esx_bennysjob:getStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mecano', function(inventory)
    cb(inventory.items)
  end)

end)

RegisterServerEvent('esx_bennysjob:putStockItems')
AddEventHandler('esx_bennysjob:putStockItems', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mecano', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= 0 then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
    else
      TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = _U('invalid_quantity'), style = { ['background-color'] = '#b00000', ['color'] = '#fff' } })
    end

    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = _U('you_added') .. count .. ' ' .. item.label, style = { ['background-color'] = '#009c10', ['color'] = '#fff' } })

  end)

end)

ESX.RegisterServerCallback('esx_bennysjob:getPlayerInventory', function(source, cb)

  local xPlayer    = ESX.GetPlayerFromId(source)
  local items      = xPlayer.inventory

  cb({
    items      = items
  })

end)
