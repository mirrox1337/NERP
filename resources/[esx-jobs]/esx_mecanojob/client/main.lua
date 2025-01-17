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

local PlayerData              = {}
local GUI                     = {}
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local OnJob                   = false
local TargetCoords            = nil
local CurrentlyTowedVehicle   = nil
local Blips                   = {}
local NPCOnJob                = false
local NPCTargetTowable         = nil
local NPCTargetTowableZone     = nil
local NPCHasSpawnedTowable    = false
local NPCLastCancel           = GetGameTimer() - 5 * 60000
local NPCHasBeenNextToTowable = false

ESX                           = nil
GUI.Time                      = 0

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

function SelectRandomTowable()

  local index = GetRandomIntInRange(1,  #Config.Towables)

  for k,v in pairs(Config.Zones) do
    if v.Pos.x == Config.Towables[index].x and v.Pos.y == Config.Towables[index].y and v.Pos.z == Config.Towables[index].z then
      return k
    end
  end

end

function StartNPCJob()

  NPCOnJob = true

  NPCTargetTowableZone = SelectRandomTowable()
  local zone       = Config.Zones[NPCTargetTowableZone]

  Blips['NPCTargetTowableZone'] = AddBlipForCoord(zone.Pos.x,  zone.Pos.y,  zone.Pos.z)
  SetBlipRoute(Blips['NPCTargetTowableZone'], true)

  ESX.ShowNotification(_U('drive_to_indicated'))
end

function StopNPCJob(cancel)

  if Blips['NPCTargetTowableZone'] ~= nil then
    RemoveBlip(Blips['NPCTargetTowableZone'])
    Blips['NPCTargetTowableZone'] = nil
  end

  if Blips['NPCDelivery'] ~= nil then
    RemoveBlip(Blips['NPCDelivery'])
    Blips['NPCDelivery'] = nil
  end


  Config.Zones.VehicleDelivery.Type = -1

  NPCOnJob                = false
  NPCTargetTowable        = nil
  NPCTargetTowableZone    = nil
  NPCHasSpawnedTowable    = false
  NPCHasBeenNextToTowable = false

  if cancel then
    ESX.ShowNotification(_U('mission_canceled'))
  else
    TriggerServerEvent('esx_mecanojob:onNPCJobCompleted')
  end

end

function OpenMecanoActionsMenu()

  local elements = {
    {label = _U('vehicle_list'), value = 'vehicle_list'},
    {label = _U('work_wear'), value = 'cloakroom'},
    {label = _U('civ_wear'), value = 'cloakroom2'},
    {label = 'Plocka ut ett dyrkset', value = 'take_lockpick'},
    {label = 'Plocka ut en nyckel', value = 'take_nyckel'},
    {label = 'Öppna förrådet och lägg in', value = 'put_stock'},
    {label ='Öppna förrådet och ta ut', value = 'get_stock'}
  }
  if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.grade_name == 'boss' then
    table.insert(elements, {label = 'VD-Meny', value = 'boss_actions'})
  end

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'mecano_actions',
    {
      title    = _U('mechanic'),
      elements = elements
    },
    function(data, menu)
      if data.current.value == 'vehicle_list' then

        if Config.EnableSocietyOwnedVehicles then

            local elements = {}

            ESX.TriggerServerCallback('esx_society:getVehiclesInGarage', function(vehicles)

              for i=1, #vehicles, 1 do
                table.insert(elements, {label = GetDisplayNameFromVehicleModel(vehicles[i].model) .. ' [' .. vehicles[i].plate .. ']', value = vehicles[i]})
              end

              ESX.UI.Menu.Open(
                'default', GetCurrentResourceName(), 'vehicle_spawner',
                {
                  title    = _U('service_vehicle'),
                  align    = 'right',
                  elements = elements,
                },
                function(data, menu)

                  menu.close()

                  local vehicleProps = data.current.value

                  ESX.Game.SpawnVehicle(vehicleProps.model, Config.Zones.VehicleSpawnPoint.Pos, 270.0, function(vehicle)
                    ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
                    local playerPed = GetPlayerPed(-1)
                    TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
                  end)

                  TriggerServerEvent('esx_society:removeVehicleFromGarage', 'mecano', vehicleProps)

                end,
                function(data, menu)
                  menu.close()
                end
              )

            end, 'mecano')

          else

            local elements = {
              {label = _U('flat_bed'), value = 'flatbed'},
              {label = _U('towtruck'), value = 'towtruck'},
              {label = _U('trans_mbxclass'), value = 'trans_mbxclass'},
              {label = _U('veln'), value = 'veln'},       
            }

            ESX.UI.Menu.CloseAll()

            ESX.UI.Menu.Open(
              'default', GetCurrentResourceName(), 'spawn_vehicle',
              {
                title    = _U('service_vehicle'),
                elements = elements
              },
              function(data, menu)
                for i=1, #elements, 1 do
                  if Config.MaxInService == -1 then
                    ESX.Game.SpawnVehicle(data.current.value, Config.Zones.VehicleSpawnPoint.Pos, 90.0, function(vehicle)
                      local props = ESX.Game.GetVehicleProperties(vehicle)

                      props.plate = 'MEKONOM'

                      ESX.Game.SetVehicleProperties(vehicle, props)

                      TriggerEvent("advancedFuel:setEssence", 100, GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
                      local playerPed = GetPlayerPed(-1)
                      TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                    end)
                    break
                  else
                    ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)
                      if canTakeService then
                        ESX.Game.SpawnVehicle(data.current.value, Config.Zones.VehicleSpawnPoint.Pos, 90.0, function(vehicle)
                          local playerPed = GetPlayerPed(-1)
                          TaskWarpPedIntoVehicle(playerPed,  vehicle, -1)
                        end)
                      else
                        ESX.ShowNotification(_U('service_full') .. inServiceCount .. '/' .. maxInService)
                      end
                    end, 'mecano')
                    break
                  end
                end
                menu.close()
              end,
              function(data, menu)
                menu.close()
                OpenMecanoActionsMenu()
              end
            )

          end
      end

      if data.current.value == 'cloakroom' then
        menu.close()
        TriggerEvent('skinchanger:getSkin', function(skin)
        
            if skin.sex == 0 then

                local clothesSkin = {
                    ['tshirt_1'] = 15, ['tshirt_2'] = 0,
                    ['torso_1'] = 235, ['torso_2'] = 10,
                    ['arms'] = 30,
                    ['pants_1'] = 98, ['pants_2'] = 16,
                    ['shoes_1'] = 31, ['shoes_2'] = 1,
                    ['mask_1'] = 121, ['mask_2'] = 0,
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

            else

                local clothesSkin = {
                    ['tshirt_1'] = 15, ['tshirt_2'] = 0,
                    ['torso_1'] = 253, ['torso_2'] = 0,
                    ['arms'] = 21,
                    ['pants_1'] = 101, ['pants_2'] = 16,
                    ['shoes_1'] = 60, ['shoes_2'] = 0,
                    ['mask_1'] = 0, ['mask_2'] = 0,
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

            end

        end)
      end

      if data.current.value == 'cloakroom2' then
        menu.close()
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

            TriggerEvent('skinchanger:loadSkin', skin)

        end)
      end

      if data.current.value == 'put_stock' then
        OpenPutStocksMenu()
      end

      if data.current.value == 'get_stock' then
        OpenGetStocksMenu()
      end

      if data.current.value == 'take_lockpick' then
        ESX.TriggerServerCallback('esx_mecanojob:takelockpick')
      end

      if data.current.value == 'take_nyckel' then
        ESX.TriggerServerCallback('esx_mecanojob:takenyckel')
      end

      if data.current.value == 'boss_actions' then
        TriggerEvent('esx_society:openBossMenu', 'mecano', function(data, menu)
          menu.close()
        end)
      end

    end,
    function(data, menu)
      menu.close()
      CurrentAction     = 'mecano_actions_menu'
      CurrentActionMsg  = _U('open_actions')
      CurrentActionData = {}
    end
  )
