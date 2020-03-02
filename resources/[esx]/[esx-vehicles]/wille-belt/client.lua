
local isUiOpen = false

local rabbits = {}

local ragdoll = false
local ragdol = true

local beltOn       = false
local currentLevel = 0
--Belt
local speedBuffer  = {}
local velBuffer    = {}
local wasInCar     = false

local UI = { 

	x =  0.033 ,
	y =  -0.048 ,

}

IsCar = function(veh)
		    local vc = GetVehicleClass(veh)
		    return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)
        end	

Fwv = function (entity)
		    local hr = GetEntityHeading(entity) + 90.0
		    if hr < 0.0 then hr = 360.0 + hr end
		    hr = hr * 0.0174533
		    return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
      end

-- Fordonsmenyn tar informationen här (wille)
RegisterNetEvent('balte')
	AddEventHandler('balte', function()
		if GetVehiclePedIsIn(GetPlayerPed(-1)) ~= 0 then
			beltOn = not beltOn				  
				if beltOn then  
					--sendNotification('Du tog på dig <font color="green">Bältet</font>', 'success', 2000)
					exports['mythic_notify']:DoHudText('inform', 'Du tog på dig bältet.', { ['background-color'] = '#009c10', ['color'] = '#fff' })
					SendNUIMessage({
		            displayWindow = 'false'
		            })
		            isUiOpen = true
		  else 
					--sendNotification('Du tog av dig <font color="red">Bältet</font>', 'success', 2000)
					exports['mythic_notify']:DoHudText('inform', 'Du tog av dig bältet.', { ['background-color'] = '#b00000', ['color'] = '#fff' })
                    SendNUIMessage({
		            displayWindow = 'true'
		            })
		            isUiOpen = true 
                  end 
	           end
	      end)
-- Här slutar det

Citizen.CreateThread(function()
	Citizen.Wait(500)
	while true do
        local sleep = 750
		
		local ped = GetPlayerPed(-1)
		local car = GetVehiclePedIsIn(ped)
		
		if car ~= 0 and (wasInCar or IsCar(car)) then
            sleep = 5
		
			wasInCar = true
			if isUiOpen == false and not IsPlayerDead(PlayerId()) then
                SendNUIMessage({
            	   displayWindow = 'true'
            	   })
                isUiOpen = true 			
            end
			
			if beltOn then DisableControlAction(0, 75) end
			
			speedBuffer[2] = speedBuffer[1]
			speedBuffer[1] = GetEntitySpeed(car)
			
			if speedBuffer[2] ~= nil 
			   and not beltOn
			   and GetEntitySpeedVector(car, true).y > 1.0  
			   and speedBuffer[1] > 19.25
			   and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[1] * 0.255) then
			   
				local co = GetEntityCoords(ped)
				local fw = Fwv(ped)
				SetEntityCoords(ped, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true)
				SetEntityVelocity(ped, velBuffer[2].x, velBuffer[2].y, velBuffer[2].z)
				Citizen.Wait(1)
				SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
			end
				
			velBuffer[2] = velBuffer[1]
			velBuffer[1] = GetEntityVelocity(car)
		elseif wasInCar then
			wasInCar = false
			beltOn = false
			speedBuffer[1], speedBuffer[2] = 0.0, 0.0
			if isUiOpen == true and not IsPlayerDead(PlayerId()) then
                SendNUIMessage({
            	   displayWindow = 'false'
            	   })
                isUiOpen = false 
            end
		end
		Citizen.Wait(sleep)
	end
end)



Citizen.CreateThread(function()
	Citizen.Wait(500)

	while true do
		
		local ped = GetPlayerPed(-1)
		local car = GetVehiclePedIsIn(ped)

		if car == 0 then
			beltOn = false
			DisplayRadar(false)
		end
		
		if car ~= 0 and (wasInCar or IsCar(car)) then
			DisplayRadar(true)
		 wasInCar = true
             if isUiOpen == false and not IsPlayerDead(PlayerId()) then
                SendNUIMessage({
            	   displayWindow = 'true'
            	   })
                isUiOpen = true 			
            end
			
			if beltOn then DisableControlAction(0, 75) end
			
			speedBuffer[2] = speedBuffer[1]
			speedBuffer[1] = GetEntitySpeed(car)

			--[[if speedBuffer[2] ~= nil then
				if speedBuffer[2] - speedBuffer[1] > 0 then
					print('gamla: ' .. speedBuffer[2])
					print('nya: ' .. speedBuffer[1])
				else
					print('wtf gamla: ' .. speedBuffer[2])
					print('wtf nya: ' .. speedBuffer[1])
				end
			end]]
			
			if speedBuffer[2] ~= nil 
				and not beltOn
				and GetEntitySpeedVector(car, true).y > 11.00  
				and speedBuffer[2] > Cfg.MinSpeed 
				and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[1] * Cfg.DiffTrigger) then

				local co = GetEntityCoords(ped)
				local fw = Fwv(ped)
				SetEntityCoords(ped, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true)
				SetEntityVelocity(ped, velBuffer[2].x, velBuffer[2].y, velBuffer[2].z)
				Citizen.Wait(1)
				TriggerEvent('fivem:shake')
				TriggerEvent('fivem:knockout')
				TriggerEvent('fivem:heartbeat') 
				TriggerEvent('fivem:bang')
				TimeLeft = Config.TimeToKnocked
				repeat                                	
				TriggerEvent("mt:missiontext", 'Du blev, ~r~knockad ~w~i ' .. TimeLeft .. ' ~b~sekunder', 1000)
				TimeLeft = TimeLeft - 1
				Citizen.Wait(1000)
				until(TimeLeft == 0)
				TriggerEvent('fivem:knockout')
			end
				
			velBuffer[2] = velBuffer[1]
			velBuffer[1] = GetEntityVelocity(car)
			
		elseif wasInCar then
			wasInCar = false
			beltOn = false
			speedBuffer[1], speedBuffer[2] = 0.0, 0.0
			if isUiOpen == true and not IsPlayerDead(PlayerId()) then
                SendNUIMessage({
            	   displayWindow = 'false'
            	   })
                isUiOpen = false 
            end
		end
		Citizen.Wait(0)
	end
