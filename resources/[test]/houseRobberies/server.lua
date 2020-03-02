local ESX = nil
local robbableItems = {
 [1] = {chance = 3, id = 0, name = 'Cash', quantity = math.random(1, 200)}, -- really common
 [2] = {chance = 10, id = 'WEAPON_BAT', name = 'Baseboll trä', isWeapon = true}, -- rare
 [3] = {chance = 10, id = 'WEAPON_WRENCH', name = 'Rörtång', isWeapon = true}, -- rare
 [4] = {chance = 3, id = 'halsbandd', name = 'Halsband', quantity = math.random(1, 2)}, -- really common
 [5] = {chance = 4, id = 'weed', name = 'Joint', quantity = 1, 5}, -- rare
 [6] = {chance = 4, id = 'smycke', name = 'Smycke', quantity = 1, 2}, -- rare
 [7] = {chance = 4, id = 'laptop', name = 'Laptop', quantity = 1, 2}, -- rare
 [8] = {chance = 6, id = 'packed_meth', name = 'Methamfetamin påse', quantity = 1, 2}, -- rare
 [9] = {chance = 8, id = 'klockaa', name = 'Rolex', quantity = 2}, -- rare
 [10] = {chance = 8, id = 'packed_coke', name = 'Kokain påse', quantity = 1, 2}, -- rare
 [11] = {chance = 9, id = 'jewels', name = 'Juveler', quantity = 1,3}, -- rare
}

--[[chance = 1 is very common, the higher the value the less the chance]]--

TriggerEvent('esx:getSharedObject', function(obj)
 ESX = obj
end)

RegisterServerEvent('houseRobberies:removeLockpick')
AddEventHandler('houseRobberies:removeLockpick', function()
 local source = tonumber(source)
 local xPlayer = ESX.GetPlayerFromId(source)
 xPlayer.removeInventoryItem('advancedlockpick', 1)
 --TriggerClientEvent('chatMessage', source, '^1Your lockpick has bent out of shape')
 TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Ditt dyrkset gick sönder', style = { ['background-color'] = '#b00000', ['color'] = '#fff' } })
end)

RegisterServerEvent('houseRobberies:giveMoney')
AddEventHandler('houseRobberies:giveMoney', function()
 local source = tonumber(source)
 local xPlayer = ESX.GetPlayerFromId(source)
 local cash = math.random(200, 1000)
 xPlayer.addMoney(cash)
 TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = "Du hittade "..cash.."SEK", style = { ['background-color'] = '#009c10', ['color'] = '#fff' } })
end)

ESX.RegisterServerCallback('houseRobberies:anycops',function(source, cb)
    local anycops = 0
    local playerList = ESX.GetPlayers()
    for i=1, #playerList, 1 do
      local _source = playerList[i]
      local xPlayer = ESX.GetPlayerFromId(_source)
      local playerjob = xPlayer.job.name
      if playerjob == 'police' then
        anycops = anycops + 1
      end
    end
    cb(anycops)
  end)

RegisterServerEvent('houseRobberies:searchItem')
AddEventHandler('houseRobberies:searchItem', function()
 local source = tonumber(source)
 local item = {}
 local xPlayer = ESX.GetPlayerFromId(source)
 local gotID = {}


 for i=1, math.random(1, 2) do
  item = robbableItems[math.random(1, #robbableItems)]
  if math.random(1, 10) >= item.chance then
   if tonumber(item.id) == 0 and not gotID[item.id] then
    gotID[item.id] = true
    xPlayer.addMoney(item.quantity)
    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = "Du hittade "..item.quantity.."SEK", style = { ['background-color'] = '#009c10', ['color'] = '#fff' } })
   elseif item.isWeapon and not gotID[item.id] then
    gotID[item.id] = true
    xPlayer.addWeapon(item.id, 50)
    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = "Föremål hittat!", style = { ['background-color'] = '#009c10', ['color'] = '#fff' } })
   elseif not gotID[item.id] then
    gotID[item.id] = true
    xPlayer.addInventoryItem(item.id, item.quantity)
    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = "Föremål hittat!", style = { ['background-color'] = '#009c10', ['color'] = '#fff' } })
   end
  end
 end
end)
