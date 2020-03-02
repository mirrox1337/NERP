local Tailgater = {x = -54.5598487854, y = 344.29348754883, z = 111.16844177246, heading = 150.0}
local TailgaterProperties = json.decode('{"modStruts":-1,"plateIndex":0,"windowTint":1,"modSmokeEnabled":1,"modSpoilers":0,"modShifterLeavers":-1,"modFrontBumper":1,"color2":147,"modRightFender":-1,"modSteeringWheel":-1,"modWindows":-1,"modFrontWheels":8,"dirtLevel":0.56793433427811,"modSideSkirt":3,"modAPlate":-1,"modOrnaments":-1,"modRearBumper":3,"modSuspension":3,"modFender":0,"modSpeakers":-1,"modTank":-1,"modBackWheels":-1,"neonColor":[255,0,255],"modAerials":-1,"color1":147,"plate":"09BDL555","modArchCover":-1,"modDial":-1,"modTrimB":-1,"modEngine":3,"modBrakes":2,"tyreSmokeColor":[255,255,255],"modHood":4,"wheelColor":0,"modEngineBlock":-1,"modExhaust":1,"wheels":0,"modDoorSpeaker":-1,"modPlateHolder":-1,"pearlescentColor":111,"model":-1008861746,"modHorns":-1,"modFrame":-1,"modGrille":0,"modTurbo":1,"modVanityPlate":-1,"neonEnabled":[false,false,false,false],"modTrimA":-1,"modLivery":-1,"modSeats":-1,"modDashboard":-1,"modTransmission":2,"health":1000,"modXenon":1,"modAirFilter":-1,"modHydrolic":-1,"modTrunk":-1,"modRoof":-1,"modArmor":4}')
local Asterope = {x = -57.997737884521, y = 351.66934204102, z = 111.44739532471, heading = 200.0}
local Doors = {
	["door1"] = {["x"] = 256.31155395508, ["y"] = 220.65785217285, ["z"] = 106.42955780029, ["rotationX"] = -0.99999994039536, ["rotationY"] = -1.0, ["rotationZ"] = -19.999998092651, ["model"] = -222270721},
	["door2"] = {["x"] = 262.19808959961, ["y"] = 222.51879882813, ["z"] = 106.42955780029, ["rotationX"] = 0.0, ["rotationY"] = -0.0, ["rotationZ"] = -109.99999237061, ["model"] = 746855201},
	["vault"] = {["x"] = 255.22825622559, ["y"] = 223.97601318359, ["z"] = 102.39321899414, ["rotationX"] = 0.0, ["rotationY"] = 0.0, ["rotationZ"] = 160.0, ["model"] = 961976194}
}
local Positions = {
	["door1"] = {x = 256.47155761719, y = 219.05702209473, z = 105.2865447998},
	["door2"] = {x = 260.93444824219, y = 222.21556091309, z = 105.2836227417},
	["vault"] = {x = 253.96426391602, y = 228.1263885498, z = 100.68323516846},
	["cash"] = {x = 264.50894165039, y = 213.98802185059, z = 102.02780151367},
	["bags"] = {x = 255.80447387695, y = 219.05610656738, z = 100.84439849854}
}
local Objects = {
	["cash_pile_1"] = {x = 264.3344543457, y = 213.65769885254, z = 101.52779388428, model = GetHashKey('prop_cash_crate_01')},
	["cash_pile_2"] = {x = 264.5534543457, y = 214.29569885254, z = 101.52779388428, model = GetHashKey('prop_cash_crate_01')},
	["bag_1"] = {x = 255.63845825195, y = 219.55345153809, z = 100.60336486816, rotationX = 0.0, rotationY = 10.0, rotationZ = 160.0, model = GetHashKey('prop_cs_heist_bag_01')},
	["bag_2"] = {x = 256.12435913086, y = 219.37692260742, z = 100.60336486816, rotationX = 0.0, rotationY = 20.0, rotationZ = 180.0, model = GetHashKey('prop_cs_heist_bag_01')},
	["bag_3"] = {x = 255.71780395508, y = 219.27036315918, z = 100.60336486816, rotationX = 0.0, rotationY = 0.0, rotationZ = 155.0, model = GetHashKey('prop_cs_heist_bag_01')}
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
	["door.2"] = true,
	["door.3"] = true
}
local HackingMinigame = false
local CashSpawned = false
local GrabbingCash = false

Quest.AddQuest('donvito', 4, function()
	Quest.FinishQuest('donvito', 1)

	ESX.Game.SpawnVehicle('tailgater', Tailgater, Tailgater["heading"], function(callbackVehicle)
		ESX.Game.SetVehicleProperties(callbackVehicle, TailgaterProperties)
	end)

	ESX.Game.SpawnVehicle('asterope', Asterope, Asterope["heading"], function(callbackVehicle)
	end)

	TriggerServerEvent('never-quests:giveItem', 'donvito_item', 1)

	DonvitoUpdateLogic()
end)

