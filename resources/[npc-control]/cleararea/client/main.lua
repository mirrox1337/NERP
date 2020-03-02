-- CLEAR PEDS
Citizen.CreateThread(function()
    while (true) do
		ClearAreaOfPeds(975.08, -116.13, 74.35, 40.0, 1) -- NOTRIOUS
        Citizen.Wait(100)
    end
end)

Citizen.CreateThread(function()
	while (true) do
		ClearAreaOfPeds(-552.00, 295.00, 83.00, 82.0, 1) -- URBICUS
        Citizen.Wait(100)
    end
end)

--[[
Citizen.CreateThread(function()
    while (true) do
        ClearAreaOfPeds(342.44, -587.00, 27.79, 50.0, 1) -- SJUKHUSET
        Citizen.Wait(0)
    end
end)
--]]

-- CLEAR VEHICLES
Citizen.CreateThread(function()
    while (true) do
		ClearAreaOfVehicles(975.08, -116.13, 74.35, 30.0, false, false, false, false, false); -- NOTORIOUS
        Citizen.Wait(100)
    end
end)