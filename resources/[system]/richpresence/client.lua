local appid = '520338118184796160' -- Gör en application @ https://discordapp.com/developers/applications/
local asset = 'king' -- Ladda upp en bild och kopiera namnet https://discordapp.com/developers/applications/APPID/rich-presence/assets
local name = GetPlayerName(PlayerId())
local id = GetPlayerServerId(PlayerId())

ESX = nil

Citizen.CreateThread(function()

    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()

    while true do
        Citizen.Wait(5000)
        --SetRichPresence(CountPlayers() .. '/32 |  '.. ESX.PlayerData.job.label .. ' - ' .. ESX.PlayerData.job.grade_label .. '')
        SetRichPresence(CountPlayers() .. '/32 | ' .. name .. ' | Yrke: ' .. ESX.PlayerData.job.label .. ' |')
        SetDiscordAppId(appid)
        SetDiscordRichPresenceAsset(asset)
    end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)




function CountPlayers()
    local count = 0

    for i = 0, 31 do
        if NetworkIsPlayerActive(i) then
            count = count + 1
        end
    end

    return count
end