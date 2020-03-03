
ESX = nil
local PlayerData                = {}

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)


local radioMenu = false

function PrintChatMessage(text)
    TriggerEvent('chatMessage', "system", { 255, 0, 0 }, text)
end

function enableRadio(enable)

  SetNuiFocus(true, true)
  radioMenu = enable

  SendNUIMessage({

    type = "enableui",
    enable = enable

  })

end

--- KONTROLLERAR 'Config.enableCmd'

RegisterCommand('radio', function(source, args)
    if Config.enableCmd then
      enableRadio(true)
    end
end, false)


-- RADIO TEST

RegisterCommand('radiotest', function(source, args)
  local playerName = GetPlayerName(PlayerId())
  local data = exports.tokovoip_script:getPlayerData(playerName, "radio:channel")

  print(tonumber(data))

  if data == "nil" then
    exports['mythic_notify']:SendAlert('inform', playerName .. ' är för närvarande inte på någon radiofrekvens')
  else
    exports['mythic_notify']:SendAlert('inform', playerName .. ' är för närvarande på radiofrekvens: ' .. data .. ' MHz')
 end

end, false)

-- ANSLUTER TILL RADIO

RegisterNUICallback('joinRadio', function(data, cb)
    local _source = source
    local PlayerData = ESX.GetPlayerData(_source)
    local playerName = GetPlayerName(PlayerId())
    local getPlayerRadioChannel = exports.tokovoip_script:getPlayerData(playerName, "radio:channel")

    if tonumber(data.channel) ~= tonumber(getPlayerRadioChannel) then
        if tonumber(data.channel) <= Config.RestrictedChannels then
          if(PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'Securitas' or PlayerData.job.name == 'gang') then
            exports.tokovoip_script:removePlayerFromRadio(getPlayerRadioChannel)
            exports.tokovoip_script:setPlayerData(playerName, "radio:channel", tonumber(data.channel), true);
            exports.tokovoip_script:addPlayerToRadio(tonumber(data.channel))
            exports['mythic_notify']:SendAlert('inform', 'Du är ansluten till radiofrekvens:  ' .. data.channel .. ' MHz')
          elseif not (PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'Securitas' or PlayerData.job.name == 'gang') then
            --- info że nie możesz dołączyć bo nie jesteś policjantem
            exports['mythic_notify']:SendAlert('error', 'Du kan inte gå med i krypterade kanaler!')
          end
        end
        if tonumber(data.channel) > Config.RestrictedChannels then
          exports.tokovoip_script:removePlayerFromRadio(getPlayerRadioChannel)
          exports.tokovoip_script:setPlayerData(playerName, "radio:channel", tonumber(data.channel), true);
          exports.tokovoip_script:addPlayerToRadio(tonumber(data.channel))
          exports['mythic_notify']:SendAlert('inform', 'Du är ansluten till radiofrekvens:  ' .. data.channel .. ' MHz')
          
        end
      else
        exports['mythic_notify']:SendAlert('inform', 'Du är redan ansluten till radiofrekvens:  ' .. data.channel .. ' MHz')
      end
    cb('ok')
end)

-- LÄMNAR RADIO

RegisterNUICallback('leaveRadio', function(data, cb)
   local playerName = GetPlayerName(PlayerId())
   local getPlayerRadioChannel = exports.tokovoip_script:getPlayerData(playerName, "radio:channel")

    if getPlayerRadioChannel == "nil" then
      exports['mythic_notify']:SendAlert('inform', 'Du är för närvarande inte på någon radiofrekvens')
        else
          exports.tokovoip_script:removePlayerFromRadio(getPlayerRadioChannel)
          exports.tokovoip_script:setPlayerData(playerName, "radio:channel", "nil", true)
          exports['mythic_notify']:SendAlert('inform', 'Du lämnade radiofrekvens: ' .. getPlayerRadioChannel .. ' MHz')
    end

   cb('ok')

end)

RegisterNUICallback('escape', function(data, cb)
  local playerPed = GetPlayerPed(-1)

    enableRadio(false)
    SetNuiFocus(false, false)
    IsAnimated = false
    ClearPedSecondaryTask(playerPed)
		DeleteObject(prop)


    cb('ok')
end)

-- NET EVENT

RegisterNetEvent('ls-radio:use')
AddEventHandler('ls-radio:use', function()
  enableRadio(true)

  -- ANIMATION / PROP
  local playerPed = GetPlayerPed(-1)
		
    local prop_name = 'prop_cs_hand_radio'
    -- prop_cs_walkie_talkie
    -- prop_police_radio_handset
    
    local dict = "cellphone@"
		IsAnimated = true 	
		Citizen.CreateThread(function()
	        local x,y,z = table.unpack(GetEntityCoords(playerPed))
	        prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)		
		RequestAnimDict(dict)
			while not HasAnimDictLoaded(dict) do
			Citizen.Wait(0)
			end			
			AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 57005), 0.15, 0.0, -0.035, 80.0, 0.0, 100.0, true, true, false, true, 1, true)
			TaskPlayAnim(playerPed, dict, "cellphone_text_read_base", 3.5, -8, -1, 49, 0, 0, 0, 0)
		end)
end)

RegisterNetEvent('ls-radio:onRadioDrop')
AddEventHandler('ls-radio:onRadioDrop', function(source)
  local playerName = GetPlayerName(source)
  local getPlayerRadioChannel = exports.tokovoip_script:getPlayerData(playerName, "radio:channel")


  if getPlayerRadioChannel ~= "nil" then

    exports.tokovoip_script:removePlayerFromRadio(getPlayerRadioChannel)
    exports.tokovoip_script:setPlayerData(playerName, "radio:channel", "nil", true)
    exports['mythic_notify']:SendAlert('inform', 'Du lämnade radiofrekvens: ' .. getPlayerRadioChannel .. ' MHz')
    
end
end)

Citizen.CreateThread(function()
    while true do
        if radioMenu then
            DisableControlAction(0, 1, guiEnabled) -- LookLeftRight
            DisableControlAction(0, 2, guiEnabled) -- LookUpDown

            DisableControlAction(0, 142, guiEnabled) -- MeleeAttackAlternate

            DisableControlAction(0, 106, guiEnabled) -- VehicleMouseControlOverride

            if IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
                SendNUIMessage({
                    type = "click"
                })
            end
        end
        Citizen.Wait(0)
    end
end)
