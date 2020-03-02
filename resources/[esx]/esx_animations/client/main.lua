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

local ragdoll = false
local mp_pointing = false
local keyPressed = false
local crouched = false
local passengerDriveBy = true
handsup = false

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local knockedOut = false
local wait = 15
local count = 60

Citizen.CreateThread(function()
	while true do
		Wait(1)
		local myPed = GetPlayerPed(-1)
		if IsPedInMeleeCombat(myPed) then
			if GetEntityHealth(myPed) < 115 then
				SetPedToRagdoll(myPed, 1000, 1000, 0, 0, 0, 0)
				exports['mythic_notify']:DoHudText('inform', 'Du blev knockad', { ['background-color'] = '#b00000', ['color'] = '#fff' })
				wait = 15
				knockedOut = true
				SetEntityHealth(myPed, 116)
			end
		end
		if knockedOut == true then
			DisablePlayerFiring(PlayerId(), true)
			SetPedToRagdoll(myPed, 1000, 1000, 0, 0, 0, 0)
			ResetPedRagdollTimer(myPed)
			
			if wait >= 0 then
				count = count - 1
				if count == 0 then
					count = 60
					wait = wait - 1
					SetEntityHealth(myPed, GetEntityHealth(myPed)+4)
				end
			else
				knockedOut = false
			end
		end
	end
end)

function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end


function setRagdoll(flag)
  ragdoll = flag
end
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if ragdoll then
      SetPedToRagdoll(GetPlayerPed(-1), 1000, 1000, 0, 0, 0, 0)
    end
  end
end)

ragdol = true

function ragdolld()
	if ( ragdol ) then
		setRagdoll(true)
		ragdol = false
	else
		setRagdoll(false)
		ragdol = true
	end
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    -- List of pickup hashes (https://pastebin.com/8EuSv2r1)
    RemoveAllPickupsOfType(0xDF711959) -- weapon_carbinerifle
    RemoveAllPickupsOfType(0xF9AFB48F) -- weapon_pistol
    RemoveAllPickupsOfType(0xA9355DCD) -- weapon_pumpshotgun
  end
end)

Citizen.CreateThread(function()
	for i = 1, 12 do
		Citizen.InvokeNative(0xDC0F817884CDD856, i, false)
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(1)

		playerPed = GetPlayerPed(-1)
		car = GetVehiclePedIsIn(playerPed, false)
		if car then
			if GetPedInVehicleSeat(car, -1) == playerPed then
				SetPlayerCanDoDriveBy(PlayerId(), false)
			elseif passengerDriveBy then
				SetPlayerCanDoDriveBy(PlayerId(), true)
			else
				SetPlayerCanDoDriveBy(PlayerId(), false)
			end
		end
	end
end)

Citizen.CreateThread(function()
	local isSniper = false
	while true do
		Citizen.Wait(0)

    	local ped = GetPlayerPed(-1)

		
		--print(GetHashKey("WEAPON_SNIPERRIFLE"))
		local currentWeaponHash = GetSelectedPedWeapon(ped)

		if currentWeaponHash == 100416529 then
			isSniper = true
		elseif currentWeaponHash == 205991906 then
			isSniper = true
		elseif currentWeaponHash == -952879014 then
			isSniper = true
		elseif currentWeaponHash == GetHashKey('WEAPON_HEAVYSNIPER_MK2') then
			isSniper = true
		else
			isSniper = false
		end

		if not isSniper then
			HideHudComponentThisFrame(14)
		end
	end
end)

Citizen.CreateThread( function()
    while true do 
        Citizen.Wait( 1 )

        local ped = GetPlayerPed( -1 )

        if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then 
            DisableControlAction( 0, 36, true ) -- INPUT_DUCK  

            if ( not IsPauseMenuActive() ) then 
                if ( IsDisabledControlJustPressed( 0, 36 ) ) then 
                    RequestAnimSet( "move_ped_crouched" )

                    while ( not HasAnimSetLoaded( "move_ped_crouched" ) ) do 
                        Citizen.Wait( 100 )
                    end 

                    if ( crouched == true ) then 
                        ResetPedMovementClipset( ped, 0 )
                        crouched = false 
                    elseif ( crouched == false ) then
                        SetPedMovementClipset( ped, "move_ped_crouched", 0.25 )
                        crouched = true 
                    end 
                end
            end 
        end 
    end
end )

