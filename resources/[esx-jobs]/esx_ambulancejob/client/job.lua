local CurrentAction, CurrentActionMsg, CurrentActionData = nil, '', {}
local HasAlreadyEnteredMarker, LastHospital, LastPart, LastPartNum
local isBusy, deadPlayers, deadPlayerBlips, isOnDuty = false, {}, {}, false
isInShopMenu = false

function OpenAmbulanceActionsMenu()
	local elements = {{label = _U('cloakroom'), value = 'cloakroom'}}

	if Config.EnablePlayerManagement and ESX.PlayerData.job.grade_name == 'boss' then
		table.insert(elements, {label = _U('boss_actions'), value = 'boss_actions'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ambulance_actions', {
		title    = _U('ambulance'),
		align    = 'right',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'cloakroom' then
			OpenCloakroomMenu()
		elseif data.current.value == 'boss_actions' then
			TriggerEvent('esx_society:openBossMenu', 'ambulance', function(data, menu)
				menu.close()
			end, {wash = false})
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenMobileAmbulanceActionsMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_ambulance_actions', {
		title    = _U('ambulance'),
		align    = 'right',
		elements = {
			{label = _U('ems_menu'), value = 'citizen_interaction'},
			{label = 'Överfallslarm', value = 'larm'}
	}}, function(data, menu)

	--[[if data.current.value == 'larm' then
        local x, y, z  = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
        local PlayerCoords = GetEntityCoords(GetPlayerPed(-1),  true)
        TriggerServerEvent('esx_addons_gcphone:startCall', 'police', _U('distress_message'), PlayerCoords)
		  end]]
		  
		  if data.current.value == 'larm' then
			local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
            local plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
				TriggerServerEvent('esx_addons_gcphone:startCall', 'ambulance', 'En sjukvårdvare har aktiverat sitt överfallslarm! ', {x = plyPos.x, y = plyPos.y, z = plyPos.z}, dispatch)
				exports['mythic_notify']:SendAlert('inform', ('Överfallslarm aktiverat'))
				--TriggerServerEvent('esx_phone:send', 'police', 'En polis har aktiverat sitt överfallslarm! ', true, {x = plyPos.x, y = plyPos.y, z = plyPos.z})
		 	end

		if data.current.value == 'citizen_interaction' then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				title    = _U('ems_menu_title'),
				align    = 'right',
				elements = {
					{label = _U('ems_menu_revive'),     value = 'revive'},
              		{label = _U('ems_menu_small'),      value = 'small'},
					{label = _U('ems_menu_big'),        value = 'big'},
					{label = ('Eskortera Person'),                value = 'drag'},
              		{label = _U('ems_menu_putincar'),   value = 'put_in_vehicle'},
			        {label = ('Räkning'),                value = 'fine'},
			}}, function(data, menu)

				if isBusy then return end

				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

				if closestPlayer == -1 or closestDistance > 1.0 then
					--ESX.ShowNotification(_U('no_players'))
					exports['mythic_notify']:SendAlert('error', (_U('no_players')))
				else
					if data.current.value == 'revive' then
						revivePlayer(closestPlayer)
					elseif data.current.value == 'small' then
						ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
							if quantity > 0 then
								local closestPlayerPed = GetPlayerPed(closestPlayer)
								local health = GetEntityHealth(closestPlayerPed)

								if health > 0 then
									local playerPed = PlayerPedId()

									isBusy = true
									--ESX.ShowNotification(_U('heal_inprogress'))
									exports['mythic_notify']:SendAlert('inform', (_U('heal_inprogress')))
									TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
									Citizen.Wait(10000)
									ClearPedTasks(playerPed)

									TriggerServerEvent('esx_ambulancejob:removeItem', 'bandage')
									TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'small')
									--ESX.ShowNotification(_U('heal_complete', GetPlayerName(closestPlayer)))
									exports['mythic_notify']:SendAlert('success', (_U('heal_complete')))
									isBusy = false
								else
									--ESX.ShowNotification(_U('player_not_conscious'))
									exports['mythic_notify']:SendAlert('error', (_U('player_not_conscious')))
								end
							else
								--ESX.ShowNotification(_U('not_enough_bandage'))
								exports['mythic_notify']:SendAlert('error', (_U('not_enough_bandage')))
							end
						end, 'bandage')

					elseif data.current.value == 'big' then

						ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
							if quantity > 0 then
								local closestPlayerPed = GetPlayerPed(closestPlayer)
								local health = GetEntityHealth(closestPlayerPed)

								if health > 0 then
									local playerPed = PlayerPedId()

									isBusy = true
									--ESX.ShowNotification(_U('heal_inprogress'))
									exports['mythic_notify']:SendAlert('inform', (_U('heal_inprogress')))
									TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
									Citizen.Wait(10000)
									ClearPedTasks(playerPed)

									TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
									TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'big')
									--ESX.ShowNotification(_U('heal_complete', GetPlayerName(closestPlayer)))
									exports['mythic_notify']:SendAlert('success', (_U('heal_complete')))
									isBusy = false
								else
									--ESX.ShowNotification(_U('player_not_conscious'))
									exports['mythic_notify']:SendAlert('error', (_U('player_not_conscious')))
								end
							else
								--ESX.ShowNotification(_U('not_enough_medikit'))
								exports['mythic_notify']:SendAlert('error', (_U('not_enough_medikit')))
							end
						end, 'medikit')

					elseif data.current.value == 'drag' then
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            			if distance ~= -1 and distance <= 3.0 then
						TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(closestPlayer))
					end

					elseif data.current.value == 'put_in_vehicle' then
						TriggerServerEvent('esx_ambulancejob:putInVehicle', GetPlayerServerId(closestPlayer))
					end
				end
			end, function(data, menu)
				menu.close()
			end)
		end

	end, function(data, menu)
		menu.close()
	end)
