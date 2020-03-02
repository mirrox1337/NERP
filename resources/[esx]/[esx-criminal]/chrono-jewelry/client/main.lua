local holdingup = false
local store = ""
local blipRobbery = nil
local vetrineRotte = 0 
local ped = PlayerPedId()

local vetrine = {
	{x = 147.085, y = -1048.612, z = 29.346, heading = 70.326, isOpen = false},--
	{x = -626.735, y = -238.545, z = 38.057, heading = 214.907, isOpen = false},--
	{x = -625.697, y = -237.877, z = 38.057, heading = 217.311, isOpen = false},--
	{x = -626.825, y = -235.347, z = 38.057, heading = 33.745, isOpen = false},--
	{x = -625.77, y = -234.563, z = 38.057, heading = 33.572, isOpen = false},--
	{x = -627.957, y = -233.918, z = 38.057, heading = 215.214, isOpen = false},--
	{x = -626.971, y = -233.134, z = 38.057, heading = 215.532, isOpen = false},--
	{x = -624.433, y = -231.161, z = 38.057, heading = 305.159, isOpen = false},--
	{x = -623.045, y = -232.969, z = 38.057, heading = 303.496, isOpen = false},--
	{x = -620.265, y = -234.502, z = 38.057, heading = 217.504, isOpen = false},--
	{x = -619.225, y = -233.677, z = 38.057, heading = 213.35, isOpen = false},--
	{x = -620.025, y = -233.354, z = 38.057, heading = 34.18, isOpen = false},--
	{x = -617.487, y = -230.605, z = 38.057, heading = 309.177, isOpen = false},--
	{x = -618.304, y = -229.481, z = 38.057, heading = 304.243, isOpen = false},--
	{x = -619.741, y = -230.32, z = 38.057, heading = 124.283, isOpen = false},--
	{x = -619.686, y = -227.753, z = 38.057, heading = 305.245, isOpen = false},--
	{x = -620.481, y = -226.59, z = 38.057, heading = 304.677, isOpen = false},--
	{x = -621.098, y = -228.495, z = 38.057, heading = 127.046, isOpen = false},--
	{x = -623.855, y = -227.051, z = 38.057, heading = 38.605, isOpen = false},--
	{x = -624.977, y = -227.884, z = 38.057, heading = 48.847, isOpen = false},--
	{x = -624.056, y = -228.228, z = 38.057, heading = 216.443, isOpen = false},--
}

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local cachedBus = {}

Citizen.CreateThread(function()
    Citizen.Wait(100)

    while true do
        local sleepThread = 1000

        local entity, entityDst = ESX.Game.GetClosestObject(Config.BusAvailable)

        if DoesEntityExist(entity) and entityDst <= 4.5 then
            sleepThread = 5

            local busCoords = GetEntityCoords(entity)

            ESX.Game.Utils.DrawText3D(busCoords + vector3(0.0, 0.0, 0.5), "[~g~E~s~] Sök efter föremål", 0.4)

            if IsControlJustReleased(0, 38) then
                if not cachedBus[entity] then
                    cachedBus[entity] = true

                    SearchBus()
                else
                    exports['mythic_notify']:DoCustomHudText('success', 'Du har redan sökt igenom detta stället.', 8500, { ['background-color'] = '#4a4a4a', ['color'] = '#fff' })
                end
            end
        end

        Citizen.Wait(sleepThread)
    end
end)

function SearchBus()
    TaskStartScenarioInPlace(PlayerPedId(), "CODE_HUMAN_MEDIC_KNEEL", 0, true)
    exports['mythic_notify']:DoCustomHudText('success', 'Söker efter något användbart.', 15000, { ['background-color'] = '#007ecc', ['color'] = '#fff' })

    Citizen.Wait(15000)

    TriggerServerEvent("chrono-jewlery:retrieveItem")

    ClearPedTasks(PlayerPedId())
end

function DrawText3D(x, y, z, text, scale)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local pX, pY, pZ = table.unpack(GetGameplayCamCoords())

	SetTextScale(scale, scale)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextEntry("STRING")
	SetTextCentre(1)
	SetTextColour(255, 255, 255, 215)

	AddTextComponentString(text)
	DrawText(_x, _y)
