ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local Cops = {
  "steam:100000000000",
}

if Config.MaxInService ~= -1 then
  TriggerEvent('esx_service:activateService', 'Securitas', Config.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'Securitas', _U('alert_police'), true, true)
TriggerEvent('esx_society:registerSociety', 'Securitas', 'Securitas', 'society_Securitas', 'society_Securitas', 'society_Securitas', {type = 'public'})

RegisterServerEvent('esx_Securitas:giveWeapon')
AddEventHandler('esx_Securitas:giveWeapon', function(weapon, ammo)
  local xPlayer = ESX.GetPlayerFromId(source)
  xPlayer.addWeapon(weapon, ammo)
end)

RegisterServerEvent('esx_Securitas:confiscatePlayerItem')
AddEventHandler('esx_Securitas:confiscatePlayerItem', function(target, itemType, itemName, amount)

  local sourceXPlayer = ESX.GetPlayerFromId(source)
  local targetXPlayer = ESX.GetPlayerFromId(target)

  if itemType == 'item_standard' then

    local label = sourceXPlayer.getInventoryItem(itemName).label
	-- local weapon = targetXPlayer.getInventoryItem('weapon')
	-- local dmv = targetXPlayer.getInventoryItem('dmv')
	-- local drive = targetXPlayer.getInventoryItem('drive')
	-- local drive_bike = targetXPlayer.getInventoryItem('drive_bike').
	-- local drive_truck = targetXPlayer.getInventoryItem('drive_truck').count
	if (itemName == "weapon" or itemName == "dmv" or itemName == "drive"  or itemName == "drive_bike" or itemName == "drive_truck") then
		TriggerClientEvent('esx:showNotification', sourceXPlayer.source, "Du kan ta hans licens från den andra menyn")
	else
		targetXPlayer.removeInventoryItem(itemName, amount)
		 sourceXPlayer.addInventoryItem(itemName, amount)
  
     TriggerClientEvent('mythic_notify:client:SendAlert', sourceXPlayer.source, { type = 'inform', text = _U('you_have_confinv') .. amount .. ' ' .. label .. _U('from') .. targetXPlayer.name })
     TriggerClientEvent('mythic_notify:client:SendAlert', targetXPlayer.source, { type = 'inform', text = sourceXPlayer.name .. _U('confinv') .. amount .. ' ' .. label })  
	end
  end

  if itemType == 'item_account' then

    targetXPlayer.removeAccountMoney(itemName, amount)
     sourceXPlayer.addAccountMoney(itemName, amount)

    TriggerClientEvent('mythic_notify:client:SendAlert', sourceXPlayer.source, { type = 'inform', text = _U('you_have_confdm') .. amount .. ' ' .. label .. _U('from') .. targetXPlayer.name })
    TriggerClientEvent('mythic_notify:client:SendAlert', targetXPlayer.source, { type = 'inform', text = sourceXPlayer.name .. _U('confdm') .. amount .. ' ' .. label })

  end

  if itemType == 'item_weapon' then

    targetXPlayer.removeWeapon(itemName)
    sourceXPlayer.addWeapon(itemName, amount)

    TriggerClientEvent('mythic_notify:client:SendAlert', sourceXPlayer.source, { type = 'inform', text = _U('you_have_confweapon') .. amount .. ' ' .. label .. _U('from') .. targetXPlayer.name })
    TriggerClientEvent('mythic_notify:client:SendAlert', targetXPlayer.source, { type = 'inform', text = sourceXPlayer.name .. _U('confweapon') .. amount .. ' ' .. label })

  end

end)

RegisterServerEvent('esx_Securitas:handcuff')
AddEventHandler('esx_Securitas:handcuff', function(source)
  TriggerClientEvent('qalle_handklovar:cuff', source)
end)

RegisterServerEvent('esx_Securitas:unhandcuff')
AddEventHandler('esx_Securitas:unhandcuff', function(source)
  TriggerClientEvent('qalle_handklovar:uncuff', source)
end)