end

function revivePlayer(closestPlayer)
	isBusy = true

	ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
		if quantity > 0 then
			local closestPlayerPed = GetPlayerPed(closestPlayer)

			if IsPedDeadOrDying(closestPlayerPed, 1) then
				local playerPed = PlayerPedId()
				local lib, anim = 'mini@cpr@char_a@cpr_str', 'cpr_pumpchest'
				--ESX.ShowNotification(_U('revive_inprogress'))
				exports['mythic_notify']:SendAlert('inform', (_U('revive_inprogress')))

				for i=1, 15 do
					Citizen.Wait(900)

					ESX.Streaming.RequestAnimDict(lib, function()
						TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)
					end)
				end

				TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
				TriggerServerEvent('esx_ambulancejob:revive', GetPlayerServerId(closestPlayer))
			else
				--ESX.ShowNotification(_U('player_not_unconscious'))
				exports['mythic_notify']:SendAlert('inform', (_U('player_not_unconscious')))
			end
		else
			--ESX.ShowNotification(_U('not_enough_medikit'))
			exports['mythic_notify']:SendAlert('inform', (_U('not_enough_medikit')))
		end
		isBusy = false
	end, 'medikit')
end

function FastTravel(coords, heading)
	local playerPed = PlayerPedId()

	DoScreenFadeOut(800)

	while not IsScreenFadedOut() do
		Citizen.Wait(500)
	end

	ESX.Game.Teleport(playerPed, coords, function()
		DoScreenFadeIn(800)

		if heading then
			SetEntityHeading(playerPed, heading)
		end
	end)
end

