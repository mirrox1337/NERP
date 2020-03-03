Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["rightSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["rightCTRL"] = 36, ["rightALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["right"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local ESX = nil
local myMotel = false
local curMotel = nil
local curRoom = nil
local curRoomOwner = false
local inRoom = false
local roomOwner = nil
local playerIdent = nil
local inMotel = false
local motelTaken = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	ESX.PlayerData = ESX.GetPlayerData()
    createBlips()
    playerIdent = ESX.GetPlayerData().identifier
end)

AddEventHandler('playerSpawned', function()


    Citizen.CreateThread(function()

        while not ESX.IsPlayerLoaded() do
            Citizen.Wait(0)
        end
        Citizen.Wait(1000)
        ESX.TriggerServerCallback('lsrp-motels:getLastMotel', function(motel, room)
            print('loading saved room')
            if motel and room then
                if motel ~= nil and room ~= nil then
                    print('loading saved room 2')
                        curMotel      = motel
                        curRoom       = room
                        inRoom        = true
                        inMotel       = true
                        local roomID = nil
                        local playerPed = PlayerPedId()
                        local roomIdent = room
                        local reqmotel = motel
                        ESX.TriggerServerCallback('lsrp-motels:getMotelRoomID', function(roomno)
                        roomID = roomno
                        end, room)
                        Citizen.Wait(500)
                        if roomID ~= nil then
                        local instanceid = 'motel'..roomID..''..roomIdent
                            TriggerEvent('instance:create', 'motelroom', {property = instanceid, owner = ESX.GetPlayerData().identifier, motel = reqmotel, room = roomIdent, vid = roomID})
                        end
                end
            end
        end)
    end)



end)


function createBlips()
    for k,v in pairs(Config.Zones) do
            local blip = AddBlipForCoord(tonumber(v.Pos.x), tonumber(v.Pos.y), tonumber(v.Pos.z))
			SetBlipSprite(blip, v.Pos.sprite)
			SetBlipDisplay(blip, 4)
			SetBlipScale(blip, 0.8)
			SetBlipColour(blip, v.Pos.color)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(v.Name)
			EndTextCommandSetBlipName(blip)
    end
end

function getMyMotel()
ESX.TriggerServerCallback('lsrp-motels:checkOwnership', function(owned)
    myMotel = owned
end)
end

RegisterNetEvent('instance:onCreate')
AddEventHandler('instance:onCreate', function(instance)
    if instance.type == 'motelroom' then
        roomOwner = ESX.GetPlayerData().identifier
		TriggerEvent('instance:enter', instance)
        SetEntityNoCollisionEntity(playerPed, otherPlayerPed, true)
	end
end)

RegisterNetEvent('lsrp-motels:cancelRental')
AddEventHandler('lsrp-motels:cancelRental', function(room)
    local motelName = nil
    local motelRoom = nil
    for k,v in pairs(Config.Zones) do
        for kk,vm in pairs(v.Rooms) do       
            if room == vm.instancename then
                motelName = v.Name
                motelRoom = vm.number
            end
        end
    end
    TriggerServerEvent("lsrp-motels:cancelRental", room)
        if not status then
            myMotel = false
        end
end)

function PlayerDressings()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'room',
	{
		title    = 'Garderob',
		align    = 'right',
		elements = {
            {label = _U('player_clothes'), value = 'player_dressing'},
	        {label = _U('remove_cloth'), value = 'remove_cloth'}
        }
	}, function(data, menu)

		if data.current.value == 'player_dressing' then 
            menu.close()
			ESX.TriggerServerCallback('lsrp-motels:getPlayerDressing', function(dressing)
				elements = {}

				for i=1, #dressing, 1 do
					table.insert(elements, {
						label = dressing[i],
						value = i
					})
				end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing',
				{
					title    = _U('player_clothes'),
					align    = 'right',
					elements = elements
				}, function(data2, menu2)

					TriggerEvent('skinchanger:getSkin', function(skin)
						ESX.TriggerServerCallback('lsrp-motels:getPlayerOutfit', function(clothes)
							TriggerEvent('skinchanger:loadClothes', skin, clothes)
							TriggerEvent('esx_skin:setLastSkin', skin)

							TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('esx_skin:save', skin)
							end)
						end, data2.current.value)
					end)

				end, function(data2, menu2)
					menu2.close()
				end)
			end)

		elseif data.current.value == 'remove_cloth' then
            menu.close()
			ESX.TriggerServerCallback('lsrp-motels:getPlayerDressing', function(dressing)
				elements = {}

				for i=1, #dressing, 1 do
					table.insert(elements, {
						label = dressing[i],
						value = i
					})
				end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'remove_cloth', {
					title    = _U('remove_cloth'),
					align    = 'right',
					elements = elements
				}, function(data2, menu2)
					menu2.close()
					TriggerServerEvent('lsrp-motels:removeOutfit', data2.current.value)
                    exports['mythic_notify']:SendAlert('error', _U('removed_cloth'))
				end, function(data2, menu2)
					menu2.close()
				end)
			end)

		end

	end, function(data, menu)
        menu.close()
	end)