end)



function setRagdoll(flag)
	ragdoll = flag
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(50)
		if ragdoll then
			SetPedToRagdoll(GetPlayerPed(-1), 1000, 1000, 0, 0, 0, 0)
		end
	end
end)

RegisterNetEvent('fivem:knockout')
AddEventHandler('fivem:knockout', function()
	if ( ragdol ) then
		setRagdoll(true)
		ragdol = false
	else
		setRagdoll(false)
		ragdol = true
	end
end)

RegisterNetEvent('fivem:heartbeat')
AddEventHandler('fivem:heartbeat', function()
    
    DoScreenFadeOut(2000)
	Citizen.Wait(2500)
	playSound('heart', 20)
	DoScreenFadeIn(2000)
	Citizen.Wait(2500)
	DoScreenFadeOut(2000)
	Citizen.Wait(2500)
	playSound('heart', 20)
	DoScreenFadeIn(2000)
	Citizen.Wait(2500)
	DoScreenFadeOut(2000)
	Citizen.Wait(2500)
	playSound('heart', 20)
	DoScreenFadeIn(2000)
	Citizen.Wait(2500)
	DoScreenFadeOut(2000)
	Citizen.Wait(2500)
	playSound('heart', 20)
	DoScreenFadeIn(2000)
end)

RegisterNetEvent('fivem:shake')
AddEventHandler('fivem:shake', function()
    
ShakeGameplayCam("ROAD_VIBRATION_SHAKE", 18.75)
SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
SetPedIsDrunk(GetPlayerPed(-1), true)
Citizen.Wait(40000)
StopGameplayCamShaking(false)
ResetPedMovementClipset(GetPlayerPed(-1), 0)
SetPedIsDrunk(GetPlayerPed(-1), false)
end)

RegisterNetEvent('fivem:bang')
AddEventHandler('fivem:bang', function()
SetTimecycleModifier("spectator5")
 Citizen.Wait(40000)
    ClearTimecycleModifier()
    ResetScenarioTypesEnabled()
    SetPedMotionBlur(GetPlayerPed(-1), false)

end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        if IsPlayerDead(PlayerId()) and isUiOpen == true then
            SendNUIMessage({
                    displayWindow = 'false'
               })
            isUiOpen = false
        end    

    end
end)   

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsDisabledControlJustReleased(0, 23) and beltOn == true then
			--sendNotification('Bältet tog i <font color="red">Axeln</font>', 'error', 2000)
			exports['mythic_notify']:DoHudText('inform', 'Bältet tog i axeln.', { ['background-color'] = '#b00000', ['color'] = '#fff' })
		end
	end
end)

function drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
      SetTextOutline()
    end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
  end

local function isPedDrivingAVehicle()
    local ped = GetPlayerPed(-1)
    vehicle = GetVehiclePedIsIn(ped, false)
    if IsPedInAnyVehicle(ped, false) then
        -- Check if ped is in driver seat
        if GetPedInVehicleSeat(vehicle, -1) == ped then
            local class = GetVehicleClass(vehicle)
			-- We don't want planes, helicopters, bicycles and trains
			
            if class ~= 15 and class ~= 16 and class ~=21 and class ~=13 then
                return true
            end
        end
    end
    return false
end

--notification
function sendNotification(message, messageType, messageTimeout)
	TriggerEvent("pNotify:SendNotification", {
		text = message,
		type = messageType,
		queue = "duty",
		timeout = messageTimeout,
		layout = "bottomCenter"
	})
end

function playSound(sound, waitTime)
  TriggerServerEvent('InteractSound_SV:PlayOnSource', sound, 0.2)
  Citizen.Wait(waitTime)
end

function drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
      SetTextOutline()
  end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

RegisterNUICallback('reponseText', function(data, cb)
  local limit = data.limit or 255
  local text = data.text or ''
  
  DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", text, "", "", "", limit)
  while (UpdateOnscreenKeyboard() == 0) do
      DisableAllControlActions(0);
      Wait(0);
  end
  if (GetOnscreenKeyboardResult()) then
      text = GetOnscreenKeyboardResult()
  end
  cb(json.encode({text = text}))
end)


----Gps-----