Citizen.CreateThread(function()
    while true
        do
            -- 1.
        SetVehicleDensityMultiplierThisFrame(0.2)
        SetPedDensityMultiplierThisFrame(0.2)
        --SetRandomVehicleDensityMultiplierThisFrame(1.0)
        --SetParkedVehicleDensityMultiplierThisFrame(1.0)
        --SetScenarioPedDensityMultiplierThisFrame(2.0, 2.0)

        --local playerPed = GetPlayerPed(-1)
        --local pos = GetEntityCoords(playerPed)
        --RemoveVehiclesFromGeneratorsInArea(pos['x'] - 900.0, pos['y'] - 900.0, pos['z'] - 900.0, pos['x'] + 900.0, pos['y'] + 900.0, pos['z'] + 900.0);


        -- 2.
        --SetGarbageTrucks(0)
        --SetRandomBoats(0)
        --SetRandomBus(0)
        Citizen.Wait(1)
    end

end)


Citizen.CreateThread(function()
 	while true do
 		Citizen.Wait(10)
 		if ( IsControlPressed(2, 303) ) then
 			ragdolld()
 		end
 	end
 end)

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

local favlib = "amb@world_human_hang_out_street@female_arms_crossed@base"
local favani = "base"
local favrep = 17
local favscen = nil
local favtyp = "anim"
local favrag = 0

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function favAnim(lib, anim, repet, ragdoll)
 	
	Citizen.CreateThread(function()
		favlib = lib
		favani = anim
		favrep = repet
		favtyp = "anim"
		favrag = ragdoll
		ESX.UI.Menu.CloseAll()
	end)

end

function favScenario(anim)
 	
	Citizen.CreateThread(function()
		favscen = anim
		favtyp = "scen"
		ESX.UI.Menu.CloseAll()
	end)

end

function startAttitude(lib, anim)
 	Citizen.CreateThread(function()
	
	    local playerPed = GetPlayerPed(-1)
	
	    RequestAnimSet(anim)
	      
	    while not HasAnimSetLoaded(anim) do
	        Citizen.Wait(0)
	    end
	    SetPedMovementClipset(playerPed, anim, true)
	end)

end

function startAnim(lib, anim, repet, ragdoll, flying)
 	
	Citizen.CreateThread(function()
		print(lib)
		if GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1), false)) == 8 and not lib == "anim@veh@sit_variations@chopper@front@idle_b" then
			Stop()
		end
	  RequestAnimDict(lib)
	  
	  while not HasAnimDictLoaded( lib) do
	    Citizen.Wait(0)
	  end
	  	print(flying)
		if flying == 1 then
			DetachVehicleWindscreen(GetVehiclePedIsIn(GetPlayerPed(-1), false))
			positionen = GetEntityCoords(GetPlayerPed(-1))
			print(positionen.x)
			print("yes")
			SetEntityCollision(GetPlayerPed(-1), false)
			SetEntityCoords(GetPlayerPed(-1), positionen.x, positionen.y, positionen.z-0.5)
			Citizen.Wait(1)
 		end
 		if flying == 2 then
			TaskLeaveVehicle(GetPlayerPed(-1), GetVehiclePedIsUsing(GetPlayerPed(-1)), 0)
 		end
	  TaskPlayAnim(GetPlayerPed(-1), lib ,anim ,8.0, -8.0, -1, repet, 0, false, false, false )
	  if flying == 5 then
	  	RequestAnimDict("anim@gangops@facility@servers@bodysearch@")
	  	while not HasAnimDictLoaded("anim@gangops@facility@servers@bodysearch@") do
	    	Citizen.Wait(0)
	  	end
	  	RequestAnimDict("amb@medic@standing@kneel@exit")
	  	while not HasAnimDictLoaded("amb@medic@standing@kneel@exit") do
	    	Citizen.Wait(0)
	  	end
	  	TaskPlayAnim(GetPlayerPed(-1), "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false )
	  	Citizen.Wait(7000)
	  	TaskPlayAnim(GetPlayerPed(-1), "amb@medic@standing@kneel@exit" ,"exit" ,8.0, -8.0, -1, 0, 0, false, false, false )
	  end
	  --[[if flying == 5 then
	  	local startpos = GetEntityCoords(GetPlayerPed(-1))
	  	local currpos = startpos
	  	Citizen.Wait(500)
	  	SetEntityCoords(GetPlayerPed(-1), currpos.x, currpos.y, currpos.z-0.5)
	  	Citizen.Wait(6500)
	  	SetEntityCoords(GetPlayerPed(-1), startpos.x, startpos.y, startpos.z)
	  end]]
	  if flying == 1 then
	  	Citizen.Wait(25)
		SetEntityCollision(GetPlayerPed(-1), true)
	  end
	  if ragdoll == 1 then
	  	Citizen.Wait(500)
 		SetPedToRagdoll(GetPlayerPed(-1), 1000, 1000, 0, 0, 0, 0)
 	end

	end)