end

function OpenMecanoHarvestMenu()

  if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.grade_name ~= 'recrue' then
    local elements = {
      {label = _U('gas_can'), value = 'gaz_bottle'},
      {label = _U('repair_tools'), value = 'fix_tool'},
      {label = _U('body_work_tools'), value = 'caro_tool'}
    }

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'mecano_harvest',
      {
        title    = _U('harvest'),
        elements = elements
      },
      function(data, menu)
        if data.current.value == 'gaz_bottle' then
          menu.close()
          TriggerServerEvent('esx_mecanojob:startHarvest')
        end

        if data.current.value == 'fix_tool' then
          menu.close()
          TriggerServerEvent('esx_mecanojob:startHarvest2')
        end

        if data.current.value == 'caro_tool' then
          menu.close()
          TriggerServerEvent('esx_mecanojob:startHarvest3')
        end

      end,
      function(data, menu)
        menu.close()
        CurrentAction     = 'mecano_harvest_menu'
        CurrentActionMsg  = _U('harvest_menu')
        CurrentActionData = {}
      end
    )
  else
    ESX.ShowNotification(_U('not_experienced_enough'))
  end
end

function OpenMecanoCraftMenu()
  if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.grade_name ~= 'recrue' then

    local elements = {
      {label = _U('blowtorch'), value = 'blow_pipe'},
      {label = _U('repair_kit'), value = 'fix_kit'},
      {label = _U('body_kit'), value = 'caro_kit'}
    }

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'mecano_craft',
      {
        title    = _U('craft'),
        elements = elements
      },
      function(data, menu)
        if data.current.value == 'blow_pipe' then
          menu.close()
          TriggerServerEvent('esx_mecanojob:startCraft')
        end

        if data.current.value == 'fix_kit' then
          menu.close()
          TriggerServerEvent('esx_mecanojob:startCraft2')
        end

        if data.current.value == 'caro_kit' then
          menu.close()
          TriggerServerEvent('esx_mecanojob:startCraft3')
        end

      end,
      function(data, menu)
        menu.close()
        CurrentAction     = 'mecano_craft_menu'
        CurrentActionMsg  = _U('craft_menu')
        CurrentActionData = {}
      end
    )
  else
    ESX.ShowNotification(_U('not_experienced_enough'))
  end
