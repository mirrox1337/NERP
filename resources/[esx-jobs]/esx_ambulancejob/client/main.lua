                      function SendDistressSignal()
  local playerPed = PlayerPedId()
  PedPosition   = GetEntityCoords(playerPed)
  
  local PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z }

  ESX.ShowNotification(_U('distress_sent'))

    TriggerServerEvent('esx_addons_gcphone:startCall', 'ambulance', _U('distress_message'), PlayerCoords, {

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

ESX                             = nil
local GUI                       = {}
GUI.Time                        = 0
local PlayerData                = {}
local FirstSpawn                = true
local IsDead                    = false
local HasAlreadyEnteredMarker   = false
local LastZone                  = nil
local CurrentAction             = nil

local CurrentActionMsg          = ''
local CurrentActionData         = {}
local IsHandcuffed              = false
local IsDragged                 = false
local CopPed                    = 0
local RespawnToHospitalMenu     = nil
local OnJob                     = false
local CurrentCustomer           = nil
local CurrentCustomerBlip       = nil
local DestinationBlip           = nil
local IsNearCustomer            = false
local CustomerIsEnteringVehicle = false
local CustomerEnteredVehicle    = false
local TargetCoords              = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

--[[AddEventHandler('playerSpawned', function()
  IsDead = false

  if FirstSpawn then
    exports.spawnmanager:setAutoSpawn(false) -- disable respawn
    FirstSpawn = false

    ESX.TriggerServerCallback('esx_ambulancejob:getDeathStatus', function(isDead)
      if isDead and Config.AntiCombatLog then
        while not PlayerLoaded do
          Citizen.Wait(1000)
        end

        ESX.ShowNotification(_U('combatlog_message'))
        RemoveItemsAfterRPDeath()
      end
    end)
  end
end)]]--


RegisterNetEvent('esx_ambulancejob:multicharacter')
AddEventHandler('esx_ambulancejob:multicharacter', function()
    IsDead = false

        ESX.TriggerServerCallback('esx_ambulancejob:getDeathStatus', function(isDead)
            if isDead and Config.AntiCombatLog then
                ESX.ShowNotification(_U('combatlog_message'))
                RemoveItemsAfterRPDeath()
            end
        end)
end)

function SetVehicleMaxMods(vehicle)

  local props = {
    modEngine       = 2,
    modBrakes       = 2,
    modTransmission = 2,
    modSuspension   = 3,
    modTurbo        = true,
  }

  ESX.Game.SetVehicleProperties(vehicle, props)

end

function DrawSub(msg, time)
  ClearPrints()
  SetTextEntry_2("STRING")
  AddTextComponentString(msg)
  DrawSubtitleTimed(time, 1)
end

function ShowLoadingPromt(msg, time, type)
  Citizen.CreateThread(function()
    Citizen.Wait(0)
    N_0xaba17d7ce615adbf("STRING")
    AddTextComponentString(msg)
    N_0xbd12f8228410d9b4(type)
    Citizen.Wait(time)
    N_0x10d373323e5b9c0d()
  end)
end

function OnPlayerDeath()
  IsDead = true
  TriggerServerEvent('esx_ambulancejob:setDeathStatus', true)

  StartDeathTimer()
  StartDistressSignal()

  StartScreenEffect('DeathFailOut', 0, false)
end

function GetRandomWalkingNPC()

  local search = {}
  local peds   = ESX.Game.GetPeds()

  for i=1, #peds, 1 do
    if IsPedHuman(peds[i]) and IsPedWalking(peds[i]) and not IsPedAPlayer(peds[i]) then
      table.insert(search, peds[i])
    end
  end

  if #search > 0 then
    return search[GetRandomIntInRange(1, #search)]
  end

  print('Using fallback code to find walking ped')

  for i=1, 250, 1 do

    local ped = GetRandomPedAtCoord(0.0,  0.0,  0.0,  math.huge + 0.0,  math.huge + 0.0,  math.huge + 0.0,  26)

    if DoesEntityExist(ped) and IsPedHuman(ped) and IsPedWalking(ped) and not IsPedAPlayer(ped) then
      table.insert(search, ped)
    end

  end

  if #search > 0 then
    return search[GetRandomIntInRange(1, #search)]
  end

end

function ClearCurrentMission()

  if DoesBlipExist(CurrentCustomerBlip) then
    RemoveBlip(CurrentCustomerBlip)
  end

  if DoesBlipExist(DestinationBlip) then
    RemoveBlip(DestinationBlip)
  end

  CurrentCustomer           = nil
  CurrentCustomerBlip       = nil
  DestinationBlip           = nil
  IsNearCustomer            = false
  CustomerIsEnteringVehicle = false
  CustomerEnteredVehicle    = false
  TargetCoords              = nil

end

function StartAmbulanceJob()

  ShowLoadingPromt(_U('taking_service') .. 'Ambulance', 5000, 3)
  ClearCurrentMission()

  OnJob = true

end

function StopAmbulanceJob()

  local playerPed = GetPlayerPed(-1)

  if IsPedInAnyVehicle(playerPed, false) and CurrentCustomer ~= nil then
    local vehicle = GetVehiclePedIsIn(playerPed,  false)
    TaskLeaveVehicle(CurrentCustomer,  vehicle,  0)

    if CustomerEnteredVehicle then
      TaskGoStraightToCoord(CurrentCustomer,  TargetCoords.x,  TargetCoords.y,  TargetCoords.z,  1.0,  -1,  0.0,  0.0)
    end

  end

  ClearCurrentMission()

  OnJob = false

  DrawSub(_U('mission_complete'), 5000)

end

function RespawnPed(ped, coords, heading)
  SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
  NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
  SetPlayerInvincible(ped, false)
  TriggerEvent('esx_ambulancejob:multicharacter', coords.x, coords.y, coords.z)
  ClearPedBloodDamage(ped)

  ESX.UI.Menu.CloseAll()
end

RegisterNetEvent('esx_ambulancejob:heal')
AddEventHandler('esx_ambulancejob:heal', function(_type)
    local playerPed = GetPlayerPed(-1)
    local maxHealth = GetEntityMaxHealth(playerPed)
    if _type == 'small' then
        local health = GetEntityHealth(playerPed)
        local newHealth = math.min(maxHealth , math.floor(health + maxHealth/8))
        SetEntityHealth(playerPed, newHealth)
    elseif _type == 'big' then
        SetEntityHealth(playerPed, maxHealth)
    end
    ESX.ShowNotification(_U('healed'))
end)


function StartRespawnToHospitalMenuTimer()
  ESX.SetTimeout(Config.MenuRespawnToHospitalDelay, function()
    if IsDead then
      local elements = {}
      table.insert(elements, {label = _U('yes'), value = 'yes'})
      RespawnToHospitalMenu = ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'menuName',
        {
          title = _U('respawn_at_hospital'),
          align = 'right',
          elements = elements
        },
        function(data, menu) --Submit Cb
          menu.close()
          Citizen.CreateThread(function()
                  RemoveItemsAfterRPDeath()
                    end)
        end,
        function(data, menu) --Cancel Cb
          --menu.close()
        end,
        function(data, menu) --Change Cb
          --print(data.current.value)
        end,
        function(data, menu) --Close Cb
          RespawnToHospitalMenu = nil
        end
      )
    end
  end)
end

function StartRespawnTimer()
  ESX.SetTimeout(Config.RespawnDelayAfterRPDeath, function()
    if IsDead then
      RemoveItemsAfterRPDeath()
    end
  end)
end

function ShowTimer()
  local timer = Config.RespawnDelayAfterRPDeath
  Citizen.CreateThread(function()

    while timer > 0 and IsDead do
            Wait(0)

      raw_seconds = timer/1000
      raw_minutes = raw_seconds/60
      minutes = stringsplit(raw_minutes, ".")[1]
      seconds = stringsplit(raw_seconds-(minutes*60), ".")[1]

            SetTextFont(4)
            SetTextProportional(0)
            SetTextScale(0.0, 0.5)
            SetTextColour(255, 255, 255, 255)
            SetTextDropshadow(0, 0, 0, 0, 255)
            SetTextEdge(1, 0, 0, 0, 255)

            SetTextDropShadow()
            SetTextOutline()
            SetTextEntry("STRING")

            local text = _U('please_wait') .. minutes .. _U('minutes') .. seconds .. _U('seconds')

            if Config.EarlyRespawn then
                text = text .. '\n[~b~E~w~]'
            end

            AddTextComponentString(text)
            SetTextCentre(true)
            DrawText(0.5, 0.8)

      if Config.EarlyRespawn then
        if IsControlPressed(0, Keys['E']) then
                    RemoveItemsAfterRPDeath()
                    break
        end
      end
            timer = timer - 15
    end

        if Config.EarlyRespawn then
        while timer <= 0 and IsDead do
          Wait(0)

                SetTextFont(4)
                SetTextProportional(0)
                SetTextScale(0.0, 0.5)
                SetTextColour(255, 255, 255, 255)
                SetTextDropshadow(0, 0, 0, 0, 255)
                SetTextEdge(1, 0, 0, 0, 255)

                SetTextDropShadow()
                SetTextOutline()
                SetTextEntry("STRING")

                AddTextComponentString(_U('press_respawn'))
                SetTextCentre(true)
                DrawText(0.5, 0.8)

          if IsControlPressed(0, Keys['E']) then
            RemoveItemsAfterRPDeath()
                    break
          end
        end
        end

  end)
end

function RemoveItemsAfterRPDeath()
    Citizen.CreateThread(function()
        DoScreenFadeOut(800)
        while not IsScreenFadedOut() do
            Citizen.Wait(0)
        end
        ESX.TriggerServerCallback('esx_ambulancejob:removeItemsAfterRPDeath', function()

            TriggerEvent('esx_status:add', 'thirst', 350000)

            TriggerEvent('esx_status:add', 'hunger', 350000)
      
            ESX.SetPlayerData('lastPosition', Config.Zones.HospitalInteriorInside1.Pos)
            ESX.SetPlayerData('loadout', {})

            TriggerServerEvent('esx:updateLastPosition', Config.Zones.HospitalInteriorInside1.Pos)

            RespawnPed(GetPlayerPed(-1), Config.Zones.HospitalInteriorInside1.Pos)

            StopScreenEffect('DeathFailOut')
            DoScreenFadeIn(800)
            TriggerEvent('shakeCam', true)
        end)
    end)
end

--------add effect when the player come back after death-----
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


function OnPlayerDeath()
    IsDead = true

    TriggerEvent('esx_status:add', 'thirst', 350000)
    TriggerEvent('esx_status:add', 'hunger', 350000)

    if Config.ShowDeathTimer == true then
        ShowTimer()
    end
    StartRespawnTimer()
    if Config.RespawnToHospitalMenuTimer == true then
        StartRespawnToHospitalMenuTimer()
    end
    StartScreenEffect('DeathFailOut',  0,  false)
end

function TeleportFadeEffect(entity, coords)

  Citizen.CreateThread(function()

    DoScreenFadeOut(800)

    while not IsScreenFadedOut() do
      Citizen.Wait(0)
    end

    ESX.Game.Teleport(entity, coords, function()
      DoScreenFadeIn(800)
    end)

  end)

end

function WarpPedInClosestVehicle(ped)

  local coords = GetEntityCoords(ped)

  local vehicle, distance = ESX.Game.GetClosestVehicle({
    x = coords.x,
    y = coords.y,
    z = coords.z
  })

  if distance ~= -1 and distance <= 5.0 then

    local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
    local freeSeat = nil

    for i=maxSeats - 1, 0, -1 do
      if IsVehicleSeatFree(vehicle, i) then
        freeSeat = i
        break
      end
    end

    if freeSeat ~= nil then
      TaskWarpPedIntoVehicle(ped, vehicle, freeSeat)
    end

  else
  	ESX.ShowNotification(_U('no_vehicles'))
  end

end

function OpenAmbulanceActionsMenu()

  local elements = {
    {label = _U('cloakroom'), value = 'cloakroom'},
    --{label = 'Lägg in föremål', value = 'put_stock'},
    --{label = 'Ta ut föremål', value = 'get_stock'}
  }

  if Config.EnablePlayerManagement and PlayerData.job.grade_name == 'boss' then
    table.insert(elements, {label = _U('boss_actions'), value = 'boss_actions'})
  end

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'ambulance_actions',
    {
      title    = 'Sjukvårdare',
      elements = elements
    },
    function(data, menu)

      if data.current.value == 'cloakroom' then
        OpenCloakroomMenu()
      end

      if data.current.value == 'boss_actions' then
        TriggerEvent('esx_society:openBossMenu', 'ambulance', function(data, menu)
          menu.close()
        end, {wash = false})
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

      CurrentAction     = 'ambulance_actions_menu'
      CurrentActionMsg  = _U('open_menu')
      CurrentActionData = {}

    end
  )

end

function OpenGetStocksMenu()

  ESX.TriggerServerCallback('esx_ambulancejob:getStockItems', function(items)

    local elements = {}

    for i=1, #items, 1 do
      table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = 'Ambulansskåp',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
          {
            title = 'Hur många?'
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification('Fel skrivet')
            else
              menu2.close()
              menu.close()
              TriggerServerEvent('esx_ambulancejob:getStockItem', itemName, count)
              Citizen.Wait(500)
              OpenGetStocksMenu()
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

function OpenPutStocksMenu()

  ESX.TriggerServerCallback('esx_ambulancejob:getPlayerInventory', function(inventory)

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
        title    = 'Din Ryggsäck',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
          {
            title = 'Hur många?'
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(_U('quantity_invalid'))
            else
              menu2.close()
              menu.close()
              OpenPutStocksMenu()

              TriggerServerEvent('esx_ambulancejob:putStockItems', itemName, count)
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

function OpenMobileAmbulanceActionsMenu()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'mobile_ambulance_actions',
    {
      title    = 'EMS',
      elements = {
        {label = 'EMS Meny', value = 'citizen_interaction'},
        {label = 'Överfallslarm', value = 'larm'},
      }
    },
    function(data, menu)

     --[[ if data.current.value == 'larm' then
        local x, y, z  = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
        local PlayerCoords = GetEntityCoords(GetPlayerPed(-1),  true)
        TriggerServerEvent('esx_addons_gcphone:startCall', 'police', _U('distress_message'), PlayerCoords)
      end]]

      if data.current.value == 'citizen_interaction' then

        ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'citizen_interaction',
          {
            title    = 'EMS Meny',
            elements = {
              {label = _U('ems_menu_revive'),     value = 'revive'},
              {label = _U('ems_menu_small'),      value = 'small'},
              {label = _U('drag'),                value = 'drag'},
              {label = _U('ems_menu_big'),        value = 'big'},
              {label = _U('ems_menu_putincar'),   value = 'put_in_vehicle'},
			        {label = _U('fine'),                value = 'fine'},
            }
          },
          function(data, menu)

            if data.current.value == 'larm' then
              local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
              local plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
              TriggerServerEvent('esx_addons_chrono:startCall', 'police', 'En sjukvårdvare har aktiverat sitt överfallslarm! ', {x = plyPos.x, y = plyPos.y, z = plyPos.z}, dispatch)
              --TriggerServerEvent('esx_phone:send', 'police', 'En polis har aktiverat sitt överfallslarm! ', true, {x = plyPos.x, y = plyPos.y, z = plyPos.z})
           end

           if data.current.value == 'drag' then
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
             if distance ~= -1 and distance <= 3.0 then
                TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(closestPlayer))
            end
          end
           
            if data.current.value == 'revive' then
              menu.close()
              local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
              if closestPlayer == -1 or closestDistance > 3.0 then
                ESX.ShowNotification(_U('no_players'))
              else
                                ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(qtty)
                                    if qtty > 0 then
                        local closestPlayerPed = GetPlayerPed(closestPlayer)
                        local health = GetEntityHealth(closestPlayerPed)
                        if health == 0 then
                            local playerPed = GetPlayerPed(-1)
                            Citizen.CreateThread(function()
                              ESX.ShowNotification(_U('revive_inprogress'))
                              RequestAnimDict("missheistfbi3b_ig8_2")
                              RequestAnimDict("mini@cpr@char_a@cpr_def")
                              while not HasAnimDictLoaded("missheistfbi3b_ig8_2") do
                                Citizen.Wait(0)
                              end
                              while not HasAnimDictLoaded("mini@cpr@char_a@cpr_def") do
                                Citizen.Wait(0)
                              end
                              TaskPlayAnim(GetPlayerPed(-1), "mini@cpr@char_a@cpr_def" ,"cpr_intro" ,8.0, -8.0, -1, 1, 0, false, false, false )
                              Citizen.Wait(12000)
                              TaskPlayAnim(GetPlayerPed(-1), "missheistfbi3b_ig8_2" ,"cpr_loop_paramedic" ,8.0, -8.0, -1, 1, 0, false, false, false )
                              Citizen.Wait(10000)
                              ClearPedTasks(playerPed)
                              if GetEntityHealth(closestPlayerPed) == 0 then
                                                    TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
                                TriggerServerEvent('esx_ambulancejob:revive', GetPlayerServerId(closestPlayer))
                                ESX.ShowNotification(_U('revive_complete'))
                              else
                                ESX.ShowNotification(_U('isdead'))
                              end
                            end)
                        else
                          ESX.ShowNotification(_U('unconscious'))
                        end
                                    else
                                        ESX.ShowNotification(_U('not_enough_medikit'))
                                    end
                                end, 'medikit')
				end
            end

                        if data.current.value == 'small' then
                            menu.close()
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                            if closestPlayer == -1 or closestDistance > 3.0 then
                                ESX.ShowNotification(_U('no_players'))
                            else
                                ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(qtty)
                                    if qtty > 0 then
                                        local playerPed = GetPlayerPed(-1)
                                        Citizen.CreateThread(function()
                                            ESX.ShowNotification(_U('heal_inprogress'))
                                            TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
                                            Wait(10000)
                                            ClearPedTasks(playerPed)
                                            TriggerServerEvent('esx_ambulancejob:removeItem', 'bandage')
                                            TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'small')
                                            ESX.ShowNotification(_U('heal_complete'))
                                        end)
                                    else
                                        ESX.ShowNotification(_U('not_enough_bandage'))
                                    end
                                end, 'bandage')
                            end
                        end

                                     if data.current.value == 'handcuff' then
                TriggerServerEvent('esx_policejob:handcuff', GetPlayerServerId(player))
              end

              if data.current.value == 'unhandcuff' then
                TriggerServerEvent('esx_policejob:unhandcuff', GetPlayerServerId(player))
              end
              

              if data.current.value == 'drag' then
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                if closestPlayer == -1 or closestDistance > 3.0 then
                  ESX.ShowNotification(_U('no_players'))
                else
                  RequestAnimDict('anim@heists@load_box')
                  while not HasAnimDictLoaded('anim@heists@load_box') do
                      Wait(1)
                  end
                  TaskPlayAnim(GetPlayerPed(-1), 'anim@heists@load_box', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0) -- 8.0, -8, -1, 49, 0, 0, 0, 0)
                  Citizen.Wait(500)
                  TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(closestPlayer))
                end
              end

                        if data.current.value == 'big' then
                            menu.close()
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                            if closestPlayer == -1 or closestDistance > 3.0 then
                                ESX.ShowNotification(_U('no_players'))
                            else
                                ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(qtty)
                                    if qtty > 0 then
                                        local playerPed = GetPlayerPed(-1)
                                        Citizen.CreateThread(function()
                                            ESX.ShowNotification(_U('heal_inprogress'))
                                            TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
                                            Wait(10000)
                                            ClearPedTasks(playerPed)
                                            TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
                                            TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'big')
                                            ESX.ShowNotification(_U('heal_complete'))
                                        end)
                                    else
                                        ESX.ShowNotification(_U('not_enough_medikit'))
                                    end
                                end, 'medikit')
                            end
                        end

            if data.current.value == 'put_in_vehicle' then
              menu.close()
              WarpPedInClosestVehicle(GetPlayerPed(closestPlayer))
            end
						
			local player, distance = ESX.Game.GetClosestPlayer()
			
			if distance ~= -1 and distance <= 3.0 then
				if data.current.value == 'put_in_vehicle' then
					menu.close()
					TriggerServerEvent('esx_ambulancejob:putInVehicle', GetPlayerServerId(player))
				end
				
				if data.current.value == 'fine' then
					OpenFineMenu(player)
				end
			else
        ESX.ShowNotification(_U('no_players_nearby'))
			end

          end,
          function(data, menu)
            menu.close()
          end
        )

      end

    end,
    function(data, menu)
      menu.close()
    end
  )