end

RegisterNetEvent('instance:onEnter')
AddEventHandler('instance:onEnter', function(instance)
    if instance.type == 'motelroom' then
        
        local property = instance.data.property
        local motel = instance.data.motel
        local isHost   = GetPlayerFromServerId(instance.host) == PlayerId()
            Citizen.Wait(1000)
        local networkChannel = instance.data.vid
        NetworkSetVoiceChannel(networkChannel)
        NetworkSetTalkerProximity(30.0)
        SetEntityNoCollisionEntity(playerPed, otherPlayerPed, true)
	end
end)

AddEventHandler('instance:loaded', function()
    TriggerEvent('instance:registerType', 'motelroom', function(instance)
        EnterProperty(instance.data.property, instance.data.owner, instance.data.motel, instance.data.room)
    end, function(instance)
        Citizen.InvokeNative(0xE036A705F989E049)
		ExitProperty(instance.data.property, instance.data.motel, instance.data.room)
	end)
end)

function EnterProperty(name, owner, motel, room)
    curMotel      = motel
    curRoom       = room
    inRoom        = true
    inMotel       = true
    local playerPed     = PlayerPedId() 
    TriggerServerEvent('lsrp-motels:SaveMotel', curMotel, curRoom)
    Citizen.CreateThread(function()
        for k,v in pairs(Config.Zones) do     
                if curMotel == k then
                    SetEntityCoords(playerPed, v.roomLoc.x, v.roomLoc.y, v.roomLoc.z)
                end
        end
	end)
end

RegisterNetEvent('lsrp-motels:enterRoom')
AddEventHandler('lsrp-motels:enterRoom', function(room, motel)
    local roomID = nil
    local playerPed = PlayerPedId()
    local roomIdent = room
    local reqmotel = motel
    ESX.TriggerServerCallback('lsrp-motels:getMotelRoomID', function(roomno)
    roomID = roomno
    end, room)
    Citizen.Wait(500)
    if roomID ~= nil then
    local instanceid = 'motel'..roomID..''..roomIdent
        TriggerEvent('instance:create', 'motelroom', {property = instanceid, owner = ESX.GetPlayerData().identifier, motel = reqmotel, room = roomIdent, vid = roomID})
    end
end)

RegisterNetEvent('lsrp-motels:exitRoom')
AddEventHandler('lsrp-motels:exitRoom', function(motel, room)
    local roomID = room
    local playerPed = PlayerPedId()
    Citizen.Wait(500)
    roomOwner = nil
    TriggerEvent('instance:leave')
    SetEntityNoCollisionEntity(playerPed, otherPlayerPed, false)
end)

