TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent('chrono:transfer')
AddEventHandler('chrono:transfer', function(to, amountt)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local zPlayer = ESX.GetPlayerFromId(to)
    local balance = 0
    if zPlayer ~= nil then
        balance = xPlayer.getAccount('bank').money
        zbalance = zPlayer.getAccount('bank').money
        if tonumber(_source) == tonumber(to) then
            -- advanced notification with bank icon
            TriggerClientEvent('esx:showAdvancedNotification', _source, 'Swish',
                               'Skicka pengar',
                               'Du kan inte skicka till dig själv!',
                               'CHAR_DETONATEPHONE', 9)
        else
            if balance <= 0 or balance < tonumber(amountt) or tonumber(amountt) <=
                0 then
                -- advanced notification with bank icon
                TriggerClientEvent('esx:showAdvancedNotification', _source,
                                   'Swish', 'Skicka pengar',
                                   'Inte tillräckligt med pengar att skicka!',
                                   'CHAR_DETONATEPHONE', 9)
            else
                xPlayer.removeAccountMoney('bank', tonumber(amountt))
                zPlayer.addAccountMoney('bank', tonumber(amountt))
                -- advanced notification with bank icon
                TriggerClientEvent('esx:showAdvancedNotification', _source,
                                   'Swish', 'Skicka pengar',
                                   'Du skickade ~r~' .. amountt ..
                                       ':- ~s~ till ~r~' .. to .. '.',
                                   'CHAR_DETONATEPHONE', 9)
                TriggerClientEvent('esx:showAdvancedNotification', to, 'Swish',
                                   'Skicka pengar', 'Du fick ~r~' ..
                                       amountt .. ':- ~s~ från ~r~' .. _source ..
                                       '.', 'CHAR_DETONATEPHONE', 9)
            end

        end
    end

end)


function myfirstname(phone_number, firstname, cb)
  MySQL.Async.fetchAll("SELECT firstname, phone_number FROM users WHERE users.firstname = @firstname AND users.phone_number = @phone_number", {
    ['@phone_number'] = phone_number,
	['@firstname'] = firstname
  }, function (data)
    cb(data[1])
  end)
end