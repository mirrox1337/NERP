ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Citizen['CreateThread'](function()
    MySQL['Async']['execute']([[ALTER TABLE `users` ADD COLUMN IF NOT EXISTS `animations` LONGTEXT]])
end)

ESX['RegisterServerCallback']('loffe_animations:get_favorites', function(source, cb)
    local xPlayer = ESX['GetPlayerFromId'](source)

    MySQL['Async']['fetchScalar']("SELECT animations FROM users WHERE identifier=@identifier", {['identifier'] = xPlayer['identifier']}, function(result)
        if not result then
            MySQL['Async']['execute']([[
                UPDATE `users` SET animations=@animations WHERE identifier=@identifier
            ]], {
                ['@animations'] = '{}',
                ['@identifier'] = xPlayer['identifier'],
            })
            cb('{}')
        else
            cb(result or '{}')
        end
    end)
end)

RegisterServerEvent('loffe_animations:update_favorites')
AddEventHandler('loffe_animations:update_favorites', function(animations)
    local xPlayer = ESX['GetPlayerFromId'](source)

    MySQL['Async']['execute']([[
        UPDATE `users` SET animations=@animations WHERE identifier=@identifier
    ]], {
        ['@animations'] = animations,
        ['@identifier'] = xPlayer['identifier'],
    })

    if Config['pNotify'] then
        pNotify(xPlayer['source'], Strings['Updated_Favorites'], 'success', 3500)
    else
        TriggerClientEvent('esx:showNotification', xPlayer['source'], Strings['Updated_Favorites'])
    end
end)

RegisterServerEvent('loffe_animations:syncAccepted')
AddEventHandler('loffe_animations:syncAccepted', function(requester, id)
    local accepted = source
    
    TriggerClientEvent('loffe_animations:playSynced', accepted, requester, id, 'Accepter')
    TriggerClientEvent('loffe_animations:playSynced', requester, accepted, id, 'Requester')

    if Config['Synced'][id]['LogAnim'] then
        local GetIdent = function(src, type)
            local identifiers = GetPlayerIdentifiers(src)
            for k, v in pairs(identifiers) do
                if v:match(type .. ':') then
                    return v:gsub(type .. ':', '')
                end
            end
            return false
        end

        local steam1Name = ''
        local steam2Name = ''

        PerformHttpRequest('https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v2/?key=' .. Config['SteamWebAPI'] .. '&format=json&steamids=' .. tonumber(GetIdent(requester, 'steam'), 16), function(err, text, headers)
            steam1Name = json.decode(text)['response']['players'][1]['personaname']
        end, 'GET', '')

        PerformHttpRequest('https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v2/?key=' .. Config['SteamWebAPI'] .. '&format=json&steamids=' .. tonumber(GetIdent(accepted, 'steam'), 16), function(err, text, headers)
            steam2Name = json.decode(text)['response']['players'][1]['personaname']
        end, 'GET', '')

        while steam1Name == '' or steam2Name == '' do Wait(0) end

        DiscordLog(('[%s](https://steamcommunity.com/profiles/' .. tonumber(GetIdent(requester, 'steam'), 16) .. ') (<@%s>) gjorde synkade animationen "%s" med [%s](' .. 'https://steamcommunity.com/profiles/' .. tonumber(GetIdent(accepted, 'steam'), 16) .. ') (<@%s>)'):format(steam1Name, GetIdent(requester, 'discord'), Config['Synced'][id]['Label'], steam2Name, GetIdent(accepted, 'discord')))
    end
end)

RegisterServerEvent('loffe_animations:requestSynced')
AddEventHandler('loffe_animations:requestSynced', function(target, id)
    local requester = source
    local xPlayer = ESX['GetPlayerFromId'](requester)
    
    MySQL['Async']['fetchScalar']("SELECT firstname FROM users WHERE identifier=@identifier", {['identifier'] = xPlayer['identifier']}, function(firstname)
        TriggerClientEvent('loffe_animations:syncRequest', target, requester, id, firstname)
    end)
end)

pNotify = function(src, message, messagetype, messagetimeout)
    TriggerClientEvent("pNotify:SendNotification", src, {
        text = (message),
        type = messagetype,
        timeout = (messagetimeout),
        layout = "bottomCenter",
        queue = "global"
    })
end

DiscordLog = function(msg)
    local embed = {
        {
            ["color"] = "8663711",
            ["title"] = "Animation",
            ["description"] = msg,
            ["footer"] = {
                ["text"] = os.date("%A, %d %B %Y"):lower()
            }
        }
    }

    PerformHttpRequest(Config['DiscordWebhook'], function(err, text, headers) end, 'POST', json.encode({embeds = embed}), {['Content-Type'] = 'application/json'})
end