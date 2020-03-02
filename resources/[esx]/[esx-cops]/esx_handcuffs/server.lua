ESX               = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

----
ESX.RegisterUsableItem('handklovar', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('handklovar', 1)

	TriggerClientEvent('qalle_handklovar:cuffcheck', source)
end)

RegisterServerEvent('qalle_handklovar:cuffing')
AddEventHandler('qalle_handklovar:cuffing', function(source)
  TriggerClientEvent('qalle_handklovar:cuff', source)
end)

----
ESX.RegisterUsableItem('nyckel', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('nyckel', 1)

	TriggerClientEvent('qalle_handklovar:unlockingcuffs', source)
end)

RegisterServerEvent('qalle_handklovar:unlocking')
AddEventHandler('qalle_handklovar:unlocking', function(source)
  TriggerClientEvent('qalle_handklovar:unlockingcuffs', source)
end)
---


RegisterServerEvent('esx_drag:drag')
AddEventHandler('esx_drag:drag', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'police' then
		TriggerClientEvent('esx_drag:drag', target, source)
	else
		print(('esx_drag: %s attempted to drag (not cop)!'):format(xPlayer.identifier))
	end
end)