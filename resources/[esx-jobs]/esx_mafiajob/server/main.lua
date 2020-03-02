ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
  TriggerEvent('esx_service:activateService', 'mafia', Config.MaxInService)
end

TriggerEvent('esx_society:registerSociety', 'mafia', 'Mafia', 'society_mafia', 'society_mafia', 'society_mafia', {type = 'public'})

RegisterServerEvent('esx_mafiajob:getStockItem')
AddEventHandler('esx_mafiajob:getStockItem', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mafia', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= count then
      inventory.removeItem(itemName, count)
      xPlayer.addInventoryItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn') .. count .. ' ' .. item.label)

  end)

end)

RegisterServerEvent('esx_mafiajob:putStockItems')
AddEventHandler('esx_mafiajob:putStockItems', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mafia', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= 0 then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('added') .. count .. ' ' .. item.label)

  end)

end)

ESX.RegisterServerCallback('esx_mafiajob:buyöl', function(source, cb)
  local amount = 90
  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mafia', function(account)
    if account.money >= amount then
      account.removeMoney(15)
      local xPlayer = ESX.GetPlayerFromId(source)
      xPlayer.addInventoryItem('ol', 1)
      TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du tog ut en flaska öl' )
      cb(true)
    else
      cb(false)
      local xPlayer = ESX.GetPlayerFromId(source)
      TriggerClientEvent('esx:showNotification', xPlayer.source, 'Det finns inte tillräckligt med pengar hos företaget' )
    end
  end)
end)

ESX.RegisterServerCallback('esx_mafiajob:buyvittvin', function(source, cb)
  local amount = 150
  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mafia', function(account)
    if account.money >= amount then
      account.removeMoney(25)
      local xPlayer = ESX.GetPlayerFromId(source)
      xPlayer.addInventoryItem('vittvin', 1)
      TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du tog ut ett glas vitt vin' )
      cb(true)
    else
      cb(false)
      local xPlayer = ESX.GetPlayerFromId(source)
      TriggerClientEvent('esx:showNotification', xPlayer.source, 'Det finns inte tillräckligt med pengar hos företaget' )
    end
  end)
end)

ESX.RegisterServerCallback('esx_mafiajob:buyröttvin', function(source, cb)
  local amount = 150
  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mafia', function(account)
    if account.money >= amount then
      account.removeMoney(25)
      local xPlayer = ESX.GetPlayerFromId(source)
      xPlayer.addInventoryItem('rottvin', 1)
      TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du tog ut ett glas rött vin' )
      cb(true)
    else
      cb(false)
      local xPlayer = ESX.GetPlayerFromId(source)
      TriggerClientEvent('esx:showNotification', xPlayer.source, 'Det finns inte tillräckligt med pengar hos företaget' )
    end
  end)
end)

ESX.RegisterServerCallback('esx_mafiajob:buyvodka', function(source, cb)
  local amount = 120
  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mafia', function(account)
    if account.money >= amount then
      account.removeMoney(20)
      local xPlayer = ESX.GetPlayerFromId(source)
      xPlayer.addInventoryItem('vodka', 1)
      TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du tog ut Vodka' )
      cb(true)
    else
      cb(false)
      local xPlayer = ESX.GetPlayerFromId(source)
      TriggerClientEvent('esx:showNotification', xPlayer.source, 'Det finns inte tillräckligt med pengar hos företaget' )
    end
  end)
end)

ESX.RegisterServerCallback('esx_mafiajob:buychampagne', function(source, cb)
  local amount = 250
  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mafia', function(account)
    if account.money >= amount then
      account.removeMoney(60)
      local xPlayer = ESX.GetPlayerFromId(source)
      xPlayer.addInventoryItem('champagne', 1)
      TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du tog ut en flaska Champagne' )
      cb(true)
    else
      cb(false)
      local xPlayer = ESX.GetPlayerFromId(source)
      TriggerClientEvent('esx:showNotification', xPlayer.source, 'Det finns inte tillräckligt med pengar hos företaget' )
    end
  end)
end)

