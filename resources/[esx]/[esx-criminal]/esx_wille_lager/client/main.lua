local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}


--- esx
ESX                           = nil
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

function openBuyMenu()
    ESX.UI.Menu.CloseAll()

    local elements = {}


    table.insert(elements, {label = 'Köp ett Lager', value = 'storage'})
    table.insert(elements, {label = 'Köp en extranyckel till ditt Lager', value = 'extra_key'})
    table.insert(elements, {label = 'Ditt Lager', value = 'lager'})

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'storage_main',
        {
            title    = 'Lager-Meny',
            align    = 'right',
            elements = elements,
        },
    function (data, menu)
        local action = data.current.value
        if not IsPedInAnyVehicle(GetPlayerPed(-1), false) then

            if action == 'lager' then
                openStorageMenu()
                here()
            end

            if action == 'storage' then
                ESX.UI.Menu.Open(
                    'dialog', GetCurrentResourceName(), 'storage_key',
                {
                    title = 'Namn på nyckel?'
                },
                function(data2, menu2)
                    local keyName = (data2.value)
                    print(keyName)

                    menu2.close()
                    local storageNumber = math.random(1, 10)
                    TriggerServerEvent('esx_wille_lager:add', storageNumber, keyName)

                end,
                function(data2, menu2)
                    menu2.close()
                end
                )
            elseif action == 'extra_key' then
                ESX.TriggerServerCallback('esx_wille_lager:getStorages', function(storages)
                    local elements = {}

                    for i=1, #storages, 1 do
                        table.insert(elements, {label = 'Skåp #' ..storages[i].kU.. ' ' ..storages[i].kN, value = 'buy', storageUnit = storages[i].kU, keyUnit = storages[i].kN})
                    end

                    ESX.UI.Menu.Open(
                        'default', GetCurrentResourceName(), 'storage_second',
                        {
                            title    = 'Lager',
                            align    = 'right',
                            elements = elements,
                        },
                    function (data, menu)
                        local action = data.current.value
                        local unit = data.current.storageUnit
                        local name = data.current.keyUnit

                        if action == 'buy' then
                            TriggerServerEvent('esx_wille_lager:addKey', name, unit)
                            ESX.UI.Menu.CloseAll()
                        end
                    end,
                    function (data, menu)
                        ESX.UI.Menu.CloseAll()
                    end
                    )
                end, GetPlayerServerId(PlayerId()))
            end
        else
            ESX.ShowNotification('Du kan ~r~ej~s~ göra det i ett fordon')
        end

    end,
    function (data, menu)
        ESX.UI.Menu.CloseAll()
    end
    )
end

function here()

	local missionped = {
	    {id=1, Name=StartPed, VoiceName="GENERIC_INSULT_HIGH", Ambiance="AMMUCITY", Weapon=1649403952, modelHash="G_M_Y_BallaOrig_01", x = 1048.36, y = -3102.73, z = -39.0, heading=267.52},
	    {id=2, Name=StartDog, VoiceName="GENERIC_INSULT_HIGH", Ambiance="AMMUCITY", Weapon=1649403952, modelHash="G_M_Y_BallaOrig_01",     x = 1048.45, y = -3099.23, z = -39.0, heading=275.49}}

	Citizen.CreateThread(function()
	    Citizen.Wait(1)
	    if (not generalLoaded) then
	        for i=1, #missionped do
	            RequestModel(GetHashKey(missionped[i].modelHash))
	            while not HasModelLoaded(GetHashKey(missionped[i].modelHash)) do
	            Citizen.Wait(10)
	            end

	            missionped[i].id = CreatePed(28, missionped[i].modelHash, missionped[i].x, missionped[i].y, missionped[i].z, missionped[i].heading, false, false)
	            if missionped[i].modelHash == "G_M_Y_BallaOrig_01" then
	                SetPedFleeAttributes(missionped[i].id, 0, 0)
	                SetAmbientVoiceName(missionped[i].id, missionped[i].Ambiance)
	                SetPedDropsWeaponsWhenDead(missionped[i].id, false)
	                GiveWeaponToPed(missionped[i].id, 324215364, 2800, true, true)
	            end
	        end
	    end
	    generalLoaded = true
	end)
end

function openStorageMenu()
    ESX.UI.Menu.CloseAll()
    ESX.TriggerServerCallback('esx_wille_lager:getStorages', function(storages)
        local elements = {}

        for i=1, #storages, 1 do
            table.insert(elements, {label = 'Skåp #' ..storages[i].kU.. ' ' ..storages[i].kN, value = 'storage', storageUnit = storages[i].kU, keyUnit = storages[i].kN})
           --table.insert(elements, {label = 'Skåp', storages[i].kU, storages[i].kN, value = 'storage', storageUnit = storages[i].kU, keyUnit = storages[i].kN})
        end

        ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'storage_second',
            {
                title    = 'Lager',
                align    = 'right',
                elements = elements,
            },
        function (data, menu)
            local action = data.current.value
            local unit = data.current.storageUnit

            if not IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                if action == 'storage' then
                    ESX.TriggerServerCallback('esx_wille_lager:getKeysSimple', function(yourKeys)
                        if yourKeys == data.current.keyUnit then
                            OpenItemMenu(unit)
                        else
                            ESX.ShowNotification('Du har ~r~ej~s~ nyckel till detta Lager')
                        end
                    end, data.current.keyUnit)
                end
            else
                ESX.ShowNotification('Du kan ~r~ej~s~ göra det i ett fordon')
            end

        end,
        function (data, menu)
            ESX.UI.Menu.CloseAll()
        end
        )
    end)