-- Draw markers & Marker logic
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
			local playerCoords = GetEntityCoords(PlayerPedId())
			local letSleep, isInMarker, hasExited = true, false, false
			local currentHospital, currentPart, currentPartNum

			for hospitalNum,hospital in pairs(Config.Hospitals) do
				-- Ambulance Actions
				for k,v in ipairs(hospital.AmbulanceActions) do
					local distance = #(playerCoords - v)

					if distance < Config.DrawDistance then
						DrawMarker(Config.Marker.type, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.x, Config.Marker.y, Config.Marker.z, Config.Marker.r, Config.Marker.g, Config.Marker.b, Config.Marker.a, Config.Marker.bob, Config.Marker.face, 2, Config.Marker.rotate, nil, nil, false)
						letSleep = false

						if distance < Config.Marker.x then
							isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'AmbulanceActions', k
						end
					end
				end

				-- Pharmacies
				for k,v in ipairs(hospital.Pharmacies) do
					local distance = #(playerCoords - v)

					if distance < Config.DrawDistance then
						DrawMarker(Config.Marker.type, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.x, Config.Marker.y, Config.Marker.z, Config.Marker.r, Config.Marker.g, Config.Marker.b, Config.Marker.a, Config.Marker.bob, Config.Marker.face, 2, Config.Marker.rotate, nil, nil, false)
						letSleep = false

						if distance < Config.Marker.x then
							isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'Pharmacy', k
						end
					end
				end

				-- Vehicle Spawners
				for k,v in ipairs(hospital.Vehicles) do
					local distance = #(playerCoords - v.Spawner)

					if distance < Config.DrawDistance then
						DrawMarker(v.Marker.type, v.Spawner, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, v.Marker.bob, v.Marker.face, 2, v.Marker.rotate, nil, nil, false)
						letSleep = false

						if distance < v.Marker.x then
							isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'Vehicles', k
						end
					end
				end

				-- Helicopter Spawners
				for k,v in ipairs(hospital.Helicopters) do
					local distance = #(playerCoords - v.Spawner)

					if distance < Config.DrawDistance then
						DrawMarker(v.Marker.type, v.Spawner, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, v.Marker.bob, v.Marker.face, 2, v.Marker.rotate, nil, nil, false)
						letSleep = false

						if distance < v.Marker.x then
							isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'Helicopters', k
						end
					end
				end

				-- Fast Travels (Prompt)
				for k,v in ipairs(hospital.FastTravelsPrompt) do
					local distance = #(playerCoords - v.From)

					if distance < Config.DrawDistance then
						DrawMarker(v.Marker.type, v.From, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, v.Marker.bob, v.Marker.face, 2, v.Marker.rotate, nil, nil, false)
						letSleep = false

						if distance < v.Marker.x then
							isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'FastTravelsPrompt', k
						end
					end
				end
			end

			-- Logic for exiting & entering markers
			if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastHospital ~= currentHospital or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then
				if
					(LastHospital ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
					(LastHospital ~= currentHospital or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
				then
					TriggerEvent('esx_ambulancejob:hasExitedMarker', LastHospital, LastPart, LastPartNum)
					hasExited = true
				end

				HasAlreadyEnteredMarker, LastHospital, LastPart, LastPartNum = true, currentHospital, currentPart, currentPartNum

				TriggerEvent('esx_ambulancejob:hasEnteredMarker', currentHospital, currentPart, currentPartNum)
			end

			if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_ambulancejob:hasExitedMarker', LastHospital, LastPart, LastPartNum)
			end

			if letSleep then
				Citizen.Wait(500)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

-- Fast travels
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerCoords, letSleep = GetEntityCoords(PlayerPedId()), true

		for hospitalNum,hospital in pairs(Config.Hospitals) do
			-- Fast Travels
			for k,v in ipairs(hospital.FastTravels) do
				local distance = #(playerCoords - v.From)

				if distance < Config.DrawDistance then
					DrawMarker(v.Marker.type, v.From, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, v.Marker.bob, v.Marker.face, 2, v.Marker.rotate, nil, nil, false)
					letSleep = false

					if distance < v.Marker.x then
						FastTravel(v.To.coords, v.To.heading)
					end
				end
			end
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

AddEventHandler('esx_ambulancejob:hasEnteredMarker', function(hospital, part, partNum)
	if part == 'AmbulanceActions' then
		CurrentAction = part
		CurrentActionMsg = _U('actions_prompt')
		CurrentActionData = {}
	elseif part == 'Pharmacy' then
		CurrentAction = part
		CurrentActionMsg = _U('open_pharmacy')
		CurrentActionData = {}
	elseif part == 'Vehicles' then
		CurrentAction = part
		CurrentActionMsg = _U('garage_prompt')
		CurrentActionData = {hospital = hospital, partNum = partNum}
	elseif part == 'Helicopters' then
		CurrentAction = part
		CurrentActionMsg = _U('helicopter_prompt')
		CurrentActionData = {hospital = hospital, partNum = partNum}
	elseif part == 'FastTravelsPrompt' then
		local travelItem = Config.Hospitals[hospital][part][partNum]

		CurrentAction = part
		CurrentActionMsg = travelItem.Prompt
		CurrentActionData = {to = travelItem.To.coords, heading = travelItem.To.heading}
	end
end)

AddEventHandler('esx_ambulancejob:hasExitedMarker', function(hospital, part, partNum)
	if not isInShopMenu then
		ESX.UI.Menu.CloseAll()
	end

	CurrentAction = nil
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) then
				if CurrentAction == 'AmbulanceActions' then
					OpenAmbulanceActionsMenu()
				elseif CurrentAction == 'Pharmacy' then
					OpenPharmacyMenu()
				elseif CurrentAction == 'Vehicles' then
					OpenVehicleSpawnerMenu('car', CurrentActionData.hospital, CurrentAction, CurrentActionData.partNum)
				elseif CurrentAction == 'Helicopters' then
					OpenVehicleSpawnerMenu('helicopter', CurrentActionData.hospital, CurrentAction, CurrentActionData.partNum)
				elseif CurrentAction == 'FastTravelsPrompt' then
					FastTravel(CurrentActionData.to, CurrentActionData.heading)
				end

				CurrentAction = nil
			end
				
		elseif ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' and not isDead then
			if IsControlJustReleased(0, 167) then
				OpenMobileAmbulanceActionsMenu()
			end
		else
			Citizen.Wait(500)
		end
	  end
	end)

RegisterNetEvent('esx_ambulancejob:putInVehicle')
AddEventHandler('esx_ambulancejob:putInVehicle', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords, 5.0) then
		local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)

		if DoesEntityExist(vehicle) then
			local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

			for i=maxSeats - 1, 0, -1 do
				if IsVehicleSeatFree(vehicle, i) then
					freeSeat = i
					break
				end
			end

			if freeSeat then
				TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
			end
		end
	end
