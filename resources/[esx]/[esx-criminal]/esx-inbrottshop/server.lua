ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)


RegisterServerEvent('esx_kocken:buyFixkit')
AddEventHandler('esx_kocken:buyFixkit', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= 8006) then
		xPlayer.removeMoney(8006)
		
		xPlayer.addInventoryItem('fixkit', 1)
		
		notification("Du köpte en Reparationslåda")
	else
		notification("Du har inte tillräckligt med pengar")
	end		
end)


RegisterServerEvent('esx_kocken:buyBulletproof')
AddEventHandler('esx_kocken:buyBulletproof', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= 35000) then
		xPlayer.removeMoney(35000)
		
		xPlayer.addInventoryItem('bulletproof', 1)
		
		notification("Du köpte en Skottsäker väst")
	else
		notification("Du har inte tillräckligt med pengar")
	end		
end)


RegisterServerEvent('esx_kocken:buyDrill')
AddEventHandler('esx_kocken:buyDrill', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= 45000) then
		xPlayer.removeMoney(45000)
		
		xPlayer.addInventoryItem('drill', 1)
		
		notification("Du köpte en borrmaskin")
	else
		notification("Du har inte tillräckligt med pengar")
	end		
end)


RegisterServerEvent('esx_kocken:buyBlindfold')
AddEventHandler('esx_kocken:buyBlindfold', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= 16214) then
		xPlayer.removeMoney(16214)
		
		xPlayer.addInventoryItem('blindfold', 1)
		
		notification("Du köpte en ögonbindel")
	else
		notification("Du har inte tillräckligt med pengar")
	end		
end)


RegisterServerEvent('esx_kocken:buyFishingrod')
AddEventHandler('esx_kocken:buyFishingrod', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= 2591) then
		xPlayer.removeMoney(2591)
		
		xPlayer.addInventoryItem('fishing_rod', 1)
		
		notification("Du köpte en fiskespö")
	else
		notification("Du har inte tillräckligt med pengar")
	end		
end)

RegisterServerEvent('esx_kocken:buyAntibiotika')
AddEventHandler('esx_kocken:buyAntibiotika', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= 1239) then
		xPlayer.removeMoney(1239)
		
		xPlayer.addInventoryItem('anti', 1)
		
		notification("Du köpte en antibiotika")
	else
		notification("Du har inte tillräckligt med pengar")
	end		
end)

RegisterServerEvent('esx_kocken:buyPhone')
AddEventHandler('esx_kocken:buyPhone', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= 3400) then
		xPlayer.removeMoney(3400)
		
		xPlayer.addInventoryItem('phone', 1)
		
		notification("Du köpte en ny telefon")
	else
		notification("Du har inte tillräckligt med pengar")
	end		
end)