RegisterNetEvent('lsrp-motels:roomOptions')
AddEventHandler('lsrp-motels:roomOptions', function(room, motel)
    local motelName = nil
    local motelRoom = nil
    for k,v in pairs(Config.Zones) do
        for kk,vm in pairs(v.Rooms) do       
            if room == vm.instancename then
                motelName = v.Name
                motelRoom = vm.number
            end
        end
    end
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'lsrp-motels',
        {
            title    = motelName..' Rum '..motelRoom,
            align    = 'right',
            elements = { 
                { label = 'Gå in i ditt rum', value = 'enter' },
                { label = 'Säg upp hyreskontraktet', value = 'cancel' }
            }
        },
    function(data, entry)
        local value = data.current.value

        if value == 'enter' then
            entry.close()
            TriggerEvent("lsrp-motels:enterRoom", room, motel)

        elseif value == 'cancel' then
            entry.close()
            TriggerEvent("lsrp-motels:cancelRental", room)
        end

    end,
    function(data, entry)
        entry.close()
    end)
end)


RegisterNetEvent('lsrp-motels:roomMenu')
AddEventHandler('lsrp-motels:roomMenu', function(room, motel)
    local motelName = nil
    local motelRoom = nil
    local roomID = nil
    local owner = ESX.GetPlayerData().identifier
    for k,v in pairs(Config.Zones) do
        for kk,vm in pairs(v.Rooms) do       
            if room == vm.instancename then
                motelName = v.Name
                motelRoom = vm.number
            end
        end
    end
   
        options = {}

        table.insert(options, {label = 'Förråd', value = 'inventory'})
        if roomOwner == playerIdent then
        table.insert(options, {label = 'Bjud in person till ditt rum', value = 'inviteplayer'})
        end
        if Config.SwitchCharacterSup then
        table.insert(options, {label = 'Byt karaktär', value = 'changechar'})
        end
        table.insert(options, {label = 'Gå ut ur rummet', value = 'leaveroom'})
        
        
        

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'lsrp-motels',
        {
            title    = motelName..' Rum '..motelRoom,
            align    = 'right',
            elements = options
        },
    function(data, menu)
        local value = data.current.value
        if value == 'changechar' then
            menu.close()
            TriggerServerEvent("kashactersS:SaveSwitchedPlayer")
                if not status then
                    inMotel = false
                    TriggerEvent('kashactersC:ReloadCharacters')
                end
        
        elseif value == 'leaveroom' then
        menu.close()
        TriggerEvent('lsrp-motels:exitRoom', curMotel, curRoom)
        elseif value == 'inventory' then
            menu.close()

            owner = ESX.GetPlayerData().identifier
        if roomOwner == owner then
                if not status then
                    OpenPropertyInventoryMenu('motels', owner)
                end
        else
            exports['mythic_notify']:SendAlert('error', 'Enbart tillgänglig av rum Ägaren')  
        end
        elseif value == 'inviteplayer' then
            local myInstance = nil
            local roomIdent = room
            local reqmotel = motel
            
            for k,v in pairs(Config.Zones) do
                for kk,vm in pairs(v.Rooms) do       
                    if room == vm.instancename then
                        playersInArea = ESX.Game.GetPlayersInArea(vm.entry, 5.0)
                    end
                end
            end
             
			local elements      = {}
            if playersInArea ~= nil then
                for i=1, #playersInArea, 1 do
                    if playersInArea[i] ~= PlayerId() then
                        table.insert(elements, {label = GetPlayerName(playersInArea[i]), value = playersInArea[i]})
                    end
                end
            else
                table.insert(elements, {label = 'Det står ingen utanför.'})
            end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'room_invite',
			{
				title    = motelName..' Rum '..motelRoom .. ' - ' .. _U('invite') ..' Citizen',
				align    = 'right',
				elements = elements,
            }, function(data2, menu2)
                ESX.TriggerServerCallback('lsrp-motels:getMotelRoomID', function(roomno)
                    print(room)
                    roomID = roomno
                    end, room)
                myInstance = 'motel'..roomID..''..roomIdent
				TriggerEvent('instance:invite', 'motelroom', GetPlayerServerId(data2.current.value), {property = myInstance, owner = ESX.GetPlayerData().identifier, motel = reqmotel, room = roomIdent, vid = roomID})
                exports['mythic_notify']:SendAlert('inform', _U('you_invited', GetPlayerName(data2.current.value)))
			end, function(data2, menu2)
				menu2.close()
			end)



        end

    end,
    function(data, menu)
        menu.close()
    end)

end)