end)

function OpenCloakroomMenu()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom', {
		title    = _U('cloakroom'),
		align    = 'right',
		elements = {
			{label = 'Civilakläder', value = 'citizen_wear'},
        	{label = 'Arbetskläder (Pike)', value = 'ambulance_wear_pike'},
        	{label = 'Arbetskläder (Tröja)', value = 'ambulance_wear_trojan'},
        	{label = 'Arbetskläder (Jacka)', value = 'ambulance_wear_jacka'},
        	{label = 'Arbetskläder (Operationsskjorta)', value = 'ambulance_wear_operation'},
        	--{label = 'Skyddsoverall', value = 'virus_wear'},
        	{label = 'Chefskläder', value = 'boss_wear'}
	}}, function(data, menu)
		if data.current.value == 'citizen_wear' then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				TriggerEvent('skinchanger:loadSkin', skin)
				isOnDuty = false

				for playerId,v in pairs(deadPlayerBlips) do
					RemoveBlip(v)
					deadPlayerBlips[playerId] = nil
				end
			end)
		elseif data.current.value == 'ambulance_wear_pike' then
        TriggerEvent('skinchanger:getSkin', function(skin)
        
            if skin.sex == 0 then

                local clothesSkin = {
                  ['tshirt_1'] = 129, ['tshirt_2'] = 0,
                  ['torso_1'] = 55, ['torso_2'] = 0,
                  ['arms'] = 85,
                  ['bags_1'] = 0, ['bags_2'] = 0,
                  ['pants_1'] = 46, ['pants_2'] = 0,
                  ['shoes_1'] = 25, ['shoes_2'] = 0,
                  ['mask_1'] = 121, ['mask_2'] = 0,
                  ['chain_1'] = 126, ['chain_2'] = 0,
                  ['ears_1'] = -1, ['ears_2'] = 0
              }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

            else

              local clothesSkin = {
                ['tshirt_1'] = 159, ['tshirt_2'] = 0,
                ['torso_1'] = 49, ['torso_2'] = 0,
                ['arms'] = 109,
                ['bags_1'] = 0, ['bags_2'] = 0,
                ['pants_1'] = 13, ['pants_2'] = 0,
                ['shoes_1'] = 25, ['shoes_2'] = 0,
                ['mask_1'] = 121, ['mask_2'] = 0,
                ['chain_1'] = 96, ['chain_2'] = 0,
                ['ears_1'] = -1, ['ears_2'] = 0
            }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

			end
			
			isOnDuty = true
			TriggerEvent('esx_ambulancejob:setDeadPlayers', deadPlayers)

            local playerPed = GetPlayerPed(-1)
            SetPedArmour(playerPed, 0)
            ClearPedBloodDamage(playerPed)
            ResetPedVisibleDamage(playerPed)
            ClearPedLastWeaponDamage(playerPed)
            
        end)
	  
	elseif data.current.value == 'ambulance_wear_operation' then
        TriggerEvent('skinchanger:getSkin', function(skin)
        
            if skin.sex == 0 then

                local clothesSkin = {
                    ['tshirt_1'] = 15, ['tshirt_2'] = 0,
                    ['torso_1'] = 8, ['torso_2'] = 0,
                    ['arms'] = 85,
                    ['pants_1'] = 20, ['pants_2'] = 0,
                    ['bags_1'] = 0, ['bags_2'] = 0,
                    ['shoes_1'] = 57, ['shoes_2'] = 9,
                    ['helmet_1'] = -1, ['helmet_2'] = 0,
                    ['chain_1'] = 126, ['chain_2'] = 0,
                    ['mask_1'] = 121, ['mask_2'] = 0,
                    ['ears_1'] = 121, ['ears_2'] = 0,
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

            else

                local clothesSkin = {
                    ['tshirt_1'] = 15, ['tshirt_2'] = 0,
                    ['torso_1'] = 45, ['torso_2'] = 0,
                    ['arms'] = 85,
                    ['pants_1'] = 61, ['pants_2'] = 3,
                    ['shoes_1'] = 24, ['shoes_2'] = 0,
                    ['mask_1'] = 121, ['mask_2'] = 0,
                    ['chain_1'] = 96, ['chain_2'] = 0,
                    ['ears_1'] = -1, ['ears_2'] = 0
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

            end

            isOnDuty = true
			TriggerEvent('esx_ambulancejob:setDeadPlayers', deadPlayers)

            local playerPed = GetPlayerPed(-1)
            SetPedArmour(playerPed, 0)
            ClearPedBloodDamage(playerPed)
            ResetPedVisibleDamage(playerPed)
            ClearPedLastWeaponDamage(playerPed)
            
		end)
		
	elseif data.current.value == 'ambulance_wear_trojan' then
			TriggerEvent('skinchanger:getSkin', function(skin)
			
				if skin.sex == 0 then
	
					local clothesSkin = {
					  ['tshirt_1'] = 15, ['tshirt_2'] = 0,
						['torso_1'] = 245, ['torso_2'] = 0,
						['arms'] = 92,
						['pants_1'] = 46, ['pants_2'] = 3,
						['bags_1'] = 0, ['bags_2'] = 0,
						['shoes_1'] = 25, ['shoes_2'] = 0,
						['helmet_1'] = -1, ['helmet_2'] = 0,
						['chain_1'] = 0, ['chain_2'] = 0,
						['mask_1'] = 121, ['mask_2'] = 0,
						['ears_1'] = 121, ['ears_2'] = 0,
					}
					TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
	
				else
	
				  local clothesSkin = {
					  ['tshirt_1'] = 15, ['tshirt_2'] = 0,
					  ['torso_1'] = 288, ['torso_2'] = 0,
					  ['arms'] = 109,
					  ['pants_1'] = 13, ['pants_2'] = 0,
					  ['bags_1'] = 0, ['bags_2'] = 0,
					  ['shoes_1'] = 25, ['shoes_2'] = 0,
					  ['helmet_1'] = -1, ['helmet_2'] = 0,
					  ['chain_1'] = 96, ['chain_2'] = 0,
					  ['mask_1'] = 121, ['mask_2'] = 0,
					  ['ears_1'] = 121, ['ears_2'] = 0,
				  }
					TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
	
				end
	
				isOnDuty = true
				TriggerEvent('esx_ambulancejob:setDeadPlayers', deadPlayers)

            	local playerPed = GetPlayerPed(-1)
            	SetPedArmour(playerPed, 0)
            	ClearPedBloodDamage(playerPed)
            	ResetPedVisibleDamage(playerPed)
            	ClearPedLastWeaponDamage(playerPed)
				
			end)

		elseif data.current.value == 'ambulance_wear_jacka' then
				TriggerEvent('skinchanger:getSkin', function(skin)
				
					if skin.sex == 0 then
		
						local clothesSkin = {
							['tshirt_1'] = 15, ['tshirt_2'] = 0,
							['torso_1'] = 279, ['torso_2'] = 0,
							['arms'] = 88,
							['bags_1'] = 0, ['bags_2'] = 0,
							['pants_1'] = 46, ['pants_2'] = 0,
							['shoes_1'] = 25, ['shoes_2'] = 0,
							['helmet_1'] = -1, ['helmet_2'] = 0,
							['chain_1'] = 0, ['chain_2'] = 0,
							['mask_1'] = 121, ['mask_2'] = 0,
							['ears_1'] = 121, ['ears_2'] = 0,
						}
						TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
		
					else
		
						local clothesSkin = {
							['tshirt_1'] = 14, ['tshirt_2'] = 0,
							['torso_1'] = 295, ['torso_2'] = 0,
							['arms'] = 101,
							['bags_1'] = 0, ['bags_2'] = 0,
							['pants_1'] = 13, ['pants_2'] = 0,
							['shoes_1'] = 24, ['shoes_2'] = 0,
							['chain_1'] = 96, ['chain_2'] = 0,
							['mask_1'] = 121, ['mask_2'] = 0,
							['chain_1'] = 96, ['chain_2'] = 0,
							['ears_1'] = -1, ['ears_2'] = 0
						}
						TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
		
					end
		
					isOnDuty = true
					TriggerEvent('esx_ambulancejob:setDeadPlayers', deadPlayers)

            		local playerPed = GetPlayerPed(-1)
            		SetPedArmour(playerPed, 0)
            		ClearPedBloodDamage(playerPed)
            		ResetPedVisibleDamage(playerPed)
            		ClearPedLastWeaponDamage(playerPed)
					
				end)

			elseif data.current.value == 'boss_wear' then
					TriggerEvent('skinchanger:getSkin', function(skin)
					
						if skin.sex == 0 then
			
						  local clothesSkin = {
							['tshirt_1'] = 33, ['tshirt_2'] = 5,
							['torso_1'] = 29, ['torso_2'] = 7,
							['decals_1'] = 0, ['decals_2'] = 0,
							['arms'] = 6,
							['bags_1'] = 0, ['bags_2'] = 0,
							['pants_1'] = 25, ['pants_2'] = 0,
							['shoes_1'] = 10, ['shoes_2'] = 0,
							['helmet_1'] = -1, ['helmet_2'] = 0,
									['glasses_1'] = -1, ['glasses_2'] = 0,
							['chain_1'] = 126, ['chain_2'] = 0,
						}
							TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			
						else
			
						  local clothesSkin = {
							['tshirt_1'] = 64, ['tshirt_2'] = 0,
							['torso_1'] = 57, ['torso_2'] = 7,
							['arms'] = 105,
							['bags_1'] = 0, ['bags_2'] = 0,
							['pants_1'] = 52, ['pants_2'] = 2,
							['shoes_1'] = 29, ['shoes_2'] = 0,
							['mask_1'] = 121, ['mask_2'] = 0,
							['chain_1'] = 96, ['chain_2'] = 0,
							['ears_1'] = -1, ['ears_2'] = 0
						}
							TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			
						end
			
						isOnDuty = true
						TriggerEvent('esx_ambulancejob:setDeadPlayers', deadPlayers)

            			local playerPed = GetPlayerPed(-1)
            			SetPedArmour(playerPed, 0)
            			ClearPedBloodDamage(playerPed)
            			ResetPedVisibleDamage(playerPed)
            			ClearPedLastWeaponDamage(playerPed)
						
					end)
				  end

		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end

function OpenPharmacyMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pharmacy', {
		title    = _U('pharmacy_menu_title'),
		align    = 'right',
		elements = {
			{label = _U('pharmacy_take', _U('medikit')), item = 'medikit', type = 'slider', value = 1, min = 1, max = 25},
			{label = _U('pharmacy_take', _U('bandage')), item = 'bandage', type = 'slider', value = 1, min = 1, max = 50},
			{label = _U('pharmacy_take', ('Komradio')), item = 'radio', type = 'slider', value = 1, min = 1, max = 1}
	}}, function(data, menu)
		TriggerServerEvent('esx_ambulancejob:giveItem', data.current.item, data.current.value)
	end, function(data, menu)
		menu.close()
	end)