end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

RegisterNetEvent("mt:missiontext")
AddEventHandler("mt:missiontext", function(text, time)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(text)
    DrawSubtitleTimed(time, 1)
end)

function loadAnimDict( dict )  
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 

RegisterNetEvent('chrono-jewelry:currentlyrobbing')
AddEventHandler('chrono-jewelry:currentlyrobbing', function(robb)
	local playerRob = PlayerPedId()
	loadAnimDict( "random@arrests" )
	TaskPlayAnim(playerRob, "random@arrests", "radio_chatter", 2.0, 2.5, -1, 49, 0, 0, 0, 0 )
	RemoveAnimDict("random@arrests")
	FreezeEntityPosition(GetPlayerPed(-1), true)
	exports['mythic_notify']:DoCustomHudText('success', _U('rob_wait_time'), 20000, { ['background-color'] = '#007ecc', ['color'] = '#fff' })
	Citizen.Wait(20000)
	exports['mythic_notify']:DoCustomHudText('success', _U('started_to_rob') .. _U('do_not_move'), 7500, { ['background-color'] = '#007ecc', ['color'] = '#fff' })
	PlaySound(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
	Citizen.Wait(1000)
	PlaySound(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
	Citizen.Wait(1000)
	PlaySound(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
	Citizen.Wait(1000)
	PlaySound(-1, "GO", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
	holdingup = true
	store = robb
end)

RegisterNetEvent('chrono-jewelry:killblip')
AddEventHandler('chrono-jewelry:killblip', function()
    RemoveBlip(blipRobbery)
end)

RegisterNetEvent('chrono-jewelry:setblip')
AddEventHandler('chrono-jewelry:setblip', function(position)
    blipRobbery = AddBlipForCoord(position.x, position.y, position.z)
    SetBlipSprite(blipRobbery , 161)
    SetBlipScale(blipRobbery , 2.0)
    SetBlipColour(blipRobbery, 3)
    PulseBlip(blipRobbery)
end)

RegisterNetEvent('chrono-jewelry:toofarlocal')
AddEventHandler('chrono-jewelry:toofarlocal', function(robb)
	holdingup = false
	ESX.ShowNotification(_U('robbery_cancelled'))
	robbingName = ""
	incircle = false
end)


RegisterNetEvent('chrono-jewelry:robberycomplete')
AddEventHandler('chrono-jewelry:robberycomplete', function(robb)
	holdingup = false
	ESX.ShowNotification(_U('robbery_complete'))
	store = ""
	incircle = false
end)

Citizen.CreateThread(function()
	for k,v in pairs(Stores)do
		local ve = v.position
		local blip = AddBlipForCoord(ve.x, ve.y, ve.z)
		SetBlipSprite(blip, 617)
		SetBlipScale(blip, 0.8)
		SetBlipColour(blip, 32)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_U('shop_robbery'))
		EndTextCommandSetBlipName(blip)
	end
end)

animazione = false
incircle = false
soundid = GetSoundId()

function drawTxt(x, y, scale, text, red, green, blue, alpha)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextScale(0.64, 0.64)
	SetTextColour(red, green, blue, alpha)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
    DrawText(0.155, 0.935)
end

local borsa = nil

Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(1000)
	  TriggerEvent('skinchanger:getSkin', function(skin)
		borsa = skin['bags_1']
	  end)
	  Citizen.Wait(1000)
	end
end)

Citizen.CreateThread(function()
      
	while true do
		local pos = GetEntityCoords(GetPlayerPed(-1), true)

		for k,v in pairs(Stores)do
			local pos2 = v.position

			if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 15.0)then
				if not holdingup then
					DrawMarker(27, v.position.x, v.position.y, v.position.z-0.9, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 255, 0, 0, 200, 0, 0, 0, 0)

					if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 1.0)then
						if (incircle == false) and Config.NeedBag == true then
							if borsa == 40 or borsa == 41 or borsa == 44 or borsa == 45 then
								exports['mythic_notify']:DoHudText('inform', ('Du har en väska.'))
								exports['mythic_notify']:DoHudText('inform', _U('press_to_rob'))
							else
								exports['mythic_notify']:DoHudText('inform', _U('need_bag'))
							end

								
							ESX.TriggerServerCallback('chrono-jewelry:itemState', function(itemState)

								if itemState == 1 then
									exports['mythic_notify']:DoHudText('inform', 'Du har en busshammare.')
									print(itemState)
								else
									exports['mythic_notify']:DoHudText('inform', 'Du saknar ett föremål.')
									print(itemState)
								end
							end)

						end

					incircle = true
						if IsPedShooting(GetPlayerPed(-1)) and CheckWeapon(GetPlayerPed(-1)) then 
							if Config.NeedBag then
							    if borsa == 40 or borsa == 41 or borsa == 44 or borsa == 45 then
							        ESX.TriggerServerCallback('chrono-jewelry:conteggio', function(CopsConnected)
								        if CopsConnected >= Config.RequiredCopsRob then
							                TriggerServerEvent('chrono-jewelry:rob', k)
							                --PlaySoundFromCoord(soundid, "VEHICLES_HORNS_AMBULANCE_WARNING", pos2.x, pos2.y, pos2.z)
								        else
									        exports['mythic_notify']:DoCustomHudText('success', _U('min_two_police') .. Config.RequiredCopsRob .. _U('min_two_police2'), 8500, { ['background-color'] = '#ad0000', ['color'] = '#fff' })
								        end
							        end)		

								end
							else
							end	
                        end

					elseif(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) > 1.0)then
						incircle = false
					end	
				end
			end
		end

		if holdingup then
			ClearPedSecondaryTask(GetPlayerPed(-1))
			FreezeEntityPosition(GetPlayerPed(-1), false)
			drawTxt(0.3, 1.4, 0.45, _U('smash_case') .. ' :~r~ ' .. vetrineRotte .. '/' .. Config.MaxWindows, 185, 185, 185, 255)
			for i,v in pairs(vetrine) do 
				if(GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 1.25) and not v.isOpen then 
					DrawText3D(v.x, v.y, v.z, '~w~[~g~E~w~] ' .. _U('press_to_collect'), 0.6)
					if IsControlJustPressed(0, 38) then
						animazione = true
					    SetEntityCoords(GetPlayerPed(-1), v.x, v.y, v.z-0.95)
					    SetEntityHeading(GetPlayerPed(-1), v.heading)
						v.isOpen = true 
						PlaySoundFromCoord(-1, "Glass_Smash", v.x, v.y, v.z, "", 0, 0, 0)
					    if not HasNamedPtfxAssetLoaded("scr_jewelheist") then
					    RequestNamedPtfxAsset("scr_jewelheist")
					    end
					    while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
					    Citizen.Wait(0)
					    end
					    SetPtfxAssetNextCall("scr_jewelheist")
					    StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", v.x, v.y, v.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
					    loadAnimDict( "missheist_jewel" ) 
						TaskPlayAnim(GetPlayerPed(-1), "missheist_jewel", "smash_case", 8.0, 1.0, -1, 2, 0, 0, 0, 0 ) 
						TriggerEvent("mt:missiontext", _U('collectinprogress'), 3000)
					    --DisplayHelpText(_U('collectinprogress'))
					    DrawSubtitleTimed(5000, 1)
					    Citizen.Wait(5000)
					    ClearPedTasksImmediately(GetPlayerPed(-1))
					    TriggerServerEvent('chrono-jewelry:gioielli')
					    PlaySound(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
					    vetrineRotte = vetrineRotte+1
					    animazione = false

						if vetrineRotte == Config.MaxWindows then 
						    for i,v in pairs(vetrine) do 
								v.isOpen = false
								vetrineRotte = 0
							end
							TriggerServerEvent('chrono-jewelry:endrob', store)
							exports['mythic_notify']:DoCustomHudText('success', _U('lester'), 8500, { ['background-color'] = '#007ecc', ['color'] = '#fff' })
						    holdingup = false
						    StopSound(soundid)
						end
					end
				end	
			end

			local pos2 = Stores[store].position

			if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -622.566, -230.183, 38.057, true) > 13.5 ) then
				TriggerServerEvent('chrono-jewelry:toofar', store)
				exports['mythic_notify']:DoCustomHudText('success', _U('robbery_has_cancelled'), 8500, { ['background-color'] = 'ad0000', ['color'] = '#fff' })
				holdingup = false
				for i,v in pairs(vetrine) do 
					v.isOpen = false
					vetrineRotte = 0
				end
				StopSound(soundid)
			end

		end

		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
      
	while true do
		Wait(1)
		if animazione == true then

			if not IsEntityPlayingAnim(PlayerPedId(), 'missheist_jewel', 'smash_case', 3) then
				TaskPlayAnim(PlayerPedId(), 'missheist_jewel', 'smash_case', 8.0, 8.0, -1, 17, 1, false, false, false)
			end
		end
	end
