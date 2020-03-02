ESX                           = nil
local PlayerData              = {}

Citizen.CreateThread(function ()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
        PlayerData = ESX.GetPlayerData()
    end
end)

RegisterNUICallback('yellow_postPages', function(data, cb)
  TriggerServerEvent('chrono:yellow_postPagess', data.firstname or '', data.phone_number or '', data.lastname or '', data.message)
end)

RegisterNetEvent("chrono:yellow_getPagess")
AddEventHandler("chrono:yellow_getPagess", function(pagess)
  SendNUIMessage({event = 'yellow_pagess', pagess = pagess})
end)

RegisterNetEvent("chrono:yellow_newPagess")
AddEventHandler("chrono:yellow_newPagess", function(pages)
  SendNUIMessage({event = 'yellow_newPages', pages = pages})
end)

RegisterNetEvent("chrono:yellow_showError")
AddEventHandler("chrono:yellow_showError", function(title, message)
  SendNUIMessage({event = 'yellow_showError', message = message, title = title})
end)

RegisterNetEvent("chrono:yellow_showSuccess")
AddEventHandler("chrono:yellow_showSuccess", function(title, message)
  SendNUIMessage({event = 'yellow_showSuccess', message = message, title = title})
end)

RegisterNUICallback('yellow_getPagess', function(data, cb)
  TriggerServerEvent('chrono:yellow_getPagess', data.firstname, data.phone_number)
end)


RegisterNUICallback('deleteYellow', function(data)
  TriggerServerEvent('chrono:deleteYellow', data.id)
end)