Citizen.CreateThread(function()
	Citizen.Wait(500)

	if ESX.IsPlayerLoaded() then
		DonvitoUpdateLogic()
		
		CreateBlip({["x"] = 242.02084350586, ["y"] = 219.31625366211, ["z"] = 105.28677368164}, 'Central Banken', 255, 2, false, 1.3)
	end
end)

AddEventHandler('skinchanger:modelLoaded', function()
	DonvitoUpdateLogic()

	CreateBlip({["x"] = 242.02084350586, ["y"] = 219.31625366211, ["z"] = 105.28677368164}, 'Central Banken', 255, 2, false, 1.3)
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

	  	SetEntityRotation(object, 0.0, 0.0, 250.0)
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
		Citizen.Wait(10000)

		local boxTop = {
			["x"] = 264.0,
			["y"] = 214.0,
			["z"] = 101.0,
			["model"] = 1695952043
		}

		local box = {
			["x"] = 264.0,
			["y"] = 214.0,
			["z"] = 101.0,
			["model"] = -517601980
		}	

		RemoveObject(boxTop)
		RemoveObject(box)
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

					if id == "vault" then
						DonvitoApplyVaultRotation(object)
					end
				end
			end

			index = index + 1 
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if HackingMinigame then
			DisableControlAction(2, 24, true) -- Attack
			DisableControlAction(2, 257, true) -- Attack 2
			DisableControlAction(2, 25, true) -- Aim
			DisableControlAction(2, 263, true) -- Melee Attack 1	
			DisableControlAction(2, 30, true) -- Move LEFT/RIGHT
			DisableControlAction(2, 31, true) -- MOVE UP/DOWN
			DisableControlAction(2, Keys['R'], true) -- Reload
			DisableControlAction(2, Keys['TOP'], true) -- Open phone (not needed?)
			DisableControlAction(2, Keys['SPACE'], true) -- Jump
			DisableControlAction(2, Keys['Q'], true) -- Cover
			DisableControlAction(2, Keys['TAB'], true) -- Select Weapon
			DisableControlAction(2, Keys['F'], true) -- Also 'enter'?
			DisableControlAction(2, Keys['F1'], true) -- Disable phone
			DisableControlAction(2, Keys['F2'], true) -- Inventory
			DisableControlAction(2, Keys['F3'], true) -- Animations

			if IsControlJustPressed(0, Keys["ENTER"]) then
				SendNUIMessage({
					["action"] = 'keyinput',
					["key"] = 'ENTER'
				})
			elseif IsControlJustPressed(0, Keys["ESC"] or IsControlJustPressed(0, Keys["BACKSPACE"])) then
				SendNUIMessage({
					["action"] = 'hide'
				})

				HackingMinigame = false
				DestroyCamera()
				DonvitoUpdateLogic()
			end
		else
			if CashSpawned then
				if CachedData["money"] == nil then
					local money = math.random(500000, 1000000)

					CachedData["money"] = money
					CachedData["totalMoney"] = money

		  			GlobalEvent('donvito:UpdateCache', json.encode(CachedData))
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
	     			AddTextComponentString("Tryck ~INPUT_CONTEXT~ för att ta en väska.")
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

						     					ESX.ShowNotification("Tagna Pengar ~g~" .. CurrencyFormat(cash))		
						     					
						     					TriggerServerEvent('never-quests:giveMoney', 'black_money', cash)

						     					CachedData["money"] = CachedData["money"] - cash
						  						GlobalEvent('donvito:UpdateCache', json.encode(CachedData))

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
	     					ESX.ShowNotification("~r~Snälla vänta upp til 10 sekunder!")
	     				end
	     			end
				end
			end
		end
	end
end)

