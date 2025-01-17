function SendDistressSignal()
	local playerPed = PlayerPedId()
	PedPosition   = GetEntityCoords(playerPed)
	
	local PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z }
  
	--ESX.ShowNotification(_U('distress_sent'))
	exports['mythic_notify']:SendAlert('warning', (_U('distress_sent')))
  
	  TriggerServerEvent('esx_addons_gcphone:startCall', 'Securitas', _U('distress_message'), PlayerCoords, {
  
	  PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z },
	})
  end
  
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
  
  local PlayerData                = {}
  local GUI                       = {}
  local HasAlreadyEnteredMarker   = false
  local LastStation               = nil
  local LastPart                  = nil
  local LastPartNum               = nil
  local LastEntity                = nil
  local CurrentAction             = nil
  local CurrentActionMsg          = ''
  local CurrentActionData         = {}
  local IsHandcuffed              = false
  local playerId = PlayerId()
  local serverId = GetPlayerServerId(localPlayerId)
  local tiempo = 12000
  local vehWeapons = {
	0x1D073A89, -- ShotGun
	0x83BF0278, -- Carbine
	0x5FC3C11, -- Sniper
	0x2BE6766B, -- smg
	0x1B06D571, -- pistol
	0x5EF9FEC4, -- combat pistol
  }
  
  local hasBeenInPoliceVehicle = false
  
  local alreadyHaveWeapon = {}
  
  ESX                             = nil
  GUI.Time                        = 0
  
  Citizen.CreateThread(function()
	while ESX == nil do
	  TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	  Citizen.Wait(0)
	end
  end)
  
  --[[Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(0)
	  if IsPedBeingStunned(GetPlayerPed(-1)) then
	  SetPedMinGroundTimeForStungun(GetPlayerPed(-1), tiempo)
	  end
	end
  end)]]
  
  function SetVehicleMaxMods(vehicle)
  
	local props = {
	  modEngine       = 4,
	  modBrakes       = 3,
	  modTransmission = 3,
	  modSuspension   = 3,
	  modTurbo        = true,
	}
  
	ESX.Game.SetVehicleProperties(vehicle, props)
  
  end
  
  function getJob()
	
	if PlayerData.job ~= nil then
	return PlayerData.job.name  
	
	end  
  end
  
  function JailPlayer(player)
	ESX.UI.Menu.Open(
	  'dialog', GetCurrentResourceName(), 'jail_menu',
	  {
		title = _U('jail_menu_info'),
	  },
	function (data2, menu)
	  local jailTime = tonumber(data2.value)
	  if jailTime == nil then
		--ESX.ShowNotification(_U('invalid_amount'))
		exports['mythic_notify']:SendAlert('error', (_U('invalid_amount')))
		
	  else
		TriggerServerEvent("esx_mirrox_jailer:PutInJail", player, jailTime * 60)
		menu.close()
	  end
	end,
	function (data2, menu)
	  menu.close()
	end
	)
  end
  
  function OpenCloakroomMenu()
  
	local elements = {
	  { label = _U('citizen_wear'), value = 'citizen_wear' }
	}
  
	if PlayerData.job.grade_name == 'recruit' then
	  table.insert(elements, {label = _U('Securitas_wear'), value = 'recruit_wear'})
	end
  
	if PlayerData.job.grade_name == 'officer' then
	  table.insert(elements, {label = _U('Securitas_wear'), value = 'officer_wear'})
	  table.insert(elements, {label = _U('krimv_wear'), value = 'krimv_wear'})
	  table.insert(elements, {label = _U('bullet_wear'), value = 'bullet_wear'})
	  table.insert(elements, {label = _U('gilet_wear'), value = 'gilet_wear'})
	end
  
	if PlayerData.job.grade_name == 'sergeant' then
	  table.insert(elements, {label = _U('Securitas_wear'), value = 'sergeant_wear'})
	  table.insert(elements, {label = _U('personskydd_wear'), value = 'personskydd_wear'})
	  table.insert(elements, {label = _U('krimv_wear'), value = 'krimv_wear'})
	  table.insert(elements, {label = _U('bullet_wear'), value = 'bullet_wear'})
	  table.insert(elements, {label = _U('ord_wear'), value = 'ord_wear'})
	  table.insert(elements, {label = _U('gilet_wear'), value = 'gilet_wear'})
	end
  
	if PlayerData.job.grade_name == 'lieutenant' then
	  table.insert(elements, {label = _U('Securitas_wear'), value = 'lieutenant_wear'})
	  table.insert(elements, {label = _U('personskydd_wear'), value = 'personskydd_wear'})
	  table.insert(elements, {label = _U('krimv_wear'), value = 'krimv_wear'})
	  table.insert(elements, {label = _U('bullet_wear'), value = 'bullet_wear'})
	  table.insert(elements, {label = _U('ord_wear'), value = 'ord_wear'})
	  table.insert(elements, {label = _U('gilet_wear'), value = 'gilet_wear'})
	end
  
	if PlayerData.job.grade_name == 'boss' then
	  table.insert(elements, {label = _U('Securitas_wear'), value = 'boss_wear'})
	  table.insert(elements, {label = _U('personskydd_wear'), value = 'personskydd_wear'})
	  table.insert(elements, {label = _U('krimv_wear'), value = 'krimv_wear'})
	  table.insert(elements, {label = _U('bullet_wear'), value = 'bullet_wear'})
	  table.insert(elements, {label = _U('ord_wear'), value = 'ord_wear'})
	  table.insert(elements, {label = _U('gilet_wear'), value = 'gilet_wear'})
	end
  
	ESX.UI.Menu.CloseAll()
  
	ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'cloakroom',
	  {
		title    = _U('cloakroom'),
		align    = 'right',
		elements = elements,
	  },
	  function(data, menu)
		menu.close()
  
		if data.current.value == 'citizen_wear' then
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
			TriggerEvent('esx:restoreLoadout')
			local playerPed = GetPlayerPed(-1)
			SetPedArmour(playerPed, 0)
			ClearPedBloodDamage(playerPed)
			ResetPedVisibleDamage(playerPed)
			ClearPedLastWeaponDamage(playerPed)
		  end)
		end
  
		if data.current.value == 'recruit_wear' then
		  TriggerEvent('skinchanger:getSkin', function(skin)
		  
			  if skin.sex == 0 then
  
				local clothesSkin = {
				  ['tshirt_1'] = 0,  ['tshirt_2'] = 0,
				  ['torso_1'] = 274,   ['torso_2'] = 0,
				  ['decals_1'] = 0,   ['decals_2'] = 0,
				  ['arms'] = 30,
				  ['pants_1'] = 59,   ['pants_2'] = 2,
				  ['shoes_1'] = 25,   ['shoes_2'] = 0,
				  ['helmet_1'] = 10,  ['helmet_2'] = 1,
				  ['chain_1'] = 0,    ['chain_2'] = 0,
				  ['ears_1'] = -1,      ['ears_2'] = 0,
				  ['mask_1'] = 4,     ['mask_2'] = 0,
				  ['bproof_1'] = 4, ['bproof_2'] = 4,
			  }
				  TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
  
			  else
  
				local clothesSkin = {
				  ['tshirt_1'] = 1,  ['tshirt_2'] = 0,
				  ['torso_1'] = 292,   ['torso_2'] = 0,
				  ['decals_1'] = 0,   ['decals_2'] = 0,
				  ['arms'] = 31,
				  ['pants_1'] = 61,   ['pants_2'] = 2,
				  ['shoes_1'] = 25,   ['shoes_2'] = 0,
				  ['helmet_1'] = -1,  ['helmet_2'] = 0,
				  ['chain_1'] = 0,    ['chain_2'] = 0,
				  ['ears_1'] = 0,     ['ears_2'] = 0,
				  ['mask_1'] = 121,     ['mask_2'] = 0,
				  ['bags_1'] = 1, ['bags_2'] = 0,
				  ['bproof_1'] = 5, ['bproof_2'] = 4,
			  }
				  TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
  
			  end
  
			  local playerPed = GetPlayerPed(-1)
			  SetPedArmour(playerPed, 50)
			  ClearPedBloodDamage(playerPed)
			  ResetPedVisibleDamage(playerPed)
			  ClearPedLastWeaponDamage(playerPed)
			  
		  end)
		end
  
		if data.current.value == 'officer_wear' then
		  TriggerEvent('skinchanger:getSkin', function(skin)
		  
			  if skin.sex == 0 then
  
				local clothesSkin = {
					['tshirt_1'] = 0,  ['tshirt_2'] = 0,
					['torso_1'] = 274,   ['torso_2'] = 0,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['arms'] = 30,
					['pants_1'] = 59,   ['pants_2'] = 2,
					['shoes_1'] = 25,   ['shoes_2'] = 0,
					['helmet_1'] = 10,  ['helmet_2'] = 1,
					['chain_1'] = 0,    ['chain_2'] = 0,
					['ears_1'] = -1,      ['ears_2'] = 0,
					['mask_1'] = 4,     ['mask_2'] = 0,
					['bproof_1'] = 4, ['bproof_2'] = 4,
				}
					TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
	
				else
	
				  local clothesSkin = {
					['tshirt_1'] = 1,  ['tshirt_2'] = 0,
					['torso_1'] = 292,   ['torso_2'] = 0,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['arms'] = 31,
					['pants_1'] = 61,   ['pants_2'] = 2,
					['shoes_1'] = 25,   ['shoes_2'] = 0,
					['helmet_1'] = -1,  ['helmet_2'] = 0,
					['chain_1'] = 0,    ['chain_2'] = 0,
					['ears_1'] = 0,     ['ears_2'] = 0,
					['mask_1'] = 121,     ['mask_2'] = 0,
					['bags_1'] = 1, ['bags_2'] = 0,
					['bproof_1'] = 5, ['bproof_2'] = 4,
				}
				  TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
  
			  end
  
			  local playerPed = GetPlayerPed(-1)
			  SetPedArmour(playerPed, 100)
			  ClearPedBloodDamage(playerPed)
			  ResetPedVisibleDamage(playerPed)
			  ClearPedLastWeaponDamage(playerPed)
			  
		  end)
		end
  
		if data.current.value == 'sergeant_wear' then
		  TriggerEvent('skinchanger:getSkin', function(skin)
		  
			  if skin.sex == 0 then
  
				local clothesSkin = {
					['tshirt_1'] = 0,  ['tshirt_2'] = 0,
					['torso_1'] = 274,   ['torso_2'] = 0,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['arms'] = 30,
					['pants_1'] = 59,   ['pants_2'] = 2,
					['shoes_1'] = 25,   ['shoes_2'] = 0,
					['helmet_1'] = 10,  ['helmet_2'] = 1,
					['chain_1'] = 0,    ['chain_2'] = 0,
					['ears_1'] = -1,      ['ears_2'] = 0,
					['mask_1'] = 4,     ['mask_2'] = 0,
					['bproof_1'] = 4, ['bproof_2'] = 4,
				}
					TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
	
				else
	
				  local clothesSkin = {
					['tshirt_1'] = 1,  ['tshirt_2'] = 0,
					['torso_1'] = 292,   ['torso_2'] = 0,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['arms'] = 31,
					['pants_1'] = 61,   ['pants_2'] = 2,
					['shoes_1'] = 25,   ['shoes_2'] = 0,
					['helmet_1'] = -1,  ['helmet_2'] = 0,
					['chain_1'] = 0,    ['chain_2'] = 0,
					['ears_1'] = 0,     ['ears_2'] = 0,
					['mask_1'] = 121,     ['mask_2'] = 0,
					['bags_1'] = 1, ['bags_2'] = 0,
					['bproof_1'] = 5, ['bproof_2'] = 4,
				}
				  TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
  
			  end
  
			  local playerPed = GetPlayerPed(-1)
			  SetPedArmour(playerPed, 50)
			  ClearPedBloodDamage(playerPed)
			  ResetPedVisibleDamage(playerPed)
			  ClearPedLastWeaponDamage(playerPed)
			  
		  end)
		end
  
		if data.current.value == 'lieutenant_wear' then
		  TriggerEvent('skinchanger:getSkin', function(skin)
		  
			  if skin.sex == 0 then
  
				local clothesSkin = {
					['tshirt_1'] = 0,  ['tshirt_2'] = 0,
					['torso_1'] = 274,   ['torso_2'] = 0,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['arms'] = 30,
					['pants_1'] = 59,   ['pants_2'] = 2,
					['shoes_1'] = 25,   ['shoes_2'] = 0,
					['helmet_1'] = 10,  ['helmet_2'] = 1,
					['chain_1'] = 0,    ['chain_2'] = 0,
					['ears_1'] = -1,      ['ears_2'] = 0,
					['mask_1'] = 4,     ['mask_2'] = 0,
					['bproof_1'] = 4, ['bproof_2'] = 4,
				}
					TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
	
				else
	
				  local clothesSkin = {
					['tshirt_1'] = 1,  ['tshirt_2'] = 0,
					['torso_1'] = 292,   ['torso_2'] = 0,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['arms'] = 31,
					['pants_1'] = 61,   ['pants_2'] = 2,
					['shoes_1'] = 25,   ['shoes_2'] = 0,
					['helmet_1'] = -1,  ['helmet_2'] = 0,
					['chain_1'] = 0,    ['chain_2'] = 0,
					['ears_1'] = 0,     ['ears_2'] = 0,
					['mask_1'] = 121,     ['mask_2'] = 0,
					['bags_1'] = 1, ['bags_2'] = 0,
					['bproof_1'] = 5, ['bproof_2'] = 4,
				}
				  TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
  
			  end
  
			  local playerPed = GetPlayerPed(-1)
			  SetPedArmour(playerPed, 50)
			  ClearPedBloodDamage(playerPed)
			  ResetPedVisibleDamage(playerPed)
			  ClearPedLastWeaponDamage(playerPed)
			  
		  end)
		end
  
		if data.current.value == 'boss_wear' then
		  TriggerEvent('skinchanger:getSkin', function(skin)
		  
			  if skin.sex == 0 then
  
				local clothesSkin = {
					['tshirt_1'] = 0,  ['tshirt_2'] = 0,
					['torso_1'] = 274,   ['torso_2'] = 0,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['arms'] = 30,
					['pants_1'] = 59,   ['pants_2'] = 2,
					['shoes_1'] = 25,   ['shoes_2'] = 0,
					['helmet_1'] = 10,  ['helmet_2'] = 1,
					['chain_1'] = 0,    ['chain_2'] = 0,
					['ears_1'] = -1,      ['ears_2'] = 0,
					['mask_1'] = 4,     ['mask_2'] = 0,
					['bproof_1'] = 4, ['bproof_2'] = 4,
				}
					TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
	
				else
	
				  local clothesSkin = {
					['tshirt_1'] = 1,  ['tshirt_2'] = 0,
					['torso_1'] = 292,   ['torso_2'] = 0,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['arms'] = 31,
					['pants_1'] = 61,   ['pants_2'] = 2,
					['shoes_1'] = 25,   ['shoes_2'] = 0,
					['helmet_1'] = -1,  ['helmet_2'] = 0,
					['chain_1'] = 0,    ['chain_2'] = 0,
					['ears_1'] = 0,     ['ears_2'] = 0,
					['mask_1'] = 121,     ['mask_2'] = 0,
					['bags_1'] = 1, ['bags_2'] = 0,
					['bproof_1'] = 5, ['bproof_2'] = 4,
				}
				  TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
  
			  end
  
			  local playerPed = GetPlayerPed(-1)
			  SetPedArmour(playerPed, 50)
			  ClearPedBloodDamage(playerPed)
			  ResetPedVisibleDamage(playerPed)
			  ClearPedLastWeaponDamage(playerPed)
			  
		  end)
		end
  
		if data.current.value == 'personskydd_wear' then
		  TriggerEvent('skinchanger:getSkin', function(skin)
		  
			  if skin.sex == 0 then
  
				local clothesSkin = {
					['tshirt_1'] = 0,  ['tshirt_2'] = 0,
					['torso_1'] = 274,   ['torso_2'] = 0,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['arms'] = 30,
					['pants_1'] = 59,   ['pants_2'] = 2,
					['shoes_1'] = 25,   ['shoes_2'] = 0,
					['helmet_1'] = 10,  ['helmet_2'] = 1,
					['chain_1'] = 0,    ['chain_2'] = 0,
					['ears_1'] = -1,      ['ears_2'] = 0,
					['mask_1'] = 4,     ['mask_2'] = 0,
					['bproof_1'] = 4, ['bproof_2'] = 4,
				}
					TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
	
				else
	
				  local clothesSkin = {
					['tshirt_1'] = 1,  ['tshirt_2'] = 0,
					['torso_1'] = 292,   ['torso_2'] = 0,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['arms'] = 31,
					['pants_1'] = 61,   ['pants_2'] = 2,
					['shoes_1'] = 25,   ['shoes_2'] = 0,
					['helmet_1'] = -1,  ['helmet_2'] = 0,
					['chain_1'] = 0,    ['chain_2'] = 0,
					['ears_1'] = 0,     ['ears_2'] = 0,
					['mask_1'] = 121,     ['mask_2'] = 0,
					['bags_1'] = 1, ['bags_2'] = 0,
					['bproof_1'] = 5, ['bproof_2'] = 4,
				}
				  TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
  
			  end
  
			  local playerPed = GetPlayerPed(-1)
			  SetPedArmour(playerPed, 50)
			  ClearPedBloodDamage(playerPed)
			  ResetPedVisibleDamage(playerPed)
			  ClearPedLastWeaponDamage(playerPed)
			  
		  end)
		end
  
		if data.current.value == 'krimv_wear' then
		  TriggerEvent('skinchanger:getSkin', function(skin)
		  
			  if skin.sex == 0 then
  
				  local clothesSkin = {
					['tshirt_1'] = 49,  ['tshirt_2'] = 0,
					['torso_1'] = 51,   ['torso_2'] = 2,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['arms'] = 30,
					['pants_1'] = 59,   ['pants_2'] = 3,
					['shoes_1'] = 24,   ['shoes_2'] = 0,
					['helmet_1'] = 10,  ['helmet_2'] = 2,
					['chain_1'] = 0,    ['chain_2'] = 0,
					['ears_1'] = -1,      ['ears_2'] = 0,
					['mask_1'] = 121,     ['mask_2'] = 0,
				  }
				  TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
  
			  else
  
				  local clothesSkin = {
					['tshirt_1'] = 31,  ['tshirt_2'] = 0,
					['torso_1'] = 44,   ['torso_2'] = 2,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['arms'] = 44,
					['pants_1'] = 61,   ['pants_2'] = 3,
					['shoes_1'] = 24,   ['shoes_2'] = 0,
					['helmet_1'] = -1,  ['helmet_2'] = 0,
					['chain_1'] = 0,    ['chain_2'] = 0,
					['ears_1'] = 0,     ['ears_2'] = 0,
					['mask_1'] = 121,  ['mask_2'] = 0,
				  }
				  TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
  
			  end
  
			  local playerPed = GetPlayerPed(-1)
			  SetPedArmour(playerPed, 100)
			  ClearPedBloodDamage(playerPed)
			  ResetPedVisibleDamage(playerPed)
			  ClearPedLastWeaponDamage(playerPed)
			  
		  end)
		end
  
		if data.current.value == 'bullet_wear' then
		  TriggerEvent('skinchanger:getSkin', function(skin)
		  
			  if skin.sex == 0 then
  
				  local clothesSkin = {
					['bproof_1'] = 11,  ['bproof_2'] = 1
				  }
				  TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
  
			  else
  
				  local clothesSkin = {
					['bproof_1'] = 13,  ['bproof_2'] = 1
				  }
				  TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
  
			  end
  
			  local playerPed = GetPlayerPed(-1)
			  SetPedArmour(playerPed, 100)
			  ClearPedBloodDamage(playerPed)
			  ResetPedVisibleDamage(playerPed)
			  ClearPedLastWeaponDamage(playerPed)
			  
		  end)
		end
		
  
		if data.current.value == 'ord_wear' then
		  TriggerEvent('skinchanger:getSkin', function(skin)
		  
			  if skin.sex == 0 then
  
				  local clothesSkin = {
					['bproof_1'] = 11,  ['bproof_2'] = 2
				  }
				  TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
  
			  else
  
				  local clothesSkin = {
					['bproof_1'] = 13,  ['bproof_2'] = 2
				  }
				  TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
  
			  end
  
			  local playerPed = GetPlayerPed(-1)
			  SetPedArmour(playerPed, 50)
			  ClearPedBloodDamage(playerPed)
			  ResetPedVisibleDamage(playerPed)
			  ClearPedLastWeaponDamage(playerPed)
			  
		  end)
		end
  
		if data.current.value == 'gilet_wear' then
		  TriggerEvent('skinchanger:getSkin', function(skin)
		  
			  if skin.sex == 0 then
  
				  local clothesSkin = {
					['bproof_1'] = -1,  ['bproof_2'] = 0
				  }
				  TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
  
			  else
  
				  local clothesSkin = {
					['bproof_1'] = -1,  ['bproof_2'] = 0
				  }
				  TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
  
			  end
  
			  local playerPed = GetPlayerPed(-1)
			  SetPedArmour(playerPed, 50)
			  ClearPedBloodDamage(playerPed)
			  ResetPedVisibleDamage(playerPed)
			  ClearPedLastWeaponDamage(playerPed)
			  
		  end)
		end
  
		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
  
	  end,
	  function(data, menu)
  
		menu.close()
  
		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	  end
	)
  
  end
  
  function OpenArmoryMenu(station)
  
	if Config.EnableArmoryManagement then
  
	  local elements = {
		{label = _U('get_weapon'), value = 'get_weapon'},
		{label = _U('put_weapon'), value = 'put_weapon'},
		--{label = 'Plocka ut från förrådet',  value = 'get_stock'},
		{label = 'Lägg in i förrådet',  value = 'put_stock'}
	  }
  
	  if PlayerData.job.grade_name == 'officer' then
		table.insert(elements, {label = ('Plocka ut från förrådet'), value = 'get_stock'})
	  end
  
	  if PlayerData.job.grade_name == 'sergeant' then
		table.insert(elements, {label = ('Plocka ut från förrådet'), value = 'get_stock'})
	  end
  
	  if PlayerData.job.grade_name == 'lieutenant' then
		table.insert(elements, {label = ('Plocka ut från förrådet'), value = 'get_stock'})
	  end
  
	  if PlayerData.job.grade_name == 'boss' then
		table.insert(elements, {label = ('Plocka ut från förrådet'), value = 'get_stock'})
		table.insert(elements, {label = _U('buy_weapons'), value = 'buy_weapons'})
	  end
  
	  ESX.UI.Menu.CloseAll()
  
	  ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'armory',
		{
		  title    = _U('armory'),
		  align    = 'right',
		  elements = elements,
		},
		function(data, menu)
  
		  if data.current.value == 'get_weapon' then
			OpenGetWeaponMenu()
		  end
  
		  if data.current.value == 'put_weapon' then
			OpenPutWeaponMenu()
		  end
  
		  if data.current.value == 'buy_weapons' then
			OpenBuyWeaponsMenu(station)
		  end
  
		  if data.current.value == 'put_stock' then
				OpenPutStocksMenu()
			  end
  
			  if data.current.value == 'get_stock' then
				OpenGetStocksMenu()
			  end
  
		end,
		function(data, menu)
  
		  menu.close()
  
		  CurrentAction     = 'menu_armory'
		  CurrentActionMsg  = _U('open_armory')
		  CurrentActionData = {station = station}
		end
	  )
  
	else
  
	  local elements = {}
  
	  for i=1, #Config.PoliceStations[station].AuthorizedWeapons, 1 do
		local weapon = Config.PoliceStations[station].AuthorizedWeapons[i]
		table.insert(elements, {label = ESX.GetWeaponLabel(weapon.name), value = weapon.name})
	  end
  
	  ESX.UI.Menu.CloseAll()
  
	  ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'armory',
		{
		  title    = _U('armory'),
		  align    = 'right',
		  elements = elements,
		},
		function(data, menu)
		  local weapon = data.current.value
		  TriggerServerEvent('esx_Securitasjob:giveWeapon', weapon,  1000)
		end,
		function(data, menu)
  
		  menu.close()
  
		  CurrentAction     = 'menu_armory'
		  CurrentActionMsg  = _U('open_armory')
		  CurrentActionData = {station = station}
  
		end
	  )
  
	end
  
  end
  
  function OpenVehicleSpawnerMenu(station, partNum)
  
	local vehicles = Config.PoliceStations[station].Vehicles
  
	ESX.UI.Menu.CloseAll()
  
	if Config.EnableSocietyOwnedVehicles then
  
	  local elements = {}
  
	  ESX.TriggerServerCallback('esx_society:getVehiclesInGarage', function(garageVehicles)
  
		for i=1, #garageVehicles, 1 do
		  table.insert(elements, {label = GetDisplayNameFromVehicleModel(garageVehicles[i].model) .. ' [' .. garageVehicles[i].plate .. ']', value = garageVehicles[i]})
		end
  
		ESX.UI.Menu.Open(
		  'default', GetCurrentResourceName(), 'vehicle_spawner',
		  {
			title    = _U('vehicle_menu'),
			align    = 'right',
			elements = elements,
		  },
		  function(data, menu)
  
			menu.close()
  
			local vehicleProps = data.current.value
  
			ESX.Game.SpawnVehicle(vehicleProps.model, vehicles[partNum].SpawnPoint, 270.0, function(vehicle)
			local props = ESX.Game.GetVehicleProperties(vehicle)
  
			props.plate = 'SECURITAS'
  
			ESX.Game.SetVehicleProperties(vehicle, props)
  
			TriggerEvent("advancedFuel:setEssence", 100, GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
			local playerPed = GetPlayerPed(-1)
			TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
			end)
  
			TriggerServerEvent('esx_society:removeVehicleFromGarage', 'Securitas', vehicleProps)
  
		  end,
		  function(data, menu)
  
			menu.close()
  
			CurrentAction     = 'menu_vehicle_spawner'
			CurrentActionMsg  = _U('vehicle_spawner')
			CurrentActionData = {station = station, partNum = partNum}
  
		  end
		)
  
	  end, 'Securitas')
  
	else
  
	  local elements = {}
	  
		  table.insert(elements, { label = 'Securitas', value = 'dilettante2'})
		table.insert(elements, { label = 'Kriminalvården', value = 'policet4'})
		  table.insert(elements, { label = 'Personskyddet', value = 'baller4'})
  
  
  
	   if PlayerData.job.grade_name == 'Recruit' then
	  table.insert(elements, { label = 'Securitas', value = 'dilettante2'})
  
	  end
  
	  if PlayerData.job.grade_name == 'Officer' then
		  table.insert(elements, { label = 'Securitas', value = 'dilettante2'})
		table.insert(elements, { label = 'Kriminalvården', value = 'policet4'})
	  end
  
	  if PlayerData.job.grade_name == 'Sergeant' then
		  table.insert(elements, { label = 'Securitas', value = 'dilettante2'})
		table.insert(elements, { label = 'Kriminalvården', value = 'policet4'})
		  table.insert(elements, { label = 'Personskyddet', value = 'baller5'})
	  end
  
	  if PlayerData.job.grade_name == 'Lieutenant' then
		  table.insert(elements, { label = 'Securitas', value = 'dilettante2'})
		table.insert(elements, { label = 'Kriminalvården', value = 'policet4'})
		  table.insert(elements, { label = 'Personskyddet', value = 'baller5'})
	  end
  
	  if PlayerData.job.grade_name == 'Boss' then
		  table.insert(elements, { label = 'Securitas', value = 'dilettante2'})
		table.insert(elements, { label = 'Kriminalvården', value = 'policet4'})
		  table.insert(elements, { label = 'Personskyddet', value = 'baller5'})
	  end
  
	  ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'vehicle_spawner',
		{
		  title    = _U('vehicle_menu'),
		  align    = 'right',
		  elements = elements,
		},
		function(data, menu)
  
		  menu.close()
  
		  local model = data.current.value
  
		  local vehicle = GetClosestVehicle(vehicles[partNum].SpawnPoint.x,  vehicles[partNum].SpawnPoint.y,  vehicles[partNum].SpawnPoint.z,  3.0,  0,  71)
  
		  if not DoesEntityExist(vehicle) then
  
			local playerPed = GetPlayerPed(-1)
			 DoScreenFadeOut(1000)
			 Citizen.Wait(2000)
			if Config.MaxInService == -1 then
			  ESX.Game.SpawnVehicle(model, {
				x = vehicles[partNum].SpawnPoint.x,
				y = vehicles[partNum].SpawnPoint.y,
				z = vehicles[partNum].SpawnPoint.z
			  }, vehicles[partNum].Heading, function(vehicle)
			  DoScreenFadeIn(1000)
				local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
				vehicleProps.plate = 'SECURITAS'
				ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
				TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
				SetVehicleMaxMods(vehicle)
				TriggerEvent("advancedFuel:setEssence", 100, GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
				local playerPed = GetPlayerPed(-1)
				TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
			  end)
  
			else
  
			  ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)
  
				if canTakeService then
  
				  ESX.Game.SpawnVehicle(model, {
					x = vehicles[partNum].SpawnPoint.x,
					y = vehicles[partNum].SpawnPoint.y,
					z = vehicles[partNum].SpawnPoint.z
				  }, vehicles[partNum].Heading, function(vehicle)
					TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
					SetVehicleMaxMods(vehicle)
				  end)
  
				else
				  exports['mythic_notify']:SendAlert('error', _U('service_max') .. inServiceCount .. '/' .. maxInService)
				end
  
			  end, 'Securitas')
  
			end
  
		  else
			--ESX.ShowNotification(_U('vehicle_out'))
			exports['mythic_notify']:SendAlert('inform', (_U('vehicle_out')))
		  end
  
		end,
		function(data, menu)
  
		  menu.close()
  
		  CurrentAction     = 'menu_vehicle_spawner'
		  CurrentActionMsg  = _U('vehicle_spawner')
		  CurrentActionData = {station = station, partNum = partNum}
  
		end
	  )
  
	end
  
  end
  
  
  
  function OpenSecuritasActionsMenu()
  
	ESX.UI.Menu.CloseAll()
  
	ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'Securitas_actions',
	  {
		title    = 'Securitasmeny',
		align    = 'right',
		elements = {
		  {label = _U('citizen_interaction'), value = 'citizen_interaction'},
		  {label = _U('vehicle_interaction'), value = 'vehicle_interaction'},
		  {label = _U('object_spawner'),      value = 'object_spawner'},
		  {label = 'Överfallslarm', value = 'larm'},
		 -- {label = 'jail', value = 'jail_menu'},
		},
	  },
	  function(data, menu)

		if data.current.value == 'larm' then
			local x, y, z  = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
			local PlayerCoords = GetEntityCoords(GetPlayerPed(-1),  true)
			--TriggerServerEvent('esx_addons_gcphone:startCall', 'police', _U('distress_message'), PlayerCoords)
			TriggerServerEvent('esx_addons_gcphone:startCall', 'police', 'En Securitasvakt har aktiverat sitt överfallslarm! ', {x = plyPos.x, y = plyPos.y, z = plyPos.z}, dispatch)
		  end	
		  
		  if data.current.value == 'jail_menu' then
			openJailMenu(playerid)
		  end
  
		if data.current.value == 'citizen_interaction' then
  
		  ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'citizen_interaction',
			{
			  title    = _U('citizen_interaction'),
			  align    = 'right',
			  elements = {
				{label = _U('id_card'),         value = 'identity_card'},
				{label = _U('search'),          value = 'body_search'},
				{label = 'Sätt På Handbojor',   value = 'handcuff'},
				{label = 'Ta Av Handbojor',    value = 'unhandcuff'},
				{label = _U('drag'),      	  value = 'drag'},
				{label = _U('put_in_vehicle'),  value = 'put_in_vehicle'},
				{label = _U('out_the_vehicle'), value = 'out_the_vehicle'},
				{label = _U('fine'),            value = 'fine'},
				{label = ('HLR'),   value = 'revive'},
				{label = ('Fängsla'),   value = 'jail'}
				
			  },
			},
			 function(data2, menu2)
  
			  local player, distance = ESX.Game.GetClosestPlayer()
  
			  if distance ~= -1 and distance <= 3.0 then
  
  
				if data2.current.value == 'identity_card' then
				  OpenIdentityCardMenu(player)
				end
  
				if data2.current.value == 'body_search' then
				  OpenBodySearchMenu(player)
				end

				if data2.current.value == 'jail' then
					openJailMenu(GetPlayerServerId(player))
				end
  
				if data2.current.value == 'handcuff' then
				  RequestAnimDict('missheistfbisetup1')
  
				  TaskPlayAnim(GetPlayerPed(-1), 'missheistfbisetup1' ,'unlock_loop_janitor' ,8.0, -8.0, -1, 0, 0, false, false, false )
				  Citizen.Wait(2900)
				  ClearPedTasksImmediately(GetPlayerPed(-1))
				  TriggerServerEvent('esx_Securitas:handcuff', GetPlayerServerId(player))
				  TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "cuffs", 0.5)
				end
  
				if data2.current.value == 'unhandcuff' then
				  RequestAnimDict('missheistfbisetup1')
				  
				  TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'a_uncuff', 8.0, -8.0, -1, 1, 0, false, false, false)
				  Citizen.Wait(2900)
				  ClearPedTasksImmediately(GetPlayerPed(-1))
				  TriggerServerEvent('esx_Securitas:unhandcuff', GetPlayerServerId(player))
				  TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "cuffs", 0.5)
				end
  
				if data2.current.value == 'drag' then
				  TriggerServerEvent('esx_drag:drag', GetPlayerServerId(player))
				end
  
				if data2.current.value == 'put_in_vehicle' then
				  TriggerServerEvent('esx_policejob:putInVehicle', GetPlayerServerId(player))
				end
  
				if data2.current.value == 'out_the_vehicle' then
					TriggerServerEvent('esx_policejob:OutVehicle', GetPlayerServerId(player))
				end
  
				if data2.current.value == 'fine' then
				  OpenFineMenu(player)
				end
				
				if data2.current.value == 'revive' then
  
				  menu.close()
  
				  local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
  
				  if closestPlayer == -1 or closestDistance > 3.0 then
			--ESX.ShowNotification(_U('no_players'))
			exports['mythic_notify']:SendAlert('error', (_U('no_players')))
			
			
				  else
  
					  local ped    = GetPlayerPed(closestPlayer)
					  local health = GetEntityHealth(ped)
					  local ped    = GetPlayerPed(closestPlayer)
					  local health = GetEntityHealth(ped)
  
					  if health < 100 then
  
						  local playerPed        = GetPlayerPed(-1)
						  local closestPlayerPed = GetPlayerPed(closestPlayer)
  
						  Citizen.CreateThread(function()
  
				--ESX.ShowNotification(_U('revive_inprogress'))
				exports['mythic_notify']:SendAlert('inform', (_U('revive_inprogress')))
  
							  TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
							  Citizen.Wait(10000)
							  ClearPedTasks(playerPed)
  
							  if GetEntityHealth(closestPlayerPed) == 0 then
								  TriggerServerEvent('esx_ambulancejob:revive', GetPlayerServerId(closestPlayer))
								  exports['mythic_notify']:SendAlert('success', _U('revive_complete') .. GetPlayerName(closestPlayer))
							  else
								  exports['mythic_notify']:SendAlert('error', GetPlayerName(closestPlayer) .. _U('isdead'))
							  end
  
						  end)
  
					  else
			  exports['mythic_notify']:SendAlert('warning', GetPlayerName(closestPlayer) .. _U('unconscious'))
					  end
				  end
		end
  
			  else
				--ESX.ShowNotification(_U('no_players_nearby'))
				exports['mythic_notify']:SendAlert('error', (_U('no_players_nearby')))
			  end
  
			end,
			function(data2, menu2)
			  menu2.close()
			end
		  )
  
		end
  
		if data.current.value == 'vehicle_interaction' then
  
		  ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'vehicle_interaction',
			{
			  title    = _U('vehicle_interaction'),
			  align    = 'right',
			  elements = {
				{label = _U('vehicle_info'), value = 'vehicle_infos'},
			   -- {label = _U('pick_lock'),    value = 'hijack_vehicle'},
			  },
			},
			function(data2, menu2)
  
			  local playerPed = GetPlayerPed(-1)
			  local coords    = GetEntityCoords(playerPed)
			  local vehicle   = GetClosestVehicle(coords.x,  coords.y,  coords.z,  3.0,  0,  71)
  
			  if DoesEntityExist(vehicle) then
  
				local vehicleData = ESX.Game.GetVehicleProperties(vehicle)
  
				if data2.current.value == 'vehicle_infos' then
				  OpenVehicleInfosMenu(vehicleData)
				end
  
				if data2.current.value == 'hijack_vehicle' then
  
				  local playerPed = GetPlayerPed(-1)
				  local coords    = GetEntityCoords(playerPed)
  
				  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then
  
					local vehicle = GetClosestVehicle(coords.x,  coords.y,  coords.z,  3.0,  0,  71)
  
					if DoesEntityExist(vehicle) then
  
					  Citizen.CreateThread(function()
  
						TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
  
						Wait(20000)
  
						ClearPedTasksImmediately(playerPed)
  
						SetVehicleDoorsLocked(vehicle, 1)
						SetVehicleDoorsLockedForAllPlayers(vehicle, false)
  
						--TriggerEvent('esx:showNotification', _U('vehicle_unlocked'))
						exports['mythic_notify']:SendAlert('success', (_U('vehicle_unlocked')))
  
					  end)
  
					end
  
				  end
  
				end
  
			  else
				--ESX.ShowNotification(_U('no_vehicles_nearby'))
				exports['mythic_notify']:SendAlert('error', (_U('no_vehicles_nearby')))
			  end
  
			end,
			function(data2, menu2)
			  menu2.close()
			end
		  )
  
		end
  
		if data.current.value == 'object_spawner' then
  
		  ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'citizen_interaction',
			{
			  title    = _U('traffic_interaction'),
			  align    = 'right',
			  elements = {
				{label = _U('cone'),     value = 'prop_roadcone02a'},
				{label = _U('barrier'), value = 'ba_prop_battle_barrier_01b'},
				{label = _U('barrier2'),    value = 'ba_prop_battle_barrier_02a'},
				--{label = _U('box'),   value = 'prop_boxpile_07d'},
				--{label = _U('cash'),   value = 'hei_prop_cash_crate_half_full'}
			  },
			},
			function(data2, menu2)
  
  
			  local model     = data2.current.value
			  local playerPed = GetPlayerPed(-1)
			  local coords    = GetEntityCoords(playerPed)
			  local forward   = GetEntityForwardVector(playerPed)
			  local x, y, z   = table.unpack(coords + forward * 1.0)

  
			  ESX.Game.SpawnObject(model, {
				x = x,
				y = y,
				z = z
			  }, function(obj)
				SetEntityHeading(obj, GetEntityHeading(playerPed))
				PlaceObjectOnGroundProperly(obj)
			  end)
  
			end,
			function(data2, menu2)
			  menu2.close()
			end
		  )
  
		end      
		
		if data.current.value == 'radar_spawner' then
		  TriggerEvent('esx_Securitas:POLICE_radar')
		end      
  
	  end,
	  function(data, menu)
  
		menu.close()
  
	  end
	)
  
  end
  
  function OpenIdentityCardMenu(player)
  
	if Config.EnableESXIdentity then
  
	  ESX.TriggerServerCallback('esx_Securitas:getOtherPlayerData', function(data)
  
  --      local jobLabel    = nil
		local sexLabel    = nil
		local sex         = nil
		local dobLabel    = nil
		local heightLabel = nil
		local idLabel     = nil
  
  --      if data.job.grade_label ~= nil and  data.job.grade_label ~= '' then
  --        jobLabel = 'Job : ' .. data.job.label .. ' - ' .. data.job.grade_label
  --      else
  --        jobLabel = 'Job : ' .. data.job.label
  --      end
  
		if data.sex ~= nil then
		  if (data.sex == 'm') or (data.sex == 'M') then
			sex = 'Man'
		  else
			sex = 'Kvinna'
		  end
		  sexLabel = 'Kön : ' .. sex
		else
		  sexLabel = 'Kön : Okänt'
		end
  
		if data.dob ~= nil then
		  dobLabel = 'Personnummer : ' .. data.dob
		else
		  dobLabel = 'Personnummer : Okänt'
		end
  
		if data.height ~= nil then
		  heightLabel = 'Längd : ' .. data.height .. ' cm'
		else
		  heightLabel = 'Längd : Okänt'
		end
  
		if data.name ~= nil then
		  idLabel = 'Medborgarens nummer : ' .. GetPlayerServerId(player)
		else
		  idLabel = 'Medborgarens nummer är okänt'
		end
  
		local elements = {
		  {label = ('Namn: ') .. data.firstname .. " " .. data.lastname, value = nil},
		  {label = sexLabel,    value = nil},
		  {label = dobLabel,    value = nil},
		  {label = heightLabel, value = nil},
          --{label = jobLabel,    value = nil},
		  {label = idLabel,     value = nil},
		}
  
		if data.drunk ~= nil then
		  table.insert(elements, {label = ('Alkohol i blodet: ') .. data.drunk .. '%', value = nil})
		end
  
		if data.licenses ~= nil then
  
		  table.insert(elements, {label = '--- Licenses ---', value = nil})
  
		  for i=1, #data.licenses, 1 do
			table.insert(elements, {label = data.licenses[i].label, value = nil})
		  end
  
		end
  
		ESX.UI.Menu.Open(
		  'default', GetCurrentResourceName(), 'citizen_interaction',
		  {
			title    = _U('citizen_interaction'),
			align    = 'right',
			elements = elements,
		  },
		  function(data, menu)
  
		  end,
		  function(data, menu)
			menu.close()
		  end
		)
  
	  end, GetPlayerServerId(player))
  
	else
  
	  ESX.TriggerServerCallback('esx_Securitas:getOtherPlayerData', function(data)
  
  --      local jobLabel = nil
  
  --      if data.job.grade_label ~= nil and  data.job.grade_label ~= '' then
  --        jobLabel = 'Job : ' .. data.job.label .. ' - ' .. data.job.grade_label
  --      else
  --        jobLabel = 'Job : ' .. data.job.label
  --      end
  
  --        local elements = {
  --          {label = _U('name') .. data.name, value = nil},
  --          {label = jobLabel,              value = nil},
  --        }
  
		if data.drunk ~= nil then
		  table.insert(elements, {label = _U('bac') .. data.drunk .. '%', value = nil})
		end
  
		if data.licenses ~= nil then
  
		  table.insert(elements, {label = '--- Licenses ---', value = nil})
  
		  for i=1, #data.licenses, 1 do
			table.insert(elements, {label = data.licenses[i].label, value = nil})
		  end
  
		end
  
		ESX.UI.Menu.Open(
		  'default', GetCurrentResourceName(), 'citizen_interaction',
		  {
			title    = _U('citizen_interaction'),
			align    = 'right',
			elements = elements,
		  },
		  function(data, menu)
  
		  end,
		  function(data, menu)
			menu.close()
		  end
		)
  
	  end, GetPlayerServerId(player))
  
	end
  
  end
  
  function OpenBodySearchMenu(player)
  RequestAnimDict("mini@repair")
	ESX.TriggerServerCallback('esx_Securitas:getOtherPlayerData', function(data)
	  TaskPlayAnim(GetPlayerPed(-1),"mini@repair","fixing_a_ped", 1.0, -1.0, 10000, 1, 1, false, false, false)
	  local elements = {}
  
	  local blackMoney = 0
  
	  for i=1, #data.accounts, 1 do
		if data.accounts[i].name == 'black_money' then
		  blackMoney = data.accounts[i].money
		end
	  end
  
	  table.insert(elements, {
		label          = ('Konfiskera svarta pengar: $') .. blackMoney,
		value          = 'black_money',
		itemType       = 'item_account',
		amount         = blackMoney
	  })
  
	  table.insert(elements, {label = '--- Vapen ---', value = nil})
  
	  for i=1, #data.weapons, 1 do
		table.insert(elements, {
		  label          = ('Konfiskera ') .. ESX.GetWeaponLabel(data.weapons[i].name),
		  value          = data.weapons[i].name,
		  itemType       = 'item_weapon',
		  amount         = data.ammo,
		})
	  end
  
	  table.insert(elements, {label = ('--- Packning ---'), value = nil})
  
	  for i=1, #data.inventory, 1 do
		if data.inventory[i].count > 0 then
		  table.insert(elements, {
			label          = ('Konfiskera ') .. data.inventory[i].count .. ' ' .. data.inventory[i].label,
			value          = data.inventory[i].name,
			itemType       = 'item_standard',
			amount         = data.inventory[i].count,
		  })
		end
	  end
  
  
	  ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'body_search',
		{
		  title    = ('search'),
		  align    = 'right',
		  elements = elements,
		},
		function(data, menu)
  
		  local itemType = data.current.itemType
		  local itemName = data.current.value
		  local amount   = data.current.amount
  
		  if data.current.value ~= nil then
  
			TriggerServerEvent('esx_Securitas:confiscatePlayerItem', GetPlayerServerId(player), itemType, itemName, amount)
  
			OpenBodySearchMenu(player)
  
		  end
  
		end,
		function(data, menu)
		  menu.close()
		end
	  )
  
	end, GetPlayerServerId(player))
  
  end
  
  function OpenFineMenu(player)
  
	ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'fine',
	  {
		title    = _U('fine'),
		align    = 'right',
		elements = {
		  {label = _U('traffic_offense'),   value = 0},
		},
	  },
	  function(data, menu)
  
		OpenFineCategoryMenu(player, data.current.value)
  
	  end,
	  function(data, menu)
		menu.close()
	  end
	)
  
  end
  
  function OpenFineHistoryMenu(player, category)
  
	ESX.TriggerServerCallback('esx_kekke_fine_history:getFineHistory', function(fines)
  
	  local elements = {}
  
	  for i=1, #fines, 1 do
		table.insert(elements, {
		  label     = fines[i].label .. ' SEK ' .. fines[i].amount,
		  value = i
		})
	  end
  
	  ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'fine_history',
		{
		  title    = _U('fine_history'),
		  align    = 'right',
		  elements = elements,
		},
		function(data, menu)
  
		end,
		function(data, menu)
		  menu.close()
		end
	  )
  
	end, GetPlayerServerId(player))
  
  end
  
  function OpenFineCategoryMenu(player, category)
  
	ESX.TriggerServerCallback('esx_Securitas:getFineList', function(fines)
  
	  local elements = {}
  
	  for i=1, #fines, 1 do
		table.insert(elements, {
		  label     = fines[i].label .. ' SEK ' .. fines[i].amount,
		  value     = fines[i].id,
		  amount    = fines[i].amount,
		  fineLabel = fines[i].label
		})
	  end
  
	  ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'fine_category',
		{
		  title    = _U('fine'),
		  align    = 'right',
		  elements = elements,
		},
		function(data, menu)
  
		  local label  = data.current.fineLabel
		  local amount = data.current.amount
  
		  menu.close()
  
		  if Config.EnablePlayerManagement then
			--local xPlayer = ESX.GetPlayerFromId(GetPlayerServerId(player))
			TriggerServerEvent('esx_kekke_fine_history:addFineHistory', GetPlayerServerId(player), label, amount)
			TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_Securitas', ('fine_total') .. label, amount)
		  else
			TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), '', ('fine_total') .. label, amount)
		  end
  
		  ESX.SetTimeout(300, function()
			OpenFineCategoryMenu(player, category)
		  end)
  
		end,
		function(data, menu)
		  menu.close()
		end
	  )
  
	end, category)
  
  end
  
  function OpenVehicleInfosMenu(vehicleData)
  
	ESX.TriggerServerCallback('esx_Securitas:getVehicleInfos', function(infos)
  
	  local elements = {}
  
	  table.insert(elements, {label = ('Regnr: ') .. infos.plate, value = nil})
  
	  if infos.owner == nil then
		table.insert(elements, {label = ('Okänd ägare'), value = nil})
	  else
		table.insert(elements, {label = ('Ägare: ') .. infos.owner, value = nil})
	  end
  
	  ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'vehicle_infos',
		{
		  title    = _U('vehicle_info'),
		  align    = 'right',
		  elements = elements,
		},
		nil,
		function(data, menu)
		  menu.close()
		end
	  )
  
	end, vehicleData.plate)
  
  end
  
  function OpenGetWeaponMenu()
  
	ESX.TriggerServerCallback('esx_Securitas:getArmoryWeapons', function(weapons)
  
	  local elements = {}
  
	  for i=1, #weapons, 1 do
		if weapons[i].count > 0 then
		  table.insert(elements, {label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name), value = weapons[i].name})
		end
	  end
  
	  ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'armory_get_weapon',
		{
		  title    = _U('get_weapon_menu'),
		  align    = 'right',
		  elements = elements,
		},
		function(data, menu)
  
		  menu.close()
  
		  ESX.TriggerServerCallback('esx_Securitas:removeArmoryWeapon', function()
			OpenGetWeaponMenu()
		  end, data.current.value)
  
		end,
		function(data, menu)
		  menu.close()
		end
	  )
  
	end)
  
  end
  
  function OpenPutWeaponMenu()
  
	local elements   = {}
	local playerPed  = GetPlayerPed(-1)
	local weaponList = ESX.GetWeaponList()
  
	for i=1, #weaponList, 1 do
  
	  local weaponHash = GetHashKey(weaponList[i].name)
  
	  if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
		local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
		table.insert(elements, {label = weaponList[i].label, value = weaponList[i].name})
	  end
  
	end
  
	ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'armory_put_weapon',
	  {
		title    = _U('put_weapon_menu'),
		align    = 'right',
		elements = elements,
	  },
	  function(data, menu)
  
		menu.close()
  
		ESX.TriggerServerCallback('esx_Securitas:addArmoryWeapon', function()
		  OpenPutWeaponMenu()
		end, data.current.value)
  
	  end,
	  function(data, menu)
		menu.close()
	  end
	)
  
  end
  
  function OpenBuyWeaponsMenu(station)
  
	ESX.TriggerServerCallback('esx_Securitas:getArmoryWeapons', function(weapons)
  
	  local elements = {}
  
	  for i=1, #Config.PoliceStations[station].AuthorizedWeapons, 1 do
  
		local weapon = Config.PoliceStations[station].AuthorizedWeapons[i]
		local count  = 0
  
		for i=1, #weapons, 1 do
		  if weapons[i].name == weapon.name then
			count = weapons[i].count
			break
		  end
		end
  
		table.insert(elements, {label = 'x' .. count .. ' ' .. ESX.GetWeaponLabel(weapon.name) .. ' $' .. weapon.price, value = weapon.name, price = weapon.price})
  
	  end
  
	  ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'armory_buy_weapons',
		{
		  title    = _U('buy_weapon_menu'),
		  align    = 'right',
		  elements = elements,
		},
		function(data, menu)
  
		  ESX.TriggerServerCallback('esx_Securitas:buy', function(hasEnoughMoney)
  
			if hasEnoughMoney then
			  ESX.TriggerServerCallback('esx_Securitas:addArmoryWeapon', function()
				OpenBuyWeaponsMenu(station)
			  end, data.current.value)
			else
			  --ESX.ShowNotification(_U('not_enough_money'))
			  exports['mythic_notify']:SendAlert('error', (_U('not_enough_money')))
			end
  
		  end, data.current.price)
  
		end,
		function(data, menu)
		  menu.close()
		end
	  )
  
	end)
  
  end
  
