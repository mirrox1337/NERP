local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback("wille-food:checkMoney", function(source, cb)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local money = xPlayer.getMoney()

    cb(money)
end)


RegisterServerEvent("wille-food:removeMoney")
AddEventHandler("wille-food:removeMoney", function(money)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    xPlayer.removeMoney(money)
end)