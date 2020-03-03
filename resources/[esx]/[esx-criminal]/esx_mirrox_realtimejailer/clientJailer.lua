local cJ = false
local IsPlayerUnjailed = false
PlayerData = {}


--ESX base

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end

	while ESX.GetPlayerData() == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
	
	LoadTeleporters()
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(response)
	PlayerData["job"] = response
end)

RegisterNetEvent("esx_mirrox_jailer:JailInStation")
AddEventHandler("esx_mirrox_jailer:JailInStation", function(Station, JailTime)
	jailing(Station, JailTime)
end)

function jailing(Station, JailTime)
	if cJ == true then
		return
	end
	local PlayerPed = GetPlayerPed(-1)
	if DoesEntityExist(PlayerPed) then
		
		Citizen.CreateThread(function()
			local spawnloccoords = {}
			SetJailClothes()
			spawnloccoords = SetPlayerSpawnLocationjail(Station)
			SetEntityCoords(PlayerPed, spawnloccoords.x,spawnloccoords.y, spawnloccoords.z )
			cJ = true
			IsPlayerUnjailed = false
			while JailTime > 0 and not IsPlayerUnjailed do
				local remainingjailseconds = JailTime/ 60
				local jailseconds =  math.floor(JailTime) % 60 
				local remainingjailminutes = remainingjailseconds / 60
				local jailminutes =  math.floor(remainingjailseconds) % 60
				local remainingjailhours = remainingjailminutes / 24
				local jailhours =  math.floor(remainingjailminutes) % 24
				local remainingjaildays = remainingjailhours / 365 
				local jaildays =  math.floor(remainingjailhours) % 365

				
				PlayerPed = GetPlayerPed(-1)
				--RemoveAllPedWeapons(PlayerPed, true)
				--SetEntityInvincible(PlayerPed, true)
				if IsPedInAnyVehicle(PlayerPed, false) then
					ClearPedTasksImmediately(PlayerPed)
				end
				if JailTime % 10 == 0 then
					if JailTime % 30 == 0 then
						ESX.ShowNotification("Du har ~p~"..math.floor(jaildays).."~s~ Dagar ~p~"..math.floor(jailhours).."~s~ Timmar ~p~"..math.floor(jailminutes).."~s~ Minuter ~p~"..math.floor(jailseconds).."~s~ sekunder kvar i fängelse!.")
						--exports['mythic_notify']:SendAlert('inform', "Du har"..math.floor(jaildays).." Dagar"..math.floor(jailhours).." Timmar"..math.floor(jailminutes).." Minuter"..math.floor(jailseconds).." sekunder kvar i fängelse!.")
					end
				end
				Citizen.Wait(1000)
				local pL = GetEntityCoords(PlayerPed, true)
				local D = Vdist(spawnloccoords.x,spawnloccoords.y, spawnloccoords.z, pL['x'], pL['y'], pL['z'])
				if D > spawnloccoords.distance then -- distance#######################################################################################
					SetEntityCoords(PlayerPed, spawnloccoords.x,spawnloccoords.y, spawnloccoords.z)
					print("vad gör detta?")
				end
				JailTime = JailTime - 1.0
			end
			--ESX.ShowNotification("Du släpps, håll dig lugn ute! Lycka till!")
			exports['mythic_notify']:SendAlert('inform', "Du släpps, håll dig lugn ute! Lycka till!")
			GetBackOriginalClothes()
			TriggerServerEvent('esx_mirrox_jailer:UnJailplayer2')
			local outsidecoords = {}
			outsidecoords = SetPlayerSpawnLocationoutsidejail(Station)
			SetEntityCoords(PlayerPed, outsidecoords.x,outsidecoords.y,outsidecoords.z )
			cJ = false
			--SetEntityInvincible(PlayerPed, false)
			TriggerEvent('esx_society:getPlayerSkin')
		end)
	end
end