end

function OpenFineMenu(player)

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'fine',
    {
      title    = _U('fine'),
      align    = 'right',
      elements = {
        {label = _U('ambulance_consultation'),   value = 0},
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



function OpenFineCategoryMenu(player, category)

  ESX.TriggerServerCallback('esx_ambulancejob:getFineList', function(fines)

    local elements = {}

    for i=1, #fines, 1 do
      table.insert(elements, {
        label     = fines[i].label .. ' $' .. fines[i].amount,
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
          TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_ambulance', _U('fine_total') .. label, amount)
        else
          TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), '', _U('fine_total') .. label, amount)
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

function OpenCloakroomMenu()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'cloakroom',
    {
      title    = 'Omklädningsrum',
      align    = 'right',
      elements = {
        {label = 'Civilakläder', value = 'citizen_wear'},
        {label = 'Arbetskläder (Pike)', value = 'ambulance_wear_pike'},
        {label = 'Arbetskläder (Tröja)', value = 'ambulance_wear_trojan'},
        {label = 'Arbetskläder (Jacka)', value = 'ambulance_wear_jacka'},
        {label = 'Arbetskläder (Operationsskjorta)', value = 'ambulance_wear_operation'},
        --{label = 'Skyddsoverall', value = 'virus_wear'},
        {label = 'Chefskläder', value = 'boss_wear'}
      },
    },
    function(data, menu)

      menu.close()

      if data.current.value == 'citizen_wear' then

        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
          TriggerEvent('skinchanger:loadSkin', skin)
        end)

      end

      if data.current.value == 'virus_wear' then
        TriggerEvent('skinchanger:getSkin', function(skin)
          if skin.sex == 0 then
            TriggerEvent('skinchanger:loadClothes', skin, Config.VirusWear.male)
          else
            TriggerEvent('skinchanger:loadClothes', skin, Config.VirusWear.female)
          end
        end)
      end

      if data.current.value == 'ambulance_wear_pike' then
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

            local playerPed = GetPlayerPed(-1)
            SetPedArmour(playerPed, 0)
            ClearPedBloodDamage(playerPed)
            ResetPedVisibleDamage(playerPed)
            ClearPedLastWeaponDamage(playerPed)
            
        end)
      end

if data.current.value == 'ambulance_wear_operation' then
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

            local playerPed = GetPlayerPed(-1)
            SetPedArmour(playerPed, 0)
            ClearPedBloodDamage(playerPed)
            ResetPedVisibleDamage(playerPed)
            ClearPedLastWeaponDamage(playerPed)
            
        end)
      end



