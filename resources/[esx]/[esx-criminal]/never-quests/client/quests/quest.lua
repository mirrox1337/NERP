function CreateBlip(coords, name, id, color, waypoint)
	local blip = AddBlipForCoord(coords.x, coords.y,coords.z)

	SetBlipSprite(blip, id)
	SetBlipDisplay(blip, 4)
	SetBlipColour(blip, color)
	SetBlipAsShortRange(blip, true)
	SetBlipRoute(blip, waypoint)
	SetBlipRouteColour(blip, color)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
	EndTextCommandSetBlipName(blip)

	return blip
end

local bankAlarms = {}

function StartAlarmAtBank(alarm)
	GlobalEvent('never-quests:bankAlarm')
end

local scene = 0
local IsGrabbing = false
local IsStarting = false
local CashGrabs = {}

function RegisterCashGrab(tray)
	Citizen.CreateThread(function()
		local ped = GetPlayerPed(-1)
		local coords = GetEntityCoords(ped)
		local cashModel = GetHashKey('hei_prop_heist_cash_pile')

		RequestModel(cashModel)

		while not HasModelLoaded(cashModel) do
			Citizen.Wait(25)
		end

		local cashpile = CreateObject(cashModel, coords["x"], coords["y"], coords["z"] - 0.55, true, true, true)

		FreezeEntityPosition(cashpile, true)
		SetEntityInvincible(cashpile, true)
		SetEntityNoCollisionEntity(ped, cashpile)
		SetEntityVisible(cashpile, false, false)
		AttachEntityToEntity(cashpile, ped, GetPedBoneIndex(ped, 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 0, true)

		while IsGrabbing do
			Citizen.Wait(0)

			if GetSynchronizedScenePhase(scene) < 1.0 then
				if HasAnimEventFired(ped, GetHashKey("CASH_APPEAR")) then
					if not IsEntityVisible(cashpile) then
						SetEntityVisible(cashpile, true, false)
					end
				end
			end

			if HasAnimEventFired(ped, GetHashKey("RELEASE_CASH_DESTROY")) then
				if IsEntityVisible(cashpile) then
					SetEntityVisible(cashpile, false, false)
				end
			end
		end

		SetEntityAsMissionEntity(cashpile, true,false)
		DeleteObject(cashpile)
	end)
end

function CashGrab(CachedData, trollyId, callback, resetCallback, cancelCallback, trolly)
	IsStarting = true

	Citizen.CreateThread(function()
		local storedId = math.random(0, 1000)

		while true do
			Citizen.Wait(0)

			local foundId = false

			for i=1, #CashGrabs, 1 do
				if CashGrabs[i]["id"] == storedId then
					foundId = true
				end
			end

			if foundId then
				storedId = math.random(0, 1000)
			else
				break
			end
		end

		local stored = {["id"] = math.random(0, 1000), ["cached"] = CachedData, ["cancelCallback"] = cancelCallback, ["trolly"] = trollyId, ["trollyObject"] = trolly, ["cancelled"] = false, ["bag"] = 0, ["trolly"] = trolly, ["scene"] = 0}
		
		table.insert(CashGrabs, stored)

		local ped = GetPlayerPed(-1)
		local coords = GetEntityCoords(ped)
		local heading = GetEntityHeading(ped)
  		local trollyCoords = GetEntityCoords(trolly)
  		local trollyHeading = GetEntityRotation(trolly)["z"]

		TaskStandStill(ped, 100)
		SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)

		Citizen.Wait(100)

		if stored["cancelled"] then
			for i=1, #CashGrabs, 1 do
				if CashGrabs[i]["id"] == storedId then
					table.remove(CashGrabs, i)
				end
			end

			return
		end

		local bagModel = GetHashKey("hei_p_m_bag_var22_arm_s") 

		RequestModel(bagModel)

		while not HasModelLoaded(bagModel) do
			Citizen.Wait(0)
		end

		if stored["cancelled"] then
			for i=1, #CashGrabs, 1 do
				if CashGrabs[i]["id"] == storedId then
					table.remove(CashGrabs, i)
				end
			end

			return
		end

		local bag = CreateObject(bagModel, coords["x"], coords["y"], coords["z"] - 0.55, false, false, false)

		SetEntityInvincible(bag, true)
		SetEntityNoCollisionEntity(ped, bag)

		stored["bag"] = bag

		UpdateClothes(
			{
				["male"] = {
					["bags_1"] = 0,
					["bags_2"] = 0,
				},
				["female"] = {
					["bags_1"] = 0,										
					["bags_2"] = 0,
				}
			}
		)

		FreezeEntityPosition(ped, true)

		scene = CashGrabAnim('intro', bag, trollyCoords, trollyHeading, trolly)
		stored["scene"] = scene

		Citizen.Wait(2000)

		if stored["cancelled"] then
			for i=1, #CashGrabs, 1 do
				if CashGrabs[i]["id"] == storedId then
					table.remove(CashGrabs, i)
				end
			end

			return
		end

		scene = CashGrabAnim('grab', bag, trollyCoords, trollyHeading, trolly)
		stored["scene"] = scene

		local timestamp = GetGameTimer()
		local model = GetHashKey("prop_anim_cash_pile_01")

		RequestModel(model)

	    while not HasModelLoaded(model) do
	      	Citizen.Wait(0)
	    end

	    IsStarting = false
		IsGrabbing = true
	    RegisterCashGrab(tray)

	    Citizen.Wait(48000)

	    if stored["cancelled"] then
	    	for i=1, #CashGrabs, 1 do
				if CashGrabs[i]["id"] == storedId then
					table.remove(CashGrabs, i)
				end
			end

			return
		end

	    StopEntityAnim(ped, 'anim@heists@ornate_bank@grab_cash', 'grab', true)

	    IsGrabbing = false

		local cash = CachedData["trolly" .. trollyId .. "_money"]

		ESX.ShowNotification("Grabbed ~g~" .. CurrencyFormat(cash))		
		
		TriggerServerEvent('never-quests:giveMoney', 'black_money', cash)

		resetCallback()

		scene = CashGrabAnim('exit', bag, trollyCoords, trollyHeading, tray)
		stored["scene"] = scene

		Citizen.Wait(2600)
		Citizen.InvokeNative(0xCD9CC7E200A52A6F, scene)

		if stored["cancelled"] then
			for i=1, #CashGrabs, 1 do
				if CashGrabs[i]["id"] == storedId then
					table.remove(CashGrabs, i)
				end
			end

			return
		end

		UpdateClothes(
			{
				["male"] = {
					["bags_1"] = 45,
					["bags_2"] = 0,
				},
				["female"] = {
					["bags_1"] = 45,										
					["bags_2"] = 0,
				}
			}
		)

		SetEntityAsMissionEntity(bag, true, false)
		DeleteObject(bag)
		FreezeEntityPosition(ped, false)
		FreezeEntityPosition(trolly, true)
		ClearPedTasksImmediately(ped)

		callback()

		for i=1, #CashGrabs, 1 do
			if CashGrabs[i]["id"] == storedId then
				table.remove(CashGrabs, i)
			end
		end
	end)
