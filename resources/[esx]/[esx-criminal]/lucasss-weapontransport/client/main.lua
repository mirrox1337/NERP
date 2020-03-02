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

local CurrentBlip = nil
local CurrentTransport = nil

ESX = nil
PlayerData = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj)
			ESX = obj

			if ESX.IsPlayerLoaded() == true then
				PlayerData = ESX.GetPlayerData()
			end

			Marker.AddMarker('cargo_start', Config.StartPosition, 'Tryck ~INPUT_CONTEXT~ ~w~för att starta ~b~Transporten ~y~($' .. Config.Price .. ')', nil, 0, function()
				ESX.TriggerServerCallback('esx_cooldowns:getCooldown', function(cooldown)
					if cooldown == 0 then
						ESX.TriggerServerCallback('revenge-weapontransport:getPolice', function(police)
							if police >= 3 then
								OpenConfirmationMenu(function(state)
									if state == true then
										ESX.TriggerServerCallback('revenge-weapontransport:buyCargo', function(success)
											if success == true then
												StartTransport()								
											else
												TriggerEvent('esx:showNotification', '~r~Du har inte tillräkligt med pengar. ($' .. v.Price .. ')')
											end
										end, Config.Price)
									end
								end)
							else
								TriggerEvent('esx:showNotification', '~r~Det måste minst vara 3 poliser i staden.')
							end
						end)
					else
						--TriggerEvent('esx:showNotification', '~r~Det har nyligen varit en transport vänta ~b~' .. cooldown .. ' ~r~Sekunder.')
						TriggerEvent('esx:showNotification', '~r~Det har nyligen varit en transport kom tillbaka senare.')
					end
				end, 'cargo')
			end)
		end)

		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2500)

		if CurrentTransport ~= nil then
			local vehicle = CurrentTransport.vehicle

			if (CurrentTransport.timestamp + Config.BlipFollowing) > GetGameTimer() then
				local coords = GetEntityCoords(vehicle)

				TriggerServerEvent('revenge-weapontransport:updateBlip', {x = coords.x, y = coords.y, z = coords.z})

				CurrentTransport.updatingBlip = true
			else
				if CurrentTransport.updatingBlip == true then
					CurrentTransport.updatingBlip = false

					NotifyPolice('Vi förlorade transporten hitta den!')

					TriggerServerEvent('revenge-weapontransport:removeBlip')
				end
			end

			if (CurrentTransport.timestamp + Config.MaximumTime) < GetGameTimer() then
				FailTransport()
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentTransport ~= nil then
			local secondsLeft = math.floor(((CurrentTransport.timestamp + Config.MaximumTime) - GetGameTimer()) / 1000)

			drawTxt(0.90, 1.40, 1.0, 1.0, 0.4, ('Sekunder kvar på Transporten: ~b~' .. secondsLeft .. ' (' .. math.floor((secondsLeft / 60)) .. 'm)'), 255, 255, 255, 255, false)    						
		end
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

function StartTransport()
	local ped = GetPlayerPed(-1)
	local deliverPosition = Config.DeliverPositions[math.random(#Config.DeliverPositions)]

	Marker.AddMarker('cargo_deliver', deliverPosition, 'Tryck ~INPUT_CONTEXT~ ~w~för att leverera~b~Transporten', nil, 0, function()
		DeliverTransport()
	end, nil, {x = 7.0, y = 7.0, z = 0.75})

	local blip = AddBlipForCoord(deliverPosition.x, deliverPosition.y, deliverPosition.z)
	
	SetBlipSprite(blip, 460)
	SetBlipColour(blip, 5)
	SetBlipRoute(blip, true)
	SetBlipRouteColour(blip, 5)
 
	local vehicles = 0

	for k,v in pairs(Config.Cargos) do
		vehicles = vehicles + 1
	end

	local randomizedIndex = math.random(vehicles)
	local index = 0
	local cargo = {}
	local randomizedVehicle = ""	

	for k,v in pairs(Config.Cargos) do
	   index = index + 1

	   if randomizedIndex == index then
               randomizedVehicle = k
	       cargo = v
	   end
	end

	ESX.Game.SpawnVehicle(randomizedVehicle, Config.SpawnPosition, Config.SpawnPosition.heading, function(vehicle)
		TaskWarpPedIntoVehicle(ped, vehicle, -1)

		CurrentTransport = {
			vehicle = vehicle,
			cargo = cargo,
			blip = blip,
			timestamp = GetGameTimer(),
			updatingBlip = true
		}
	end)

	NotifyPolice('WARNING:En Transport har blivit upptäckt och kommer lämna av olagligt gods.')

	ESX.TriggerServerCallback('esx_cooldowns:setCooldown', function()
	end, 'cargo', Config.CargoDelay)
end

function DeliverTransport()
	local ped = GetPlayerPed(-1)
	local vehicle = GetVehiclePedIsIn(ped)

	if vehicle ~= nil then
		if CurrentTransport ~= nil then
			if vehicle == CurrentTransport.vehicle then
				local rewards = {}

				for i=1, #CurrentTransport.cargo, 1 do
					if math.random(100) > 33 then
						table.insert(rewards, CurrentTransport.cargo[i])
					end
				end

				--NotifyPolice('The cargo has been delivered.')

				TriggerServerEvent('revenge-weapontransport:removeBlip')
				TriggerServerEvent('revenge-weapontransport:giveRewards', GetPlayerServerId(PlayerId()), rewards)

				Marker.RemoveMarker('cargo_deliver')
				RemoveBlip(CurrentTransport.blip)

				DeleteVehicle(vehicle)

				CurrentTransport = nil
			else
				TriggerEvent('esx:showNotification', 'Fel fordon!')
			end
		end
	end
end

function FailTransport()
	Marker.RemoveMarker('cargo_deliver')
	RemoveBlip(CurrentTransport.blip)

	CurrentTransport = nil

	NotifyPolice('Transporten är avslutad. Bra jobbat!')
end

function NotifyPolice(message)
	TriggerServerEvent('esx_phone:send', 'police', message, true, false)
end

function OpenConfirmationMenu(callback)
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'confirmation_menu',
		{
			title = 'Are you sure?',
			align = 'right',
			elements = {
				{label = 'Ja', value = 'yes'},
				{label = 'Nej', value = 'no'}
			}
		},
		function(data, menu)
			menu.close()

			callback(data.current.value == 'yes')
		end,
		function(data, menu)
			menu.close()

			callback()
		end
	)
end

function drawTxt(x, y, width, height, scale, text, r, g, b, a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    
    if outline then
      SetTextOutline()
    end

    SetTextEntry("STRING")
    AddTextComponentString(text)

    DrawText(x - width / 2, y - height / 2 + 0.005)
end

RegisterNetEvent('revenge-weapontransport:updatedBlip')
AddEventHandler('revenge-weapontransport:updatedBlip', function(coords)
	if CurrentBlip ~= nil then
		RemoveBlip(CurrentBlip)
	end

	CurrentBlip = AddBlipForCoord(coords.x, coords.y, coords.z)

	SetBlipSprite(CurrentBlip , 161)
    SetBlipScale(CurrentBlip , 2.0)
    SetBlipColour(CurrentBlip, 3)
	
    PulseBlip(CurrentBlip)
end)

RegisterNetEvent('revenge-weapontransport:removeBlip')
AddEventHandler('revenge-weapontransport:removeBlip', function()
	if CurrentBlip ~= nil then
		RemoveBlip(CurrentBlip)

		CurrentBlip = nil
	end
end)