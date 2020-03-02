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

ESX = nil
PlayerData = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj)
			ESX = obj

			if ESX.IsPlayerLoaded() == true then
				PlayerData = ESX.GetPlayerData()
			end

            local coords = GetEntityCoords(GetPlayerPed(-1))

			for k,v in pairs(Config.Shops) do
				--if GetDistanceBetweenCoords(coords, -2.49, -1822.06, 28.59, true) < 5.0 then
				Marker.AddMarker(k .. '_shop_marker', v.Position, 'Tryck ~INPUT_CONTEXT~ för att öppna menyn.', nil, 0, 
				
					function()
						OpenShopMenu(k, v)
					end,
					function()
						ESX.UI.Menu.CloseAll()
					end, v.HideMarker
				)
			end
			--end
		end)

		Citizen.Wait(0)
	end
end)

local HadArmor = false

AddEventHandler('skinchanger:modelLoaded', function()
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)

			local ped = GetPlayerPed(-1)
			local armor = GetPedArmour(ped)

			if armor > 1 then
				HadArmor = true
			else
				if HadArmor == true then
					HadArmor = false

					TriggerEvent('skinchanger:getSkin', function(skin)
						local clothes = {
							['bproof_1'] = 0,
							['bproof_2'] = 0
						}

						TriggerEvent('skinchanger:loadClothes', skin, clothes)
					end)
				end
			end
		end
	end)	
end)


function OpenShopMenu(title, values)
	RequestAnimDict("anim@heists@humane_labs@finale@keycards")

    while not HasAnimDictLoaded( "anim@heists@humane_labs@finale@keycards") do
        Citizen.Wait(0)
    end

    TaskPlayAnim(GetPlayerPed(-1), "anim@heists@humane_labs@finale@keycards" ,"ped_b_enter" ,8.0, -8.0, -1, 0, 0, false, false, false )
    Citizen.Wait(1000)
	local elements = {}

	for i=1, #values.Content, 1 do
		local item = values.Content[i]

		table.insert(elements, 
			{
				label = item.Label .. ' - $' .. item.Price,
				value = item.Item,
				amount = item.Amount,
				cost = item.Price
			}
		)
	end

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), title .. '_shop_menu', 
		{
			title = title,
			align = 'center',
			elements = elements
		},
		function(data, menu)
			if data.current.value == 'bulletproof_vest' then
				ESX.TriggerServerCallback('wille-specialshop:buyBulletproofVest', function(success)
					if success == false then
						exports['mythic_notify']:DoHudText('inform', 'Du har inte tillräkligt med pengar!', { ['background-color'] = '#b00000', ['color'] = '#fff' })
					else
						SetPedArmour(GetPlayerPed(-1), 100)

						TriggerEvent('skinchanger:getSkin', function(skin)
							local clothes = {
								['bproof_1'] = 16,
								['bproof_2'] = 2
							}

							TriggerEvent('skinchanger:loadClothes', skin, clothes)
						end)
					end
				end, data.current.cost)
			elseif data.current.value == 'weapon_switchblade' then
				ESX.TriggerServerCallback('kulan-specialshop:switchblade', function(success)
					if success == false then
						exports['mythic_notify']:DoHudText('inform', 'Du har inte tillräckligt med Svarta pengar på dig', { ['background-color'] = '#b00000', ['color'] = '#fff' })
					else
						exports['mythic_notify']:DoHudText('inform', 'Du köpte en Switchblade', { ['background-color'] = '#009c10', ['color'] = '#fff' })

					end
				
				end)

		    else
				ESX.TriggerServerCallback('wille-specialshop:buyItem', function(success)
					if success == false then
						exports['mythic_notify']:DoHudText('inform', 'Du har inte tillräkligt med pengar!', { ['background-color'] = '#b00000', ['color'] = '#fff' })
					end
				end, data.current.value, data.current.amount, data.current.cost)
			end
		end,
		function(data, menu)
			menu.close()
		end
	)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

local blips = {
	--{title="Mohammed's Livs", colour=25, id=140, x = -1172.07, y = -1571.93, z = 4.66},
	--{title="Aladdin's Fiskebutik", colour=1, id=68, x = 814.59, y = -93.13, z = 80.6}
}


Citizen.CreateThread(function()

	for _, info in pairs(blips) do
		info.blip = AddBlipForCoord(info.x, info.y, info.z)
		SetBlipSprite(info.blip, info.id)
		SetBlipDisplay(info.blip, 4)
		SetBlipScale(info.blip, 1.0)
		SetBlipColour(info.blip, info.colour)
		SetBlipAsShortRange(info.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(info.title)
		EndTextCommandSetBlipName(info.blip)
	end
end)