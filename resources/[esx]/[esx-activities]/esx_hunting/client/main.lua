local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX                             = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end

	ScriptLoaded()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

function ScriptLoaded()
	Citizen.Wait(1000)
	LoadMarkers()
end

Citizen.CreateThread(function()
    local blip = AddBlipForCoord(-696.68, 5802.5, 17.33)

    SetBlipSprite (blip, 103)
    SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 1.)
    SetBlipColour (blip, 69)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Jaktstugan')
    EndTextCommandSetBlipName(blip)
end)


local AnimalPositions = {
	--{x = 1196.24, y = 4505.37, z = 58.7},
	--{x = 1014.56, y = 4720.38, z = 153.44},
	--{x = 786.79, y = 4554.33, z = 49.42},
	--{x = 263.83, y = 4402.01, z = 46.38},
	--{x = 557.9, y = 4175.25, z = 37.61},
	--{x = 35.16, y = 4324.38, z = 43.58},
	--{x = -302.01, y = 4507.36, z = 102.65},
	--{x = -318.71, y = 4260.39, z = 43.1},
	--{x = -676.84, y = 4405.62, z = 18.52},
	--{x = -1089.91, y = 4387.44, z = 12.81},
	--{x = -1526.54, y = 4536.51, z = 47.07},
	--{x = -1821.5, y = 4559.0, z = 3.25},
	--{x = -1022.53, y = 4214.47, z = 118.22},
	--{x = -529.92, y = 4200.41, z = 193.26},
	--{x = 1468.67, y = 4601.0, z = 55.55},
	--{x = 1481.75, y = 5008.46, z = 103.03},
	--{x = 1742.85, y = 5133.27, z = 114.1},
	--{x = 1361.31, y = 4981.11, z = 118.24},
	--{x = -457.2, y = 5812.0, z = 48.08},
	--{x = -364.79, y = 5923.35, z = 44.23},
	--{x = -455.26, y = 5549.85, z = 74.25},
	--{x = -719.38, y = 5370.97, z = 60.33},
	{x = -451.59, y = 5482.58, z = 81.7},
	{x = -470.54, y = 5025.06, z = 155.21},
	{x = -477.05, y = 4734.85, z = 240.02},
	{x = -683.17, y = 4921.1, z = 178.48},
	{x = -948.67, y = 5118.25, z = 172.64},
	{x = -771.36, y = 5332.97, z = 74.02},
	{x = -583.78, y = 5209.02, z = 81.71},
	{x = -1110.32, y = 5177.61, z = 112.83},
	{x = -764.55, y = 5191.03, z = 112.8},
	{x = -374.33, y = 5336.73, z = 117.97},

}

local AnimalsInSession = {}

local Positions = {
	['StartHunting'] = { ['hint'] = '[E] Påbörja jakt', ['x'] = -696.68, ['y'] = 5802.5, ['z'] = 17.33 },
	['Sell'] = { ['hint'] = '[E] Sälj', ['x'] = -679.56, ['y'] = 5833.86, ['z'] = 17.32 },
	['SpawnATV'] = { ['x'] = -696.9, ['y'] = 5810.96, ['z'] = 17.33 }
}

local OnGoingHuntSession = false
local HuntCar = nil

function LoadMarkers()

	Citizen.CreateThread(function()
		for index, v in ipairs(Positions) do
			if index ~= 'SpawnATV' then
				local StartBlip = AddBlipForCoord(v.x, v.y, v.z)
				SetBlipSprite(StartBlip, 442)
				SetBlipColour(StartBlip, 75)
				SetBlipScale(StartBlip, 0.7)
				SetBlipAsShortRange(StartBlip, true)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString('Jaktställe')
				EndTextCommandSetBlipName(StartBlip)
			end
		end
	end)

	LoadModel('blazer')
	LoadModel('a_c_deer')
	LoadAnimDict('amb@medic@standing@kneel@base')
	LoadAnimDict('anim@gangops@facility@servers@bodysearch@')



	Citizen.CreateThread(function()
		while true do
			local sleep = 500
			
			local plyCoords = GetEntityCoords(PlayerPedId())

			for index, value in pairs(Positions) do
				if value.hint ~= nil then

					if OnGoingHuntSession and index == 'StartHunting' then
						value.hint = '[E] Avsluta jakt'
					elseif not OnGoingHuntSession and index == 'StartHunting' then
						value.hint = '[E] Påbörja jakt'
					end

					local distance = GetDistanceBetweenCoords(plyCoords, value.x, value.y, value.z, true)

					if distance < 5.0 then
						sleep = 5
						DrawM(value.hint, 27, value.x, value.y, value.z - 0.945, 255, 255, 255, 1.5, 15)
						if distance < 1.0 then
							if IsControlJustReleased(0, Keys['E']) then
								if index == 'StartHunting' then
									StartHuntingSession()
								else
									SellItems()
								end
							end
						end
					end

				end
				
			end
			Citizen.Wait(sleep)
		end
	end)
end

