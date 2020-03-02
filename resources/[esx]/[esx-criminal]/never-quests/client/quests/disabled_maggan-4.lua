local Stockade = {x = 1443.3873291016, y = 3645.3005371094, z = 33.220050811768, heading = 284.22210693359}
local Uniform = json.decode('{"shoes_2":0,"pants_1":28,"torso_1":111,"bproof_1":11,"torso_2":3,"tshirt_1":122,"pants_2":0,"helmet_2":0,"glasses_2":0,"tshirt_2":0,"helmet_1":65,"mask_2":0,"bproof_2":1,"decals_1":0,"mask_1":121,"shoes_1":1,"chain_1":0,"arms":17,"glasses_1":5,"chain_2":0,"decals_2":0}')
local Doors = {
	["door1"] = {["x"] = -105.0, ["y"] = 6474.0, ["z"] = 32.0, ["rotationX"] = 0.0, ["rotationY"] = 0.0, ["rotationZ"] = 48.0, ["model"] = 1622278560},
	["door2"] = {["x"] = -106.0, ["y"] = 6476.0, ["z"] = 32.0, ["rotationX"] = 0.0, ["rotationY"] = 0.0, ["rotationZ"] = -45.0, ["model"] = 1309269072}
}
local Positions = {
	["door1"] = {["x"] = -104.33673095703, ["y"] = 6471.9775390625, ["z"] = 30.62671661377, ["heading"] = 45.103466033936},
	["door2"] = {["x"] = -106.53300476074, ["y"] = 6474.9291992188, ["z"] = 30.62671661377, ["heading"] = 316.70013427734},
	["cash"] = {["x"] = -104.3207321167, ["y"] = 6477.1918945313, ["z"] = 31.50606918335, ["heading"] = 321.48037719727},
	["bags"] = {["x"] = -106.63687133789, ["y"] = 6477.1352539063, ["z"] = 30.62671661377, ["heading"] = 53.531105041504}
}
local Objects = {
	["cash_pile_1"] = {["x"] = -104.65497589111, ["y"] = 6477.5654296875, ["z"] = 31.478824615479, model = GetHashKey('prop_cash_crate_01')},
	["cash_pile_2"] = {["x"] = -104.20729064941, ["y"] = 6476.849609375, ["z"] = 31.503162384033, model = GetHashKey('prop_cash_crate_01')},
	["bag_1"] = {["x"] = -106.45573425293, ["y"] = 6477.1137695313, ["z"] = 30.520703262329, rotationX = 0.0, rotationY = 20.0, rotationZ = 130.0, model = GetHashKey('prop_cs_heist_bag_01')},
	["bag_2"] = {["x"] = -106.58578491211, ["y"] = 6477.9145507813, ["z"] = 30.520707077026, rotationX = 0.0, rotationY = 20.0, rotationZ = 110.0, model = GetHashKey('prop_cs_heist_bag_01')},
	["bag_3"] = {["x"] = -106.46390533447, ["y"] = 6477.3720703125, ["z"] = 30.520708984375, rotationX = 0.0, rotationY = 20.0, rotationZ = 130.0, model = GetHashKey('prop_cs_heist_bag_01')}
}
local CashGrabs = {
	{
		["add"] = 430,
		["remove"] = 470
	},
	{
		["add"] = 430,
		["remove"] = 470
	},
	{
		["add"] = 430,
		["remove"] = 470
	},
	{
		["add"] = 430,
		["remove"] = 630
	},
	{
		["add"] = 430,
		["remove"] = 630
	},
	{
		["add"] = 430,
		["remove"] = 630
	},
	{
		["add"] = 500,
		["remove"] = 630
	},
	{
		["add"] = 430,
		["remove"] = 630
	},
		{
		["add"] = 430,
		["remove"] = 630
	},
	{
		["add"] = 430,
		["remove"] = 630
	}
}
local CachedData = {
	["door.1"] = true,
	["door.2"] = true
}
local CashSpawned = false
local GrabbingCash = false

Quest.AddQuest('maggan', 4, function()
	Citizen.CreateThread(function()
		Citizen.Wait(500)

		Quest.FinishQuest('maggan', 1)

		ESX.Game.SpawnVehicle('stockade', Stockade, Stockade["heading"], function(callbackVehicle)
		end)

		TriggerEvent('skinchanger:getSkin', function(skin)
			TriggerEvent('skinchanger:loadClothes', skin, Uniform)
		end)

		TriggerServerEvent('never-quests:giveItem', 'maggan_item', 1)

		MagganUpdateLogic() 
	end)
end)