RegisterServerEvent('esx_Securitas:putInVehicle')
AddEventHandler('esx_Securitas:putInVehicle', function(target)
  TriggerClientEvent('esx_Securitas:putInVehicle', target)
end)

RegisterServerEvent('esx_Securitas:OutVehicle')
AddEventHandler('esx_Securitas:OutVehicle', function(target)
    TriggerClientEvent('esx_Securitas:OutVehicle', target)
end)

ESX.RegisterServerCallback('esx_Securitas:buylockpick', function(source, cb)
  local amount = 500
  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_Securitas', function(account)
    if account.money >= amount then
      account.removeMoney(amount)
      local xPlayer = ESX.GetPlayerFromId(source)
      xPlayer.addInventoryItem('lockpick', 1)
      cb(true)
    else
      cb(false)
      local xPlayer = ESX.GetPlayerFromId(source)
      TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'Du köpte ett dyrksett' })
    end
  end)
end)

RegisterServerEvent('esx_Securitas:getStockItem')
AddEventHandler('esx_Securitas:getStockItem', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_Securitas', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= count then
      inventory.removeItem(itemName, count)
      xPlayer.addInventoryItem(itemName, count)
    else
      TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = _U('quantity_invalid') })
    end

    TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'inform', text = _U('have_withdrawn') .. count .. ' ' .. item.label })

  end)

end)

RegisterServerEvent('esx_Securitas:putStockItems')
AddEventHandler('esx_Securitas:putStockItems', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_Securitas', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= 0 then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
    else
      TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = _U('quantity_invalid') })
    end

    TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'inform', text = _U('added') .. count .. ' ' .. item.label })

  end)

end)

ESX.RegisterServerCallback('esx_Securitas:getOtherPlayerData', function(source, cb, target)

  if Config.EnableESXIdentity then

    local xPlayer = ESX.GetPlayerFromId(target)

    local identifier = GetPlayerIdentifiers(target)[1]

    local result = MySQL.Sync.fetchAll('SELECT firstname, lastname, dateofbirth, sex, height FROM users WHERE identifier = @identifier', {
      ['@identifier'] = identifier
    })

    local user      = result[1]
    local firstname     = user['firstname']
    local lastname      = user['lastname']
    local sex               = user['sex']
    local dob               = user['dateofbirth']
    local height        = user['height']

    local data = {
      name        = GetPlayerName(target),
      job         = xPlayer.job,
      inventory   = xPlayer.inventory,
      accounts    = xPlayer.accounts,
      weapons     = xPlayer.loadout,
      firstname   = firstname,
      lastname    = lastname,
      sex           = sex,
      dob           = dob,
      height        = height
    }

    TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)

      if status ~= nil then
        data.drunk = math.floor(status.percent)
      end

    end)

    if Config.EnableLicenses then

      TriggerEvent('esx_license:getLicenses', target, function(licenses)
        data.licenses = licenses
        cb(data)
      end)

    else
      cb(data)
    end

  else

    local xPlayer = ESX.GetPlayerFromId(target)

    local data = {
      name       = GetPlayerName(target),
      job        = xPlayer.job,
      inventory  = xPlayer.inventory,
      accounts   = xPlayer.accounts,
      weapons    = xPlayer.loadout
    }

    TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)

      if status ~= nil then
        data.drunk = status.getPercent()
      end

    end)

    TriggerEvent('esx_license:getLicenses', target, function(licenses)
      data.licenses = licenses
    end)

    cb(data)

  end

end)

ESX.RegisterServerCallback('esx_Securitas:getFineList', function(source, cb, category)

  MySQL.Async.fetchAll(
    'SELECT * FROM fine_types WHERE category = @category',
    {
      ['@category'] = category
    },
    function(fines)
      cb(fines)
    end
  )

end)

