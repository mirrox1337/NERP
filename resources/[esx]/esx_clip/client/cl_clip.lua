ESX          = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx_clip:clipcli')
AddEventHandler('esx_clip:clipcli', function()
  ped = GetPlayerPed(-1)
  if IsPedArmed(ped, 4) then
    hash=GetSelectedPedWeapon(ped)
    if hash~=nil then
      TriggerServerEvent('esx_clip:remove')
      AddAmmoToPed(GetPlayerPed(-1), hash,25)
      exports['mythic_notify']:DoHudText('inform', 'Du använde ammuniation.', { ['background-color'] = '#009c10', ['color'] = '#fff' })
    else
      exports['mythic_notify']:DoHudText('inform', 'Du har inte ett vapen i handen.', { ['background-color'] = '#b00000', ['color'] = '#fff' })
    end
  else
    exports['mythic_notify']:DoHudText('inform', 'Denna typ av ammunation är inte kompatibel.', { ['background-color'] = '#b00000', ['color'] = '#fff' })
  end
end)
