ESX = nil


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_posten:receiveMoney')
AddEventHandler('esx_posten:receiveMoney', function()
    local _source = source
    local Player = ESX.GetPlayerFromId(_source)
    local moneytoget = math.random(100, 120)
    Player.addMoney(moneytoget)
    sendNotification(_source, 'Du klarade av körningen och tog emot ~g~'..moneytoget..' SEK')
end)


--notification
function sendNotification(xSource, message)
    TriggerClientEvent('notification', xSource, message)
end