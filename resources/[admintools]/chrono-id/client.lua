local showPlayerBlips = false
local ignorePlayerNameDistance = false
local playerNamesDist = 40
local displayIDHeight = 1.5 --Height of ID above players head(starts at center body mass)
--Set Default Values for Colors
local red = 255
local green = 255
local blue = 255
local group

RegisterNetEvent('es_admin:setGroup')
AddEventHandler('es_admin:setGroup', function(g)
    print('group setted ' .. g)
    group = g
end)

function DrawText3D(x,y,z, text) 
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = (1/dist)*10
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
    
    if onScreen then
        SetTextScale(0.0*scale, 0.55*scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(red, green, blue, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        World3dToScreen2d(x,y,z, 0) --Added Here
        DrawText(_x,_y)
    end
end

--[[local showingID = false
RegisterNetEvent('esx_id:id')
AddEventHandler('esx_id:id', function()
    if showingID == true then
        showingID = false
    elseif showingID == false
        showingID = true
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if showingID == true then

        end
    end
end)]]

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(20)
            for i=0,255 do
                N_0x31698aa80e0223f8(i)
            end
            for id = 0, 255 do
                if  ((NetworkIsPlayerActive( id )) and GetPlayerPed( id ) ~= GetPlayerPed( -1 )) and IsControlPressed(1, 19, true) then
                    ped = GetPlayerPed( id )
                    blip = GetBlipFromEntity( ped )
    
                    x1, y1, z1 = table.unpack( GetEntityCoords( GetPlayerPed( -1 ), true ) )
                    x2, y2, z2 = table.unpack( GetEntityCoords( GetPlayerPed( id ), true ) )
                    distance = math.floor(GetDistanceBetweenCoords(x1,  y1,  z1,  x2,  y2,  z2,  true))
                    if ((distance < playerNamesDist)) then
                        if not (ignorePlayerNameDistance) then
                            if group ~= "user" then 
                                red = 255
                                green = 255
                                blue = 255
                                DrawText3D(x2, y2, z2 + displayIDHeight, GetPlayerServerId(id))
                            end
                        end
                    end  
                end
            end
            Citizen.Wait(0)
        end
    end)