function StartHuntingSession()

	if OnGoingHuntSession then

		OnGoingHuntSession = false
		RemoveWeaponFromPed(PlayerPedId(), GetHashKey("WEAPON_HEAVYSNIPER"), true, true)
		RemoveWeaponFromPed(PlayerPedId(), GetHashKey("WEAPON_KNIFE"), true, true)

		-- Hunter outfit remove
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
			local model = nil

		  if skin.sex == 0 then
			  model = GetHashKey("mp_m_freemode_01")
		  else
			  model = GetHashKey("mp_f_freemode_01")
		  end

		  RequestModel(model)
		  
		  while not HasModelLoaded(model) do
			  RequestModel(model)
			  
			  Citizen.Wait(1)
		  end

		  SetPlayerModel(PlayerId(), model)
		  SetModelAsNoLongerNeeded(model)

		  TriggerEvent('skinchanger:loadSkin', skin)
	  end)

	  	-- Vehicle delete
		DeleteEntity(HuntCar)

		for index, value in pairs(AnimalsInSession) do
			if DoesEntityExist(value.id) then
				DeleteEntity(value.id)
			end
		end

	else
		OnGoingHuntSession = true

		-- Vehicle Spawn

		HuntCar = CreateVehicle(GetHashKey('blazer'), Positions['SpawnATV'].x, Positions['SpawnATV'].y, Positions['SpawnATV'].z, 169.79, true, false)

		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_HEAVYSNIPER"),45, true, false)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_KNIFE"),0, true, false)

		-- Hunter outfit add
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then
				local clothes = json.decode('{"tshirt_1":15,"shoes_2":0,"helmet_1":6,"arms":15,"torso_1":221,"bodyb_2":0,"arms_2":0,"pants_2":15,"bodyb_1":0,"tshirt_2":0,"torso_2":15,"glasses_1":0,"pants_1":86,"bags_2":0,"helmet_2":0,"chest_1":0,"watches_2":0,"shoes_1":82,"chest_3":0}')
		
				TriggerEvent('skinchanger:loadClothes', skin, clothes)
			else
				local clothes = json.decode('{"tshirt_1":15,"pants_1":89,"shoes_2":0,"helmet_1":60,"arms":20,"torso_1":232,"bodyb_2":0,"arms_2":0,"pants_2":15,"bodyb_1":0,"tshirt_2":0,"helmet_2":0,"torso_2":15,"chest_2":0,"chest_1":0,"shoes_1":24}')
			
				TriggerEvent('skinchanger:loadClothes', skin, clothes)
			end
		end)

		-- Animals
		Citizen.CreateThread(function()

				
			for index, value in pairs(AnimalPositions) do
				local Animal = CreatePed(5, GetHashKey('a_c_deer'), value.x, value.y, value.z, 0.0, true, false)
				TaskWanderStandard(Animal, true, true)
				SetEntityAsMissionEntity(Animal, true, true)
				--Blips

				local AnimalBlip = AddBlipForEntity(Animal)
				SetBlipSprite(AnimalBlip, 442)
				SetBlipColour(AnimalBlip, 76)
				SetBlipScale(AnimalBlip, 0.65)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString('Hjort - Djur')
				EndTextCommandSetBlipName(AnimalBlip)


				table.insert(AnimalsInSession, {id = Animal, x = value.x, y = value.y, z = value.z, Blipid = AnimalBlip})
			end


			while OnGoingHuntSession do
				local sleep = 500
				for index, value in ipairs(AnimalsInSession) do
					if DoesEntityExist(value.id) then
						local AnimalCoords = GetEntityCoords(value.id)
						local PlyCoords = GetEntityCoords(PlayerPedId())
						local AnimalHealth = GetEntityHealth(value.id)
						
						local PlyToAnimal = GetDistanceBetweenCoords(PlyCoords, AnimalCoords, true)

						if AnimalHealth <= 0 then
							SetBlipColour(value.Blipid, 3)
							if PlyToAnimal < 2.0 then
								sleep = 5

								ESX.Game.Utils.DrawText3D({x = AnimalCoords.x, y = AnimalCoords.y, z = AnimalCoords.z + 1}, '[E] Slakta djuret', 0.4)

								if IsControlJustReleased(0, Keys['E']) then
									if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey('WEAPON_KNIFE')  then
										if DoesEntityExist(value.id) then
											table.remove(AnimalsInSession, index)
											SlaughterAnimal(value.id)
										end
									else
										exports['mythic_notify']:SendAlert('error', 'Du måste använda din kniv!')
									end
								end

							end
						end
					end
				end

				Citizen.Wait(sleep)

			end
				
		end)
	end
end

function SlaughterAnimal(AnimalId)

	exports['mythic_progbar']:Progress({
			name = "SlaughterAnimal",
			duration = 5000,
			label = "Slacktar Djuret",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			},
			animation = {
				animDict = "anim@gangops@facility@servers@bodysearch@",
				anim = "player_search",
			},
			prop = {
				
			}
		}, function(cancelled)
			if not cancelled then

				ClearPedTasksImmediately(PlayerPedId())
				local AnimalWeight = math.random(10, 160) / 10

				exports['mythic_notify']:SendAlert('success', 'Du har slaktat djuret och fått en köttmängd på ' ..AnimalWeight.. 'kg')

				TriggerServerEvent('esx-qalle-hunting:reward', AnimalWeight)

				DeleteEntity(AnimalId)
			end
		end)
	end

function SellItems()
	TriggerServerEvent('esx-qalle-hunting:sell')
end

function LoadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end    
end

function LoadModel(model)
    while not HasModelLoaded(model) do
          RequestModel(model)
          Citizen.Wait(10)
    end
end

function DrawM(hint, type, x, y, z)
	ESX.Game.Utils.DrawText3D({x = x, y = y, z = z + 1.0}, hint, 0.4)
	DrawMarker(type, x, y, z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 255, 255, 100, false, true, 2, false, false, false, false)
end