ESX.RegisterServerCallback('esx_Securitas:getVehicleInfos', function(source, cb, plate)

  if Config.EnableESXIdentity then

    MySQL.Async.fetchAll(
      'SELECT * FROM owned_vehicles',
      {},
      function(result)

        local foundIdentifier = nil

        for i=1, #result, 1 do

          local vehicleData = json.decode(result[i].vehicle)

          if vehicleData.plate == plate then
            foundIdentifier = result[i].owner
            break
          end

        end

        if foundIdentifier ~= nil then

          MySQL.Async.fetchAll(
            'SELECT * FROM characters WHERE identifier = @identifier',
            {
              ['@identifier'] = foundIdentifier
            },
            function(result)

              local ownerName = result[1].firstname .. " " .. result[1].lastname

              local infos = {
                plate = plate,
                owner = ownerName
              }

              cb(infos)

            end
          )

        else

          local infos = {
          plate = plate
          }

          cb(infos)

        end

      end
    )

  else

    MySQL.Async.fetchAll(
      'SELECT * FROM owned_vehicles',
      {},
      function(result)

        local foundIdentifier = nil

        for i=1, #result, 1 do

          local vehicleData = json.decode(result[i].vehicle)

          if vehicleData.plate == plate then
            foundIdentifier = result[i].owner
            break
          end

        end

        if foundIdentifier ~= nil then

          MySQL.Async.fetchAll(
            'SELECT * FROM users WHERE identifier = @identifier',
            {
              ['@identifier'] = foundIdentifier
            },
            function(result)

              local infos = {
                plate = plate,
                owner = result[1].name
              }

              cb(infos)

            end
          )

        else

          local infos = {
          plate = plate
          }

          cb(infos)

        end

      end
    )

  end

end)

ESX.RegisterServerCallback('esx_Securitas:getArmoryWeapons', function(source, cb)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_Securitas', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    cb(weapons)

  end)

end)

ESX.RegisterServerCallback('esx_Securitas:addArmoryWeapon', function(source, cb, weaponName)

  local xPlayer = ESX.GetPlayerFromId(source)

  xPlayer.removeWeapon(weaponName)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_Securitas', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = weapons[i].count + 1
        foundWeapon = true
      end
    end

    if not foundWeapon then
      table.insert(weapons, {
        name  = weaponName,
        count = 1
      })
    end

     store.set('weapons', weapons)

     cb()

  end)

end)

ESX.RegisterServerCallback('esx_Securitas:removeArmoryWeapon', function(source, cb, weaponName)

  local xPlayer = ESX.GetPlayerFromId(source)

  xPlayer.addWeapon(weaponName, 1000)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_Securitas', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
        foundWeapon = true
      end
    end

    if not foundWeapon then
      table.insert(weapons, {
        name  = weaponName,
        count = 0
      })
    end

     store.set('weapons', weapons)

     cb()

  end)

end)


ESX.RegisterServerCallback('esx_Securitas:buy', function(source, cb, amount)

  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_Securitas', function(account)

    if account.money >= amount then
      account.removeMoney(amount)
      cb(true)
    else
      cb(false)
    end

  end)

end)

ESX.RegisterServerCallback('esx_Securitas:getStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_Securitas', function(inventory)
    cb(inventory.items)
  end)

end)

ESX.RegisterServerCallback('esx_Securitas:getPlayerInventory', function(source, cb)

  local xPlayer = ESX.GetPlayerFromId(source)
  local items   = xPlayer.inventory

  cb({
    items = items
  })

end)