Citizen.CreateThread(function()
	Citizen.Wait(500)

	if ESX.IsPlayerLoaded() then
		MagganUpdateLogic()

		CreateBlip({["x"] = -113.76078796387, ["y"] = 6459.9462890625, ["z"] = 30.468461990356}, 'Riksbanken', 255, 2, false, 1.3)
	end
end)

AddEventHandler('skinchanger:modelLoaded', function()
	MagganUpdateLogic()

	CreateBlip({["x"] = -113.76078796387, ["y"] = 6459.9462890625, ["z"] = 30.468461990356}, 'Riksbanken', 255, 2, false, 1.3)
end)

Citizen.CreateThread(function()
	for i=1, 2, 1 do
		local pile = Objects["cash_pile_" .. i]	
		local object = GetObject(pile)

		if object ~= nil and DoesEntityExist(object) then
			SetEntityAsMissionEntity(object)
			DeleteObject(object)
		end
	end

	for i=1, 3, 1 do
		local bag = Objects["bag_" .. i]	
		local object = GetObject(bag)

		if object ~= nil and DoesEntityExist(object) then
			SetEntityAsMissionEntity(object)
			DeleteObject(object)
		end
	end

	for i=1, 2, 1 do
		local pile = Objects["cash_pile_" .. i]	

		RequestModel(pile["model"])

	    while not HasModelLoaded(pile["model"]) do
	    	Citizen.Wait(1)
	    end

	    local object = CreateObject(pile["model"], pile["x"], pile["y"], pile["z"], false, true, true)

	  	SetEntityRotation(object, 0.0, 0.0, 40.0)
		SetEntityAsMissionEntity(object, true, false)
		FreezeEntityPosition(object, true)
	end

	for i=1, 3, 1 do
		local bag = Objects["bag_" .. i]

		RequestModel(bag["model"])

	    while not HasModelLoaded(bag["model"]) do
	    	Citizen.Wait(1)
	    end

	    local object = CreateObject(bag["model"], bag["x"], bag["y"], bag["z"], false, true, true)

	    SetEntityRotation(object, bag["rotationX"], bag["rotationY"], bag["rotationZ"])
		SetEntityAsMissionEntity(object, true, false)
		FreezeEntityPosition(object, true)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)

		local index = 1

		for id,door in order.pairs(Doors) do
			local object = GetClosestObjectOfType(door["x"], door["y"], door["z"], 15.0, door["model"], false, false, false)

			if object ~= nil then 
				if CachedData["door." .. index] then
					SetEntityRotation(object, door["rotationX"], door["rotationY"], door["rotationZ"])

					FreezeEntityPosition(object, true)
				else		
					FreezeEntityPosition(object, false)
				end
			end

			index = index + 1 
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CashSpawned then
			if CachedData["money"] == nil then
				local money = math.random(50000, 90000)

				CachedData["money"] = money
				CachedData["totalMoney"] = money

	  			GlobalEvent('maggan:UpdateCache', json.encode(CachedData))
			end

			local ped = GetPlayerPed(-1)
			local coords = GetEntityCoords(ped)
			local distance = GetDistanceBetweenCoords(coords["x"], coords["y"], coords["z"], Positions["cash"]["x"], Positions["cash"]["y"], Positions["cash"]["z"], true)
			local bagDistance = GetDistanceBetweenCoords(coords["x"], coords["y"], coords["z"], Positions["bags"]["x"], Positions["bags"]["y"], Positions["bags"]["z"], true)
			
			if distance < 5.0 then
				DrawText3D(Positions["cash"]["x"], Positions["cash"]["y"], Positions["cash"]["z"], "Pengar: ~b~" .. CurrencyFormat(CachedData["money"]), 0.5, 0.025, 0.0125)
			end

			if bagDistance < 2.5 then
				SetTextComponentFormat('STRING')
     			AddTextComponentString("Tryck ~INPUT_CONTEXT~ för att ta en väska")
     			DisplayHelpTextFromStringLabel(0, 0, 1, -1)

     			if IsControlJustPressed(0, Keys["E"]) then
     				local clothes = {
     					["male"] = {
     						["bags_1"] = 44
     					},
     					["female"] = {
     						["bags_1"] = 44
     					}
     				}

     				UpdateClothes(clothes)
     			end
			end

			if distance < 1.0 then
				if not GrabbingCash then
					SetTextComponentFormat('STRING')
	     			AddTextComponentString("Tryck ~INPUT_CONTEXT~ för att plocka pengar!")
	     			DisplayHelpTextFromStringLabel(0, 0, 1, -1)
	     		else
	     			SetTextComponentFormat('STRING')
	     			AddTextComponentString("")
	     			DisplayHelpTextFromStringLabel(0, 0, 1, -1)
	     		end

     			if IsControlJustPressed(0, Keys["E"]) then
     				if not GrabbingCash then
     					if CachedData["money"] <= 0 then
     						ESX.ShowNotification("~r~Du har redan tagit alla pengar!")
     					else
	     					TriggerEvent('skinchanger:getSkin', function(skin)
	     						if skin["bags_1"] ~= 44 and skin["bags_1"] ~= 45 then
	     							ESX.ShowNotification("~r~Ta en väska först!")
	     						else
			     					GrabbingCash = true
									
									Citizen.CreateThread(function()
										TaskStandStill(ped, 100)
										SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)

										Citizen.Wait(100)

										PlayAnimation(ped, 'anim@heists@ornate_bank@grab_cash', 'intro')
										
										Citizen.Wait(2000)

										PlayAnimation(ped, 'anim@heists@ornate_bank@grab_cash', 'grab',
											{
												["playbackRate"] = 0.1
											}
										)

										local timestamp = GetGameTimer()
										local model = GetHashKey("prop_anim_cash_pile_01")

										RequestModel(model)

									    while not HasModelLoaded(model) do
									      	Citizen.Wait(0)
									    end

										for i=1, #CashGrabs, 1 do
											Citizen.Wait(CashGrabs[i]["add"])

										    local cash = CreateObject(model, 0.0, 0.0, 0.0, 1, 1, 0)

										    AttachEntityToEntity(cash, ped, GetPedBoneIndex(ped, 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)

										    Citizen.Wait(CashGrabs[i]["remove"])

										    SetEntityAsMissionEntity(cash)
										    DeleteObject(cash)
										end
								
				     					if IsEntityPlayingAnim(ped, 'anim@heists@ornate_bank@grab_cash', 'grab', 1) then
					     					local total = CachedData["totalMoney"]
					     					local cash = math.random(math.floor(total / 15.0), math.floor(total / 10.0))

					     					GrabbingCash = false

					     					if CachedData["money"] < cash then
					     						cash = CachedData["money"]
					     					end

					     					ESX.ShowNotification("Tagna pengar ~g~" .. CurrencyFormat(cash))		
					     					
					     					TriggerServerEvent('never-quests:giveMoney', 'black_money', cash)

					     					CachedData["money"] = CachedData["money"] - cash
					  						GlobalEvent('maggan:UpdateCache', json.encode(CachedData))

											PlayAnimation(ped, 'anim@heists@ornate_bank@grab_cash', 'exit')

											Citizen.Wait(1)

											while IsEntityPlayingAnim(ped, 'anim@heists@ornate_bank@grab_cash', 'exit', 1) do
												Citizen.Wait(0)
											end
										end

										UpdateClothes(
											{
												["male"] = {
													["bags_1"] = 45
												},
												["female"] = {
													["bags_1"] = 45
												}
											}
										)

										SetEntityAsMissionEntity(bag, true, false)
										DeleteObject(bag)
									end)
								end
							end)
	     				end
     				else
     					ESX.ShowNotification("~r~vänta upp till 10 sekunder!")
     				end
     			end
			end
		end
	end