end

function startAdvAnim(anim)
 	
	Citizen.CreateThread(function()
		local setset = GetEntityType(-1126237515)
		print(setset)
	  AttachEntityToEntity(GetPlayerPed(-1), -1126237515, 0, 0.0, -1.0, 0.0, 0.0, 0.0, 0.0, true, true, true, false, 1, true)
	  TaskStartScenarioInPlace(GetPlayerPed(-1), anim, 0, false)
	  

	end)

end

function startDoubleAni(lib, anim, lib2, anim2, repet, ragdoll, flying)
 	
	Citizen.CreateThread(function()
		print(GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1), false)))
		if GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1), false)) == 8 then
			Stop()
		end
	  RequestAnimDict(lib)
	  RequestAnimDict(lib2)
	  
	  while not HasAnimDictLoaded( lib) do
	    Citizen.Wait(0)
	  end
	  while not HasAnimDictLoaded( lib2) do
	    Citizen.Wait(0)
	  end
	  	
 		
	  TaskPlayAnim(GetPlayerPed(-1), lib2 ,anim2 ,8.0, -8.0, -1, 1, 0, false, false, false )
	  Citizen.Wait(5)
	  TaskPlayAnim(GetPlayerPed(-1), lib ,anim ,8.0, -8.0, -1, 49, 0, false, false, false )

	end)

end

function startScenario(anim)
  TaskStartScenarioInPlace(GetPlayerPed(-1), anim, 0, false)
end

function OpenAnimationsMenu()

	local elements = {}

	for i=1, #Config.Animations, 1 do
		table.insert(elements, {label = Config.Animations[i].label, value = Config.Animations[i].name})
	end
	table.insert(elements, {label = "Välj Favorit (Z)", value = "favvo"})

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'animations',
		{
			title    = 'Animationer',
			align    = 'right',
			elements = elements
		},
		function(data, menu)
			if data.current.value == "favvo" then
				OpenAnimationsMenu2()
			else
				OpenAnimationsSubMenu(data.current.value)
			end
		end,
		function(data, menu)
			TriggerEvent('esx_qalle:openMenu')
		end
	)

end

function OpenAnimationsMenu2()

	local elements = {}

	for i=1, #Config.Animations, 1 do
		if Config.Animations[i].name ~= "attitudem" then
			table.insert(elements, {label = Config.Animations[i].label, value = Config.Animations[i].name})
		end
	end

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'animations2',
		{
			title    = 'Ny Favorit',
			align = 'right',
			elements = elements
		},
		function(data, menu)
			OpenAnimationsSubMenu2(data.current.value)
		end,
		function(data, menu)
			menu.close()
		end
	)

end

function OpenAnimationsSubMenu(menu)

	local title    = nil
	local elements = {}

	for i=1, #Config.Animations, 1 do
		
		if Config.Animations[i].name == menu then

			title = Config.Animations[i].label

			for j=1, # Config.Animations[i].items, 1 do
				table.insert(elements, {label = Config.Animations[i].items[j].label, type = Config.Animations[i].items[j].type, value = Config.Animations[i].items[j].data})
			end

			break

		end

	end

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'animations_sub2',
		{
			title    = title,
			align = 'right',
			elements = elements
		},
		function(data, menu)

			local type = data.current.type
			local lib  = data.current.value.lib
			local anim = data.current.value.anim
			local lib2 = data.current.value.lib2
			local anim2 = data.current.value.anim2
			local repet = data.current.value.repet
			local posX = data.current.value.posX
			local posY = data.current.value.posY
			local posZ = data.current.value.posZ
			local ragdoll = data.current.value.ragdoll
			local flying = data.current.value.flying

			if type == 'scenario' then
				startScenario(anim)
			else
				if type == 'attitude' then
					startAttitude(lib, anim)
				else
					if type == 'doubleani' then
						startDoubleAni(lib, anim, lib2, anim2)
					else
						if type == 'AdvAnim' then
							startAdvAnim(anim)
						else
							startAnim(lib, anim, repet, ragdoll, flying)
						end
					end
				end
			end

		end,
		function(data, menu)
			menu.close()
		end
	)