if data.current.value == 'ambulance_wear_trojan' then
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

            local playerPed = GetPlayerPed(-1)
            SetPedArmour(playerPed, 0)
            ClearPedBloodDamage(playerPed)
            ResetPedVisibleDamage(playerPed)
            ClearPedLastWeaponDamage(playerPed)
            
        end)
      end

if data.current.value == 'ambulance_wear_jacka' then
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

            local playerPed = GetPlayerPed(-1)
            SetPedArmour(playerPed, 0)
            ClearPedBloodDamage(playerPed)
            ResetPedVisibleDamage(playerPed)
            ClearPedLastWeaponDamage(playerPed)
            
        end)
      end


      if data.current.value == 'boss_wear' then
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

            local playerPed = GetPlayerPed(-1)
            SetPedArmour(playerPed, 50)
            ClearPedBloodDamage(playerPed)
            ResetPedVisibleDamage(playerPed)
            ClearPedLastWeaponDamage(playerPed)
            
        end)
      end

      CurrentAction     = 'ambulance_actions_menu'
      CurrentActionMsg  = _U('open_menu')
      CurrentActionData = {}

    end,
    function(data, menu)
      menu.close()
    end
  )

end

function OpenVehicleSpawnerMenu()

  ESX.UI.Menu.CloseAll()

  if Config.EnableSocietyOwnedVehicles then

    local elements = {}

    ESX.TriggerServerCallback('esx_society:getVehiclesInGarage', function(vehicles)

      for i=1, #vehicles, 1 do
        table.insert(elements, {label = GetDisplayNameFromVehicleModel(vehicles[i].model) .. ' [' .. vehicles[i].plate .. ']', value = vehicles[i]})
      end

      ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'vehicle_spawner',
        {
          title    = _U('veh_menu'),
          align    = 'right',
          elements = elements,
        },
        function(data, menu)

          menu.close()

          local vehicleProps = data.current.value

          ESX.Game.SpawnVehicle(vehicleProps.model, Config.Zones.VehicleSpawnPoint.Pos, 112.0, function(vehicle)
          local props = ESX.Game.GetVehicleProperties(vehicle)

          props.plate = 'AMBULANS'

          ESX.Game.SetVehicleProperties(vehicle, props)

          local reg = GetVehicleNumberPlateText(vehicle)
          TriggerServerEvent("LegacyFuel:UpdateServerFuelTable", reg, 100)
          local playerPed = GetPlayerPed(-1)
          TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
          end)

          TriggerServerEvent('esx_society:removeVehicleFromGarage', 'ambulance', vehicleProps)

        end,
        function(data, menu)

          menu.close()

          CurrentAction     = 'vehicle_spawner_menu'
          CurrentActionMsg  = _U('veh_spawn')
          CurrentActionData = {}

        end
      )

    end, 'ambulance')

  else

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vehicle_spawner',
      {
        title    = _U('veh_menu'),
        align    = 'right',
        elements = {
          {label = 'Ambulans - Volvo XC70', value = 'ambulance'},
          {label = 'Ambulans - Volkswagen Amarok', value = 'ambulance2'},
          {label = 'Ambulans - Volvo XC90 Nilsson', value = 'xc90n'},
          {label = 'Akutbil', value = 'policeold2'},      

        },
      },
      function(data, menu)
        menu.close()
        local model = data.current.value
        ESX.Game.SpawnVehicle(model, Config.Zones.VehicleSpawnPoint.Pos, 112.0, function(vehicle)
          local props = ESX.Game.GetVehicleProperties(vehicle)

          props.plate = 'AMBULANS'

          ESX.Game.SetVehicleProperties(vehicle, props)

          TriggerEvent("advancedFuel:setEssence", 100, GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
          local playerPed = GetPlayerPed(-1)
          TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
	  SetVehicleMaxMods(vehicle)
        end)
      end,
      function(data, menu)
        menu.close()
        CurrentAction     = 'vehicle_spawner_menu'
        CurrentActionMsg  = _U('veh_spawn')
        CurrentActionData = {}
      end
    )

  end

