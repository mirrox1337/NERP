local firstSpawn, PlayerLoaded = true, false

isDead = false
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	PlayerLoaded = true
	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	PlayerLoaded = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

--[[
AddEventHandler('playerSpawned', function()
	isDead = false
	TriggerServerEvent('esx_ambulancejob:onPlayerSpawn')

	if firstSpawn then
		exports.spawnmanager:setAutoSpawn(false) -- disable respawn
		firstSpawn = false

		if Config.AntiCombatLog then
			while not PlayerLoaded do
				Citizen.Wait(1000)
			end

			ESX.TriggerServerCallback('esx_ambulancejob:getDeathStatus', function(shouldDie)
				if shouldDie then
					ESX.ShowNotification(_U('combatlog_message'))
					RemoveItemsAfterRPDeath()
				end
			end)
		end
	end
end)
--]]

RegisterNetEvent('esx_ambulancejob:multicharacter')
AddEventHandler('esx_ambulancejob:multicharacter', function()
    IsDead = false

        ESX.TriggerServerCallback('esx_ambulancejob:getDeathStatus', function(isDead)
            if isDead and Config.AntiCombatLog then
				--ESX.ShowNotification(_U('combatlog_message'))
				exports['mythic_notify']:SendAlert('inform', (_U('combatlog_message')))
                RemoveItemsAfterRPDeath()
            end
        end)
end)

-- Create blips
Citizen.CreateThread(function()
	for k,v in pairs(Config.Hospitals) do
		local blip = AddBlipForCoord(v.Blip.coords)

		SetBlipSprite(blip, v.Blip.sprite)
		SetBlipScale(blip, v.Blip.scale)
		SetBlipColour(blip, v.Blip.color)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(_U('blip_hospital'))
		EndTextCommandSetBlipName(blip)
	end
end)

-- Disable most inputs when dead
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if isDead then
			DisableAllControlActions(0)
			EnableControlAction(0, 47, true)
			EnableControlAction(0, 245, true)
			EnableControlAction(0, 38, true)
		else
			Citizen.Wait(500)
		end
	end
end)

function OnPlayerDeath()
	isDead = true
	ESX.UI.Menu.CloseAll()
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', true)

	StartDeathTimer()
	StartDistressSignal()

	StartScreenEffect('DeathFailOut', 0, false)
end

RegisterNetEvent('esx_ambulancejob:useItem')
AddEventHandler('esx_ambulancejob:useItem', function(itemName)
	ESX.UI.Menu.CloseAll()

	if itemName == 'medikit' then
		local lib, anim = 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01' -- TODO better animations
		local playerPed = PlayerPedId()

		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)

			Citizen.Wait(500)
			while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
				Citizen.Wait(0)
				DisableAllControlActions(0)
			end

			TriggerEvent('esx_ambulancejob:heal', 'big', true)
			--ESX.ShowNotification(_U('used_medikit'))
			exports['mythic_notify']:SendAlert('inform', (_U('used_medikit')))
		end)

	elseif itemName == 'bandage' then
		local lib, anim = 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01' -- TODO better animations
		local playerPed = PlayerPedId()

		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)

			Citizen.Wait(500)
			while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
				Citizen.Wait(0)
				DisableAllControlActions(0)
			end

			TriggerEvent('esx_ambulancejob:heal', 'small', true)
			--ESX.ShowNotification(_U('used_bandage'))
			exports['mythic_notify']:SendAlert('inform', (_U('used_bandage')))
		end)
	end
end)

function StartDistressSignal()
	Citizen.CreateThread(function()
		local timer = Config.BleedoutTimer

		while timer > 0 and isDead do
			Citizen.Wait(0)
			timer = timer - 30

			SetTextFont(4)
			SetTextScale(0.45, 0.45)
			SetTextColour(185, 185, 185, 255)
			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			BeginTextCommandDisplayText('STRING')
			AddTextComponentSubstringPlayerName(_U('distress_send'))
			EndTextCommandDisplayText(0.175, 0.805)

			if IsControlJustReleased(0, 47) then
				SendDistressSignal()
				break
			end
		end
	end)
end

function SendDistressSignal()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	--ESX.ShowNotification(_U('distress_sent'))
	exports['mythic_notify']:SendAlert('warning', (_U('distress_sent')))
	TriggerServerEvent('esx_ambulancejob:onPlayerDistress')
end

function DrawGenericTextThisFrame()
	SetTextFont(4)
	SetTextScale(0.0, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)
end

function secondsToClock(seconds)
	local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0

	if seconds <= 0 then
		return 0, 0
	else
		local hours = string.format('%02.f', math.floor(seconds / 3600))
		local mins = string.format('%02.f', math.floor(seconds / 60 - (hours * 60)))
		local secs = string.format('%02.f', math.floor(seconds - hours * 3600 - mins * 60))

		return mins, secs
	end
end

