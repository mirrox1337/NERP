ESX               = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

-----

RegisterNetEvent('chrono:startVest')
AddEventHandler('chrono:startVest', function(source)
    VestAnimation()
end)

function VestAnimation()
    local playerPed = GetPlayerPed(-1)
    local dict1 = "clothingtrousers"
    local dict2 = "clothingtie"

    Citizen.CreateThread(function()
        RequestAnimDict(dict1)
        while not HasAnimDictLoaded(dict1) do
        Citizen.Wait(0)
        end
        TaskPlayAnim(GetPlayerPed(-1), dict1 ,"try_trousers_negative_a" ,8.0, -8.0, -1, 0, 0, false, false, false )
        Citizen.Wait(4000)
        TriggerEvent('skinchanger:getSkin', function(skin)
            local clothes = {
                ['bproof_1'] = 16,
                ['bproof_2'] = 2
            }

            TriggerEvent('skinchanger:loadClothes', skin, clothes)
        end)
        RequestAnimDict(dict2)
        while not HasAnimDictLoaded(dict2) do
        Citizen.Wait(0)
        end
        TaskPlayAnim(GetPlayerPed(-1), dict2 ,"try_tie_neutral_a" ,8.0, -8.0, -1, 0, 0, false, false, false )
        Citizen.Wait(1000)
        SetPedArmour(GetPlayerPed(-1), 100)
    end)
end