end

function OpenVehicleSpawnerMenu2()

  ESX.UI.Menu.CloseAll()

  if Config.EnableSocietyOwnedVehicles then

    local elements = {}

    ESX.TriggerServerCallback('esx_society:getVehiclesInGarage', function(vehicles)

      for i=1, #vehicles, 1 do
        table.insert(elements, {label = GetDisplayNameFromVehicleModel(vehicles[i].model) .. ' [' .. vehicles[i].plate .. ']', value = vehicles[i]})
      end

      ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'vehicle_spawner2',
        {
          title    = _U('veh_menu'),
          align    = 'right',
          elements = elements,
        },
        function(data, menu)

          menu.close()

          local vehicleProps = data.current.value

          ESX.Game.SpawnVehicle(vehicleProps.model, Config.Zones.VehicleSpawnPoint2.Pos, 112.0, function(vehicle)
          local props = ESX.Game.GetVehicleProperties(vehicle)

          props.plate = 'AMBULANS'

          ESX.Game.SetVehicleProperties(vehicle, props)

          local reg = GetVehicleNumberPlateText(vehicle)
          TriggerServerEvent("LegacyFuel:UpdateServerFuelTable", reg, 100)
          local playerPed = GetPlayerPed(-1)
          TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
          end)

          TriggerServerEvent('esx_society:removeVehicleFromGarage', 'ambulance', vehicleProps)

        end,
        function(data, menu)

          menu.close()

          CurrentAction     = 'vehicle_spawner_menu2'
          CurrentActionMsg  = _U('veh_spawn')
          CurrentActionData = {}

        end
      )

    end, 'ambulance')

  else

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vehicle_spawner2',
      {
        title    = _U('veh_menu'),
        align    = 'right',
        elements = {
          {label = 'Ambulans heli', value = 'frogger'},    

        },
      },
      function(data, menu)
        menu.close()
        local model = data.current.value
        ESX.Game.SpawnVehicle(model, Config.Zones.VehicleSpawnPoint2.Pos, 112.0, function(vehicle)
          local props = ESX.Game.GetVehicleProperties(vehicle)

          props.plate = 'AMBULANS'

          ESX.Game.SetVehicleProperties(vehicle, props)

          TriggerEvent("advancedFuel:setEssence", 100, GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
          local playerPed = GetPlayerPed(-1)
          TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
	  SetVehicleMaxMods(vehicle)
        end)
      end,
      function(data, menu)
        menu.close()
        CurrentAction     = 'vehicle_spawner_menu2'
        CurrentActionMsg  = _U('veh_spawn')
        CurrentActionData = {}
      end
    )

  end