end

function OpenItemMenu(storageUnit)
    RequestAnimDict("anim@heists@humane_labs@finale@keycards")

    while not HasAnimDictLoaded( "anim@heists@humane_labs@finale@keycards") do
        Citizen.Wait(0)
    end

    TaskPlayAnim(GetPlayerPed(-1), "anim@heists@humane_labs@finale@keycards" ,"ped_b_enter" ,8.0, -8.0, -1, 0, 0, false, false, false )

    Citizen.Wait(500)
    ESX.UI.Menu.CloseAll()
    ESX.TriggerServerCallback('esx_wille_lager:getInventory', function(items)
        local elements = {}

        table.insert(elements, {label = 'Lägg in något', value = 'put'})

        for i=1, #items.items, 1 do
            table.insert(elements, {label = items.items[i].label .. ' ' .. items.items[i].count .. 'st', item = items.items[i].itemName, value = 'take'})
        end

        for i=1, #items.weapons, 1 do
            table.insert(elements, {label = ESX.GetWeaponLabel(items.weapons[i].weaponName), item = items.weapons[i].weaponName, value = 'take_weapon'})
        end

        ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'storage_second',
            {
                title    = 'Lager',
                align    = 'right',
                elements = elements,
            },
        function (data, menu)
            local action = data.current.value

            if not IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                if action == 'put' then
                    print(storageUnit)
                    openPutIn(storageUnit)
                end
                if action == 'take' then
                    local itemName = data.current.item

                    ESX.UI.Menu.Open(
                      'dialog', GetCurrentResourceName(), 'take_storage',
                      {
                        title = 'Hur många?'
                      },
                      function(data2, menu2)

                        local count = tonumber(data2.value)

                        if count == nil then
                          ESX.ShowNotification(_U('quantity_invalid'))
                        else
                            ESX.UI.Menu.CloseAll()
                            print(storageUnit)
                            TriggerServerEvent('esx_wille_lager:takeItem', itemName, count, storageUnit)
                        end

                      end,
                      function(data2, menu2)
                      end
                    )

                end
                if action == 'take_weapon' then
                	TriggerServerEvent('esx_wille_lager:takeWeapon', data.current.item, storageUnit)
                	ESX.UI.Menu.CloseAll()
                end
            else
                ESX.ShowNotification('Du kan ~r~ej~s~ göra det i ett fordon')
            end

        end,
        function (data, menu)
            menu.close()
        end
        )
    end, storageUnit)
end

function openPutIn(storageUnit)

  ESX.TriggerServerCallback('esx_wille_lager:getPlayerInventory', function(inventory)

    local elements = {}

    for i=1, #inventory.weapons, 1 do
		table.insert(elements, {
			label          = ESX.GetWeaponLabel(inventory.weapons[i].name),
			value          = inventory.weapons[i].name,
			action 		   = 'weapon'
		})
    end

    for i=1, #inventory.items, 1 do

      local item = inventory.items[i]

      if item.count > 0 then
        table.insert(elements, {label = item.label .. ' ' .. item.count .. 'st', type = 'item_standard', value = item.name, action = 'item'})
      end

    end
    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'storage_menu',
      {
        title    = 'Din Ryggsäck',
        align    = 'right',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value


        if data.current.action == 'item' then
	        ESX.UI.Menu.Open(
	          'dialog', GetCurrentResourceName(), 'putin_count',
	          {
	            title = 'Hur mycket?'
	          },
	          function(data2, menu2)

	            local count = tonumber(data2.value)

	            if count == nil then
	                ESX.ShowNotification('Error')
	            else
	                ESX.UI.Menu.CloseAll()

	                TriggerServerEvent('esx_wille_lager:putItem', itemName, count, storageUnit)
	            end

	            end,
	        function(data2, menu2)
	            menu2.close()
	        end
	        )
    	elseif data.current.action == 'weapon' then
			TriggerServerEvent('esx_wille_lager:putWeapon', data.current.value, storageUnit)
			ESX.UI.Menu.CloseAll()
		end

      	end,
      	function(data, menu)
        	menu.close()
      	end
    )


  end)

end

--local hasSpawned = false

Citizen.CreateThread(function()
    while true do
        Wait(0)

        local coords = GetEntityCoords(GetPlayerPed(-1))


        if(GetDistanceBetweenCoords(coords, Config.GambinoLagerMenu.x, Config.GambinoLagerMenu.y, Config.GambinoLagerMenu.z, true) < 20.0) then
            DrawMarker(Config.Type, Config.GambinoLagerMenu.x, Config.GambinoLagerMenu.y, Config.GambinoLagerMenu.z - 0.96, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Size.x, Config.Size.y, Config.Size.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 255, false, true, 2, false, false, false, false)
            if(GetDistanceBetweenCoords(coords, Config.GambinoLagerMenu.x, Config.GambinoLagerMenu.y, Config.GambinoLagerMenu.z, true) < 2.0) then
                Draw3DText(Config.GambinoLagerMenu.x, Config.GambinoLagerMenu.y, Config.GambinoLagerMenu.z+0.1, '[E] för att öppna Lager menyn')
                if IsControlJustReleased(0, Keys['E']) then
                    openBuyMenu()
                end
            end
        end
    end
end)

--notification
function sendNotification(message, messageType, messageTimeout)
	TriggerEvent("pNotify:SendNotification", {
		text = message,
		type = messageType,
		queue = "records",
		timeout = messageTimeout,
		layout = "bottomCenter"
	})
end

--display
function Draw3DText(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 90)
end