function DonvitoUpdateLogic()
	local ped = GetPlayerPed(-1)

	CachedData["door.1"] = true
	CachedData["door.2"] = true
	CachedData["door.3"] = true

	if CachedData["state"] == nil or CachedData["data"] == 0 then
		Markers.AddMarker("donvito_quest_final", Positions["door1"], "Tryck ~INPUT_CONTEXT~ för att svetsa upp låset på  ~y~dörren", function()
			ESX.TriggerServerCallback('never-quests:hasItem', function(has)
				if has then
					ESX.TriggerServerCallback('cooldowns:getCooldown', function(cooldown)
						if cooldown == 0 then
							ESX.TriggerServerCallback('never-quests:getPolice', function(count)
								if count >= 5 then
									Citizen.CreateThread(function()
										ESX.TriggerServerCallback('cooldowns:setCooldown', function()
										end, 'quest_robbery', 7200)

										Markers.RemoveMarker('donvito_quest_final')

										TaskStandStill(ped, 100)

										Citizen.Wait(100)

							            TaskStartScenarioInPlace(ped, "WORLD_HUMAN_WELDING", 0, true)

										Citizen.Wait(15000)

							            ClearPedTasksImmediately(ped)
										CachedData["state"] = 1	
										GlobalEvent('donvito:UpdateCache', json.encode(CachedData))
									end)
								else
									ESX.ShowNotification('Det måste vara minst ~b~5 ~w~Poliser i staden för att starta ett rån.')
								end
							end)
						else
							ESX.ShowNotification('~r~Det har nyligen varit rån vänta ~b~' .. cooldown .. ' ~r~sekunder.')
						end
					end, 'quest_robbery')
				else
					ESX.ShowNotification('~r~Du har inte USB Terminal Decrypter')
				end
			end, 'donvito_item', 1)
		end, {red = 255, green = 0, blue = 0, alpha = 75})
	elseif CachedData["state"] == 1 then
		CachedData["door.1"] = false

		ESX.TriggerServerCallback('never-quests:hasItem', function(has)
			if has then
				Markers.AddMarker("donvito_quest_final", Positions["door2"], "Tryck ~INPUT_CONTEXT~ för att svetsa upp låset på ~y~dörren", function()
					Citizen.CreateThread(function()
						Markers.RemoveMarker('donvito_quest_final')
						TaskStandStill(ped, 100)

						Citizen.Wait(100)
						TaskStartScenarioInPlace(ped, "WORLD_HUMAN_WELDING", 0, true)

						Citizen.Wait(15000)

			            ClearPedTasksImmediately(ped)
						CachedData["state"] = 2

						GlobalEvent('donvito:UpdateCache', json.encode(CachedData))
					end)
				end, {red = 255, green = 0, blue = 0, alpha = 75})
			end
		end, 'donvito_item', 1)
	elseif CachedData["state"] == 2 then
		CachedData["door.1"] = false
		CachedData["door.2"] = false

		ESX.TriggerServerCallback('never-quests:hasItem', function(has)
			if has then
				Markers.AddMarker("donvito_quest_final", Positions["vault"], "Tryck ~INPUT_CONTEXT~ för att hacka dig in i ~b~bankvalvet", function()
					Markers.RemoveMarker('donvito_quest_final')

					StartAlarmAtBank("PALETO_BAY_SCORE_ALARM")
					GlobalEvent('never-quests:alarm', 'robbery', GetEntityCoords(GetPlayerPed(-1))["x"], GetEntityCoords(GetPlayerPed(-1))["y"], GetEntityCoords(GetPlayerPed(-1))["z"], 'Terminal på Riksbanken ~w~hålller på att bli hackad av några rånare. ~r~Skicka alla enheter!', 600000)

					HackingMinigame = true

					SendNUIMessage({
						["action"] = 'show',
						["bank"] = 'Pacific Standard'
					})

					SetupCamera({x = 253.13085021973, y = 228.444328125, z = 102.21723516846, rX = 0.0, rY = 0.0, rZ = 70.0})
				end, {red = 255, green = 0, blue = 0, alpha = 75})
			end
		end, 'donvito_item', 1)
	elseif CachedData["state"] == 3 then
		Markers.RemoveMarker("donvito_quest_final")

		CachedData["door.1"] = false
		CachedData["door.2"] = false
		CachedData["door.3"] = false

		CashSpawned = true
	end
end

function DonvitoHackingSuccessful(bank)
	ESX.TriggerServerCallback('never-quests:hasItem', function(has)
		if has then
			HackingMinigame = false
			DestroyCamera()

			CachedData["state"] = 3

			GlobalEvent('donvito:UpdateCache', json.encode(CachedData))
			
			DonvitoUpdateLogic()

			ESX.ShowNotification("Du har framgångsrikt hackat ~b~" .. bank .. "~w~'s valvet. ~r~TA ALLA SEDLAR FORT!")

			TriggerServerEvent('never-quests:removeItem', 'donvito_item', 1)
		else
			ESX.ShowNotification('~r~USB Terminal Decrypter kunnde ej hittas!.')
		end
	end, 'donvito_item', 1)
end

function DonvitoApplyVaultRotation(object)
	local rotation = GetEntityRotation(object)["z"]

	Citizen.CreateThread(function()
		FreezeEntityPosition(object, false)

		while rotation > 0.0 do
			Citizen.Wait(1)

			rotation = rotation - 0.25

			SetEntityRotation(object, 0.0, 0.0, rotation)
		end

		FreezeEntityPosition(object, true)
	end)
end

RegisterNetEvent('donvito:UpdateCache')
AddEventHandler('donvito:UpdateCache', function(cache)
	CachedData = json.decode(cache)

	DonvitoUpdateLogic()
end)

AddEventHandler('never-quests:message:hackingSuccess', function(bank)
	if bank["bank"] == "Pacific Standard" then
		DonvitoHackingSuccessful(bank["bank"])
	end
end)