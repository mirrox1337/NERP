ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_ambulancejob:revive')
AddEventHandler('esx_ambulancejob:revive', function(target)
  TriggerClientEvent('esx_ambulancejob:revive', target)
end)
RegisterServerEvent('esx_ambulancejob:heal')
AddEventHandler('esx_ambulancejob:heal', function(target, type)
  TriggerClientEvent('esx_ambulancejob:heal', target, type)
end)

TriggerEvent('esx_phone:registerNumber', 'ambulance', _U('alert_ambulance'), true, true)
TriggerEvent('esx_society:registerSociety', 'ambulance', 'Ambulance', 'society_ambulance', 'society_ambulance', 'society_ambulance', {type = 'public'})

ESX.RegisterServerCallback('esx_ambulancejob:removeItemsAfterRPDeath', function(source, cb)

  local xPlayer = ESX.GetPlayerFromId(source)

  if Config.RemoveCashAfterRPDeath then


    if xPlayer.getMoney() > 0 then
      xPlayer.removeMoney(xPlayer.getMoney())
    end


    if xPlayer.getAccount('black_money').money > 0 then
      xPlayer.setAccountMoney('black_money', 0)
    end


  end

  if Config.RemoveItemsAfterRPDeath then
    for i=1, #xPlayer.inventory, 1 do
      if xPlayer.inventory[i].count > 0 then
        xPlayer.setInventoryItem(xPlayer.inventory[i].name, 0)
      end
    end
  end

  if Config.RemoveWeaponsAfterRPDeath then
    for i=1, #xPlayer.loadout, 1 do
      xPlayer.removeWeapon(xPlayer.loadout[i].name)
    end
  end

  if Config.RespawnFine then
    xPlayer.removeAccountMoney('bank', Config.RespawnFineAmount)
  end
  
  RemoveLicense(xPlayer)

  cb()

end)

RegisterServerEvent('esx_ambulancejob:drag')
AddEventHandler('esx_ambulancejob:drag', function(target)
  local _source = source
  TriggerClientEvent('esx_ambulancejob:drag', target, _source)
end)


ESX.RegisterServerCallback('esx_ambulancejob:getItemAmount', function(source, cb, item)
  local xPlayer = ESX.GetPlayerFromId(source)
  local qtty = xPlayer.getInventoryItem(item).count
  cb(qtty)
end)

RegisterServerEvent('esx_ambulancejob:removeItem')
AddEventHandler('esx_ambulancejob:removeItem', function(item)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  xPlayer.removeInventoryItem(item, 1)
  if item == 'bandage' then
    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = _U('used_bandage'), style = { ['background-color'] = '#009c10', ['color'] = '#fff' } })
  elseif item == 'medikit' then
    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = _U('used_medikit'), style = { ['background-color'] = '#009c10', ['color'] = '#fff' } })
  end
end)

RegisterServerEvent('esx_ambulancejob:giveItem')
AddEventHandler('esx_ambulancejob:giveItem', function(item)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  local limit = 20
  local delta = 1
  local qtty = 19
  if limit ~= -1 then
    delta = limit - qtty
  end
  if qtty < limit then
    xPlayer.addInventoryItem(item, delta)
  else
    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = _U('max_item'), style = { ['background-color'] = '#b00000', ['color'] = '#fff' } })
  end
end)

RegisterServerEvent('esx_ambulancejob:putInVehicle')
AddEventHandler('esx_ambulancejob:putInVehicle', function(target)
  TriggerClientEvent('esx_ambulancejob:putInVehicle', target)
end)

TriggerEvent('es:addGroupCommand', 'revive', 'admin', function(source, args, user)

  if args[2] ~= nil then
    TriggerClientEvent('esx_ambulancejob:revive', tonumber(args[2]))
  else
    TriggerClientEvent('esx_ambulancejob:revive', source)
  end

end, function(source, args, user)
  TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficient Permissions.")
end, {help = _U('revive_help'), params = {{name = 'id'}}})

TriggerEvent('es:addGroupCommand', 'revivea', 'mod', function(source, args, user)

  if args[2] ~= nil then
    TriggerClientEvent('esx_ambulancejob:revive', tonumber(args[2]))
  else
    TriggerClientEvent('esx_ambulancejob:revive', source)
  end

end, function(source, args, user)
  TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficient Permissions.")
end, {help = _U('revive_help'), params = {{name = 'id'}}})



ESX.RegisterServerCallback('esx_ambulancejob:getFineList', function(source, cb, category)

  MySQL.Async.fetchAll(
    'SELECT * FROM fine_types_ambulance WHERE category = @category',
    {
      ['@category'] = category
    },
    function(fines)
      cb(fines)
    end
  )

end)

-- RegisterServerEvent('esx_ambulancejob:removeLicense')
-- AddEventHandler('esx_ambulancejob:removeLicense', function(source, cb)
	
	-- local _source = source
	-- local identifier = GetPlayerIdentifiers(_source)

	-- MySQL.Async.fetchAll(
    -- 'DELETE * FROM user_licenses WHERE identifier = @identifier',
    -- {
      -- ['@identifier'] = identifier
    -- },
	-- )
-- end)