function OpenGetStocksMenu()

	ESX.TriggerServerCallback('esx_Securitas:getStockItems', function(items)

		local elements = {}

		for i=1, #items, 1 do
			if items[i].count > 0 then
			table.insert(elements, {
				label = 'x' .. items[i].count .. ' ' .. items[i].label,
				value = items[i].name
			})
		end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu',
		{
			title    = _U('Securitas_stock'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
				title = ('quantity')
			}, function(data2, menu2)

				local count = tonumber(data2.value)

				if count == nil then
					exports['mythic_notify']:SendAlert('error', _U('quantity_invalid'))
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('esx_Securitas:getStockItem', itemName, count)

					Citizen.Wait(300)
					OpenGetStocksMenu()
				end

			end, function(data2, menu2)
				menu2.close()
			end)

		end, function(data, menu)
			menu.close()
		end)

	end)

end
  
  function OpenPutStocksMenu()
  
	ESX.TriggerServerCallback('esx_Securitas:getPlayerInventory', function(inventory)
  
	  local elements = {}
  
	  for i=1, #inventory.items, 1 do
  
		local item = inventory.items[i]
  
		if item.count > 0 then
		  table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
		end
  
	  end
  
	  ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'stocks_menu',
		{
		  title    = _U('inventory'),
		  elements = elements
		},
		function(data, menu)
  
		  local itemName = data.current.value
  
		  ESX.UI.Menu.Open(
			'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
			{
			  title = _U('quantity')
			},
			function(data2, menu2)
  
			  local count = tonumber(data2.value)
  
			  if count == nil then
				--ESX.ShowNotification(_U('quantity_invalid'))
				exports['mythic_notify']:SendAlert('error', (_U('quantity_invalid')))
			  else
				menu2.close()
				menu.close()
				OpenPutStocksMenu()
  
				TriggerServerEvent('esx_Securitas:putStockItems', itemName, count)
			  end
  
			end,
			function(data2, menu2)
			  menu2.close()
			end
		  )
  
		end,
		function(data, menu)
		  menu.close()
		end
	  )
  
	end)
  
  end
  
  RegisterNetEvent('esx:playerLoaded')
  AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
  end)
  
  RegisterNetEvent('esx:setJob')
  AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
  end)
  
  RegisterNetEvent('esx_phone:loaded')
  AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
  
	local specialContact = {
	  name       = 'Securitas',
	  number     = 'Securitas',
	  base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNi1jMTM4IDc5LjE1OTgyNCwgMjAxNi8wOS8xNC0wMTowOTowMSAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENDIDIwMTcgKFdpbmRvd3MpIiB4bXBNTTpJbnN0YW5jZUlEPSJ4bXAuaWlkOjQwRDQzQzU2QzI0NzExRTc4RTFBQjBFMjg3NTExRjFCIiB4bXBNTTpEb2N1bWVudElEPSJ4bXAuZGlkOjQwRDQzQzU3QzI0NzExRTc4RTFBQjBFMjg3NTExRjFCIj4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InhtcC5paWQ6NDBENDNDNTRDMjQ3MTFFNzhFMUFCMEUyODc1MTFGMUIiIHN0UmVmOmRvY3VtZW50SUQ9InhtcC5kaWQ6NDBENDNDNTVDMjQ3MTFFNzhFMUFCMEUyODc1MTFGMUIiLz4gPC9yZGY6RGVzY3JpcHRpb24+IDwvcmRmOlJERj4gPC94OnhtcG1ldGE+IDw/eHBhY2tldCBlbmQ9InIiPz7hPt6DAAAIYklEQVR42qxXCWxU1xU9f52ZP57NM8YeG4OxMXghbDZ2gBSbxUCgWSiijaKoG4VUSaBJowSaNm2KKBSBQQkpoSxNkaAqSUlCCjVgGpYEjEmAAiaYDNjgbWw8Xmb5M/P3vjFEQhEKxuRLT3rz/tzz7j333XPfh2EYuHPczzOvjH/jqRn82vux+eZ+LB7gkVlbDlgqCQgMGGPADpgFe1Zqdu5MhqXMglXNi4q99QPBob5JO0VR3+4xx7unlpc9P7cseVkoKgoJCIdgkg/VxDYcPHioUlWVwL1SMCAHhufmTZ5WPmlZkpUdP/uRlIxd2yvfL5o4q9BsFsxHq/ec/NniF5+pPhVp6w1GLxw/8cXa+st1n/THAbo/NJWUTn76T398ucrDX5wyp6Ik49L5/dd2VMVf8njctpQUl+sf1fJvTtfurZs7syTdw9dNXPH6kn9PKZu+MBHPvbDv6UBx8YT5b25YvWPPP1cdaGjTP0xJtUH3NXMrhyR/kJ6WnulJSXOtzk7ey13tEBwuFv5eoWrn31fsWbPq9S1Tysp//EAOsJzFufSl3/7hsyPbW/zHGxu/Xzp4RjR8DvkyP6TC7ilRA/sgd36AaQ7P+IcUS3YkeAZzHvZO66lt8x+uervhuRdeec0iOAYN2IFxI5knbdzZHO14jXW9M+/VYTdODdYaNgIRE6IeDRbJD0vMD9GlgJbMUK5uweCGTwZtcI181XTyjJPXazNKCukfDbgMOzqj5129f5ZKih2uXk6Ao4CFwnlhGSEi3MAiy82DZigEkhQkeXXwQhqYERJ6RsdQWhB3MZE10bZ25eyAGWjqwGVJc/Z6cxlWTFIhRhSku4Kg3Abc31MgmOMQTDF4JqmgUnV4XSHERBlRq4rkYRQDxin6mnHhAQ6hHt/8XnBzmNbgmR1HUraGQFBD6jgJaaMkaLoKRVWRWkh+F8noCmkQhmhwz4ojLmh4Z3doG8EIP6gQsfvWWnzFY9is3hCDsGxCb5RHXGOhG0xfodHQYGYUOAUFdl6Cw6bhsk9rn/pCNJfYR75NB+56Bmga1lkPmxYdPi3tHpTMZq08Vux39EzIagymoktxQKKskA0emnHLWYYywFMyTIYIDxfEMHsHYlfO+DNST47tCCi+GaWmpw7XSu+qGkL9YuC5BULl7xYm/bqlQ/WHRMM6o3oli5RiARSx1ziyo/R1PHdkksw1E3mnENZtQNclqWracsVj18LpKZy3cmdk0/pd4vP9UUK6otRUrqhA7hDOm+PVk4Yn+7kCphogIUx3fgwH3QEPGpFG+TCIakAqfLDSXahwfkSc0JDP/ReZ9hZ6uFcTcjM5r6IamF5iKrsb43dzwGhq1xoTk4ZWDTYLSF7j9FzvCRQwJ1A58X08nnIUjydXI10IwmOOYF5KNeYkH8OGybtRQJ/EE95PiU2McVp1XGvR+kCbb2Hq/dEBY++x+JExI7j5Xb06wr1yV8uNSLuamfRQoeVLMIyOTK6Z5EpGt+iEpHMYxHfDqsVBkXAKhS+hMRb4W6P1dT7J3R1DajjGgGAevZsDd2OAmjbB9ESiGDxOGu0BzZwqRJO7Ylb8Ynwt6EQahvpQPKgFHTE7ApIdhS4/Hs2pB6UYWDiuFkFJQKpFdPo7NXOygwFNsMqL+ccS57VfKai/rrYk22lEJQOZaYwtxxvNCKlWzMjvRE6qgrK8bgwmUhzTBaIDZqS7gan5Xcgm72bm30SYrGenRdOz0hlHjGAksL66obYRbK1fUnzkC/ktMy9aK0r5BXYXTeW5OrGxdT4Kdw3t67CSzhIRIr6TciQ1iKdPLAFXo4Gn1T6WWyKZWJz+N6ITFMSYYby1W/zw0Cm5sl9KmOami4JhPRCNGxcLczhDVilCZwii7kB9vAj1YgFSjDY0xUejzHUc5a6jaCZzD1mrF/PJf4oRMZLhtQQhaxQKc1jIilHXG9Zvej30uHsysPZF+7bZ080FniSal6MJgWERIppP+WLo0x0yfpB5Cj0NDiwpOEwI0NFaY8N8snb6Kqk0imiEEUe2J4YMF4esDIZ6d5Xr9+si+vIjx6QrBGH0tzKw8z+xTW4rxSeEhUmwTGQx0BEmnt4WH0K/aNgwwnQFLi4MJxdBLn+FrJHLMamIW8ooE5sQqRiaYFAJ/YWbBLRjf3TLPVNwsEbaumZr5Eic7BchB8ggIeemybAx4VuHmDS5logDC0aeBWvIoHUZC/LOoFV0oK8OCaSNjmCkN9GsKIQJRiwOrN8eqdn3qfSXfnXDd/4Vfa3qWLw+caRO1WmIh8MYw31OIjT1mSSi/ckjlzAlr5OMAH5K5tEEAwk43YxC7gwUMYSTF1XSMwxUn5Cuvv2euOwO7b53N7SYqPTlP0/aXJLPPRaOqJBI83nlq5fRzpdhKP85nskhumJwt40U7Goow3WpBG7pJNblroWNjcEisDh3VTmwelvkWVINTfd9LR83klu0abl9S1wmbUCW0dxjwuamH+K0Ph2Ikaue5bauxEh5mwMoYo5gccZuZLujYE18Igj8al1waW2dsvG+2vHXz4RCbrxGxJMl+9yMsMjLUHFg4k6caz2kV10fbnx8wXOZ5FmbNzYwqmLIVao4s4P2NdNobGeRaU30JYNg8OOJAwO7kNgEKi0vi330l/OFFWVF/OAIKcsh6QxCIQWKIiPYo4V0AuBysQ6W5+Cw82hq05AkUPjsf0rb5j3iG5ca1P1h0Wh7oC8j0hPGHtvqPp7ioW2d3TqshFqJnO7u0K3e4iJSayZrIllLcdHo7tGjU5/tnuoPaKe/s08zq4XKWTRPWDppHD+LlLb18jW1ZttH0Y26Dn3hk5Ylo4Zzk4hQxU+dlw/9dU/0TcKWrz+fZv8XYADKodqb+HwseQAAAABJRU5ErkJggg=='
	}
  
	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
  
  end)
  
  AddEventHandler('esx_Securitas:hasEnteredMarker', function(station, part, partNum)
  
	if part == 'Cloakroom' then
	  CurrentAction     = 'menu_cloakroom'
	  CurrentActionMsg  = _U('open_cloackroom')
	  CurrentActionData = {}
	end
  
	if part == 'Armory' then
	  CurrentAction     = 'menu_armory'
	  CurrentActionMsg  = _U('open_armory')
	  CurrentActionData = {station = station}
	end
  
	if part == 'VehicleSpawner' then
	  CurrentAction     = 'menu_vehicle_spawner'
	  CurrentActionMsg  = _U('vehicle_spawner')
	  CurrentActionData = {station = station, partNum = partNum}
	end
  
	if part == 'HelicopterSpawner' then
  
	  local helicopters = Config.PoliceStations[station].Helicopters
  
	  if not IsAnyVehicleNearPoint(helicopters[partNum].SpawnPoint.x, helicopters[partNum].SpawnPoint.y, helicopters[partNum].SpawnPoint.z,  3.0) then
  
		ESX.Game.SpawnVehicle('polmav', {
		  x = helicopters[partNum].SpawnPoint.x,
		  y = helicopters[partNum].SpawnPoint.y,
		  z = helicopters[partNum].SpawnPoint.z
		}, helicopters[partNum].Heading, function(vehicle)
		  SetVehicleModKit(vehicle, 0)
		  SetVehicleLivery(vehicle, 0)
		  DoScreenFadeIn(1000)
		   local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
		   vehicleProps.plate = 'SECURITAS'
		   ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
		   --TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
		   SetVehicleMaxMods(vehicle)
		   TriggerEvent("advancedFuel:setEssence", 100, GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
		   local playerPed = GetPlayerPed(-1)
		   --TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
		end)
  
  
  
	  end
  
	end
  
	if part == 'VehicleDeleter' then
  
	  local playerPed = GetPlayerPed(-1)
	  local coords    = GetEntityCoords(playerPed)
  
	  if IsPedInAnyVehicle(playerPed,  false) then
  
		local vehicle = GetVehiclePedIsIn(playerPed, false)
  
		if DoesEntityExist(vehicle) then
		  CurrentAction     = 'delete_vehicle'
		  CurrentActionMsg  = _U('store_vehicle')
		  CurrentActionData = {vehicle = vehicle}
		end
  
	  end
  
	end
  
	if part == 'BossActions' then
	  CurrentAction     = 'menu_boss_actions'
	  CurrentActionMsg  = _U('open_bossmenu')
	  CurrentActionData = {}
	end
  
  end)
  
  AddEventHandler('esx_Securitas:hasExitedMarker', function(station, part, partNum)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
  end)
  
  AddEventHandler('esx_Securitas:hasEnteredEntityZone', function(entity)
  
	local playerPed = GetPlayerPed(-1)
  
	if PlayerData.job ~= nil and PlayerData.job.name == 'Securitas' and not IsPedInAnyVehicle(playerPed, false) then
	  CurrentAction     = 'remove_entity'
	  CurrentActionMsg  = _U('remove_object')
	  CurrentActionData = {entity = entity}
	end
  
	if GetEntityModel(entity) == GetHashKey('p_ld_stinger_s') then
  
	  local playerPed = GetPlayerPed(-1)
	  local coords    = GetEntityCoords(playerPed)
  
	  if IsPedInAnyVehicle(playerPed,  false) then
  
		local vehicle = GetVehiclePedIsIn(playerPed)
  
		for i=0, 7, 1 do
		  SetVehicleTyreBurst(vehicle,  i,  true,  1000)
		end
  
	  end
  
	end
  
  end)
  
  AddEventHandler('esx_Securitas:hasExitedEntityZone', function(entity)
  
	if CurrentAction == 'remove_entity' then
	  CurrentAction = nil
	end
  
  end)
  
  RegisterNetEvent('esx_Securitas:handcuff')
  AddEventHandler('esx_Securitas:handcuff', function()
  
	IsHandcuffed    = not IsHandcuffed;
	local playerPed = GetPlayerPed(-1)
  
	Citizen.CreateThread(function()
  
	  if IsHandcuffed then
  
		RequestAnimDict('mp_arresting')
  
		while not HasAnimDictLoaded('mp_arresting') do
		  Wait(100)
		end
  
		TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
		SetEnableHandcuffs(playerPed, true)
		SetPedCanPlayGestureAnims(playerPed, false)
		FreezeEntityPosition(playerPed,  true)
  
	  else
  
		ClearPedSecondaryTask(playerPed)
		SetEnableHandcuffs(playerPed, false)
		SetPedCanPlayGestureAnims(playerPed,  true)
		FreezeEntityPosition(playerPed, false)
  
	  end
  
	end)
  end)
  
  RegisterNetEvent('esx_Securitas:putInVehicle')
  AddEventHandler('esx_Securitas:putInVehicle', function()
  
	local playerPed = GetPlayerPed(-1)
	local coords    = GetEntityCoords(playerPed)
  
	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
  
	  local vehicle = GetClosestVehicle(coords.x,  coords.y,  coords.z,  5.0,  0,  71)
  
	  if DoesEntityExist(vehicle) then
  
		local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
		local freeSeat = nil
  
		for i=maxSeats - 1, 0, -1 do
		  if IsVehicleSeatFree(vehicle,  i) then
			freeSeat = i
			break
		  end
		end
  
		if freeSeat ~= nil then
		  TaskWarpPedIntoVehicle(playerPed,  vehicle,  freeSeat)
		end
  
	  end
  
	end
  
  end)
  
  RegisterNetEvent('esx_Securitas:OutVehicle')
  AddEventHandler('esx_Securitas:OutVehicle', function(t)
	local ped = GetPlayerPed(t)
	ClearPedTasksImmediately(ped)
	plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
	local xnew = plyPos.x+2
	local ynew = plyPos.y+2
  
	SetEntityCoords(GetPlayerPed(-1), xnew, ynew, plyPos.z)
  end)
  
  -- Handcuff
  Citizen.CreateThread(function()
	while true do
	  Wait(0)
	  if IsHandcuffed then
		DisableControlAction(0, 142, true) -- MeleeAttackAlternate
		DisableControlAction(0, 30,  true) -- MoveLeftRight
		DisableControlAction(0, 31,  true) -- MoveUpDown
	  end
	end
  end)
  
  -- Create blips
  Citizen.CreateThread(function()
  
	for k,v in pairs(Config.PoliceStations) do
  
	  local blip = AddBlipForCoord(v.Blip.Pos.x, v.Blip.Pos.y, v.Blip.Pos.z)
  
	  SetBlipSprite (blip, v.Blip.Sprite)
	  SetBlipDisplay(blip, v.Blip.Display)
	  SetBlipScale  (blip, v.Blip.Scale)
	  SetBlipColour (blip, v.Blip.Colour)
	  SetBlipAsShortRange(blip, true)
  
	  BeginTextCommandSetBlipName("STRING")
	  AddTextComponentString(_U('map_blip'))
	  EndTextCommandSetBlipName(blip)
  
	end
  
  end)
  
  -- Display markers
  Citizen.CreateThread(function()
	while true do
  
	  Wait(0)
  
	  if PlayerData.job ~= nil and PlayerData.job.name == 'Securitas' then
  
		local playerPed = GetPlayerPed(-1)
		local coords    = GetEntityCoords(playerPed)
  
		for k,v in pairs(Config.PoliceStations) do
  
		  for i=1, #v.Cloakrooms, 1 do
			if GetDistanceBetweenCoords(coords,  v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z,  true) < Config.DrawDistance then
			  DrawMarker(Config.MarkerType, v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
			end
		  end
  
		  for i=1, #v.Armories, 1 do
			if GetDistanceBetweenCoords(coords,  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < Config.DrawDistance then
			  DrawMarker(Config.MarkerType, v.Armories[i].x, v.Armories[i].y, v.Armories[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
			end
		  end
  
		  for i=1, #v.Vehicles, 1 do
			if GetDistanceBetweenCoords(coords,  v.Vehicles[i].Spawner.x,  v.Vehicles[i].Spawner.y,  v.Vehicles[i].Spawner.z,  true) < Config.DrawDistance then
			  DrawMarker(Config.MarkerType, v.Vehicles[i].Spawner.x, v.Vehicles[i].Spawner.y, v.Vehicles[i].Spawner.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
			end
		  end
  
		  for i=1, #v.VehicleDeleters, 1 do
			if GetDistanceBetweenCoords(coords,  v.VehicleDeleters[i].x,  v.VehicleDeleters[i].y,  v.VehicleDeleters[i].z,  true) < Config.DrawDistance then
			  DrawMarker(Config.MarkerType, v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
			end
		  end
  
		  if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'Securitas' and PlayerData.job.grade_name == 'boss' then
  
			for i=1, #v.BossActions, 1 do
			  if not v.BossActions[i].disabled and GetDistanceBetweenCoords(coords,  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < Config.DrawDistance then
				DrawMarker(Config.MarkerType, v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
			  end
			end
  
		  end
  
		end
  
	  end
  
	end
  end)
  
  -- Enter / Exit marker events
  Citizen.CreateThread(function()
  
	while true do
  
	  Wait(0)
  
	  if PlayerData.job ~= nil and PlayerData.job.name == 'Securitas' then
  
		local playerPed      = GetPlayerPed(-1)
		local coords         = GetEntityCoords(playerPed)
		local isInMarker     = false
		local currentStation = nil
		local currentPart    = nil
		local currentPartNum = nil
  
		for k,v in pairs(Config.PoliceStations) do
  
		  for i=1, #v.Cloakrooms, 1 do
			if GetDistanceBetweenCoords(coords,  v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z,  true) < Config.MarkerSize.x then
			  isInMarker     = true
			  currentStation = k
			  currentPart    = 'Cloakroom'
			  currentPartNum = i
			end
		  end
  
		  for i=1, #v.Armories, 1 do
			if GetDistanceBetweenCoords(coords,  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < Config.MarkerSize.x then
			  isInMarker     = true
			  currentStation = k
			  currentPart    = 'Armory'
			  currentPartNum = i
			end
		  end
  
		  for i=1, #v.Vehicles, 1 do
  
			if GetDistanceBetweenCoords(coords,  v.Vehicles[i].Spawner.x,  v.Vehicles[i].Spawner.y,  v.Vehicles[i].Spawner.z,  true) < Config.MarkerSize.x then
			  isInMarker     = true
			  currentStation = k
			  currentPart    = 'VehicleSpawner'
			  currentPartNum = i
			end
  
			if GetDistanceBetweenCoords(coords,  v.Vehicles[i].SpawnPoint.x,  v.Vehicles[i].SpawnPoint.y,  v.Vehicles[i].SpawnPoint.z,  true) < Config.MarkerSize.x then
			  isInMarker     = true
			  currentStation = k
			  currentPart    = 'VehicleSpawnPoint'
			  currentPartNum = i
			end
  
		  end
  
		  for i=1, #v.Helicopters, 1 do
  
			if GetDistanceBetweenCoords(coords,  v.Helicopters[i].Spawner.x,  v.Helicopters[i].Spawner.y,  v.Helicopters[i].Spawner.z,  true) < Config.MarkerSize.x then
			  isInMarker     = true
			  currentStation = k
			  currentPart    = 'HelicopterSpawner'
			  currentPartNum = i
			end
  
			if GetDistanceBetweenCoords(coords,  v.Helicopters[i].SpawnPoint.x,  v.Helicopters[i].SpawnPoint.y,  v.Helicopters[i].SpawnPoint.z,  true) < Config.MarkerSize.x then
			  isInMarker     = true
			  currentStation = k
			  currentPart    = 'HelicopterSpawnPoint'
			  currentPartNum = i
			end
  
		  end
  
		  for i=1, #v.VehicleDeleters, 1 do
			if GetDistanceBetweenCoords(coords,  v.VehicleDeleters[i].x,  v.VehicleDeleters[i].y,  v.VehicleDeleters[i].z,  true) < Config.MarkerSize.x then
			  isInMarker     = true
			  currentStation = k
			  currentPart    = 'VehicleDeleter'
			  currentPartNum = i
			end
		  end
  
		  if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'Securitas' and PlayerData.job.grade_name == 'boss' then
  
			for i=1, #v.BossActions, 1 do
			  if GetDistanceBetweenCoords(coords,  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < Config.MarkerSize.x then
				isInMarker     = true
				currentStation = k
				currentPart    = 'BossActions'
				currentPartNum = i
			  end
			end
  
		  end
  
		end
  
		local hasExited = false
  
		if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum) ) then
  
		  if
			(LastStation ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
			(LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
		  then
			TriggerEvent('esx_Securitas:hasExitedMarker', LastStation, LastPart, LastPartNum)
			hasExited = true
		  end
  
		  HasAlreadyEnteredMarker = true
		  LastStation             = currentStation
		  LastPart                = currentPart
		  LastPartNum             = currentPartNum
  
		  TriggerEvent('esx_Securitas:hasEnteredMarker', currentStation, currentPart, currentPartNum)
		end
  
		if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
  
		  HasAlreadyEnteredMarker = false
  
		  TriggerEvent('esx_Securitas:hasExitedMarker', LastStation, LastPart, LastPartNum)
		end
  
	  end
  
	end
  end)
  
  -- Enter / Exit entity zone events
  --[[Citizen.CreateThread(function()
  
	local trackedEntities = {
	  'prop_roadcone02a',
	  'ba_prop_battle_barrier_01b',
	  'ba_prop_battle_barrier_02a',
	  'prop_boxpile_07d',
	  'hei_prop_cash_crate_half_full'
	}
  
	while true do
  
	  Citizen.Wait(0)
  
	  local playerPed = GetPlayerPed(-1)
	  local coords    = GetEntityCoords(playerPed)
  
	  local closestDistance = -1
	  local closestEntity   = nil
  
	  for i=1, #trackedEntities, 1 do
  
		local object = GetClosestObjectOfType(coords.x,  coords.y,  coords.z,  3.0,  GetHashKey(trackedEntities[i]), false, false, false)
  
		if DoesEntityExist(object) then
  
		  local objCoords = GetEntityCoords(object)
		  local distance  = GetDistanceBetweenCoords(coords.x,  coords.y,  coords.z,  objCoords.x,  objCoords.y,  objCoords.z,  true)
  
		  if closestDistance == -1 or closestDistance > distance then
			closestDistance = distance
			closestEntity   = object
		  end
  
		end
  
	  end
  
	  if closestDistance ~= -1 and closestDistance <= 3.0 then
  
		if LastEntity ~= closestEntity then
		  TriggerEvent('esx_Securitas:hasEnteredEntityZone', closestEntity)
		  LastEntity = closestEntity
		end
  
	  else
  
		if LastEntity ~= nil then
		  TriggerEvent('esx_Securitas:hasExitedEntityZone', LastEntity)
		  LastEntity = nil
		end
  
	  end
  
	end
  end)]]
  
  -- Key Controls
  Citizen.CreateThread(function()
	while true do
  
	  Citizen.Wait(0)
  
	  if CurrentAction ~= nil then
  
		SetTextComponentFormat('STRING')
		AddTextComponentString(CurrentActionMsg)
		DisplayHelpTextFromStringLabel(0, 0, 1, -1)
  
		if IsControlPressed(0,  Keys['E']) and PlayerData.job ~= nil and PlayerData.job.name == 'Securitas' and (GetGameTimer() - GUI.Time) > 150 then
  
		  if CurrentAction == 'menu_cloakroom' then
			OpenCloakroomMenu()
		  end
  
		  if CurrentAction == 'menu_armory' then
			OpenArmoryMenu(CurrentActionData.station)
		  end
  
		  if CurrentAction == 'menu_vehicle_spawner' then
			OpenVehicleSpawnerMenu(CurrentActionData.station, CurrentActionData.partNum)
		  end
  
		  if CurrentAction == 'delete_vehicle' then
  
			if Config.EnableSocietyOwnedVehicles then
  
			  local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
			  TriggerServerEvent('esx_society:putVehicleInGarage', 'Securitas', vehicleProps)
  
			else
  
			  if
				GetEntityModel(vehicle) == GetHashKey('police')  or
				GetEntityModel(vehicle) == GetHashKey('police2') or
				GetEntityModel(vehicle) == GetHashKey('police3') or
				GetEntityModel(vehicle) == GetHashKey('police4') or
				GetEntityModel(vehicle) == GetHashKey('policeb') or
				GetEntityModel(vehicle) == GetHashKey('policet')
			  then
				TriggerServerEvent('esx_service:disableService', 'Securitas')
			  end
  
			end
  
			ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
		  end
  
		  if CurrentAction == 'menu_boss_actions' then
  
			ESX.UI.Menu.CloseAll()
  
			TriggerEvent('esx_society:openBossMenu', 'Securitas', function(data, menu)
  
			  menu.close()
  
			  CurrentAction     = 'menu_boss_actions'
			  CurrentActionMsg  = _U('open_bossmenu')
			  CurrentActionData = {}
  
			end)
  
		  end
  
		  if CurrentAction == 'remove_entity' then
			DeleteEntity(CurrentActionData.entity)
		  end
  
		  CurrentAction = nil
		  GUI.Time      = GetGameTimer()
  
		end
  
	  end
  
	   if IsControlPressed(0,  Keys['F6']) and PlayerData.job ~= nil and PlayerData.job.name == 'Securitas' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'Securitas_actions') and (GetGameTimer() - GUI.Time) > 150 then
		OpenSecuritasActionsMenu()
		GUI.Time = GetGameTimer()
	  end
  
	end
  end)
  
  -- NO NPC STEAL
  --[[Citizen.CreateThread(function()
		  while true do
			  Wait(0)
  
			  local player = GetPlayerPed(-1)
  
			  if DoesEntityExist(GetVehiclePedIsTryingToEnter(PlayerPedId(player))) then
  
				  local veh = GetVehiclePedIsTryingToEnter(PlayerPedId(player))
				  local lock = GetVehicleDoorLockStatus(veh)
  
				  if lock == 7 then
					  SetVehicleDoorsLocked(veh, 2)
				  end
  
				  local pedd = GetPedInVehicleSeat(veh, -1)
  
				  if pedd then
					  SetPedCanBeDraggedOut(pedd, false)
				  end
			  end
	  end
  end)]]
  
  --[[Citizen.CreateThread(function()
  
	while true do
	  Citizen.Wait(0)
  
	  if(IsPedInAnyPoliceVehicle(GetPlayerPed(-1))) then
		if(not hasBeenInPoliceVehicle) then
		  hasBeenInPoliceVehicle = true
		end
	  else
		if(hasBeenInPoliceVehicle) then
		  for i,k in pairs(vehWeapons) do
			if(not alreadyHaveWeapon[i]) then
			  TriggerServerEvent("PoliceVehicleWeaponDeleter:askDropWeapon",k)
			end
		  end
		  hasBeenInPoliceVehicle = false
		end
	  end
  
	end
  
  end)]]
  
  
  Citizen.CreateThread(function()
  
	while true do
	  Citizen.Wait(0)
	  if(not IsPedInAnyVehicle(GetPlayerPed(-1))) then
		for i=1,#vehWeapons do
		  if(HasPedGotWeapon(GetPlayerPed(-1), vehWeapons[i], false)==1) then
			alreadyHaveWeapon[i] = true
		  else
			alreadyHaveWeapon[i] = false
		  end
		end
	  end
	  Citizen.Wait(5000)
	end
  
  end)
  
  
  RegisterNetEvent("PoliceVehicleWeaponDeleter:drop")
  AddEventHandler("PoliceVehicleWeaponDeleter:drop", function(wea)
	RemoveWeaponFromPed(GetPlayerPed(-1), wea)
  end)

  function openJailMenu(playerid)
	local elements = {
	  {label = "Skicka till fängelset",     value = 'Jail'},
	  {label = "Släpp ut person",     value = 'FreePlayer'},
	}
	ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'jail_menu',
	  {
		title    = 'Sätt i fängelset',
		align    = 'right',
		elements = elements,
	  },
	  function(data3, menu)
		  if data3.current.value ~= "FreePlayer" then
			  maxLength = 4
			  AddTextEntry('FMMC_KEY_TIP8', "Antal timmar i fängelse")
			  DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", maxLength)
        --ESX.ShowNotification("~p~Ange antalet timmar du vill sätta personen i fängelse.")
        exports['mythic_notify']:SendAlert('inform', "Ange antalet timmar du vill sätta personen i fängelse.")
			  blockinput = true
  
			  while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
				  Citizen.Wait( 0 )
			  end
  
			  local jailtime = GetOnscreenKeyboardResult()
  
			  UnblockMenuInput()
  
			  if string.len(jailtime) >= 1 and tonumber(jailtime) ~= nil then
				  TriggerServerEvent('esx_mirrox_jailer:PutInJail', playerid, data3.current.value, tonumber(jailtime)*60*60)
			  else
				  return false
			  end
		  else
			  TriggerServerEvent('esx_mirrox_jailer:UnJailplayer', playerid)
		  end
	  end,
	  function(data3, menu)
		menu.close()
	  end
	)
  end
  
  function UnblockMenuInput()
	  Citizen.CreateThread( function()
		  Citizen.Wait( 150 )
		  blockinput = false 
	  end )
  end