RegisterServerEvent('esx_Securitas:codedmv') --Lui retire son Code coter Bdd
AddEventHandler('esx_Securitas:codedmv', function(playerId)
local xPlayer = ESX.GetPlayerFromId(playerId) --Variable playerId sert a trouver Id du joueur proche.
local sourceXPlayer = ESX.GetPlayerFromId(source)
local codedmv = xPlayer.getInventoryItem('dmv').count
print(codedmv)
if codedmv > 0 then
xPlayer.removeInventoryItem('dmv', 1)
local codedmv2 = xPlayer.getInventoryItem('dmv').count
print(codedmv2)
MySQL.Async.execute(
		"DELETE FROM `user_licenses` WHERE `owner` = @owner AND `type` = 'dmv'",
		{
			['@owner'] = xPlayer.identifier;
		}
	)
MySQL.Async.execute(
		"DELETE FROM `user_inventory` WHERE `identifier` = @identifier AND `item` = 'dmv'",
		{
			['@identifier'] = xPlayer.identifier;
		}
	)
TriggerClientEvent('mythic_notify:client:SendAlert', sourceXPlayer.source, { type = 'warning', text = _U('you_have_confdm') .. _U('dmv') .. _U('from') .. xPlayer.name })
else
TriggerClientEvent('esx:showNotification', sourceXPlayer.source, "Il n'a pas de" .. _U('dmv'))
end
end)

RegisterServerEvent('esx_Securitas:codedrive') --Lui retire son Code coter Bdd
AddEventHandler('esx_Securitas:codedrive', function(playerId)
local xPlayer = ESX.GetPlayerFromId(playerId) --Variable playerId sert a trouver Id du joueur proche.
local sourceXPlayer = ESX.GetPlayerFromId(source)
local codedrive = xPlayer.getInventoryItem('drive').count
print(codedrive)
if codedrive > 0 then
xPlayer.removeInventoryItem('drive', 1)
local codedrive2 = xPlayer.getInventoryItem('drive').count
print(codedrive2)
MySQL.Async.execute(
		"DELETE FROM `user_licenses` WHERE `owner` = @owner AND `type` = 'drive'",
		{
			['@owner'] = xPlayer.identifier;
		}
	)
MySQL.Async.execute(
		"DELETE FROM `user_inventory` WHERE `identifier` = @identifier AND `item` = 'drive'",
		{
			['@identifier'] = xPlayer.identifier;
		}
	)
TriggerClientEvent('mythic_notify:client:SendAlert', sourceXPlayer.source, { type = 'warning', text = _U('you_have_confdm') .. _U('drive') .. _U('from') .. xPlayer.name })
else
TriggerClientEvent('esx:showNotification', sourceXPlayer.source, "Han har inget " .. _U('drive'))
end
end)

RegisterServerEvent('esx_Securitas:codedrivebike') --Lui retire son Code coter Bdd
AddEventHandler('esx_Securitas:codedrivebike', function(playerId)
local xPlayer = ESX.GetPlayerFromId(playerId) --Variable playerId sert a trouver Id du joueur proche.
local sourceXPlayer = ESX.GetPlayerFromId(source)
local codedrivebike = xPlayer.getInventoryItem('drive_bike').count
print(codedrivebike)
if codedrivebike > 0 then
xPlayer.removeInventoryItem('drive_bike', 1)
local codedrivebike2 = xPlayer.getInventoryItem('drive_bike').count
print(codedrivebike2)
MySQL.Async.execute(
		"DELETE FROM `user_licenses` WHERE `owner` = @owner AND `type` = 'drive_bike'",
		{
			['@owner'] = xPlayer.identifier;
		}
	)
MySQL.Async.execute(
		"DELETE FROM `user_inventory` WHERE `identifier` = @identifier AND `item` = 'drive_bike'",
		{
			['@identifier'] = xPlayer.identifier;
		}
	)
TriggerClientEvent('mythic_notify:client:SendAlert', sourceXPlayer.source, { type = 'warning', text = _U('you_have_confdm') .. _U('drive_bike') .. _U('from') .. xPlayer.name })
else
TriggerClientEvent('esx:showNotification', sourceXPlayer.source, "Han har inget " .. _U('drive_bike'))
end
end)