end

RegisterNetEvent('esx_ambulancejob:heal')
AddEventHandler('esx_ambulancejob:heal', function(healType, quiet)
	local playerPed = PlayerPedId()
	local maxHealth = GetEntityMaxHealth(playerPed)

	if healType == 'small' then
		local health = GetEntityHealth(playerPed)
		local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 8))
		SetEntityHealth(playerPed, newHealth)
	elseif healType == 'big' then
		SetEntityHealth(playerPed, maxHealth)
	end

	if not quiet then
		--ESX.ShowNotification(_U('healed'))
		exports['mythic_notify']:SendAlert('inform', (_U('healed')))
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	if isOnDuty and job ~= 'ambulance' then
		for playerId,v in pairs(deadPlayerBlips) do
			RemoveBlip(v)
			deadPlayerBlips[playerId] = nil
		end

		isOnDuty = false
	end
end)

RegisterNetEvent('esx_ambulancejob:setDeadPlayers')
AddEventHandler('esx_ambulancejob:setDeadPlayers', function(_deadPlayers)
	deadPlayers = _deadPlayers

	if isOnDuty then
		for playerId,v in pairs(deadPlayerBlips) do
			RemoveBlip(v)
			deadPlayerBlips[playerId] = nil
		end

		for playerId,status in pairs(deadPlayers) do
			if status == 'distress' then
				local player = GetPlayerFromServerId(playerId)
				local playerPed = GetPlayerPed(player)
				local blip = AddBlipForEntity(playerPed)

				SetBlipSprite(blip, 303)
				SetBlipColour(blip, 1)
				SetBlipFlashes(blip, true)
				SetBlipCategory(blip, 7)

				BeginTextCommandSetBlipName('STRING')
				AddTextComponentSubstringPlayerName(_U('blip_dead'))
				EndTextCommandSetBlipName(blip)

				deadPlayerBlips[playerId] = blip
			end
		end
	end
end)