end

function OpenAnimationsSubMenu2(menu)

	local title    = nil
	local elements = {}

	for i=1, #Config.Animations, 1 do
		
		if Config.Animations[i].name == menu then

			title = Config.Animations[i].label

			for j=1, # Config.Animations[i].items, 1 do
				table.insert(elements, {label = Config.Animations[i].items[j].label, type = Config.Animations[i].items[j].type, value = Config.Animations[i].items[j].data})
			end

			break

		end

	end

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'animations_sub',
		{
			title    = title,
			align = 'right',
			elements = elements
		},
		function(data, menu)

			local type = data.current.type
			local lib  = data.current.value.lib
			local anim = data.current.value.anim
			local lib2 = data.current.value.lib2
			local anim2 = data.current.value.anim2
			local repet = data.current.value.repet
			local posX = data.current.value.posX
			local posY = data.current.value.posY
			local posZ = data.current.value.posZ
			local ragdoll = data.current.value.ragdoll
			local flying = data.current.value.flying

			if type == 'scenario' then
				favScenario(anim)
			else
				if type == 'attitude' then
					stop()
				else
					favAnim(lib, anim, repet, ragdoll)
				end
			end

		end,
		function(data, menu)
			menu.close()
		end
	)

end

local function startPointing()
  
  local playerPed = GetPlayerPed(-1)

  RequestAnimDict("anim@mp_point")
  
  while not HasAnimDictLoaded("anim@mp_point") do
    Citizen.Wait(0)
  end
  
  SetPedCurrentWeaponVisible(playerPed, 0, 1, 1, 1)
  SetPedConfigFlag(playerPed, 36, 1)
  
  Citizen.InvokeNative(0x2D537BA194896636, playerPed, "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
end

local function stopPointing()

    local playerPed = GetPlayerPed(-1)

    Citizen.InvokeNative(0xD01015C7316AE176, playerPed, "Stop")
   
    if not IsPedInjured(playerPed) then
      ClearPedSecondaryTask(playerPed)
    end

    if not IsPedInAnyVehicle(playerPed, 1) then
      SetPedCurrentWeaponVisible(playerPed, 1, 1, 1, 1)
    end

    SetPedConfigFlag(playerPed, 36, 0)
    
    ClearPedSecondaryTask(PlayerPedId())
end

-- Key Controls
Citizen.CreateThread(function()
  while true do
  Citizen.Wait(0)


	  if IsControlJustReleased(0, Keys['X']) then
	  	ClearPedTasks(GetPlayerPed(-1))
	  end

	  if IsControlJustReleased(0, Keys['Z']) then
	  	print(IsPedInAnyVehicle(GetPlayerPed(-1)))
	  	if IsPedInAnyVehicle(GetPlayerPed(-1)) ~= false then
  		elseif favtyp == "anim" then
  			RequestAnimDict(favlib)
  
			while not HasAnimDictLoaded( favlib) do
				Citizen.Wait(0)
			end
	  		TaskPlayAnim(GetPlayerPed(-1), favlib ,favani ,8.0, -8.0, -1, favrep, 0, false, false, false )
	  		if favrag == 1 then
			  	Citizen.Wait(500)
		 		SetPedToRagdoll(GetPlayerPed(-1), 1000, 1000, 0, 0, 0, 0)
		 	end
	  	elseif favtyp == "scen" then
				TaskStartScenarioInPlace(GetPlayerPed(-1), favscen, 0, false)
		end

	  end

  end
end)

RegisterNetEvent('esx_animations:openMenu')
AddEventHandler('esx_animations:openMenu', function()
	ESX.UI.Menu.CloseAll()
	OpenAnimationsMenu()
end)

local function startPointing()
  
  local playerPed = GetPlayerPed(-1)

  RequestAnimDict("anim@mp_point")
  
  while not HasAnimDictLoaded("anim@mp_point") do
    Citizen.Wait(0)
  end
  
  SetPedCurrentWeaponVisible(playerPed, 0, 1, 1, 1)
  SetPedConfigFlag(playerPed, 36, 1)
  
  Citizen.InvokeNative(0x2D537BA194896636, playerPed, "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
end

local function stopPointing()

    local playerPed = GetPlayerPed(-1)

    Citizen.InvokeNative(0xD01015C7316AE176, playerPed, "Stop")
   
    if not IsPedInjured(playerPed) then
      ClearPedSecondaryTask(playerPed)
    end

    if not IsPedInAnyVehicle(playerPed, 1) then
      SetPedCurrentWeaponVisible(playerPed, 1, 1, 1, 1)
    end

    SetPedConfigFlag(playerPed, 36, 0)
    
    ClearPedSecondaryTask(PlayerPedId())
end

local holstered = true
local lastWeapon = nil

local weapons = {
    "WEAPON_COMBATPISTOL",
	"WEAPON_STUNGUN",
	"WEAPON_KNIFE",
	"WEAPON_PISTOL",
	"WEAPON_PISTOL50",
	"WEAPON_APPISTOL",
	"WEAPON_MINISMG",
	"WEAPON_MICROSMG",
	"WEAPON_MACHINEPISTOl",
	"WEAPON_PISTOL_MK2",
	"WEAPON_SNSPISTOL_MK2",
	"WEAPON_SNSPISTOL",
}

 Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1)
        if DoesEntityExist(ped) and not IsEntityDead(ped) and not IsPedInAnyVehicle(ped, true) then
            loadAnimDict( "rcmjosh4" )
            loadAnimDict( "weapons@pistol@" )

            if CheckWeapon(ped) then
                if holstered then
                    local weapon = GetSelectedPedWeapon(ped)

                    SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)

                    TaskPlayAnim(ped, "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
                    
                    Citizen.Wait(600)

                    SetCurrentPedWeapon(ped, weapon, true)

                    Citizen.Wait(100)
                    ClearPedTasks(ped)

                    holstered = false
                end
            elseif not CheckWeapon(ped) then
                if not holstered then
                    if lastWeapon ~= nil then
                        SetCurrentPedWeapon(ped, lastWeapon, true)
                    end

                    TaskPlayAnim(ped, "weapons@pistol@", "aim_2_holster", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
                    
                    Citizen.Wait(500)

                    SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
                    
                    ClearPedTasks(ped)
                    holstered = true
                end
            end

            lastWeapon = GetSelectedPedWeapon(ped)
        end
    end
end)


function CheckWeapon(ped)
    for i=1, #weapons do
        if GetHashKey(weapons[i]) == GetSelectedPedWeapon(ped) then
            return true
        end
    end

    return false
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        
        Citizen.Wait(0)
    end
end

-- Key Controls
Citizen.CreateThread(function()
  while true do
  Citizen.Wait(0)

  		local lPed = GetPlayerPed(-1)

        RequestAnimDict("amb@world_human_hang_out_street@female_arms_crossed@idle_a")
        while not HasAnimDictLoaded("amb@world_human_hang_out_street@female_arms_crossed@idle_a") do
          Citizen.Wait(0)        
        end

	  if IsControlJustReleased(0, Keys['X']) then
	  	ClearPedTasks(GetPlayerPed(-1))
	  end

  end
end)

function getSurrenderStatus()
	return handsup
end

RegisterNetEvent('vk_handsup:getSurrenderStatusPlayer')
AddEventHandler('vk_handsup:getSurrenderStatusPlayer',function(event,source)
		if handsup then
			TriggerServerEvent("vk_handsup:reSendSurrenderStatus",event,source,true)
		else
			TriggerServerEvent("vk_handsup:reSendSurrenderStatus",event,source,false)
		end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local lPed = GetPlayerPed(-1)
		RequestAnimDict("random@mugging3")
		if not IsPedInAnyVehicle(lPed, false) and not IsPedSwimming(lPed) and not IsPedShooting(lPed) and not IsPedClimbing(lPed) and not IsPedCuffed(lPed) and not IsPedDiving(lPed) and not IsPedFalling(lPed) and not IsPedJumping(lPed) and not IsPedJumpingOutOfVehicle(lPed) and IsPedOnFoot(lPed) and not IsPedRunning(lPed) and not IsPedUsingAnyScenario(lPed) and not IsPedInParachuteFreeFall(lPed) then
			if IsControlPressed(1, 323) then
				if DoesEntityExist(lPed) then
					SetCurrentPedWeapon(lPed, 0xA2719263, true)
					Citizen.CreateThread(function()
						RequestAnimDict("random@mugging3")
						while not HasAnimDictLoaded("random@mugging3") do
							Citizen.Wait(100)
						end

						if not handsup then
							handsup = true
							TaskPlayAnim(lPed, "random@mugging3", "handsup_standing_base", 8.0, -8, -1, 49, 0, 0, 0, 0)
						end   
					end)
				end
			end
		end
		if IsControlReleased(1, 323) then
			if DoesEntityExist(lPed) then
				Citizen.CreateThread(function()
					RequestAnimDict("random@mugging3")
					while not HasAnimDictLoaded("random@mugging3") do
						Citizen.Wait(100)
					end

					if handsup then
						handsup = false
						ClearPedSecondaryTask(lPed)
					end
				end)
			end
		end
	end
end)

local function startPointing()
    local ped = GetPlayerPed(-1)
    RequestAnimDict("anim@mp_point")
    while not HasAnimDictLoaded("anim@mp_point") do
        Wait(0)
    end
    SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
    SetPedConfigFlag(ped, 36, 1)
    Citizen.InvokeNative(0x2D537BA194896636, ped, "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
    RemoveAnimDict("anim@mp_point")
end

local function stopPointing()
    local ped = GetPlayerPed(-1)
    Citizen.InvokeNative(0xD01015C7316AE176, ped, "Stop")
    if not IsPedInjured(ped) then
        ClearPedSecondaryTask(ped)
    end
    if not IsPedInAnyVehicle(ped, 1) then
        SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
    end
    SetPedConfigFlag(ped, 36, 0)
    ClearPedSecondaryTask(PlayerPedId())
end

local once = true
local oldval = false
local oldvalped = false

Citizen.CreateThread(function()
    while true do
        Wait(0)

        if once then
            once = false
        end

        if not keyPressed then
            if IsControlPressed(0, 29) and not mp_pointing and IsPedOnFoot(PlayerPedId()) then
                Wait(200)
                if not IsControlPressed(0, 29) then
                    keyPressed = true
                    startPointing()
                    mp_pointing = true
                else
                    keyPressed = true
                    while IsControlPressed(0, 29) do
                        Wait(50)
                    end
                end
            elseif (IsControlPressed(0, 29) and mp_pointing) or (not IsPedOnFoot(PlayerPedId()) and mp_pointing) then
                keyPressed = true
                mp_pointing = false
                stopPointing()
            end
        end

        if keyPressed then
            if not IsControlPressed(0, 29) then
                keyPressed = false
            end
        end
        if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) and not mp_pointing then
            stopPointing()
        end
        if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) then
            if not IsPedOnFoot(PlayerPedId()) then
                stopPointing()
            else
                local ped = GetPlayerPed(-1)
                local camPitch = GetGameplayCamRelativePitch()
                if camPitch < -70.0 then
                    camPitch = -70.0
                elseif camPitch > 42.0 then
                    camPitch = 42.0
                end
                camPitch = (camPitch + 70.0) / 112.0

                local camHeading = GetGameplayCamRelativeHeading()
                local cosCamHeading = Cos(camHeading)
                local sinCamHeading = Sin(camHeading)
                if camHeading < -180.0 then
                    camHeading = -180.0
                elseif camHeading > 180.0 then
                    camHeading = 180.0
                end
                camHeading = (camHeading + 180.0) / 360.0

                local blocked = 0
                local nn = 0

                local coords = GetOffsetFromEntityInWorldCoords(ped, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
                local ray = Cast_3dRayPointToPoint(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, ped, 7);
                nn,blocked,coords,coords = GetRaycastResult(ray)

                Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Pitch", camPitch)
                Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Heading", camHeading * -1.0 + 1.0)
                Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isBlocked", blocked)
                Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isFirstPerson", Citizen.InvokeNative(0xEE778F8C7E1142E2, Citizen.InvokeNative(0x19CAFA3C87F7C2FF)) == 4)

            end
        end
    end
end)

function AddTextEntry(key, value)
	Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), key, value)
end

Citizen.CreateThread(function()
  AddTextEntry('FE_THDR_GTAO', 'Never Ending Roleplay')
end)





function sendNotification(message, messageType, messageTimeout)
	TriggerEvent("pNotify:SendNotification", {
		text = message,
		type = messageType,
		queue = "wille",
		timeout = messageTimeout,
		layout = "bottomCenter"
	})
end
