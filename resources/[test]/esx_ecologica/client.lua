local thirst, hunger = 0, 0
local PlayerData = {}
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	while true do
	Citizen.Wait(900)
		job = ESX.GetPlayerData().job.label
		job2 = ESX.GetPlayerData().job.grade_label
	end
end)

Citizen.CreateThread(function() 
	while true do
		Citizen.Wait(250)
		local hour = GetClockHours()
		local minutes = GetClockMinutes()
        SendNUIMessage({
			show = 		IsPauseMenuActive(),
            thirst = 	math.ceil(thirst),
			hunger = 	math.ceil(hunger),
			hora = 		hour.. ":" ..minutes,	
			label = 	job,	
			label2 = 	job2,

		})	
	end
end)
  

AddEventHandler("esx_ecologica:updateBasics", function(basics)
    hunger, thirst = basics[1].percent, basics[2].percent
end)