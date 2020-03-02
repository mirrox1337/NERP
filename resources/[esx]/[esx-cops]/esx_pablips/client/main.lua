local blips = {}
local PlayerData                = {}
local GUI                       = {}
local sData 					= false
local playerCanSee 				= false
local PlayerData                = {}
ESX                             = nil





Citizen.CreateThread(function()
  while ESX == nil do
   TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(1)
  end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)

	 PlayerData.job = job

end)




Citizen.CreateThread(function()
	while true  do
		
		if (PlayerData.job ~= nil and PlayerData.job.name == 'police' or  PlayerData.job ~= nil and PlayerData.job.name == 'sheriff') and (sData == false ) then
		
			TriggerServerEvent('esx_tracker:addPoliceToTable')
			sData = true
		end
	
		if (PlayerData.job ~= nil and PlayerData.job.name == 'offpolice') and sData then
	
			TriggerServerEvent('esx_tracker:removePoliceFromTable')
			sData = false
		end
		
		if (PlayerData.job ~= nil and PlayerData.job.name == 'ambulance') and (sData == false ) then
		
			TriggerServerEvent('esx_tracker:addAmbulanceToTable')
			sData = true
		end
	
		if (PlayerData.job ~= nil and PlayerData.job.name == 'offambulance') and sData then
	
			TriggerServerEvent('esx_tracker:removeAmbulanceFromTable')
			sData = false
		end
		
		
		
		
		Citizen.Wait(1)
	end
end)



--//Police//---
RegisterNetEvent('esx_tracker:updatePolice')
AddEventHandler('esx_tracker:updatePolice',function(policetable,name,showblips)
	
	if name == GetPlayerName(PlayerId()) and (showblips == true) then

		playerCanSee = true

		elseif name ==  GetPlayerName(PlayerId()) and (showblips == false) then

			playerCanSee = false
	end

	
	if (PlayerData.job ~= nil and PlayerData.job.name == 'offpolice') or (playerCanSee == false) then
		for i = 0,255 do
			RemoveBlip(blips[i])
		end
	end
	

	if	(PlayerData.job ~= nil and PlayerData.job.name == 'police' or  PlayerData.job ~= nil and PlayerData.job.name == 'sheriff') and playerCanSee then
	
		for i = 0,255 do
			RemoveBlip(blips[i])
		end
			
		for i=0,255 do
			for k,v in pairs(policetable) do
				local playerPed = GetPlayerPed(i)
				local playerName = GetPlayerName(i)
				
				if playerName == policetable[k].i then
			
					local new_blip = AddBlipForEntity(playerPed)
					BeginTextCommandSetBlipName("STRING");
					AddTextComponentString(policetable[k].name);
					EndTextCommandSetBlipName(new_blip);
					SetBlipColour(new_blip, 33)
					SetBlipCategory(new_blip, 2)
					SetBlipScale(new_blip, 0.5)
					blips[k] = new_blip
					--Citizen.InvokeNative(0xBFEFE3321A3F5015, playerPed, playerName, false, false, '', false)
				end
			end
		end
	end
end)
------------------------------------------------

--//Ambulance//---
RegisterNetEvent('esx_tracker:updateAmbulance')
AddEventHandler('esx_tracker:updateAmbulance',function(ambulancetable,name,showblips)
	
	if name == GetPlayerName(PlayerId()) and (showblips == true) then

		playerCanSee = true

		elseif name ==  GetPlayerName(PlayerId()) and (showblips == false) then

			playerCanSee = false
	end

	
	if (PlayerData.job ~= nil and PlayerData.job.name == 'offambulance') or (playerCanSee == false) then
		for i = 0,255 do
			RemoveBlip(blips[i])
		end
	end
	

	if	(PlayerData.job ~= nil and PlayerData.job.name == 'ambulance') and playerCanSee then
	
		for i = 0,255 do
			RemoveBlip(blips[i])
		end
			
		for i=0,255 do
			for k,v in pairs(ambulancetable) do
				local playerPed = GetPlayerPed(i)
				local playerName = GetPlayerName(i)
				
				if playerName == ambulancetable[k].i then
			
					local new_blip = AddBlipForEntity(playerPed)
					BeginTextCommandSetBlipName("STRING");
					AddTextComponentString(ambulancetable[k].name);
					EndTextCommandSetBlipName(new_blip);
					SetBlipColour(new_blip, 33)
					SetBlipCategory(new_blip, 2)
					SetBlipScale(new_blip, 0.5)
					blips[k] = new_blip
					--Citizen.InvokeNative(0xBFEFE3321A3F5015, playerPed, playerName, false, false, '', false)
				end
			end
		end
	end
end)
------------------------------------------------