end

function OpenMobileMecanoActionsMenu()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'mobile_mecano_actions',
    {
      title    = _U('mechanic'),
      elements = {
      --  {label = 'Bryt Upp Dörr',     value = 'hijack_vehicle'},
        {label = 'Laga',       value = 'fix_vehicle'},
        {label = 'Tvätta',      value = 'clean_vehicle'},
        {label = 'Beslagta Fordon',     value = 'delete_vehicle'},
        {label = 'Sätt på/av fordon på flak',       value = 'dep_vehicle'},
        {label = 'System Fakturor', value = 'fine'},
        {label = 'Valfri Faktura', value = 'egen_fine'},
      }
    },
    function(data, menu)
      if data.current.value == 'fine' then
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        if closestPlayer == -1 or closestDistance > 3.0 then
          ESX.ShowNotification('Ingen nära, blind eller?')
        else
          OpenFineMenu(closestPlayer)
        end
      end

      if data.current.value == 'egen_fine' then

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'finees',
          {
            title = _U('invoice_amount'),
          },
          function (data2, menu)

            local amount = tonumber(data2.value)

            if amount == nil then
              ESX.ShowNotification(_U('invoice_amount'))
            else
              menu.close()

              local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

              if closestPlayer == -1 or closestDistance > 3.0 then
                ESX.ShowNotification(_U('invoice_amount'))
              else
                TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_mecano', 'Falck', tonumber(data2.value))
              end
            end
          end,
          function (data2, menu)
            menu.close()
          end
        )
      end

      if data.current.value == 'hijack_vehicle' then

        local playerPed = GetPlayerPed(-1)
        local coords    = GetEntityCoords(playerPed)

        if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

          local vehicle = nil

          if IsPedInAnyVehicle(playerPed, false) then
            vehicle = GetVehiclePedIsIn(playerPed, false)
          else
            vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
          end

          if DoesEntityExist(vehicle) then
            TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
            Citizen.CreateThread(function()
              Citizen.Wait(10000)
              SetVehicleDoorsLocked(vehicle, 1)
              SetVehicleDoorsLockedForAllPlayers(vehicle, false)
              ClearPedTasksImmediately(playerPed)
              ESX.ShowNotification(_U('vehicle_unlocked'))
            end)
          end

        end

      end

      if data.current.value == 'fix_vehicle' then

        local playerPed = GetPlayerPed(-1)
        local coords    = GetEntityCoords(playerPed)

        if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

          local vehicle = nil

          if IsPedInAnyVehicle(playerPed, false) then
            vehicle = GetVehiclePedIsIn(playerPed, false)
          else
            vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
          end

          if DoesEntityExist(vehicle) then
            SetVehicleDoorOpen(vehicle,4,0,0)
		exports['mythic_progbar']:Progress({
			name = "mechanicRepair",
			duration = 60000,
			label = "Reparerar Fordon",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			},
			animation = {
				animDict = "mini@repair",
				anim = "fixing_a_ped",
			},
			prop = {
				model = "prop_tool_screwdvr03",
				bone = 58870,
				coords = { x = 0.00, y = 0.05, z = 0.15 },
				rotation = { x = 180.0, y = 0.0, z = 0.0 },
			}
		}, function(status)
			if not status then
        SetVehicleFixed(vehicle)
        SetVehicleDeformationFixed(vehicle)
        SetVehicleUndriveable(vehicle, false)
        SetVehicleEngineOn(vehicle,  true,  true)
        ClearPedTasksImmediately(playerPed)
				ClearPedTasks(playerPed)
				SetVehicleDoorShut(vehicle,4,0)

      exports['mythic_notify']:SendAlert('Success', ('Fordon är fixat'))

      if hp then
        if hp >= 0 and hp < 200 then
          local price = math.random(50, 150)
          ESX.ShowNotification('Fordonet är lagat och delarna ~r~kostade~s~ ' .. price .. ' ~g~SEK')
          TriggerServerEvent('qalleXD', price)
        else
        local price = math.floor(hp / 40)
        ESX.ShowNotification('Fordonet är lagat och delarna ~r~kostade~s~ ' .. price .. ' ~g~SEK')
        TriggerServerEvent('qalleXD', price)
      end
    end
  end