end

function OpenPharmacyMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'pharmacy',
        {
            title    = _U('pharmacy_menu_title'),
            align    = 'right',
            elements = {
                {label = _U('inventory') .. ' ' .. _('medikit'),  value = 'medikit'},
                {label = _U('inventory') .. ' ' .. _('bandage'),  value = 'bandage'},
                {label = _U('inventory') .. ' ' .. _('xanax'),  value = 'xanax'},
                {label = _U('inventory') .. ' ' .. _('radio'),  value = 'radio'},
                --{label = _U('inventory') .. ' ' .. _('ambulancecard'),  value = 'ambulancecard'},
            },
        },
        function(data, menu)
            TriggerServerEvent('esx_ambulancejob:giveItem', data.current.value)
        end,
        function(data, menu)
            menu.close()
            CurrentAction     = 'pharmacy'
            CurrentActionMsg  = _U('open_pharmacy')
            CurrentActionData = {}
        end
    )
end

AddEventHandler('playerSpawned', function()

  IsDead = false

  if FirstSpawn then
    exports.spawnmanager:setAutoSpawn(false)
    FirstSpawn = false
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

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)

  local specialContact = {
    name       = 'Ambulans',
    number     = 'ambulance',
    base64Icon = 'data:image/png;base64,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'
  }

  TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)