end)

--[[
RegisterNetEvent("lester:createBlip")
AddEventHandler("lester:createBlip", function(type, x, y, z)
	local blip = AddBlipForCoord(x, y, z)
	SetBlipSprite(blip, type)
	SetBlipColour(blip, 1)
	SetBlipScale(blip, 0.8)
	SetBlipAsShortRange(blip, true)
	if(type == 77)then
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Lester")
		EndTextCommandSetBlipName(blip)
	end
end)
]]--

blip = false

Citizen.CreateThread(function()
	TriggerEvent('lester:createBlip', 77, 1272.6, -1711.87, 54.77)
	while true do
	
		Citizen.Wait(1)
	
			local playerPed = PlayerPedId()
			local coords    = GetEntityCoords(playerPed)
			
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 1272.6, -1711.87, 54.77, true) <= 10 and not blip then
				DrawMarker(20, 1272.6, -1711.87, 54.77, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 102, 100, 102, 100, false, true, 2, false, false, false, false)
				if GetDistanceBetweenCoords(coords, 1272.52, -1711.94, 54.77, true) < 1.0 then
					DisplayHelpText(_U('press_to_sell'))
					if IsControlJustReleased(1, 51) then
						blip = true
						ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
							if quantity >= Config.MaxJewelsSell then
								ESX.TriggerServerCallback('chrono-jewelry:conteggio', function(CopsConnected)
									if CopsConnected >= Config.RequiredCopsSell then
										RequestAnimDict("anim@heists@humane_labs@finale@keycards")
										TaskPlayAnim(GetPlayerPed(-1), "anim@heists@humane_labs@finale@keycards" ,"ped_b_enter" ,8.0, -8.0, -1, 0, 0, false, false, false )
										Citizen.Wait(1000)
										FreezeEntityPosition(playerPed, true)
										TriggerEvent('mt:missiontext', _U('goldsell'), 10000)
										exports['mythic_notify']:DoCustomHudText('success', _U('goldsell'), 10000, { ['background-color'] = '007ecc', ['color'] = '#fff' })
										Wait(10000)
										FreezeEntityPosition(playerPed, false)
										TriggerServerEvent('chrono-jewelry:vendita')
										blip = false
									else
										blip = false
										exports['mythic_notify']:DoCustomHudText('success', _U('copsforsell') .. Config.RequiredCopsSell .. _U('copsforsell2'), 8500, { ['background-color'] = '#ad0000', ['color'] = '#fff' })
									end
								end)
							else
								blip = false
								exports['mythic_notify']:DoCustomHudText('success', _U('notenoughgold') .. Config.MaxJewelsSell .. _U('notenoughgold2'), 8500, { ['background-color'] = '#ad0000', ['color'] = '#fff' })
							end
						end, 'jewels')
					end
				end
			end
	end
end)


function CheckWeapon(ped)
	if IsEntityDead(ped) then
		blocked = false
			return false
		else
			for i = 1, #Config.Weapons do
				if GetHashKey(Config.Weapons[i]) == GetSelectedPedWeapon(ped) then
					return true
				end
			end
		return false
	end
end