function SetPlayerSpawnLocationjail(location)
	if location == 'Jail' then
		return {x=1799.8345947266,y=2489.1350097656,z=-119.02998352051, distance = 280}
	end
end

function SetPlayerSpawnLocationoutsidejail(location)
	if location == 'Jail' then
		return {x=1847.5042724609,y=2586.2209472656,z=44.672046661377}
	end
end

RegisterNetEvent("esx_mirrox_jailer:UnJail")
AddEventHandler("esx_mirrox_jailer:UnJail", function()
	IsPlayerUnjailed = true
	GetBackOriginalClothes()
end)

function SetJailClothes()
local playerPed = GetPlayerPed(-1)
  TriggerEvent('skinchanger:getSkin', function(skin)
     if skin.sex == 0 then
      if Config.Clothes.police.prison_wear.male ~= nil then
        TriggerEvent('skinchanger:loadClothes', skin, Config.Clothes.police.prison_wear.male)
      else
		--ESX.ShowNotification('no_outfit')
		exports['mythic_notify']:SendAlert('error', 'Ingen outfit')
      end
    else
      if Config.Clothes.police.prison_wear.female ~= nil then
        TriggerEvent('skinchanger:loadClothes', skin, Config.Clothes.police.prison_wear.female)
      else
		ESX.ShowNotification('no_outfit')
		exports['mythic_notify']:SendAlert('error', 'Ingen outfit')
      end
    end
  end)
end

function GetBackOriginalClothes()
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
	  TriggerEvent('skinchanger:loadSkin', skin)
	end)
end

function TeleportPlayer(pos)

	local Values = pos

	if #Values["goal"] > 1 then

		local elements = {}

		for i, v in pairs(Values["goal"]) do
			table.insert(elements, { label = v, value = v })
		end

		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'teleport_jail',
			{
				title    = "Choose Position",
				align    = 'center',
				elements = elements
			},
		function(data, menu)

			local action = data.current.value
			local position = Config.Teleports[action]

			if action == "Kontrollrum" or action == "Cellarna" then

				if PlayerData.job.name ~= "police" then
					ESX.ShowNotification("Du har inte ~r~behörighet~s~ att gå in där")
					return
				end
			end

			menu.close()

			DoScreenFadeOut(100)

			Citizen.Wait(250)

			SetEntityCoords(PlayerPedId(), position["x"], position["y"], position["z"])

			Citizen.Wait(250)

			DoScreenFadeIn(100)
			
		end,

		function(data, menu)
			menu.close()
		end)
	else
		local position = Config.Teleports[Values["goal"][1]]

		DoScreenFadeOut(100)

		Citizen.Wait(250)

		SetEntityCoords(PlayerPedId(), position["x"], position["y"], position["z"])

		Citizen.Wait(250)

		DoScreenFadeIn(100)
	end
end

function LoadTeleporters()
	Citizen.CreateThread(function()
		while true do
			
			local sleepThread = 500

			local Ped = PlayerPedId()
			local PedCoords = GetEntityCoords(Ped)

			for p, v in pairs(Config.Teleports) do

				local DistanceCheck = GetDistanceBetweenCoords(PedCoords, v["x"], v["y"], v["z"], true)

				if DistanceCheck <= 7.5 then

					sleepThread = 5

					ESX.Game.Utils.DrawText3D(v, "~p~[E]~s~ Gå Igenom", 0.4)

					if DistanceCheck <= 1.0 then
						if IsControlJustPressed(0, 38) then
							TeleportPlayer(v)
						end
					end
				end
			end

			Citizen.Wait(sleepThread)

		end
	end)
end

Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.Teleports["Gå ut"]["x"], Config.Teleports["Gå ut"]["y"], Config.Teleports["Gå ut"]["z"])

    SetBlipSprite (blip, 188)
    SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 0.8)
    SetBlipColour (blip, 49)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Fängelset')
    EndTextCommandSetBlipName(blip)
end)