function StartDeathTimer()
	local canPayFine = false

	if Config.EarlyRespawnFine then
		ESX.TriggerServerCallback('esx_ambulancejob:checkBalance', function(canPay)
			canPayFine = canPay
		end)
	end

	local earlySpawnTimer = ESX.Math.Round(Config.EarlyRespawnTimer / 1000)
	local bleedoutTimer = ESX.Math.Round(Config.BleedoutTimer / 1000)

	Citizen.CreateThread(function()
		-- early respawn timer
		while earlySpawnTimer > 0 and isDead do
			Citizen.Wait(1000)

			if earlySpawnTimer > 0 then
				earlySpawnTimer = earlySpawnTimer - 1
			end
		end

		-- bleedout timer
		while bleedoutTimer > 0 and isDead do
			Citizen.Wait(1000)

			if bleedoutTimer > 0 then
				bleedoutTimer = bleedoutTimer - 1
			end
		end
	end)

	Citizen.CreateThread(function()
		local text, timeHeld

		-- early respawn timer
		while earlySpawnTimer > 0 and isDead do
			Citizen.Wait(0)
			text = _U('respawn_available_in', secondsToClock(earlySpawnTimer))

			DrawGenericTextThisFrame()

			SetTextEntry('STRING')
			AddTextComponentString(text)
			DrawText(0.5, 0.8)
		end

		-- bleedout timer
		while bleedoutTimer > 0 and isDead do
			Citizen.Wait(0)
			text = _U('respawn_bleedout_in', secondsToClock(bleedoutTimer))

			if not Config.EarlyRespawnFine then
				text = text .. _U('respawn_bleedout_prompt')

				if IsControlPressed(0, 38) and timeHeld > 60 then
					RemoveItemsAfterRPDeath()
					break
				end
			elseif Config.EarlyRespawnFine and canPayFine then
				text = text .. _U('respawn_bleedout_fine', ESX.Math.GroupDigits(Config.EarlyRespawnFineAmount))

				if IsControlPressed(0, 38) and timeHeld > 60 then
					TriggerServerEvent('esx_ambulancejob:payFine')
					RemoveItemsAfterRPDeath()
					break
				end
			end

			if IsControlPressed(0, 38) then
				timeHeld = timeHeld + 1
			else
				timeHeld = 0
			end

			DrawGenericTextThisFrame()

			SetTextEntry('STRING')
			AddTextComponentString(text)
			DrawText(0.5, 0.8)
		end

		if bleedoutTimer < 1 and isDead then
			RemoveItemsAfterRPDeath()
		end
	end)
end

function RemoveItemsAfterRPDeath()
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)

	Citizen.CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(10)
		end

		ESX.TriggerServerCallback('esx_ambulancejob:removeItemsAfterRPDeath', function()
			local formattedCoords = {
				x = Config.RespawnPoint.coords.x,
				y = Config.RespawnPoint.coords.y,
				z = Config.RespawnPoint.coords.z
			}

			ESX.SetPlayerData('loadout', {})
			RespawnPed(PlayerPedId(), formattedCoords, Config.RespawnPoint.heading)

			StopScreenEffect('DeathFailOut')
			DoScreenFadeIn(800)
			TriggerEvent('shakeCam', true)
		end)
	end)
end

local time = 0
local shakeEnable = false

RegisterNetEvent('shakeCam')
AddEventHandler('shakeCam', function(status)
	if(status == true)then
		ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE", 1.0)
		shakeEnable = true
	elseif(status == false)then
		ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE", 0)
		shakeEnable = false
		time = 0
	end
end)

-----Enable/disable the effect by pills
Citizen.CreateThread(function()
	while true do 
		Wait(100)
		if(shakeEnable)then
			time = time + 100
			if(time > 5000)then -- 5 seconds
				TriggerEvent('shakeCam', false)
			end
		end
	end
end)

function RespawnPed(ped, coords, heading)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(ped, false)
	TriggerEvent('esx_ambulancejob:multicharacter', coords.x, coords.y, coords.z)
	ClearPedBloodDamage(ped)

	ESX.UI.Menu.CloseAll()
end

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
	local specialContact = {
		name       = 'Ambulance',
		number     = 'ambulance',
		base64Icon = 'data:image/png;base64,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'
	}

	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	OnPlayerDeath()
end)

RegisterNetEvent('esx_ambulancejob:revive')
AddEventHandler('esx_ambulancejob:revive', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)

	DoScreenFadeOut(800)

	while not IsScreenFadedOut() do
		Citizen.Wait(50)
	end

	local formattedCoords = {
		x = ESX.Math.Round(coords.x, 1),
		y = ESX.Math.Round(coords.y, 1),
		z = ESX.Math.Round(coords.z, 1)
	}

	RespawnPed(playerPed, formattedCoords, 0.0)

	StopScreenEffect('DeathFailOut')
	DoScreenFadeIn(800)
end)

-- Load unloaded IPLs
if Config.LoadIpl then
	RequestIpl('Coroner_Int_on') -- Morgue
end

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)

  local specialContact = {
    name       = 'Ambulans',
    number     = 'ambulance',
    base64Icon = 'data:image/png;base64,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'
  }

  TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)

end)