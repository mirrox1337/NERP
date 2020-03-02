
RegisterServerEvent("max:lowmoney")
AddEventHandler("max:lowmoney", function(money)
    local _source = source	
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeMoney(money)
end)

