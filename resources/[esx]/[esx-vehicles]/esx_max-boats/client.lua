ESX = nil
Citizen.CreateThread(function()
	while true do
		Wait(5)
		if ESX ~= nil then
		
		else
			ESX = nil
			TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
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




			
			
for _, info in pairs(Config.MarkerZones) do
		info.blip = AddBlipForCoord(info.x, info.y, info.z)
		SetBlipSprite(info.blip, 455)
		SetBlipDisplay(info.blip, 4)
		SetBlipScale(info.blip, 1.0)
		SetBlipColour(info.blip, 20)
		SetBlipAsShortRange(info.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Båt uthyrning")
		EndTextCommandSetBlipName(info.blip)
	end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k in pairs(Config.MarkerZones) do
		
            DrawMarker(1, Config.MarkerZones[k].x, Config.MarkerZones[k].y, Config.MarkerZones[k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 3.0, 1.0, 0, 150, 150, 100, 0, 0, 0, 0)	
		end
    end
end)

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
Citizen.CreateThread(function()
while true do
	Wait(600)
		if pause and fishing then
			pausetimer = pausetimer + 1
		end
end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
	
        for k in pairs(Config.MarkerZones) do
        	local ped = PlayerPedId()
            local pedcoords = GetEntityCoords(ped, false)
            local distance = Vdist(pedcoords.x, pedcoords.y, pedcoords.z, Config.MarkerZones[k].x, Config.MarkerZones[k].y, Config.MarkerZones[k].z)
            if distance <= 1.40 then

					DisplayHelpText('Tryck E för att hyra en båt')
					
					if IsControlJustPressed(0, Keys['E']) and IsPedOnFoot(ped) then
						OpenBoatsMenu(Config.MarkerZones[k].xs, Config.MarkerZones[k].ys, Config.MarkerZones[k].zs)
					end 
			elseif distance < 1.45 then
				ESX.UI.Menu.CloseAll()
            end
        end
    end
end)

function OpenBoatsMenu(x, y , z)
	local ped = PlayerPedId()
	PlayerData = ESX.GetPlayerData()
	local elements = {}
	
	
		table.insert(elements, {label = '<span style="color:green;">Gummibåt</span> <span style="color:red;">1500</span>', value = 'boat'})
		table.insert(elements, {label = '<span style="color:green;">Fiskebåt</span> <span style="color:red;">500</span>', value = 'boat6'}) 
		table.insert(elements, {label = '<span style="color:green;">Sportbåt</span> <span style="color:red;">2500</span>', value = 'boat5'}) 	
		table.insert(elements, {label = '<span style="color:green;">Jetski</span> <span style="color:red;">500</span>', value = 'boat2'}) 
		table.insert(elements, {label = '<span style="color:green;">Segelbåt</span> <span style="color:red;">1000</span>', value = 'boat3'}) 
		table.insert(elements, {label = '<span style="color:green;">Ubåt</span> <span style="color:red;">8000</span>', value = 'boat4'})
		
	--If user has police job they will be able to get free Police Predator boat
	if PlayerData.job.name == "police" then
		table.insert(elements, {label = '<span style="color:green;">Polisbåt</span>', value = 'police'})
	end
	
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'client',
    {
		title    = 'Hyr en båt',
		align    = 'center',
		elements = elements,
    },
	
	
	function(data, menu)

	if data.current.value == 'boat' then
		ESX.UI.Menu.CloseAll()

		TriggerServerEvent("max:lowmoney", 2500) 
		TriggerEvent("chatMessage", 'Du hyrde en båt för', {255,0,255}, '$' .. 1500)
		SetPedCoordsKeepVehicle(ped, x, y , z)
		TriggerEvent('esx:spawnVehicle', "dinghy4")
	end
	
	if data.current.value == 'boat2' then
		ESX.UI.Menu.CloseAll()

		TriggerServerEvent("max:lowmoney", 5500) 
		TriggerEvent("chatMessage", 'Du hyrde en båt för', {255,0,255}, '$' .. 500)
		SetPedCoordsKeepVehicle(ped, x, y , z)
		TriggerEvent('esx:spawnVehicle', "seashark")
	end
	
	if data.current.value == 'boat3' then
		ESX.UI.Menu.CloseAll()

		TriggerServerEvent("max:lowmoney", 6000) 
		TriggerEvent("chatMessage", 'Du hyrde en båt för', {255,0,255}, '$' .. 1000)
		SetPedCoordsKeepVehicle(ped, x, y , z)
		TriggerEvent('esx:spawnVehicle', "MARQUIS")
	end

	if data.current.value == 'boat4' then
		ESX.UI.Menu.CloseAll()

		TriggerServerEvent("max:lowmoney", 7500) 
		TriggerEvent("chatMessage", 'Du hyrde en båt för', {255,0,255}, '$' .. 8000)
		SetPedCoordsKeepVehicle(ped, x, y , z)
		TriggerEvent('esx:spawnVehicle', "submersible2")
	end
	
	if data.current.value == 'boat5' then
		ESX.UI.Menu.CloseAll()

		TriggerServerEvent("max:lowmoney", 4500) 
		TriggerEvent("chatMessage", 'Du hyrde en båt för', {255,0,255}, '$' .. 2500)
		SetPedCoordsKeepVehicle(ped, x, y , z)
		TriggerEvent('esx:spawnVehicle', "jetmax")
	end
	
	if data.current.value == 'boat6' then
		ESX.UI.Menu.CloseAll()

		TriggerServerEvent("max:lowmoney", 3500) 
		TriggerEvent("chatMessage", 'Du hyrde en båt för', {255,0,255}, '$' .. 3500)
		SetPedCoordsKeepVehicle(ped, x, y , z)
		TriggerEvent('esx:spawnVehicle', "suntrap")
	end
	
	
	if data.current.value == 'police' then
		ESX.UI.Menu.CloseAll()

		TriggerEvent("chatMessage", 'Du tog ut din polisbåt')
		SetPedCoordsKeepVehicle(ped, x, y , z)
		TriggerEvent('esx:spawnVehicle', "predator")
	end
	ESX.UI.Menu.CloseAll()
	

    end,
	function(data, menu)
		menu.close()
		end
	)
end
