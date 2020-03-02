local shopData = nil

Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local Licenses = {}

--[[Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        player = GetPlayerPed(-1)
        coords = GetEntityCoords(player)
        if IsInMohammedsLivsZone(coords) then
           --[[ if IsInAladdinFiskebutikZone(coords) then
                if IsControlJustReleased(0, Keys["E"]) then
                    OpenShopInv("aladdinfiskebutik")
                    Citizen.Wait(2000)
                end
            end
            if IsInDealerZone(coords) then
                if IsControlJustReleased(0, Keys["E"]) then
                    OpenShopInv("dealer")
                    Citizen.Wait(2000)
                end
            end
            if IsInMohammedsLivsZone(coords) then
                if IsControlJustReleased(0, Keys["E"]) then
                    OpenShopInv("mohammedslivs")
                    Citizen.Wait(2000)
                end
            end
           --[[ if IsInPrisonShopZone(coords) then
                if IsControlJustReleased(0, Keys["E"]) then
                    OpenShopInv("prison")
                    Citizen.Wait(2000)
                end
            end
            --[[
            if IsInInetShopZone(coords) then
                if IsControlJustReleased(0, Keys["E"]) then
                    OpenShopInv("inet")
                    Citizen.Wait(2000)
                end
            end
            if IsInSexShopZone(coords) then
                if IsControlJustReleased(0, Keys["E"]) then
                    OpenShopInv("sex")
                    Citizen.Wait(2000)
                end
            end
            --]]
            --if IsInUrbicusBarZone(coords) then
                --if IsControlJustReleased(0, Keys["E"]) then
                    --OpenShopInv("urbicusbar")
                    --Citizen.Wait(2000)
                --end
           -- end
            --[[if IsInSjukhusZone(coords) then
                if IsControlJustReleased(0, Keys["E"]) then
                    OpenShopInv("sjukhus")
                    Citizen.Wait(2000)
                end
            end
            if IsInGymZone(coords) then
                if IsControlJustReleased(0, Keys["E"]) then
                    OpenShopInv("gym")
                    Citizen.Wait(2000)
                end
            end
            --[[
            if IsInVendingZone(coords) then
                if IsControlJustReleased(0, Keys["E"]) then
                    OpenShopInv("vending")
                    Citizen.Wait(2000)
                end
            end
            
        end
    end
end)]]

function OpenShopInv(shoptype)
    text = "Handla"
    data = {text = text}
    inventory = {}

    ESX.TriggerServerCallback("suku:getShopItems", function(shopInv)
        for i = 1, #shopInv, 1 do
            table.insert(inventory, shopInv[i])
        end
    end, shoptype)

    Citizen.Wait(500)
    TriggerEvent("esx_inventoryhud:openShopInventory", data, inventory)
end

RegisterNetEvent("suku:OpenCustomShopInventory")
AddEventHandler("suku:OpenCustomShopInventory", function(type, shopinventory)
    text = "Handla"
    data = {text = text}
    inventory = {}

    ESX.TriggerServerCallback("suku:getCustomShopItems", function(shopInv)
        for i = 1, #shopInv, 1 do
            table.insert(inventory, shopInv[i])
        end
    end, type, shopinventory)
    Citizen.Wait(500)

    TriggerEvent("esx_inventoryhud:openShopInventory", data, inventory)
end)

RegisterNetEvent("esx_inventoryhud:openShopInventory")
AddEventHandler("esx_inventoryhud:openShopInventory", function(data, inventory)
        setShopInventoryData(data, inventory, weapons)
        openShopInventory()
end)

function setShopInventoryData(data, inventory)
    shopData = data

    SendNUIMessage(
        {
            action = "setInfoText",
            text = data.text
        }
    )

    items = {}

    SendNUIMessage(
        {
            action = "setShopInventoryItems",
            itemList = inventory
        }
    )
end

function openShopInventory()
    loadPlayerInventory()
    isInInventory = true

    SendNUIMessage(
        {
            action = "display",
            type = "shop"
        }
    )

    SetNuiFocus(true, true)
end

RegisterNUICallback("TakeFromShop", function(data, cb)
        if IsPedSittingInAnyVehicle(playerPed) then
            return
        end

        if type(data.number) == "number" and math.floor(data.number) == data.number then
            local dict = "mp_common"
		
				RequestAnimDict(dict)
				while not HasAnimDictLoaded(dict) do
					Citizen.Wait(0)
				end
            TriggerServerEvent("suku:SellItemToPlayer", GetPlayerServerId(PlayerId()), data.item.type, data.item.name, tonumber(data.number))
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5, 'demo1', 0.3)
            TaskPlayAnim(GetPlayerPed(-1), dict, "givetake1_a", 8.0, 8.0, -1, 48, 1, false, false, false)
        end

        Wait(150)
        loadPlayerInventory()

        cb("ok")
    end
)

RegisterNetEvent("suku:AddAmmoToWeapon")
AddEventHandler("suku:AddAmmoToWeapon", function(hash, amount)
    AddAmmoToPed(GetPlayerPed(-1), hash, amount)
end)

function IsInAladdinFiskebutikZone(coords)
    AladdinFiskebutik = Config.Shops.AladdinFiskebutik.Locations
    for i = 1, #AladdinFiskebutik, 1 do
        if GetDistanceBetweenCoords(coords, AladdinFiskebutik[i].x, AladdinFiskebutik[i].y, AladdinFiskebutik[i].z, true) < 1.5 then
            DrawMarker(27, AladdinFiskebutik[i].x, AladdinFiskebutik[i].y, AladdinFiskebutik[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 0.5, 119, 18, 130, 255, false, false, 2, true, false, false, false)
            return true
        end
    end
    return false
end

function IsInDealerZone(coords)
    Dealer = Config.Shops.Dealer.Locations
    for i = 1, #Dealer, 1 do
        if GetDistanceBetweenCoords(coords, Dealer[i].x, Dealer[i].y, Dealer[i].z, true) < 1.5 then
            DrawMarker(27, Dealer[i].x, Dealer[i].y, Dealer[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 0.5, 119, 18, 130, 255, false, false, 2, true, false, false, false)
            return true
        end
    end
    return false
end

function IsInMohammedsLivsZone(coords)
    MohammedsLivs = Config.Shops.MohammedsLivs.Locations
    for i = 1, #MohammedsLivs, 1 do
        if GetDistanceBetweenCoords(coords, MohammedsLivs[i].x, MohammedsLivs[i].y, MohammedsLivs[i].z, true) < 1.5 then
            DrawMarker(27, MohammedsLivs[i].x, MohammedsLivs[i].y, MohammedsLivs[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 0.5, 119, 18, 130, 255, false, false, 2, true, false, false, false)
            return true
        end
    end
    return false
end

function IsInPrisonShopZone(coords)
    PrisonShop = Config.Shops.PrisonShop.Locations
    for i = 1, #PrisonShop, 1 do
        if GetDistanceBetweenCoords(coords, PrisonShop[i].x, PrisonShop[i].y, PrisonShop[i].z, true) < 1.5 then
            DrawMarker(27, PrisonShop[i].x, PrisonShop[i].y, PrisonShop[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 0.5, 119, 18, 130, 255, false, false, 2, true, false, false, false)
            return true
        end
    end
    return false
end
--[[
function IsInInetShopZone(coords)
    InetShop = Config.Shops.InetShop.Locations
    for i = 1, #InetShop, 1 do
        if GetDistanceBetweenCoords(coords, InetShop[i].x, InetShop[i].y, InetShop[i].z, true) < 1.5 then
            return true
        end
    end
    return false
end

function IsInSexShopZone(coords)
    SexShop = Config.Shops.SexShop.Locations
    for i = 1, #SexShop, 1 do
        if GetDistanceBetweenCoords(coords, SexShop[i].x, SexShop[i].y, SexShop[i].z, true) < 1.5 then
            return true
        end
    end
    return false
end
--]]
function IsInUrbicusBarZone(coords)
    UrbicusBar = Config.Shops.UrbicusBar.Locations
    for i = 1, #UrbicusBar, 1 do
        if GetDistanceBetweenCoords(coords, UrbicusBar[i].x, UrbicusBar[i].y, UrbicusBar[i].z, true) < 1.5 then
            DrawMarker(27, UrbicusBar[i].x, UrbicusBar[i].y, UrbicusBar[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 0.5, 119, 18, 130, 255, false, false, 2, true, false, false, false)
            return true
        end
    end
    return false
end

function IsInSjukhusZone(coords)
    Sjukhus = Config.Shops.Sjukhus.Locations
    for i = 1, #Sjukhus, 1 do
        if GetDistanceBetweenCoords(coords, Sjukhus[i].x, Sjukhus[i].y, Sjukhus[i].z, true) < 1.5 then
            DrawMarker(27, Sjukhus[i].x, Sjukhus[i].y, Sjukhus[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 0.5, 119, 18, 130, 255, false, false, 2, true, false, false, false)
            return true
        end
    end
    return false
end

function IsInGymZone(coords)
    Gym = Config.Shops.Gym.Locations
    for i = 1, #Gym, 1 do
        if GetDistanceBetweenCoords(coords, Gym[i].x, Gym[i].y, Gym[i].z, true) < 1.5 then
            DrawMarker(27, Gym[i].x, Gym[i].y, Gym[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 0.5, 119, 18, 130, 255, false, false, 2, true, false, false, false)
            return true
        end
    end
    return false
end

--[[
function IsInVendingZone(coords)
    Vending = Config.Shops.Vending.Locations
    for i = 1, #Vending, 1 do
        if GetDistanceBetweenCoords(coords, Vending[i].x, Vending[i].y, Vending[i].z, true) < 1.5 then
            return true
        end
    end
    return false
end
--]]
RegisterNetEvent('suku:GetLicenses')
AddEventHandler('suku:GetLicenses', function (licenses)
    for i = 1, #licenses, 1 do
        Licenses[licenses[i].type] = true
    end
end)

function OpenBuyLicenseMenu()
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_license',{
        title = 'Register a License?',
        elements = {
          { label = 'yes' ..' ($' .. Config.LicensePrice ..')', value = 'yes' },
          { label = 'no', value = 'no' },
        }
      },
      function (data, menu)
        if data.current.value == 'yes' then
            TriggerServerEvent('suku:buyLicense')
        end
        menu.close()
    end,
    function (data, menu)
        menu.close()
    end)
end

--Citizen.CreateThread(function()
   -- player = GetPlayerPed(-1)
    --coords = GetEntityCoords(player)
    --[[
    for k, v in pairs(Config.Shops.AladdinFiskebutik.Locations) do
        CreateBlip(vector3(Config.Shops.AladdinFiskebutik.Locations[k].x, Config.Shops.AladdinFiskebutik.Locations[k].y, Config.Shops.AladdinFiskebutik.Locations[k].z ), "Aladdin's Fiskebutik", 3.0, Config.AladdinFiskebutikBlipIDColor, Config.AladdinFiskebutikBlipID)
    end

    for k, v in pairs(Config.Shops.Dealer.Locations) do
        CreateBlip(vector3(Config.Shops.Dealer.Locations[k].x, Config.Shops.Dealer.Locations[k].y, Config.Shops.Dealer.Locations[k].z ), "Dealer", 3.0, Config.Color, Config.LiquorBlipID)
    end]]

    --[[for k, v in pairs(Config.Shops.MohammedsLivs.Locations) do
        CreateBlip(vector3(Config.Shops.MohammedsLivs.Locations[k].x, Config.Shops.MohammedsLivs.Locations[k].y, Config.Shops.MohammedsLivs.Locations[k].z ), "Mohammeds Livs", 3.0, Config.MohammedsLivsBlipIDColor, Config.MohammedsLivsBlipID)
    end]]
    
   --[[ for k, v in pairs(Config.Shops.PrisonShop.Locations) do
        CreateBlip(vector3(Config.Shops.PrisonShop.Locations[k].x, Config.Shops.PrisonShop.Locations[k].y, Config.Shops.PrisonShop.Locations[k].z), "Prison Commissary", 3.0, Config.Color, Config.PrisonShopBlipID)
    end
    for k, v in pairs(Config.Shops.InetShop.Locations) do
        CreateBlip(vector3(Config.Shops.InetShop.Locations[k].x, Config.Shops.InetShop.Locations[k].y, Config.Shops.InetShop.Locations[k].z), "Inet", 3.0, Config.Color, Config.ShopBlipID)
    end

    
    for k, v in pairs(Config.Shops.SexShop.Locations) do
        CreateBlip(vector3(Config.Shops.SexShop.Locations[k].x, Config.Shops.SexShop.Locations[k].y, Config.Shops.SexShop.Locations[k].z), "Emelie's Smurfshop", 3.0, 48, 489)
    end

    for k, v in pairs(Config.Shops.UrbicusBar.Locations) do
        CreateBlip(vector3(Config.Shops.UrbicusBar.Locations[k].x, Config.Shops.UrbicusBar.Locations[k].y, Config.Shops.UrbicusBar.Locations[k].z), "Urbicus Bar", 3.0, Config.Color, Config.ShopBlipID)
    end

    for k, v in pairs(Config.Shops.WeaponShop.Locations) do
        CreateBlip(vector3(Config.Shops.WeaponShop.Locations[k].x, Config.Shops.WeaponShop.Locations[k].y, Config.Shops.WeaponShop.Locations[k].z), "Ammunation", 3.0, Config.WeaponColor, Config.WeaponShopBlipID)
    end]]
--end)

--[[Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        player = GetPlayerPed(-1)
        coords = GetEntityCoords(player)

        for k, v in pairs(Config.Shops.AladdinFiskebutik.Locations) do
            if GetDistanceBetweenCoords(coords, Config.Shops.AladdinFiskebutik.Locations[k].x, Config.Shops.AladdinFiskebutik.Locations[k].y, Config.Shops.AladdinFiskebutik.Locations[k].z, true) < 1.5 then
                ESX.Game.Utils.DrawText3D(vector3(Config.Shops.AladdinFiskebutik.Locations[k].x, Config.Shops.AladdinFiskebutik.Locations[k].y, Config.Shops.AladdinFiskebutik.Locations[k].z + 1), "~p~[E]~w~ för att handla på ~p~Aladdins Fiskebutik~s~", 0.6)
            elseif GetDistanceBetweenCoords(coords, Config.Shops.AladdinFiskebutik.Locations[k].x, Config.Shops.AladdinFiskebutik.Locations[k].y, Config.Shops.AladdinFiskebutik.Locations[k].z, true) < 3.5 then
                ESX.Game.Utils.DrawText3D(vector3(Config.Shops.AladdinFiskebutik.Locations[k].x, Config.Shops.AladdinFiskebutik.Locations[k].y, Config.Shops.AladdinFiskebutik.Locations[k].z + 1), "~p~Aladdins Fiskebutik~s~", 0.6)
            end
        end


        for k, v in pairs(Config.Shops.Dealer.Locations) do
            if GetDistanceBetweenCoords(coords, Config.Shops.Dealer.Locations[k].x, Config.Shops.Dealer.Locations[k].y, Config.Shops.Dealer.Locations[k].z, true) < 1.5 then
                ESX.Game.Utils.DrawText3D(vector3(Config.Shops.Dealer.Locations[k].x, Config.Shops.Dealer.Locations[k].y, Config.Shops.Dealer.Locations[k].z + 1), "~p~[E]~w~ för att handla", 0.6)
            end
        end

        for k, v in pairs(Config.Shops.MohammedsLivs.Locations) do
            if GetDistanceBetweenCoords(coords, Config.Shops.MohammedsLivs.Locations[k].x, Config.Shops.MohammedsLivs.Locations[k].y, Config.Shops.MohammedsLivs.Locations[k].z, true) < 1.5 then
                ESX.Game.Utils.DrawText3D(vector3(Config.Shops.MohammedsLivs.Locations[k].x, Config.Shops.MohammedsLivs.Locations[k].y, Config.Shops.MohammedsLivs.Locations[k].z + 1), "Tryck ~p~[E]~w~ för att handla på ~p~Mohammeds Livs~s~", 0.6)
            elseif GetDistanceBetweenCoords(coords, Config.Shops.MohammedsLivs.Locations[k].x, Config.Shops.MohammedsLivs.Locations[k].y, Config.Shops.MohammedsLivs.Locations[k].z, true) < 3.5 then
                ESX.Game.Utils.DrawText3D(vector3(Config.Shops.MohammedsLivs.Locations[k].x, Config.Shops.MohammedsLivs.Locations[k].y, Config.Shops.MohammedsLivs.Locations[k].z + 1), "~p~Mohammeds Livs~s~", 0.6)
            end
        end

        for k, v in pairs(Config.Shops.PrisonShop.Locations) do
            if GetDistanceBetweenCoords(coords, Config.Shops.PrisonShop.Locations[k].x, Config.Shops.PrisonShop.Locations[k].y, Config.Shops.PrisonShop.Locations[k].z, true) < 1.5 then
                ESX.Game.Utils.DrawText3D(vector3(Config.Shops.PrisonShop.Locations[k].x, Config.Shops.PrisonShop.Locations[k].y, Config.Shops.PrisonShop.Locations[k].z + 1), "Tryck ~p~[E]~w~ för att handla ~p~Fängelsemat~s~", 0.6)
            elseif GetDistanceBetweenCoords(coords, Config.Shops.PrisonShop.Locations[k].x, Config.Shops.PrisonShop.Locations[k].y, Config.Shops.PrisonShop.Locations[k].z, true) < 15.5 then
                ESX.Game.Utils.DrawText3D(vector3(Config.Shops.PrisonShop.Locations[k].x, Config.Shops.PrisonShop.Locations[k].y, Config.Shops.PrisonShop.Locations[k].z + 1), "~p~Fängelsemat~s~", 0.6)
            end
        end

        for k, v in pairs(Config.Shops.InetShop.Locations) do
            if GetDistanceBetweenCoords(coords, Config.Shops.InetShop.Locations[k].x, Config.Shops.InetShop.Locations[k].y, Config.Shops.InetShop.Locations[k].z, true) < 3.0 then
                ESX.Game.Utils.DrawText3D(vector3(Config.Shops.InetShop.Locations[k].x, Config.Shops.InetShop.Locations[k].y, Config.Shops.InetShop.Locations[k].z), "Tryck ~g~[E]~w~ för att handla", 0.6)
            end
        end

        for k, v in pairs(Config.Shops.SexShop.Locations) do
            if GetDistanceBetweenCoords(coords, Config.Shops.SexShop.Locations[k].x, Config.Shops.SexShop.Locations[k].y, Config.Shops.SexShop.Locations[k].z, true) < 3.0 then
                ESX.Game.Utils.DrawText3D(vector3(Config.Shops.SexShop.Locations[k].x, Config.Shops.SexShop.Locations[k].y, Config.Shops.SexShop.Locations[k].z), "Tryck ~g~[E]~w~ för att handla", 0.6)
            end
        end

        for k, v in pairs(Config.Shops.UrbicusBar.Locations) do
            if GetDistanceBetweenCoords(coords, Config.Shops.UrbicusBar.Locations[k].x, Config.Shops.UrbicusBar.Locations[k].y, Config.Shops.UrbicusBar.Locations[k].z, true) < 1.5 then
                ESX.Game.Utils.DrawText3D(vector3(Config.Shops.UrbicusBar.Locations[k].x, Config.Shops.UrbicusBar.Locations[k].y, Config.Shops.UrbicusBar.Locations[k].z + 1), "Tryck ~p~[E]~w~ för att handla på ~p~Urbicus Bar~s~", 0.6)
            elseif GetDistanceBetweenCoords(coords, Config.Shops.UrbicusBar.Locations[k].x, Config.Shops.UrbicusBar.Locations[k].y, Config.Shops.UrbicusBar.Locations[k].z, true) < 3.5 then
                ESX.Game.Utils.DrawText3D(vector3(Config.Shops.UrbicusBar.Locations[k].x, Config.Shops.UrbicusBar.Locations[k].y, Config.Shops.UrbicusBar.Locations[k].z + 1), "~p~Urbicus Bar~s~", 0.6)
            end
        end

        for k, v in pairs(Config.Shops.Sjukhus.Locations) do
            if GetDistanceBetweenCoords(coords, Config.Shops.Sjukhus.Locations[k].x, Config.Shops.Sjukhus.Locations[k].y, Config.Shops.Sjukhus.Locations[k].z, true) < 1.5 then
                ESX.Game.Utils.DrawText3D(vector3(Config.Shops.Sjukhus.Locations[k].x, Config.Shops.Sjukhus.Locations[k].y, Config.Shops.Sjukhus.Locations[k].z + 1), "Tryck ~p~[E]~w~ för att handla på ~p~Sjukhus Kiosken~s~", 0.6)
            elseif GetDistanceBetweenCoords(coords, Config.Shops.Sjukhus.Locations[k].x, Config.Shops.Sjukhus.Locations[k].y, Config.Shops.Sjukhus.Locations[k].z, true) < 3.5 then
                ESX.Game.Utils.DrawText3D(vector3(Config.Shops.Sjukhus.Locations[k].x, Config.Shops.Sjukhus.Locations[k].y, Config.Shops.Sjukhus.Locations[k].z + 1), "~p~Sjukhus Kiosk~s~", 0.6)
            end
        end

        for k, v in pairs(Config.Shops.Gym.Locations) do
            if GetDistanceBetweenCoords(coords, Config.Shops.Gym.Locations[k].x, Config.Shops.Gym.Locations[k].y, Config.Shops.Gym.Locations[k].z, true) < 1.5 then
                ESX.Game.Utils.DrawText3D(vector3(Config.Shops.Gym.Locations[k].x, Config.Shops.Gym.Locations[k].y, Config.Shops.Gym.Locations[k].z + 1), "Tryck ~p~[E]~w~ för att handla på ~p~Gym Kiosken~s~", 0.6)
            elseif GetDistanceBetweenCoords(coords, Config.Shops.Gym.Locations[k].x, Config.Shops.Gym.Locations[k].y, Config.Shops.Gym.Locations[k].z, true) < 3.5 then
                ESX.Game.Utils.DrawText3D(vector3(Config.Shops.Gym.Locations[k].x, Config.Shops.Gym.Locations[k].y, Config.Shops.Gym.Locations[k].z + 1), "~p~Gym Kiosken~s~", 0.6)
            end
        end

        for k, v in pairs(Config.Shops.Vending.Locations) do
            if GetDistanceBetweenCoords(coords, Config.Shops.Vending.Locations[k].x, Config.Shops.Vending.Locations[k].y, Config.Shops.Vending.Locations[k].z, true) < 3.0 then
                ESX.Game.Utils.DrawText3D(vector3(Config.Shops.Vending.Locations[k].x, Config.Shops.Vending.Locations[k].y, Config.Shops.Vending.Locations[k].z), "Tryck ~g~[E]~w~ för att handla", 0.6)
            end
        end

    end
end)]]

function CreateBlip(coords, text, radius, color, sprite)
	local blip = AddBlipForCoord(coords)
	SetBlipSprite(blip, sprite)
	SetBlipColour(blip, color)
	SetBlipScale(blip, 0.8)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(text)
	EndTextCommandSetBlipName(blip)
end