ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Citizen.CreateThread(function()
	TriggerEvent('chat:addSuggestion', '/twt',  "Skicka en tweet",  { { name = "Meddelande", help = "Skicka en tweet" } } )
end)
Citizen.CreateThread(function()
	TriggerEvent('chat:addSuggestion', '/pm',  "Skicka ett pm /pm 1 1 Detta är ett",  { { name = "Meddelande", help = "/pm 1 1 Detta är ett PM" } } )
end)

--[[
local restartTimes = {3, 7, 17}

function CronTask(d, h, m)
    TriggerClientEvent('chatMessage', -1, "SERVER", {255, 50, 0}, "Restart om 5 minuter!")
end

function CronTask2(d, h, m)
    TriggerClientEvent('chatMessage', -1, "SERVER", {255, 50, 0}, "Restart om 15 minuter!")
end

function CronTask3(d, h, m)
    TriggerClientEvent('chatMessage', -1, "SERVER", {255, 50, 0}, "Restart om 30 minuter!")
end

for i=1, #restartTimes, 1 do
    TriggerEvent('cron:runAt', restartTimes[i]-1, 55, CronTask)
end

for i=1, #restartTimes, 1 do
    TriggerEvent('cron:runAt', restartTimes[i]-1, 45, CronTask2)
end

for i=1, #restartTimes, 1 do
    TriggerEvent('cron:runAt', restartTimes[i]-1, 30, CronTask3)
end

]]