end)

AddEventHandler('baseevents:onPlayerDied', function(killerType, coords)
  OnPlayerDeath()
end)

AddEventHandler('baseevents:onPlayerKilled', function(killerId, data)
  OnPlayerDeath()
end)

RegisterNetEvent('esx_ambulancejob:revive')
AddEventHandler('esx_ambulancejob:revive', function()

  local playerPed = GetPlayerPed(-1)
  local coords    = GetEntityCoords(playerPed)

  Citizen.CreateThread(function()

    DoScreenFadeOut(800)

    while not IsScreenFadedOut() do
      Citizen.Wait(0)
    end

    ESX.SetPlayerData('lastPosition', {
      x = coords.x,
      y = coords.y,
      z = coords.z
    })

    TriggerServerEvent('esx:updateLastPosition', {
      x = coords.x,
      y = coords.y,
      z = coords.z
    })

    RespawnPed(playerPed, {
      x = coords.x,
      y = coords.y,
      z = coords.z
    })

    StopScreenEffect('DeathFailOut')

    DoScreenFadeIn(800)

  end)

end)

AddEventHandler('esx_ambulancejob:hasEnteredMarker', function(zone)

  if zone == 'HospitalInteriorEntering1' then
    TeleportFadeEffect(GetPlayerPed(-1), Config.Zones.HospitalInteriorInside1.Pos)
  end

  if zone == 'HospitalInteriorExit1' then
    TeleportFadeEffect(GetPlayerPed(-1), Config.Zones.HospitalInteriorOutside1.Pos)
  end

  if zone == 'HospitalInteriorEntering2' then
        local heli = Config.HelicopterSpawner

        if not IsAnyVehicleNearPoint(heli.SpawnPoint.x, heli.SpawnPoint.y, heli.SpawnPoint.z, 3.0)
            and PlayerData.job ~= nil and PlayerData.job.name == 'ambulance' then
            ESX.Game.SpawnVehicle('frogger', {
                x = heli.SpawnPoint.x,
                y = heli.SpawnPoint.y,
                z = heli.SpawnPoint.z
            }, heli.Heading, function(vehicle)
                SetVehicleModKit(vehicle, 0)
                SetVehicleLivery(vehicle, 1)
            end)

        end
    TeleportFadeEffect(GetPlayerPed(-1), Config.Zones.HospitalInteriorInside2.Pos)
  end

  if zone == 'HospitalInteriorExit2' then
    TeleportFadeEffect(GetPlayerPed(-1), Config.Zones.HospitalInteriorOutside2.Pos)
  end

    if zone == 'ParkingDoorGoOutInside' then
        TeleportFadeEffect(GetPlayerPed(-1), Config.Zones.ParkingDoorGoOutOutside.Pos)
    end

    if zone == 'ParkingDoorGoInOutside' then
        TeleportFadeEffect(GetPlayerPed(-1), Config.Zones.ParkingDoorGoInInside.Pos)
    end

  if zone == 'AmbulanceActions' then
    CurrentAction     = 'ambulance_actions_menu'
    CurrentActionMsg  = _U('open_menu')
    CurrentActionData = {}
  end

  if zone == 'VehicleSpawner' then
    CurrentAction     = 'vehicle_spawner_menu'
    CurrentActionMsg  = _U('veh_spawn')
    CurrentActionData = {}
  end

  if zone == 'VehicleSpawner2' then
    CurrentAction     = 'vehicle_spawner_menu2'
    CurrentActionMsg  = _U('veh_spawn')
    CurrentActionData = {}
  end

    if zone == 'Pharmacy' then
        CurrentAction     = 'pharmacy'
        CurrentActionMsg  = _U('open_pharmacy')
        CurrentActionData = {}
    end

    if zone == 'VehicleDeleter' then

      local playerPed = GetPlayerPed(-1)
      local coords    = GetEntityCoords(playerPed)
  
      if IsPedInAnyVehicle(playerPed,  false) then
  
        local vehicle, distance = ESX.Game.GetClosestVehicle({
          x = coords.x,
          y = coords.y,
          z = coords.z
        })
  
        if distance ~= -1 and distance <= 1.0 then
  
          CurrentAction     = 'delete_vehicle'
          CurrentActionMsg  = _U('store_veh')
          CurrentActionData = {vehicle = vehicle}
  
        end
  
      end
  
    end
  
    if zone == 'VehicleDeleter2' then
  
      local playerPed = GetPlayerPed(-1)
      local coords    = GetEntityCoords(playerPed)
  
      if IsPedInAnyVehicle(playerPed,  false) then
  
        local vehicle, distance = ESX.Game.GetClosestVehicle({
          x = coords.x,
          y = coords.y,
          z = coords.z
        })
  
        if distance ~= -1 and distance <= 1.0 then
  
          CurrentAction     = 'delete_vehicle'
          CurrentActionMsg  = _U('store_veh')
          CurrentActionData = {vehicle = vehicle}
  
        end
  
      end
  
    end
  
  end)

function FastTravel(pos)
    TeleportFadeEffect(GetPlayerPed(-1), pos)
end

AddEventHandler('esx_ambulancejob:hasExitedMarker', function(zone)
  ESX.UI.Menu.CloseAll()
  CurrentAction = nil
end)



RegisterNetEvent('esx_policejob:handcuff')
AddEventHandler('esx_policejob:handcuff', function()
  IsHandcuffed    = not IsHandcuffed;
  
  local dict = "mp_arresting"
  local anim = "idle"
  local flags = 49
  local ped = PlayerPedId()
  local changed = false
  local prevMaleVariation = 0
  local prevFemaleVariation = 0
  local femaleHash = GetHashKey("mp_f_freemode_01")
  local maleHash = GetHashKey("mp_m_freemode_01")

    ped = GetPlayerPed(-1)
    RequestAnimDict(dict)

    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(0)
    end

        ClearPedTasks(ped)
        SetEnableHandcuffs(ped, false)
        UncuffPed(ped)

        if GetEntityModel(ped) == femaleHash or GetEntityModel(ped) == maleHash then
      if IsHandcuffed then
      SetEnableHandcuffs(ped, true)
      TaskPlayAnim(ped, dict, anim, 8.0, -8, -1, flags, 0, 0, 0, 0)
        else
      SetEnableHandcuffs(ped, false)
      ClearPedSecondaryTask(playerPed)
        end
  end
end)

