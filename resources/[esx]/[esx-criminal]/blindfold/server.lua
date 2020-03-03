local ESX = nil

-- ESX
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Sätt på/ta av ögonbindel
RegisterServerEvent('blindfold')
AddEventHandler('blindfold', function( player, hasItem )
  local src = source
  TriggerClientEvent('blindfold', player, hasItem, src)
end)

-- Notis skickas om spelaren inte har en ögonbindel
RegisterServerEvent('blindfold:notis')
AddEventHandler('blindfold:notis', function( src )
  TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'error', text = 'Du har ingen ögonbindel på dig' })
end)

-- Ger spelaren en ögonbindel
RegisterServerEvent('blindfold:giveItem')
AddEventHandler('blindfold:giveItem', function( src )
  local xPlayer = ESX.GetPlayerFromId(src)
  xPlayer.addInventoryItem('blindfold', 1)
end)

-- Kollar om spelaren har en ögonbindel
ESX.RegisterServerCallback('blindfold:itemCheck', function( src, cb )
  local xPlayer = ESX.GetPlayerFromId(src)
  local item    = xPlayer.getInventoryItem('blindfold').count
  if item > 0 then
    cb(true)
    xPlayer.removeInventoryItem('blindfold', 1)
  else
    cb(false)
  end
end)