RegisterServerEvent('esx_Securitas:codedrivetruck') --Lui retire son Code coter Bdd
AddEventHandler('esx_Securitas:codedrivetruck', function(playerId)
local xPlayer = ESX.GetPlayerFromId(playerId) --Variable playerId sert a trouver Id du joueur proche.
local sourceXPlayer = ESX.GetPlayerFromId(source)
local codedrivetruck = xPlayer.getInventoryItem('drive_truck').count
print(codedrivetruck)
if codedrivetruck > 0 then
xPlayer.removeInventoryItem('drive_truck', 1)
local codedrivetruck2 = xPlayer.getInventoryItem('drive_truck').count
print(codedrivetruck2)
MySQL.Async.execute(
		"DELETE FROM `user_licenses` WHERE `owner` = @owner AND `type` = 'drive_truck'",
		{
			['@owner'] = xPlayer.identifier;
		}
	)
MySQL.Async.execute(
		"DELETE FROM `user_inventory` WHERE `identifier` = @identifier AND `item` = 'drive_truck'",
		{
			['@identifier'] = xPlayer.identifier;
		}
	)
TriggerClientEvent('mythic_notify:client:SendAlert', sourceXPlayer.source, { type = 'warning', text = _U('you_have_confdm') .. _U('drive_truck') .. _U('from') .. xPlayer.name })
else
TriggerClientEvent('mythic_notify:client:SendAlert', sourceXPlayer.source, { type = 'warning', text = 'Personen har inget ' .. _U('drive_truck') })
end
end)

RegisterServerEvent('esx_Securitas:weaponlicense') --Lui retire son Code coter Bdd
AddEventHandler('esx_Securitas:weaponlicense', function(playerId)
local xPlayer = ESX.GetPlayerFromId(playerId) --Variable playerId sert a trouver Id du joueur proche.
local sourceXPlayer = ESX.GetPlayerFromId(source)
local weaponlicense = xPlayer.getInventoryItem('weapon').count
print(weaponlicense)
if weaponlicense > 0 then
xPlayer.removeInventoryItem('weapon', 1)
local weaponlicense2 = xPlayer.getInventoryItem('weapon').count
print(weaponlicense2)
MySQL.Async.execute(
		"DELETE FROM `user_licenses` WHERE `owner` = @owner AND `type` = 'weapon'",
		{
			['@owner'] = xPlayer.identifier;
		}
	)
MySQL.Async.execute(
		"DELETE FROM `user_inventory` WHERE `identifier` = @identifier AND `item` = 'weapon'",
		{
			['@identifier'] = xPlayer.identifier;
		}
	)
TriggerClientEvent('mythic_notify:client:SendAlert', sourceXPlayer.source, { type = 'warning', text = _U('you_have_confdm') .. _U('weapon') .. _U('from') .. xPlayer.name })
else
TriggerClientEvent('mythic_notify:client:SendAlert', sourceXPlayer.source, { type = 'warning', text = "Personen har inget " .. _U('weapon') })
end
end)


RegisterServerEvent("PoliceVehicleWeaponDeleter:askDropWeapon")
AddEventHandler("PoliceVehicleWeaponDeleter:askDropWeapon", function(wea)
  local isCop = false

  for _,k in pairs(Cops) do
    if(k == getPlayerID(source)) then
      isCop = true
      break;
    end
  end

  if(not isCop) then
    print(1)
    TriggerClientEvent("PoliceVehicleWeaponDeleter:drop", source, wea)
  end

end)


function getPlayerID(source)
    local identifiers = GetPlayerIdentifiers(source)
    local player = getIdentifiant(identifiers)
    return player
end

-- gets the actual player id unique to the player,
-- independent of whether the player changes their screen name
function getIdentifiant(id)
    for _, v in ipairs(id) do
        return v
    end
end


RegisterServerEvent('esx_Securitas:alertcops')
AddEventHandler('esx_Securitas:alertcops', function(cx,cy,cz)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()
	
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'Securitas' then
			TriggerClientEvent('esx_Securitas:setcopblip', xPlayers[i], cx,cy,cz)
		end
	end
end)
