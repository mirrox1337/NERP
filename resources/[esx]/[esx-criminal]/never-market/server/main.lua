ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj 
end)

ESX.RegisterServerCallback('wille-specialshop:buyItem', function(source, callback, itemName, amount, price)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer ~= nil then
		if xPlayer.getMoney() >= price then
			xPlayer.addInventoryItem(itemName, amount)
			xPlayer.setMoney(xPlayer.getMoney() - price)

			callback(true)
		else
			callback(false)
		end
	end
end)

ESX.RegisterServerCallback('wille-specialshop:buyBulletproofVest', function(source, callback, price)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer ~= nil then
		if xPlayer.getMoney() >= price then
			xPlayer.setMoney(xPlayer.getMoney() - price)

			callback(true)
		else
			callback(false)
		end
	end
end)

ESX.RegisterServerCallback('kulan-specialshop:switchblade', function(source, callback)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer ~= nil then
		if xPlayer.getMoney() >= 15000 then
			xPlayer.setMoney(xPlayer.getMoney() - 15000)
			xPlayer.addWeapon('weapon_switchblade')

			callback(true)
		else
			callback(false)
		end
	end
end)