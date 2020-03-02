ESX  							= nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)


 local onlinePlayers = 0

function GetPlayers()

	onlinePlayers = 0

       for _, player in ipairs(GetActivePlayers()) do
           local ped = GetPlayerPed(player)
           onlinePlayers = onlinePlayers + 1	   
       end
end

RegisterCommand('online', function()

    GetPlayers()
    ESX.ShowNotification("~h~[Online]~r~ : " .. onlinePlayers .. " / 64")

end)


--[[RegisterCommand('polis', function()

    ESX.TriggerServerCallback('esx_scoreboard:copscount',function(copscount)

        if copscount == 0 then
            copscount = 0
        end

        ESX.ShowNotification("~h~[Polis]~b~ : " .. copscount .."")

    end)

end)]]