-----Sälj dildo
RegisterServerEvent('esx_kocken:selldildo')
AddEventHandler('esx_kocken:selldildo', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local ring = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "rosadildo" then
			ring = item.count
		end
	end
    
    if ring > 0 then
        xPlayer.removeInventoryItem('rosadildo', 1)
        xPlayer.addMoney(200)
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du har ingen rosadildo att sälja !')
    end
end)
-- Sälj telefon
RegisterServerEvent('esx_kocken:sellphone')
AddEventHandler('esx_kocken:sellphone', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local smycke = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "phone" then
			smycke = item.count
		end
	end
    
    if smycke > 0 then
        xPlayer.removeInventoryItem('phone', 1)
        xPlayer.addMoney(100)
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du har inte någon Telefon att sälja!')
    end
end)
-- Sälj laptop
RegisterServerEvent('esx_kocken:sellaptop')
AddEventHandler('esx_kocken:sellaptop', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local rolex = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "laptop" then
			rolex = item.count
		end
	end
    
    if rolex > 0 then
        xPlayer.removeInventoryItem('laptop', 1)
        xPlayer.addMoney(200)
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du har inte någon laptop att sälja !')
    end
end)
-- Sälj dyrkset
RegisterServerEvent('esx_kocken:sellpick')
AddEventHandler('esx_kocken:sellpick', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local dildo = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "lockpick" then
			dildo = item.count
		end
	end
    
    if dildo > 0 then
        xPlayer.removeInventoryItem('lockpick', 1)
        xPlayer.addMoney(50)
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du har inte något dyrkset att sälja!')
    end
end)
-- Sälj klocka
RegisterServerEvent('esx_kocken:sellklocka')
AddEventHandler('esx_kocken:sellklocka', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local dildo = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "rolexklocka" then
			dildo = item.count
		end
	end
    
    if dildo > 0 then
        xPlayer.removeInventoryItem('rolexklocka', 1)
        xPlayer.addMoney(100)
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du har ingen Rolexklocka att sälja!')
    end
end)
-- Sälj halsband
RegisterServerEvent('esx_kocken:sellband')
AddEventHandler('esx_kocken:sellband', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local mp3 = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "halsbandd" then
			mp3 = item.count
		end
	end
    
    if mp3 > 0 then
        xPlayer.removeInventoryItem('halsbandd', 1)
        xPlayer.addMoney(300)
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du har inte några Halsband att sälja!')
    end
end)
-- Sälj juveler
RegisterServerEvent('esx_kocken:selljewel')
AddEventHandler('esx_kocken:selljewel', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local fishingrod = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "jewels" then
			fishingrod = item.count
		end
	end
  
    if fishingrod > 0 then
        xPlayer.removeInventoryItem('jewels', 1)
        xPlayer.addMoney(200)
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du har inte några juveler att sälja!')
    end
end)
-- Sälj frön
RegisterServerEvent('esx_kocken:sellseed')
AddEventHandler('esx_kocken:sellseed', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local drill = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "seed" then
			drill = item.count
		end
	end
    
    if drill > 0 then
        xPlayer.removeInventoryItem('seed', 1)
        xPlayer.addMoney(250)
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du har inte någon borrmaskin att sälja!')
    end
end)

RegisterServerEvent('esx_kocken:sellblindfold')
AddEventHandler('esx_kocken:sellblindfold', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local ipod = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "ipod" then
			ipod = item.count
		end
	end
    
    if blindfold > 0 then
        xPlayer.removeInventoryItem('ipod', 1)
        xPlayer.addMoney(300)
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du har inte någon ipod att sälja!')
    end
end)

--- SÄLJ Systemkamera
RegisterServerEvent('esx_kocken:sellshirt')
AddEventHandler('esx_kocken:sellshirt', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local systemkamera = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "jewels" then
			systemkamera = item.count
		end
	end
    
    if systemkamera > 0 then
        xPlayer.removeInventoryItem('jewels', 1)
        xPlayer.addMoney(300)
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du har inte nåra juveler att sälja!')
    end
end)

--- SÄLJ Marijuanafrö
RegisterServerEvent('esx_kocken:sellpants')
AddEventHandler('esx_kocken:sellpants', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local ipod = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "seed" then
			ipod = item.count
		end
	end
    
    if ipod > 0 then
        xPlayer.removeInventoryItem('seed', 1)
        xPlayer.addMoney(250)
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du har inte något frö att sälja!')
    end
end)

--- SÄLJ Iphoneladdare
RegisterServerEvent('esx_kocken:sellshoes')
AddEventHandler('esx_kocken:sellshoes', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local laddare = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "laddare" then
			laddare = item.count
		end
	end
    
    if laddare > 0 then
        xPlayer.removeInventoryItem('laddare', 1)
        xPlayer.addMoney(70)
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du har inte någon laddare att sälja!')
    end
end)

-- Sälj extranyckel
--- SÄLJ dildo
RegisterServerEvent('esx_kocken:sellextranyckel')
AddEventHandler('esx_kocken:sellextranyckel', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local extranyckel = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "extranyckel" then
			extrancykel = item.count
		end
	end
    
    if extranyckel > 0 then
        xPlayer.removeInventoryItem('extranyckel', 1)
        xPlayer.addMoney(1)
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Du har inte någon extranyckel att sälja!')
    end
end)


function notification(textString)
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = textString, style = { ['background-color'] = '#009c10', ['color'] = '#fff' } })
end