end

function CancelCashGrab()
	if IsGrabbing or IsStarting then
		IsGrabbing = false
		IsStarting = false

		FreezeEntityPosition(GetPlayerPed(-1), false)

		for i=1, #CashGrabs, 1 do
			local grab = CashGrabs[i]
			
			Citizen.InvokeNative(0xCD9CC7E200A52A6F, grab["scene"])

			if DoesEntityExist(grab["bag"]) then
				SetEntityAsMissionEntity(grab["bag"], true, false)
				DeleteObject(grab["bag"])
			end

			if DoesEntityExist(grab["trolly"]) then
				SetEntityAsMissionEntity(grab["trolly"], true, false)
				DeleteObject(grab["trolly"])
			end

			CashGrabs[i]["cancelled"] = true
			CashGrabs[i]["cancelCallback"]()
		end
	end
end

function CashGrabAnim(anim, bag, coords, trollyHeading, trolly)
	local ped = GetPlayerPed(-1)

	Citizen.InvokeNative(0xCD9CC7E200A52A6F, scene)

	RequestAnimDict("anim@heists@ornate_bank@grab_cash")

	while not HasAnimDictLoaded("anim@heists@ornate_bank@grab_cash") do
    	Citizen.Wait(0)
  	end

 	local x = coords["x"]
 	local y = coords["y"]
 	local z = coords["z"]
	local heading = trollyHeading

    scene = CreateSynchronizedScene(x, y, z, 0.0, 0.0, heading, 2)
	    
	TaskSynchronizedScene(ped, scene, "anim@heists@ornate_bank@grab_cash", anim, 8.01, -8.01, 3341, 0, 1148846080, 0)
    PlaySynchronizedEntityAnim(bag, scene, "bag_" .. anim, "anim@heists@ornate_bank@grab_cash", 8.01, -8.01, 0, 1148846080)

    if anim == "grab" then
    	PlaySynchronizedEntityAnim(trolly, scene, "cart_cash_dissapear", "anim@heists@ornate_bank@grab_cash", 8.01, -8.01, 0, 1148846080)
    end

    ForceEntityAiAndAnimationUpdate(bag)

    return scene
end

function SyncGrabAnimation(entity, dict, anim)
	GlobalEvent('never-quests:grabAnim', entity, dict, anim)
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

function RemoveObject(assets)
	local object = GetObject(assets)

	if object ~= nil and DoesEntityExist(object) then
		SetEntityAsMissionEntity(object)
		DeleteObject(object)
	end
end

RegisterNetEvent('never-quests:bankAlarm')
AddEventHandler('never-quests:bankAlarm', function(alarm)
	if not Citizen.InvokeNative(0x226435CB96CCFC8C, alarm) then
		if Citizen.InvokeNative(0x9D74AE343DB65533, alarm) then
			Citizen.InvokeNative(0x0355EF116C4C97B2, alarm, true)

			bankAlarms[alarm] = GetGameTimer()
		end
	end
end)

RegisterNetEvent('never-quests:grabAnim')
AddEventHandler('never-quests:grabAnim', function(entityType, entity, dict, anim)
	if entityType == "player" then
		
	elseif entityType == "bag" then
	
	elseif entityType == "cash" then

	elseif entityType == "trolly" then

	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(60000)

		for k,v in pairs(bankAlarms) do
			if (v + 600000) < GetGameTimer() then
				if Citizen.InvokeNative(0x226435CB96CCFC8C, alarm) then
					Citizen.InvokeNative(0xA1CADDCD98415A41, k, true)
				end

				bankAlarms[k] = nil
			end
		end
	end
end)