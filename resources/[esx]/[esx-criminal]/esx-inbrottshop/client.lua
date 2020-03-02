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
local PlayerData              = {}

Citizen.CreateThread(function()
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

function hintToDisplay(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

--local blips = {
  --    {title="Försäljning", colour=45, id=459, x = 1391.95, y = 3604.53, z = 34.98}
--}
  
local gym = {
    {x = 914.97, y = -1702.33, z = 51.26}
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k in pairs(gym) do
            --DrawMarker(21, gym[k].x, gym[k].y, gym[k].z, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5, 0, 255, 255, 255, 0, 0, 0, 0)
        end
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        for k in pairs(gym) do
		
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, gym[k].x, gym[k].y, gym[k].z)

            if dist <= 1.5 then
                --hintToDisplay('Tryck på ~INPUT_CONTEXT~ för att öppna ~b~affären~w~')
                Draw3DText(914.97, -1702.33, 51.26, '[~g~E~w~] för att öppna menyn')
				
				if IsControlJustPressed(0, Keys['E']) then
					OpenPawnMenu()
				end			
            end
        end
    end
end)

function OpenPawnMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'pawn_menu',
        {
            title    = 'Försäljning',
            align = 'right',
            elements = {
				--{label = 'Affär', value = 'shop'},
				{label = 'Sälj', value = 'sell'},
            }
        },
        function(data, menu)
            if data.current.value == 'shop' then
				OpenPawnShopMenu()
            elseif data.current.value == 'sell' then
				OpenSellMenu()
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end

function OpenPawnShopMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'pawn_shop_menu',
        {
            title    = 'Handla',
            align = 'center',
            elements = {
				{label = 'Reparationslåda (8006kr)', value = 'fixkit'},
				{label = 'Skottsäker väst (35000kr)', value = 'bulletproof'},
				{label = 'Borrmaskin (45000kr)', value = 'drill'},
				{label = 'Ögonbindel (16214kr)', value = 'blindfold'},
                {label = 'Fiskespö (2591kr)', value = 'fishingrod'},
                {label = 'Antibiotika (1239kr)', value = 'antibiotika'},
                {label = 'Samsung S8 (3400kr)', value = 'phone'},
            }
        },
        function(data, menu)
            if data.current.value == 'fixkit' then
				TriggerServerEvent('esx_kocken:buyFixkit')
            elseif data.current.value == 'bulletproof' then
				TriggerServerEvent('esx_kocken:buyBulletproof')
            elseif data.current.value == 'drill' then
				TriggerServerEvent('esx_kocken:buyDrill')
            elseif data.current.value == 'blindfold' then
				TriggerServerEvent('esx_kocken:buyBlindfold')
            elseif data.current.value == 'fishingrod' then
                TriggerServerEvent('esx_kocken:buyFishingrod')
            elseif data.current.value == 'antibiotika' then
                TriggerServerEvent('esx_kocken:buyAntibiotika')  
            elseif data.current.value == 'phone' then
				TriggerServerEvent('esx_kocken:buyPhone')
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end

function OpenSellMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'pawn_sell_menu',
        {
            title    = 'Vad vill du sälja?',
            align = 'right',
            elements = {
                {label = 'Rosadildo (200kr)', value = 'rosadildo'},
                {label = 'Iphone (100kr)', value = 'phone'},
                {label = 'Bärbardator (200kr)', value = 'laptop'},
                {label = 'Dyrkset (50kr)', value = 'lockpick'},
                {label = 'Rolexklocka (100kr)', value = 'rolexklocka'},
                {label = 'Halsbandd (300kr)', value = 'halsbandd'},
                {label = 'Juveler (200kr)', value = 'jewels'},
                {label = 'Marijuana Frö (250kr)', value = 'seed'},
            }
        },
        function(data, menu)
            if data.current.value == 'rosadildo' then
                TriggerServerEvent('esx_kocken:selldildo')
            elseif data.current.value == 'phone' then
                TriggerServerEvent('esx_kocken:sellphone')
            elseif data.current.value == 'laptop' then
                TriggerServerEvent('esx_kocken:sellaptop')
            elseif data.current.value == 'lockpick' then
                TriggerServerEvent('esx_kocken:sellpick') 
            elseif data.current.value == 'rolexklocka' then
                TriggerServerEvent('esx_kocken:sellklocka')    
            elseif data.current.value == 'halsbandd' then
                TriggerServerEvent('esx_kocken:sellband')
            elseif data.current.value == 'jewels' then
                TriggerServerEvent('esx_kocken:selljewel')
            elseif data.current.value == 'seed' then
                TriggerServerEvent('esx_kocken:sellseed')
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end


function Draw3DText(x, y, z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
  
	local scale = 0.35
   
	if onScreen then
		SetTextScale(scale, scale)
		SetTextFont(8)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		SetTextOutline()
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
        DrawText(_x,_y)

	end
end