--[[Citizen.CreateThread(function()
  while true do
    Wait(0)
    if IsDragged then
      local ped = GetPlayerPed(GetPlayerFromServerId(CopPed))
      local myped = GetPlayerPed(-1)
      RequestAnimDict('amb@world_human_bum_slumped@male@laying_on_right_side@base')
      while not HasAnimDictLoaded('amb@world_human_bum_slumped@male@laying_on_right_side@base') do
          Wait(1)
      end
      TaskPlayAnim(myped, 'amb@world_human_bum_slumped@male@laying_on_right_side@base', 'base', 8.0, 8.0, -1, 9, 0, false, false, false )
      AttachEntityToEntity(myped, ped, GetPedBoneIndex(myped, 57005), -0.32, -0.6, -0.35, 240.0, 35.0, 149.0, true, true, false, true, 1, true)
    else
      DetachEntity(GetPlayerPed(-1), true, false)
    end
  end
end)]]

-- Handcuff
Citizen.CreateThread(function()
  while true do
    Wait(0)
    if IsHandcuffed then
    DisableControlAction(0, 69, true) -- INPUT_VEH_ATTACK
    DisableControlAction(0, 92, true) -- INPUT_VEH_PASSENGER_ATTACK
    DisableControlAction(0, 114, true) -- INPUT_VEH_FLY_ATTACK
    DisableControlAction(0, 140, true) -- INPUT_MELEE_ATTACK_LIGHT
    DisableControlAction(0, 141, true) -- INPUT_MELEE_ATTACK_HEAVY
    DisableControlAction(0, 142, true) -- INPUT_MELEE_ATTACK_ALTERNATE
    DisableControlAction(0, 257, true) -- INPUT_ATTACK2
    DisableControlAction(0, 263, true) -- INPUT_MELEE_ATTACK1
    DisableControlAction(0, 264, true) -- INPUT_MELEE_ATTACK2
    DisableControlAction(0, 24, true) -- INPUT_ATTACK
    DisableControlAction(0, 25, true) -- INPUT_AIM
    DisableControlAction(0, 21, true) -- SHIFT
    DisableControlAction(0, 22, true) -- SPACE
    DisableControlAction(0, 288, true) -- F1
    DisableControlAction(0, 289, true) -- F2
    DisableControlAction(0, 170, true) -- F3
    DisableControlAction(0, 167, true) -- F6
    DisableControlAction(0, 168, true) -- F7
    DisableControlAction(0, 57, true) -- F10
    DisableControlAction(0, 73, true) -- X
    end
  end
end)



-- Create blips
Citizen.CreateThread(function()

  local blip = AddBlipForCoord(Config.Blip.Pos.x, Config.Blip.Pos.y, Config.Blip.Pos.z)

  SetBlipSprite (blip, Config.Blip.Sprite)
  SetBlipDisplay(blip, Config.Blip.Display)
  SetBlipScale  (blip, Config.Blip.Scale)
  SetBlipColour (blip, Config.Blip.Colour)
  SetBlipAsShortRange(blip, true)

  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString(_U('hospital'))
  EndTextCommandSetBlipName(blip)

end)

-- Display markers
Citizen.CreateThread(function()
  while true do
    Wait(0)

    local coords = GetEntityCoords(GetPlayerPed(-1))
    for k,v in pairs(Config.Zones) do
      if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
                if PlayerData.job ~= nil and PlayerData.job.name == 'ambulance' then
                    DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
                elseif k ~= 'AmbulanceActions' and k ~= 'VehicleSpawner' and k ~= 'VehicleDeleter'
                    and k ~= 'Pharmacy' and k ~= 'StairsGoTopBottom' and k ~= 'StairsGoBottomTop' then
                    DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
                end
      end
    end
  end
end)

-- Activate menu when player is inside marker
Citizen.CreateThread(function()
  while true do
    Wait(0)
    local coords      = GetEntityCoords(GetPlayerPed(-1))
    local isInMarker  = false
    local currentZone = nil
    for k,v in pairs(Config.Zones) do
            if PlayerData.job ~= nil and PlayerData.job.name == 'ambulance' then
                if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
                    isInMarker  = true
                    currentZone = k
                end
            elseif k ~= 'AmbulanceActions' and k ~= 'VehicleSpawner' and k ~= 'VehicleDeleter'
                and k ~= 'Pharmacy' and k ~= 'StairsGoTopBottom' and k ~= 'StairsGoBottomTop' then
                if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
                    isInMarker  = true
                    currentZone = k
                end
            end
    end
    if isInMarker and not hasAlreadyEnteredMarker then
      hasAlreadyEnteredMarker = true
      lastZone                = currentZone
      TriggerEvent('esx_ambulancejob:hasEnteredMarker', currentZone)
    end
    if not isInMarker and hasAlreadyEnteredMarker then
      hasAlreadyEnteredMarker = false
      TriggerEvent('esx_ambulancejob:hasExitedMarker', lastZone)
    end

  end
end)

