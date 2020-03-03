ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('duty:police')
AddEventHandler('duty:police', function(job)

        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer.job.name == 'police' and xPlayer.job.grade == 0 then
        xPlayer.setJob('offpolice', 0)
    elseif xPlayer.job.name == 'police' and xPlayer.job.grade == 1 then
        xPlayer.setJob('offpolice', 1)
    elseif xPlayer.job.name == 'police' and xPlayer.job.grade == 2 then
        xPlayer.setJob('offpolice', 2)
    elseif xPlayer.job.name == 'police' and xPlayer.job.grade == 3 then
        xPlayer.setJob('offpolice', 3)
    elseif xPlayer.job.name == 'police' and xPlayer.job.grade == 4 then
        xPlayer.setJob('offpolice', 4)
    elseif xPlayer.job.name == 'police' and xPlayer.job.grade == 5 then
        xPlayer.setJob('offpolice', 5)
    elseif xPlayer.job.name == 'police' and xPlayer.job.grade == 6 then
        xPlayer.setJob('offpolice', 6)
    elseif xPlayer.job.name == 'police' and xPlayer.job.grade == 9 then
        xPlayer.setJob('offpolice', 9)
    end

    if xPlayer.job.name == 'offpolice' and xPlayer.job.grade == 0 then
        xPlayer.setJob('police', 0)
    elseif xPlayer.job.name == 'offpolice' and xPlayer.job.grade == 1 then
        xPlayer.setJob('police', 1)
    elseif xPlayer.job.name == 'offpolice' and xPlayer.job.grade == 2 then
        xPlayer.setJob('police', 2)
    elseif xPlayer.job.name == 'offpolice' and xPlayer.job.grade == 3 then
        xPlayer.setJob('police', 3)
    elseif xPlayer.job.name == 'offpolice' and xPlayer.job.grade == 4 then
        xPlayer.setJob('police', 4)
    elseif xPlayer.job.name == 'offpolice' and xPlayer.job.grade == 5 then
        xPlayer.setJob('police', 5)
    elseif xPlayer.job.name == 'offpolice' and xPlayer.job.grade == 6 then
        xPlayer.setJob('police', 6)
    elseif xPlayer.job.name == 'offpolice' and xPlayer.job.grade == 9 then
        xPlayer.setJob('police', 9)
    end
end)

RegisterServerEvent('duty:ambulance')
AddEventHandler('duty:ambulance', function(job)

        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer.job.name == 'ambulance' and xPlayer.job.grade == 1 then
        xPlayer.setJob('offambulance', 1)
    elseif xPlayer.job.name == 'ambulance' and xPlayer.job.grade == 2 then
        xPlayer.setJob('offambulance', 2)
    elseif xPlayer.job.name == 'ambulance' and xPlayer.job.grade == 3 then
        xPlayer.setJob('offambulance', 3)
    end

    if xPlayer.job.name == 'offambulance' and xPlayer.job.grade == 1 then
        xPlayer.setJob('ambulance', 1)
    elseif xPlayer.job.name == 'offambulance' and xPlayer.job.grade == 2 then
        xPlayer.setJob('ambulance', 2)
    elseif xPlayer.job.name == 'offambulance' and xPlayer.job.grade == 3 then
        xPlayer.setJob('ambulance', 3)
    end
end)

RegisterServerEvent('duty:Securitas')
AddEventHandler('duty:Securitas', function(job)

        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer.job.name == 'Securitas' and xPlayer.job.grade == 1 then
        xPlayer.setJob('offSecuritas', 1)
    elseif xPlayer.job.name == 'Securitas' and xPlayer.job.grade == 2 then
        xPlayer.setJob('offSecuritas', 2)
    elseif xPlayer.job.name == 'Securitas' and xPlayer.job.grade == 3 then
        xPlayer.setJob('offSecuritas', 3)
    elseif xPlayer.job.name == 'Securitas' and xPlayer.job.grade == 4 then
        xPlayer.setJob('offSecuritas', 4)
    end

    if xPlayer.job.name == 'offSecuritas' and xPlayer.job.grade == 1 then
        xPlayer.setJob('Securitas', 1)
    elseif xPlayer.job.name == 'offSecuritas' and xPlayer.job.grade == 2 then
        xPlayer.setJob('Securitas', 2)
    elseif xPlayer.job.name == 'offSecuritas' and xPlayer.job.grade == 3 then
        xPlayer.setJob('Securitas', 3)
    elseif xPlayer.job.name == 'offSecuritas' and xPlayer.job.grade == 4 then
        xPlayer.setJob('Securitas', 4)
    end
end)

RegisterServerEvent('duty:mecano')
AddEventHandler('duty:mecano', function(job)

        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer.job.name == 'mecano' and xPlayer.job.grade == 1 then
        xPlayer.setJob('offmecano', 1)
    elseif xPlayer.job.name == 'mecano' and xPlayer.job.grade == 2 then
        xPlayer.setJob('offmecano', 2)
    elseif xPlayer.job.name == 'mecano' and xPlayer.job.grade == 3 then
        xPlayer.setJob('offmecano', 3)
    elseif xPlayer.job.name == 'mecano' and xPlayer.job.grade == 4 then
        xPlayer.setJob('offmecano', 4)
    end

    if xPlayer.job.name == 'offmecano' and xPlayer.job.grade == 1 then
        xPlayer.setJob('mecano', 1)
    elseif xPlayer.job.name == 'offmecano' and xPlayer.job.grade == 2 then
        xPlayer.setJob('mecano', 2)
    elseif xPlayer.job.name == 'offmecano' and xPlayer.job.grade == 3 then
        xPlayer.setJob('mecano', 3)
    elseif xPlayer.job.name == 'offmecano' and xPlayer.job.grade == 4 then
        xPlayer.setJob('mecano', 4)
    end
end)

--notification
function sendNotification(xSource, message, messageType, messageTimeout)
    TriggerClientEvent("pNotify:SendNotification", xSource, {
        text = message,
        type = messageType,
        queue = "qalle",
        timeout = messageTimeout,
        layout = "bottomCenter"
    })
end