end)
else
  exports['mythic_notify']:SendAlert('error',('Inget fordon i närheten'))
end
end
end


      if data.current.value == 'clean_vehicle' then
        cleanVehicle()
      end

      if data.current.value == 'delete_vehicle' then

        local ped = GetPlayerPed( -1 )

        if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then
          local pos = GetEntityCoords( ped )

          if ( IsPedSittingInAnyVehicle( ped ) ) then
            local vehicle = GetVehiclePedIsIn( ped, false )

            if ( GetPedInVehicleSeat( vehicle, -1 ) == ped ) then
              ESX.ShowNotification(_U('vehicle_impounded'))
              SetEntityAsMissionEntity( vehicle, true, true )
              deleteCar( vehicle )
            else
              ESX.ShowNotification(_U('must_seat_driver'))
            end
          else
            local playerPos = GetEntityCoords( ped, 1 )
            local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords( ped, 0.0, distanceToCheck, 0.0 )
            local vehicle = GetVehicleInDirection( playerPos, inFrontOfPlayer )

            if ( DoesEntityExist( vehicle ) ) then
              ESX.ShowNotification(_U('vehicle_impounded'))
              SetEntityAsMissionEntity( vehicle, true, true )
              deleteCar( vehicle )
            else
              ESX.ShowNotification(_U('must_near'))
            end
          end
        end
      end

      if data.current.value == 'dep_vehicle' then

        local playerped = GetPlayerPed(-1)
        local vehicle = GetVehiclePedIsIn(playerped, true)

        local towmodel = GetHashKey('flatbed')
        local isVehicleTow = IsVehicleModel(vehicle, towmodel)

        if isVehicleTow then

          local coordA = GetEntityCoords(playerped, 1)
          local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 5.0, 0.0)
          local targetVehicle = getVehicleInDirection(coordA, coordB)

          if CurrentlyTowedVehicle == nil then
            if targetVehicle ~= 0 then
              if not IsPedInAnyVehicle(playerped, true) then
                if vehicle ~= targetVehicle then
                  AttachEntityToEntity(targetVehicle, vehicle, 20, -0.0, -5.50, 0.6, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
                  CurrentlyTowedVehicle = targetVehicle
                  ESX.ShowNotification(_U('vehicle_success_attached'))

                  if NPCOnJob then

                    if NPCTargetTowable == targetVehicle then
                      ESX.ShowNotification(_U('please_drop_off'))

                      Config.Zones.VehicleDelivery.Type = 1

                      if Blips['NPCTargetTowableZone'] ~= nil then
                        RemoveBlip(Blips['NPCTargetTowableZone'])
                        Blips['NPCTargetTowableZone'] = nil
                      end

                      Blips['NPCDelivery'] = AddBlipForCoord(Config.Zones.VehicleDelivery.Pos.x,  Config.Zones.VehicleDelivery.Pos.y,  Config.Zones.VehicleDelivery.Pos.z)

                      SetBlipRoute(Blips['NPCDelivery'], true)

                    end

                  end

                else
                  ESX.ShowNotification(_U('cant_attach_own_tt'))
                end
              end
            else
              ESX.ShowNotification(_U('no_veh_att'))
            end
          else

            AttachEntityToEntity(CurrentlyTowedVehicle, vehicle, 20, -0.5, -13.50, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
            DetachEntity(CurrentlyTowedVehicle, true, true)

            if NPCOnJob then

              if CurrentlyTowedVehicle == NPCTargetTowable then
                ESX.Game.DeleteVehicle(NPCTargetTowable)
                TriggerServerEvent('esx_mecanojob:onNPCJobMissionCompleted')
                StopNPCJob()

              else
                ESX.ShowNotification(_U('not_right_veh'))
              end

            end

            CurrentlyTowedVehicle = nil

            ESX.ShowNotification(_U('veh_det_succ'))
          end
        else
          ESX.ShowNotification(_U('imp_flatbed'))
        end
      end

      if data.current.value == 'object_spawner' then

        ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'mobile_mecano_actions_spawn',
          {
            title    = _U('objects'),
            align    = 'right',
            elements = {
              {label = _U('roadcone'),     value = 'prop_roadcone02a'},
              {label = _U('toolbox'), value = 'prop_toolchest_01'},
            },
          },
          function(data2, menu2)


            local model     = data2.current.value
            local playerPed = GetPlayerPed(-1)
            local coords    = GetEntityCoords(playerPed)
            local forward   = GetEntityForwardVector(playerPed)
            local x, y, z   = table.unpack(coords + forward * 1.0)

            if model == 'prop_roadcone02a' then
              z = z - 2.0
            elseif model == 'prop_toolchest_01' then
              z = z - 2.0
            end

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

function OpenFineCategoryMenu(player, category)

  ESX.TriggerServerCallback('esx_mecanojob:getFineList', function(fines)

    local elements = {}

    for i=1, #fines, 1 do
      table.insert(elements, {
        label     = fines[i].label .. ' SEK' .. fines[i].amount,
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
          TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_mecano', _U('fine_total') .. label, amount)
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

function OpenGetStocksMenu()

  ESX.TriggerServerCallback('esx_mecanojob:getStockItems', function(items)

    print(json.encode(items))

    local elements = {}

    for i=1, #items, 1 do
      table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = _U('mechanic_stock'),
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
          {
            title = _U('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(_U('invalid_quantity'))
            else
              menu2.close()
              menu.close()
              OpenGetStocksMenu()

              TriggerServerEvent('esx_mecanojob:getStockItem', itemName, count)
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

ESX.TriggerServerCallback('esx_mecanojob:getPlayerInventory', function(inventory)

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
              ESX.ShowNotification(_U('invalid_quantity'))
            else
              menu2.close()
              menu.close()
              OpenPutStocksMenu()

              TriggerServerEvent('esx_mecanojob:putStockItems', itemName, count)
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


RegisterNetEvent('esx_mecanojob:onHijack')
AddEventHandler('esx_mecanojob:onHijack', function()
  local playerPed = GetPlayerPed(-1)
  local coords    = GetEntityCoords(playerPed)

  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

    local vehicle = nil

    if IsPedInAnyVehicle(playerPed, false) then
      vehicle = GetVehiclePedIsIn(playerPed, false)
    else
      vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
    end

    local crochete = math.random(100)
    local alarm    = math.random(100)

    if DoesEntityExist(vehicle) then
      if alarm <= 33 then
        SetVehicleAlarm(vehicle, true)
        StartVehicleAlarm(vehicle)
      end
      TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
      Citizen.CreateThread(function()
        Citizen.Wait(10000)
        if crochete <= 66 then
          SetVehicleDoorsLocked(vehicle, 1)
          SetVehicleDoorsLockedForAllPlayers(vehicle, false)
          ClearPedTasksImmediately(playerPed)
          ESX.ShowNotification(_U('veh_unlocked'))
        else
          ESX.ShowNotification(_U('hijack_failed'))
          ClearPedTasksImmediately(playerPed)
        end
      end)
    end

  end
end)

RegisterNetEvent('esx_mecanojob:onCarokit')
AddEventHandler('esx_mecanojob:onCarokit', function()
  local playerPed = GetPlayerPed(-1)
  local coords    = GetEntityCoords(playerPed)

  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

    local vehicle = nil

    if IsPedInAnyVehicle(playerPed, false) then
      vehicle = GetVehiclePedIsIn(playerPed, false)
    else
      vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
    end

    if DoesEntityExist(vehicle) then
      TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_HAMMERING", 0, true)
      Citizen.CreateThread(function()
        Citizen.Wait(10000)
        SetVehicleFixed(vehicle)
        SetVehicleDeformationFixed(vehicle)
        ClearPedTasksImmediately(playerPed)
        ESX.ShowNotification(_U('body_repaired'))
      end)
    end
  end
end)

RegisterNetEvent('esx_mecanojob:onFixkit')
AddEventHandler('esx_mecanojob:onFixkit', function()
  local playerPed = GetPlayerPed(-1)
  local coords    = GetEntityCoords(playerPed)

  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

    local vehicle = nil

    if IsPedInAnyVehicle(playerPed, false) then
      vehicle = GetVehiclePedIsIn(playerPed, false)
    else
      vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
    end

    if DoesEntityExist(vehicle) then
      TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
      Citizen.CreateThread(function()
        Citizen.Wait(20000)
        SetVehicleFixed(vehicle)
        SetVehicleDeformationFixed(vehicle)
        SetVehicleUndriveable(vehicle, false)
        ClearPedTasksImmediately(playerPed)
        ESX.ShowNotification(_U('veh_repaired'))
      end)
    end
  end
end)

function setEntityHeadingFromEntity ( vehicle, playerPed )
    local heading = GetEntityHeading(vehicle)
    SetEntityHeading( playerPed, heading )
end

function getVehicleInDirection(coordFrom, coordTo)
  local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
  local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
  return vehicle
end

function deleteCar( entity )
    Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

AddEventHandler('esx_mecanojob:hasEnteredMarker', function(zone)

  if zone == NPCJobTargetTowable then

  end

  if zone == 'MecanoActions' then
    CurrentAction     = 'mecano_actions_menu'
    CurrentActionMsg  = _U('open_actions')
    CurrentActionData = {}
  end

  if zone == 'Garage' then
    CurrentAction     = 'mecano_harvest_menu'
    CurrentActionMsg  = _U('harvest_menu')
    CurrentActionData = {}
  end

  if zone == 'Craft' then
    CurrentAction     = 'mecano_craft_menu'
    CurrentActionMsg  = _U('craft_menu')
    CurrentActionData = {}
  end

  if zone == 'VehicleDeleter' then

    local playerPed = GetPlayerPed(-1)

    if IsPedInAnyVehicle(playerPed,  false) then

      local vehicle = GetVehiclePedIsIn(playerPed,  false)

      CurrentAction     = 'delete_vehicle'
      CurrentActionMsg  = _U('veh_stored')
      CurrentActionData = {vehicle = vehicle}
    end
  end

end)

AddEventHandler('esx_mecanojob:hasExitedMarker', function(zone)

  if zone == 'Craft' then
    TriggerServerEvent('esx_mecanojob:stopCraft')
    TriggerServerEvent('esx_mecanojob:stopCraft2')
    TriggerServerEvent('esx_mecanojob:stopCraft3')
  end

  if zone == 'Garage' then
    TriggerServerEvent('esx_mecanojob:stopHarvest')
    TriggerServerEvent('esx_mecanojob:stopHarvest2')
    TriggerServerEvent('esx_mecanojob:stopHarvest3')
  end

  CurrentAction = nil
  ESX.UI.Menu.CloseAll()
end)

AddEventHandler('esx_mecanojob:hasEnteredEntityZone', function(entity)

  local playerPed = GetPlayerPed(-1)

  if PlayerData.job ~= nil and PlayerData.job.name == 'mecano' and not IsPedInAnyVehicle(playerPed, false) then
    CurrentAction     = 'remove_entity'
    CurrentActionMsg  = _U('press_remove_obj')
    CurrentActionData = {entity = entity}
  end

end)

AddEventHandler('esx_mecanojob:hasExitedEntityZone', function(entity)

  if CurrentAction == 'remove_entity' then
    CurrentAction = nil
  end

end)

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
  local specialContact = {
    name       = _U('mechanic'),
    number     = 'mecano',
    base64Icon = 'data:image/png;base64,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'
  }
  TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

-- Pop NPC mission vehicle when inside area
Citizen.CreateThread(function()
  while true do

    Wait(0)

    if NPCTargetTowableZone ~= nil and not NPCHasSpawnedTowable then

      local coords = GetEntityCoords(GetPlayerPed(-1))
      local zone   = Config.Zones[NPCTargetTowableZone]

      if GetDistanceBetweenCoords(coords, zone.Pos.x, zone.Pos.y, zone.Pos.z, true) < Config.NPCSpawnDistance then

        local model = Config.Vehicles[GetRandomIntInRange(1,  #Config.Vehicles)]

        ESX.Game.SpawnVehicle(model, zone.Pos, 0, function(vehicle)
          NPCTargetTowable = vehicle
        end)

        NPCHasSpawnedTowable = true

      end

    end

    if NPCTargetTowableZone ~= nil and NPCHasSpawnedTowable and not NPCHasBeenNextToTowable then

      local coords = GetEntityCoords(GetPlayerPed(-1))
      local zone   = Config.Zones[NPCTargetTowableZone]

      if(GetDistanceBetweenCoords(coords, zone.Pos.x, zone.Pos.y, zone.Pos.z, true) < Config.NPCNextToDistance) then
        ESX.ShowNotification(_U('please_tow'))
        NPCHasBeenNextToTowable = true
      end

    end

  end
end)

-- Create Blips
Citizen.CreateThread(function()
  local blip = AddBlipForCoord(Config.Zones.MecanoActions.Pos.x, Config.Zones.MecanoActions.Pos.y, Config.Zones.MecanoActions.Pos.z)
  SetBlipSprite (blip, 446)
  SetBlipDisplay(blip, 6)
  SetBlipScale  (blip, 0.7)
  SetBlipColour (blip, 4)
  SetBlipAsShortRange(blip, true)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString(_U('mechanic'))
  EndTextCommandSetBlipName(blip)
end)

-- Display markers
Citizen.CreateThread(function()
  while true do
    Wait(0)
    if PlayerData.job ~= nil and PlayerData.job.name == 'mecano' then

      local coords = GetEntityCoords(GetPlayerPed(-1))

      for k,v in pairs(Config.Zones) do
        if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
          DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
        end
      end
    end
  end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
  while true do
    Wait(0)
    if PlayerData.job ~= nil and PlayerData.job.name == 'mecano' then
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
        TriggerEvent('esx_mecanojob:hasEnteredMarker', currentZone)
      end
      if not isInMarker and HasAlreadyEnteredMarker then
        HasAlreadyEnteredMarker = false
        TriggerEvent('esx_mecanojob:hasExitedMarker', LastZone)
      end
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

          if IsControlJustReleased(0, 38) and PlayerData.job ~= nil and PlayerData.job.name == 'mecano' then

            if CurrentAction == 'mecano_actions_menu' then
                OpenMecanoActionsMenu()
            end

            if CurrentAction == 'mecano_harvest_menu' then
                OpenMecanoHarvestMenu()
            end

            if CurrentAction == 'mecano_craft_menu' then
                OpenMecanoCraftMenu()
            end

            if CurrentAction == 'delete_vehicle' then

              if Config.EnableSocietyOwnedVehicles then

                local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
                TriggerServerEvent('esx_society:putVehicleInGarage', 'mecano', vehicleProps)

              else

                if
                  GetEntityModel(vehicle) == GetHashKey('flatbed')   or
				  GetEntityModel(vehicle) == GetHashKey('towtruck')   or
                  GetEntityModel(vehicle) == GetHashKey('towtruck2') or
                  GetEntityModel(vehicle) == GetHashKey('slamvan3')
                then
                  TriggerServerEvent('esx_service:disableService', 'mecano')
                end

              end

              ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
            end

            if CurrentAction == 'remove_entity' then
              DeleteEntity(CurrentActionData.entity)
            end

            CurrentAction = nil
          end
        end

        if IsControlJustReleased(0, Keys['F6']) and PlayerData.job ~= nil and PlayerData.job.name == 'mecano' then
            OpenMobileMecanoActionsMenu()
        end

        if IsControlJustReleased(0, Keys['DELETE']) and PlayerData.job ~= nil and PlayerData.job.name == 'mecano' then

          if NPCOnJob then

            if GetGameTimer() - NPCLastCancel > 5 * 60000 then
              StopNPCJob(true)
              NPCLastCancel = GetGameTimer()
            else
              ESX.ShowNotification(_U('wait_five'))
            end

          else

            local playerPed = GetPlayerPed(-1)

            if IsPedInAnyVehicle(playerPed,  false) and IsVehicleModel(GetVehiclePedIsIn(playerPed,  false), GetHashKey("flatbed")) then
              StartNPCJob()
            else
              ESX.ShowNotification(_U('must_in_flatbed'))
            end

          end

        end

    end
end)

function cleanVehicle()
  local playerPed = PlayerPedId()
	local vehicle   = ESX.Game.GetVehicleInDirection()
	local coords    = GetEntityCoords(playerPed)

		if IsPedSittingInAnyVehicle(playerPed) then
			exports['mythic_notify']:SendAlert('error', (_U('inside_vehicle')))
			return
		end

		if DoesEntityExist(vehicle) then
			exports['mythic_progbar']:Progress({
				name = "mechanicWash",
				duration = 60000,
				label = "Tvättar",
				useWhileDead = false,
				canCancel = true,
				controlDisables = {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				},
					animation = {
						animDict = "amb@world_human_maid_clean@base",
						anim = "base",
					},
					prop = {
						model = "prop_cs_bandana",
						bone = 58870,
						coords = { x = 0.00, y = 0.05, z = 0.15 },
						rotation = { x = 180.0, y = 0.0, z = 0.0 },
					}
				}, function(status)
					if not status then
						SetVehicleDirtLevel(vehicle, 0)
					ClearPedTasksImmediately(playerPed)

					exports['mythic_notify']:SendAlert('success', ('Fordonet är nu rent'))
					end
				end)
			else
				exports['mythic_notify']:SendAlert('error', ('Inget fordon i närheten'))
			end
		end

function openMechanic()
  if PlayerData.job ~= nil and PlayerData.job.name == 'mecano' then
    OpenMobileMecanoActionsMenu()
  end
end