-- Key Controls
Citizen.CreateThread(function()
  while true do

    Citizen.Wait(0)

    if CurrentAction ~= nil then

      SetTextComponentFormat('STRING')
      AddTextComponentString(CurrentActionMsg)
      DisplayHelpTextFromStringLabel(0, 0, 1, -1)

      if IsControlJustReleased(0, Keys['E']) and PlayerData.job ~= nil and PlayerData.job.name == 'ambulance' then

        if CurrentAction == 'ambulance_actions_menu' then
          OpenAmbulanceActionsMenu()
        end

        if CurrentAction == 'vehicle_spawner_menu' then
          OpenVehicleSpawnerMenu()
        end

        if CurrentAction == 'vehicle_spawner_menu2' then
          OpenVehicleSpawnerMenu2()
        end

                if CurrentAction == 'pharmacy' then
                    OpenPharmacyMenu()
                end

                if CurrentAction == 'fast_travel_goto_top' or CurrentAction == 'fast_travel_goto_bottom' then
                    FastTravel(CurrentActionData.pos)
                end

        if CurrentAction == 'delete_vehicle' then
          if Config.EnableSocietyOwnedVehicles then
            local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
            TriggerServerEvent('esx_society:putVehicleInGarage', 'ambulance', vehicleProps)
          end
          ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
        end

        CurrentAction = nil

      end

    end

    if IsControlJustReleased(0, Keys['F6']) and PlayerData.job ~= nil and PlayerData.job.name == 'ambulance' then
      OpenMobileAmbulanceActionsMenu()
    end
		
    if IsControlPressed(0,  Keys['DELETE']) and (GetGameTimer() - GUI.Time) > 150 then

      if OnJob then
        StopAmbulanceJob()
      else

        if PlayerData.job ~= nil and PlayerData.job.name == 'ambulance' then

          local playerPed = GetPlayerPed(-1)

          if IsPedInAnyVehicle(playerPed,  false) then

            local vehicle = GetVehiclePedIsIn(playerPed,  false)

            if PlayerData.job.grade >= 3 then
              StartAmbulanceJob()
            else
              if GetEntityModel(vehicle) == GetHashKey('ambulance') then
                StartAmbulanceJob()
              else
                ESX.ShowNotification('Du måste sitta i en ambulans')
              end
            end

          else

            if PlayerData.job.grade >= 3 then
              ESX.ShowNotification(_U('must_in_vehicle'))
            else
              ESX.ShowNotification('Du måste sitta i en ambulans')
            end

          end

        end

      end

      GUI.Time = GetGameTimer()

    end
    end
end)

-- Load unloaded IPLs
Citizen.CreateThread(function()
  LoadMpDlcMaps()
  EnableMpDlcMaps(true)
  RequestIpl('Coroner_Int_on') -- Morgue
end)

-- String string
function stringsplit(inputstr, sep)
  if sep == nil then
      sep = "%s"
  end
  local t={} ; i=1
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
      t[i] = str
      i = i + 1
  end
  return t
end

 --- action functions
 local CurrentAction           = nil
 local CurrentActionMsg        = ''
 local CurrentActionData       = {}
 local HasAlreadyEnteredMarker = false
 local LastZone                = nil
 local press = false
 
 
 --- esx
 local GUI = {}
 ESX                           = nil
 GUI.Time                      = 0
 local PlayerData              = {}
 
 Citizen.CreateThread(function ()
 while ESX == nil do
   TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
   Citizen.Wait(0)
    PlayerData = ESX.GetPlayerData()
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
 
 ----markers
 AddEventHandler('esx_passerkort:hasEnteredMarker', function (zone)
 if zone == 'SjukhusCard' then
   CurrentAction     = 'police_card'
   CurrentActionData = {}
   end
 end)
 
 AddEventHandler('esx_passerkort:hasExitedMarker', function (zone)
 CurrentAction = nil
 end)
 
 --keycontrols
 Citizen.CreateThread(function ()
 while true do
   Citizen.Wait(0)
 
   local playerPed = GetPlayerPed(-1)
 
   if CurrentAction ~= nil then
   SetTextComponentFormat('STRING')
   AddTextComponentString(CurrentActionMsg)
   DisplayHelpTextFromStringLabel(0, 0, 1, -1)
   Draw3DText(310.51, -598.02, 43.29, '[~g~E~w~] för att hämta/lämna ut/in nyckel')
   if IsControlJustReleased(0, Keys['E']) then
      if CurrentAction == 'police_card' then
       if PlayerData.job.name == 'ambulance' then
       TriggerServerEvent('card:giveItem')
       else 
       sendNotification('Du är inte anställd inom Sjukvården.', 'error', 2300)
       end
      end
    end
   end
 end
 end)
 
 -- Display markers
 Citizen.CreateThread(function ()
 while true do
   Wait(0)
 
   local coords = GetEntityCoords(GetPlayerPed(-1))
 
   for k,v in pairs(Config.Zones) do
   if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
     DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, false, true, 2, false, false, false, false)
   end
   end
 end
 end)
 
 -- Enter / Exit marker events
 Citizen.CreateThread(function ()
 while true do
   Wait(0)
 
   local coords      = GetEntityCoords(GetPlayerPed(-1))
   local isInMarker  = false
   local currentZone = nil
 
   for k,v in pairs(Config.Zones) do
   if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
     isInMarker  = true
     currentZone = k
   end
   end
 
   if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
   HasAlreadyEnteredMarker = true
   LastZone                = currentZone
   TriggerEvent('esx_passerkort:hasEnteredMarker', currentZone)
   end
 
   if not isInMarker and HasAlreadyEnteredMarker then
   HasAlreadyEnteredMarker = false
   TriggerEvent('esx_passerkort:hasExitedMarker', LastZone)
     end
   end
 end)
 
 --notification
 function sendNotification(message, messageType, messageTimeout)
   TriggerEvent("pNotify:SendNotification", {
     text = message,
     type = messageType,
     queue = "wille",
     timeout = messageTimeout,
     layout = "bottomCenter"
   })
 end
 
 
 function Draw3DText(x, y, z, text)
 local onScreen,_x,_y=World3dToScreen2d(x,y,z)
 local px,py,pz=table.unpack(GetGameplayCamCoords())
 
 local scale = 0.5
  
 if onScreen then
   SetTextScale(scale, scale)
   SetTextFont(4)
   SetTextProportional(1)
   SetTextColour(255, 255, 255, 215)
   SetTextOutline()
   SetTextEntry("STRING")
   SetTextCentre(1)
   AddTextComponentString(text)
   DrawText(_x,_y)
   
   local factor = (string.len(text)) / 370
  
     DrawRect(_x, _y + 0.0160, 0.040 + factor, 0.040, 11, 11, 41, 110)
 
 end
 end
 
 
 --[[function hintToDisplay(text)
 SetTextComponentFormat("STRING")
 AddTextComponentString(text)
 DisplayHelpTextFromStringLabel(0, 0, 1, -1)
 end]]--