RegisterNetEvent('lsrp-motels:rentRoom')
AddEventHandler('lsrp-motels:rentRoom', function(room)
    local motelName = nil
    local motelRoom = nil
    for k,v in pairs(Config.Zones) do
        for kk,vm in pairs(v.Rooms) do       
            if room == vm.instancename then
                motelName = v.Name
                motelRoom = vm.number
            end
        end
    end
    TriggerServerEvent('lsrp-motels:rentRoom', room)
        if not status then

        end
end)

function roomMarkers()
    local playerPed = PlayerPedId()
    local coords    = GetEntityCoords(playerPed)
    -- Exit Marker
    for k,v in pairs(Config.Zones) do
        for km,vm in pairs(v.Rooms) do
            distance = GetDistanceBetweenCoords(coords, v.roomExit.x, v.roomExit.y, v.roomExit.z, true)
            if (distance < 0.5) then
                if curRoom ~= nil then
                    DrawText3D(v.roomExit.x, v.roomExit.y, v.roomExit.z + 0.35, 'Tryck [~p~E~s~] för att gå ut')
                    if IsControlJustReleased(0, Keys['E']) then
                        ESX.UI.Menu.CloseAll()
                        TriggerEvent('lsrp-motels:exitRoom', curMotel, curRoom)
                    end
                end  
            end
        end
    end

    -- Room Menu Marker
    for k,v in pairs(Config.Zones) do
        distance = GetDistanceBetweenCoords(coords, v.Menu.x, v.Menu.y, v.Menu.z, true)
        if distance < 0.5 then
            DrawText3D(v.Menu.x, v.Menu.y, v.Menu.z + 0.35, 'Tryck [~p~E~s~] för att öppna menyn.')
                if IsControlJustReleased(0, Keys['E']) then
                    TriggerEvent('lsrp-motels:roomMenu', curRoom, curMotel)
                end
        end
    end

    -- Clothing Menu
    for k,v in pairs(Config.Zones) do
        distance = GetDistanceBetweenCoords(coords, v.Inventory.x, v.Inventory.y, v.Inventory.z, true)
        if (distance < v.Boundries) then
            DrawMarker(27, v.Inventory.x, v.Inventory.y, v.Inventory.z - 0.97, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.RoomMarker.x, Config.RoomMarker.y, Config.RoomMarker.z, Config.RoomMarker.Owned.r, Config.RoomMarker.Owned.g, Config.RoomMarker.Owned.b, 100, false, false, 2, true, false, false, false)	
            end
        if distance < 0.5 then
            if roomOwner == playerIdent then
            DrawText3D(v.Inventory.x, v.Inventory.y, v.Inventory.z + 0.35, 'Tryck [~p~E~s~] för att byta om.')
                if IsControlJustReleased(0, Keys['E']) then
                    PlayerDressings()
                end
            end
        end
    end

    -- Bed Stash Marker
    for k,v in pairs(Config.Zones) do
        distance = GetDistanceBetweenCoords(coords, v.BedStash.x, v.BedStash.y, v.BedStash.z, true)
        if distance < 0.5 then
            if roomOwner == playerIdent then
            DrawText3D(v.BedStash.x, v.BedStash.y, v.BedStash.z + 0.1, 'Tryck [~p~E~s~] för att kolla under madrassen.')
                if IsControlJustReleased(0, Keys['E']) then
                    OpenStash()
                end
            end
        end
    end

end


function enteredMarker()
   
    local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

if myMotel then 
    for k,v in pairs(Config.Zones) do
        for km,vm in pairs(v.Rooms) do
            if vm.instancename == myMotel then
                distance = GetDistanceBetweenCoords(coords, vm.entry.x, vm.entry.y, vm.entry.z, true)
                if (distance < 0.5) then
                    DrawText3D(vm.entry.x, vm.entry.y, vm.entry.z + 0.35, 'Tryck [~p~E~s~] för alternativ.')
                    if IsControlJustReleased(0, Keys['E']) then
                        TriggerEvent("lsrp-motels:roomOptions", vm.instancename, k)
                    end
                end
            end
        end
    end