RegisterServerEvent('esx_ambulancejob:success')
AddEventHandler('esx_ambulancejob:success', function()

  math.randomseed(os.time())

  local xPlayer        = ESX.GetPlayerFromId(source)
  local total          = math.random(Config.NPCJobEarnings.min, Config.NPCJobEarnings.max);
  local societyAccount = nil

  if xPlayer.job.grade >= 3 then
    total = total * 2
  end

  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_ambulance', function(account)
    societyAccount = account
  end)

  if societyAccount ~= nil then

    local playerMoney  = math.floor(total / 100 * 30)
    local societyMoney = math.floor(total / 100 * 70)

    xPlayer.addMoney(playerMoney)
    societyAccount.addMoney(societyMoney)

    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = _U('have_earned') .. playerMoney, style = { ['background-color'] = '#009c10', ['color'] = '#fff' } })
    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = _U('comp_earned') .. societyMoney, style = { ['background-color'] = '#009c10', ['color'] = '#fff' } })

  else

    xPlayer.addMoney(total)
    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = _U('have_earned') .. total, style = { ['background-color'] = '#009c10', ['color'] = '#fff' } })

  end

end)

ESX.RegisterUsableItem('medikit', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  xPlayer.removeInventoryItem('medikit', 1)
  TriggerClientEvent('esx_ambulancejob:heal', source, 'big')
  TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = _U('used_medikit'), style = { ['background-color'] = '#009c10', ['color'] = '#fff' } })
end)

ESX.RegisterUsableItem('pills', function(source)
  local xPlayer  = ESX.GetPlayerFromId(source)
  xPlayer.removeInventoryItem('pills', 1)
  TriggerClientEvent('shakeCam', _source, false)
  TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = _U('used_pills'), style = { ['background-color'] = '#009c10', ['color'] = '#fff' } })
end)

function RemoveLicense(xPlayer)

	MySQL.Async.execute(
		'DELETE FROM user_licenses WHERE owner = @owner',
		{
			['@owner'] = xPlayer.identifier
		}
	)
end

ESX.RegisterServerCallback('esx_ambulancejob:getStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_ambulance', function(inventory)
    cb(inventory.items)
  end)

end)

RegisterServerEvent('esx_ambulancejob:getStockItem')
AddEventHandler('esx_ambulancejob:getStockItem', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_ambulance', function(inventory)

    local inventoryItem = inventory.getItem(itemName)

    if count > 0 and inventoryItem.count >= count then
      inventory.removeItem(itemName, count)
      xPlayer.addInventoryItem(itemName, count)
    else
      TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = _U('quantity_invalid'), style = { ['background-color'] = '#b00000', ['color'] = '#fff' } })
    end

        --TriggerClientEvent('esx:showNotification', _source, _U('have_withdrawn', count, inventoryItem.label))

  end)

end)

RegisterServerEvent('esx_ambulancejob:putStockItems')
AddEventHandler('esx_ambulancejob:putStockItems', function(itemName, count)

local xPlayer = ESX.GetPlayerFromId(source)
 local sourceItem = xPlayer.getInventoryItem(itemName)

TriggerEvent('esx_addoninventory:getSharedInventory', 'society_ambulance', function(inventory)

local inventoryItem = inventory.getItem(itemName)

   -- does the player have enough of the item?
   if sourceItem.count >= count and count > 0 then
     xPlayer.removeInventoryItem(itemName, count)
     inventory.addItem(itemName, count)
     TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = _U('have_deposited', count, inventoryItem.label), style = { ['background-color'] = '#009c10', ['color'] = '#fff' } })
   else
     TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = _U('quantity_invalid'), style = { ['background-color'] = '#b00000', ['color'] = '#fff' } })
   end

  end)

end)



ESX.RegisterServerCallback('esx_ambulancejob:getPlayerInventory', function(source, cb)

  local xPlayer    = ESX.GetPlayerFromId(source)
  local items      = xPlayer.inventory

  cb({
    items      = items
  })

end)

RegisterServerEvent('esx_ambulancejob:setDeathStatus')
AddEventHandler('esx_ambulancejob:setDeathStatus', function(isDead)
	local identifier = GetPlayerIdentifiers(source)[1]

	MySQL.Sync.execute('UPDATE users SET is_dead = @isDead WHERE identifier = @identifier', {
		['@identifier'] = identifier,
		['@isDead']     = isDead
	})
end)



ESX.RegisterServerCallback('esx_ambulancejob:getDeathStatus', function(source, cb)
  local identifier = GetPlayerIdentifiers(source)[1]

  MySQL.Async.fetchScalar('SELECT is_dead FROM users WHERE identifier = @identifier', {
      ['@identifier'] = identifier
  }, function(isDead)
      if isDead then
          print(('esx_ambulancejob: %s attempted combat logging!'):format(identifier))
      end

      cb(isDead)
  end)
end)

RegisterServerEvent('card:giveItem')
AddEventHandler('card:giveItem', function()
  local xPlayer = ESX.GetPlayerFromId(source)

  if xPlayer.job.name == 'ambulance' then

    if xPlayer.getInventoryItem('ambulansnyckel')['count'] == 0 then
        xPlayer.setInventoryItem('ambulansnyckel', 1)
      else
        xPlayer.setInventoryItem('ambulansnyckel', 0)
    end
  end
end)