end)

function CurrencyFormat(amount)
	local left, number, right = string.match(amount, '^([^%d]*%d)(%d*)(.-)$')

	return '$' .. left .. (number:reverse():gsub('(%d%d%d)','%1,'):reverse()) .. right
end

function DrawText3D(x, y, z, text, scale, rectWidth, rectHeight) 
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local pX, pY, pZ = table.unpack(GetGameplayCamCoords())

	if scale == nil then
		scale = 0.35
	end

	if rectWidth == nil then
		rectWidth = 0.0
	end

	if rectHeight == nil then
		rectHeight = 0.0
	end

  	SetTextScale(scale, scale)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextEntry("STRING")
	SetTextCentre(1)
	SetTextColour(255, 255, 255, 215)

	AddTextComponentString(text)
	
	local factor = string.len(text) / 370

	DrawText(_x, _y - (rectHeight / 2.0))
	DrawRect(_x, _y + 0.0125, 0.015 + factor + rectWidth, 0.03 + rectHeight, 41, 11, 41, 68)
end

function MagganUpdateLogic()
	local ped = GetPlayerPed(-1)

	CachedData["door.1"] = true
	CachedData["door.2"] = true

	if CachedData["state"] == nil or CachedData["data"] == 0 then
		Markers.AddMarker("maggan_quest_final", Positions["door1"], "Tryck ~INPUT_CONTEXT~ för att svetsa upp låset på dörren!", function()
			ESX.TriggerServerCallback('never-quests:hasItem', function(has)
				if has then
					ESX.TriggerServerCallback('cooldowns:getCooldown', function(cooldown)
						if cooldown == 0 then
							ESX.TriggerServerCallback('never-quests:getPolice', function(count)
								if count >= 4 then
									Citizen.CreateThread(function()
										ESX.TriggerServerCallback('cooldowns:setCooldown', function()
										end, 'quest_robbery', 14400)

										Markers.RemoveMarker('maggan_quest_final')
										TaskStandStill(ped, 100)

										Citizen.Wait(100)

							            TaskStartScenarioInPlace(ped, "WORLD_HUMAN_WELDING", 0, true)

										Citizen.Wait(20000)

							            ClearPedTasksImmediately(ped)
										CachedData["state"] = 1	
										GlobalEvent('maggan:UpdateCache', json.encode(CachedData))
									end)
								else
									ESX.ShowNotification('Det måste vara minst ~b~4 ~w~Poliser i staden för att starta ett bankrån på S:E:B.')
								end
							end)
						else
							ESX.ShowNotification('~r~Det har nyligen varit ett bankrån vänta ~b~' .. cooldown .. ' ~r~sekunder.')
						end
					end, 'quest_robbery')
				else
					ESX.ShowNotification('~r~Du har inte Gruppe6 ID.')
				end
			end, 'maggan_item', 1)
		end, {red = 255, green = 0, blue = 0, alpha = 75})
	elseif CachedData["state"] == 1 then
		CachedData["door.1"] = false

		ESX.TriggerServerCallback('never-quests:hasItem', function(has)
			if has then
				Markers.AddMarker("maggan_quest_final", Positions["door2"], "Tryck ~INPUT_CONTEXT~ för att svetsa upp låset på dörren!", function()
					Citizen.CreateThread(function()
						GlobalEvent('never-quests:alarm', 'robbery', GetEntityCoords(GetPlayerPed(-1))["x"], GetEntityCoords(GetPlayerPed(-1))["y"], GetEntityCoords(GetPlayerPed(-1))["z"], 'Terminal på ~b~S:E:B ~w~håller på brytas upp av några beväpnaderånare ~r~Skicka alla enheter!', 600000)
						TriggerServerEvent('never-quests:removeItem', 'maggan_item', 1)

						Markers.RemoveMarker('maggan_quest_final')
						TaskStandStill(ped, 100)

						Citizen.Wait(100)
						TaskStartScenarioInPlace(ped, "WORLD_HUMAN_WELDING", 0, true)

						Citizen.Wait(135000)

			            ClearPedTasksImmediately(ped)
						CachedData["state"] = 2

						GlobalEvent('maggan:UpdateCache', json.encode(CachedData))
					end)
				end, {red = 255, green = 0, blue = 0, alpha = 75})
			end
		end, 'maggan_item', 1)
	elseif CachedData["state"] == 2 then
		Markers.RemoveMarker("maggan_quest_final")

		CachedData["door.1"] = false
		CachedData["door.2"] = false

		CashSpawned = true
	end
end

function GetObject(assets)
	return GetClosestObjectOfType(assets["x"], assets["y"], assets["z"], 1.0, assets["model"], false, false, false)
end

function UpdateClothes(clothes)
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			TriggerEvent('skinchanger:loadClothes', skin, clothes["male"])
		else
			TriggerEvent('skinchanger:loadClothes', skin, clothes["female"])
		end
	end)
end

function GetClothingComponent(component)
	TriggerEvent('skinchanger:getSkin', function(skin)
		return skin[component]
	end)
end

RegisterNetEvent('maggan:UpdateCache')
AddEventHandler('maggan:UpdateCache', function(cache)
	CachedData = json.decode(cache)

	MagganUpdateLogic()
end)

function CreateBlip(coords, name, id, color, waypoint, size)
	local blip = AddBlipForCoord(coords.x, coords.y,coords.z)

	SetBlipSprite(blip, id)
	SetBlipDisplay(blip, 4)
	SetBlipColour(blip, color)
	SetBlipAsShortRange(blip, true)
	SetBlipRoute(blip, waypoint)
	SetBlipRouteColour(blip, color)

	if size ~= nil then
		SetBlipScale(blip, size)
	end

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
	EndTextCommandSetBlipName(blip)

	return blip
end