else
        for k,v in pairs(Config.Zones) do
            distance = GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true)
            if (distance < v.Boundries) then
                for km,vm in pairs(v.Rooms) do
                    distance = GetDistanceBetweenCoords(coords, vm.entry.x, vm.entry.y, vm.entry.z, true)
            --[[
			if (distance < 0.5) then
				checkIsTaken(vm)	
            end
            ]]
            if (distance < 0.5) then
				if  Config.LockRentedRooms == false or motelTaken == false then			
				DrawText3D(vm.entry.x, vm.entry.y, vm.entry.z + 0.35, '[~p~E~s~] för att hyra rum nummer: ~b~~p~'..vm.number..'~s~ på ~b~~p~'..v.Name..' ~w~för ~g~'..Config.PriceRental .. ' Sek')
				if IsControlJustReleased(0, Keys['E']) then
				    TriggerEvent('lsrp-motels:rentRoom', vm.instancename)
				end
			else
				DrawText3D(vm.entry.x, vm.entry.y, vm.entry.z + 0.35, '~r~Upptaget')
			end
                    end
                end
            end
        end    
    end

end

function checkIsTaken(vm)
    ESX.TriggerServerCallback('lsrp-motels:isMotelTaken', 
        function(roomStatus)
            if  roomStatus == 0 then 
                motelTaken = false
            else 
                motelTaken = true
            end                            
    end, vm.instancename) 
end

function ExitProperty(name, motel, room)
	local property  = name
    local playerPed = PlayerPedId()
    inRoom          = false
    inMotel         = false
    TriggerServerEvent('lsrp-motels:DelMotel')
	Citizen.CreateThread(function()
        for k,v in pairs(Config.Zones) do
            for km,vm in pairs(v.Rooms) do
                if room == vm.instancename then
                SetEntityCoords(playerPed, vm.entry.x, vm.entry.y, vm.entry.z)
                end
            end
        end
	end)
end

Citizen.CreateThread(function()
    Citizen.Wait(0)
    while true do
       Citizen.Wait(0)
       enteredMarker() 
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(0)
        while true do
            Citizen.Wait(0)
            local playerPed = PlayerPedId()
            local coords    = GetEntityCoords(playerPed)

            if inRoom then
                roomMarkers()
            end 

            if not inMotel then
                for k,v in pairs(Config.Zones) do
                    distance = GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true)
                    if (distance < v.Boundries) then
                        getMyMotel()
                        Citizen.Wait(3000)
                    end
                end
            end
        end
end)


function OpenPropertyInventoryMenu(property, owner)
	ESX.TriggerServerCallback(
		"lsrp-motels:getPropertyInventory",
		function(inventory)
			TriggerEvent("esx_inventoryhud:openMotelsInventory", inventory)
		end, owner)
end

function OpenPropertyInventoryMenuBed(property, owner)
	ESX.TriggerServerCallback(
		"lsrp-motels:getPropertyInventoryBed",
		function(inventory)
			TriggerEvent("esx_inventoryhud:openMotelsInventoryBed", inventory)
		end, owner)
end

function OpenStash()

    owner = ESX.GetPlayerData().identifier
    ESX.TriggerServerCallback('lsrp-motels:checkIsOwner', function(isOwner)
        if isOwner then
                        if not status then
                            OpenPropertyInventoryMenuBed('motelsbed', owner)
                        end  
        else
            exports['mythic_notify']:SendAlert('error', 'Enbart tillgänglig av rum Ägaren')  
        end
    end, curRoom, owner)
end

DrawText3D = function(x, y, z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords()) 
	local scale = 0.45
    if onScreen then
        --SetTextScale(0.0 * scale, 0.55 * scale)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextScale(0.45, 0.45)
		SetTextColour(255, 255, 255, 255)
		SetTextDropshadow(0, 0, 0, 0, 255)
		--SetTextEdge(2, 0, 0, 0, 150)
		SetTextDropShadow()
		SetTextEntry("STRING")
		SetTextCentre(true)
		AddTextComponentString(text)
		DrawText(_x, _y)
        local factor = (string.len(text)) / 470
        --DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 125)
    end
end