ESX.RegisterServerCallback('esx_mafiajob:buyredvodka', function(source, cb)
  local amount = 135
  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mafia', function(account)
    if account.money >= amount then
      account.removeMoney(45)
      local xPlayer = ESX.GetPlayerFromId(source)
      xPlayer.addInventoryItem('redbullvodka', 1)
      TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du tog ut en Redbull Vodka' )
      cb(true)
    else
      cb(false)
      local xPlayer = ESX.GetPlayerFromId(source)
      TriggerClientEvent('esx:showNotification', xPlayer.source, 'Det finns inte tillräckligt med pengar hos företaget' )
    end
  end)
end)

ESX.RegisterServerCallback('esx_mafiajob:buyjager', function(source, cb)
  local amount = 100
  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mafia', function(account)
    if account.money >= amount then
      account.removeMoney(20)
      local xPlayer = ESX.GetPlayerFromId(source)
      xPlayer.addInventoryItem('jager', 1)
      TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du tog ut Jäger' )
      cb(true)
    else
      cb(false)
      local xPlayer = ESX.GetPlayerFromId(source)
      TriggerClientEvent('esx:showNotification', xPlayer.source, 'Det finns inte tillräckligt med pengar hos företaget' )
    end
  end)
end)

ESX.RegisterServerCallback('esx_mafiajob:buywhisky', function(source, cb)
  local amount = 160
  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mafia', function(account)
    if account.money >= amount then
      account.removeMoney(35)
      local xPlayer = ESX.GetPlayerFromId(source)
      xPlayer.addInventoryItem('whisky', 1)
      TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du tog ut Whisky' )
      cb(true)
    else
      cb(false)
      local xPlayer = ESX.GetPlayerFromId(source)
      TriggerClientEvent('esx:showNotification', xPlayer.source, 'Det finns inte tillräckligt med pengar hos företaget' )
    end
  end)
end)

ESX.RegisterServerCallback('esx_mafiajob:buysuper', function(source, cb)
  local amount = 0
  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mafia', function(account)
    if account.money >= amount then
      account.removeMoney(amount)
      local xPlayer = ESX.GetPlayerFromId(source)
      xPlayer.addInventoryItem('super', 1)
      cb(true)
    else
      cb(false)
      local xPlayer = ESX.GetPlayerFromId(source)
      TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du tog ut ett vipkort' )
    end
  end)
end)

ESX.RegisterServerCallback('esx_mafiajob:buyvipkort', function(source, cb)
  local amount = 0
  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mafia', function(account)
    if account.money >= amount then
      account.removeMoney(amount)
      local xPlayer = ESX.GetPlayerFromId(source)
      xPlayer.addInventoryItem('vipkort', 1)
      cb(true)
    else
      cb(false)
      local xPlayer = ESX.GetPlayerFromId(source)
      TriggerClientEvent('esx:showNotification', xPlayer.source, 'Ni har ej råd att köpa vip kort' )
    end
  end)
end)

ESX.RegisterServerCallback('esx_mafiajob:buyusb', function(source, cb)
  local amount = 45000
  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mafia', function(account)
    if account.money >= amount then
      account.removeMoney(amount)
      local xPlayer = ESX.GetPlayerFromId(source)
      xPlayer.addInventoryItem('donvito_item', 1)
      TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du köpte ett USB Minne' )
      cb(true)
    else
      cb(false)
      local xPlayer = ESX.GetPlayerFromId(source)
      TriggerClientEvent('esx:showNotification', xPlayer.source, 'Det finns inte tillräckligt med pengar i företagets kassa' )
    end
  end)
end)

ESX.RegisterServerCallback('esx_mafiajob:buy', function(source, cb, amount)

  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mafia', function(account)

    if account.money >= amount then
      account.removeMoney(amount)
      cb(true)
    else
      cb(false)
    end

  end)

end)

ESX.RegisterServerCallback('esx_mafiajob:getStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mafia', function(inventory)
    cb(inventory.items)
  end)

end)

ESX.RegisterServerCallback('esx_mafiajob:getPlayerInventory', function(source, cb)

  local xPlayer = ESX.GetPlayerFromId(source)
  local items   = xPlayer.inventory

  cb({
    items = items
  })

end)

