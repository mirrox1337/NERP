Citizen.CreateThread(function()
    while (true) do
        SetVehicleDensityMultiplierThisFrame(0)
        SetPedDensityMultiplierThisFrame(1.0)
        SetRandomVehicleDensityMultiplierThisFrame(1.0)
        SetParkedVehicleDensityMultiplierThisFrame(1.0)
        SetScenarioPedDensityMultiplierThisFrame(1.0, 1.0)
        Citizen.Wait(0)
    end
end)