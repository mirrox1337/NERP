local PlayerData = {}
local Quests = {
	["DonVito"] = {
		blip = 355,
		model = -236444766,
		location = {x = -94.260269165039, y = 313.91314697266, z = 135.85406494141, heading = 30.0},
		interact = {x = -95.539901733398, y = 318.45520019531, z = 135.85475158691, heading = 330.0},
		camera = {x = -92.396713256836, y = 318.48489379883, z = 137.85635375977, rX = 0.0, rY = 0.0, rZ = 150.0},
		start = {x = -99.693489074707, y = 365.42221069336, z = 112.27474975586}
	}
}
local CachedQuests = {}
local cam = nil
local quests = {}

Quest = {}
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

Citizen.CreateThread(function()
	while ESX == nil do
		Citizen.Wait(0)

		TriggerEvent('esx:getSharedObject', function(obj)
			ESX = obj

			if ESX.IsPlayerLoaded() == true then
				PlayerData = ESX.GetPlayerData()

				DoScreenFadeIn(0)

				--SetupQuests()
			end
		end)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if IsControlJustPressed(0, Keys["X"]) or IsControlJustPressed(0, Keys["F9"]) then
			CancelCashGrab()
		end
	end
end)

function SetupQuests()
	--[[CacheQuests()

	for k,v in pairs(Quests) do
		local blip = AddBlipForCoord(v.start.x, v.start.y, v.start.z)

		SetBlipSprite(blip, v.blip)
		SetBlipDisplay(blip, 4)
		SetBlipColour(blip, 5)
		SetBlipAsShortRange(blip, true)

	    BeginTextCommandSetBlipName("STRING")
	    AddTextComponentString(k)
		EndTextCommandSetBlipName(blip)
	end


	Markers.AddMarker('donvito', Quests["DonVito"].start, 'Tryck ~INPUT_CONTEXT~ för att prata med ~b~Don Vito', function()
		local quest = Quests["DonVito"]
		local questData = {
			model = quest.model,
			location = quest.location,
			interact = quest.interact,
			camera = quest.camera,
			animation = {
				group = nil,
				id = 'WORLD_HUMAN_SMOKING'
			},
			length = 10000
		}

		local objective = GetQuestObjective('donvito')
		if objective == 1 then
			questData.length = 36000
		elseif objective == 2 then
			questData.length = 22000
		elseif objective == 3 then
			questData.length = 30000
		elseif objective == 4 then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'donvito_last_prep',
				{
					title = 'Don Vito (Bank Heist)',
					align = 'top-left',
					elements = {
						{label = 'Fortsätt ($50,000)', value = 'yes'},
						{label = "fortsätt inte", value = 'no'}
					}
				},
				function(data, menu)
					menu.close()

					if data.current.value == 'yes' then
						ESX.TriggerServerCallback('never-quests:makePayment', function(success)
							if success then
								questData.length = 18000

								TalkWithPerson('Don Vito', questData)
								TriggerEvent('LIFE_CL:Sound:PlayOnOne', 'donvito_' .. objective, 0.5)

								quests["donvito_" .. objective]()
							else
								ESX.ShowNotification('~r~Du har inte tillräkligt med pengar!')
							end
						end, 50000)
					end
				end,
				function(data, menu)
					menu.close()
				end
			)

			return
		end

		TalkWithPerson('Don Vito', questData)
		TriggerEvent('LIFE_CL:Sound:PlayOnOne', 'donvito_' .. objective, 0.5)

		quests["donvito_" .. objective]()
	end)]]
end

function Quest.AddQuest(person, id, callback)
	quests[person .. '_' .. id] = callback
end

function Quest.FinishQuest(person, next)
	UpdateQuest(person, next)
end

function CreateBlip(coords, name, id, color, waypoint)
	local blip = AddBlipForCoord(coords.x, coords.y,coords.z)

	SetBlipSprite(blip, id)
	SetBlipDisplay(blip, 4)
	SetBlipColour(blip, color)
	SetBlipAsShortRange(blip, true)

	if waypoint then
		SetBlipRoute(blip, true)
		SetBlipRouteColour(blip, color)
	end

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
	EndTextCommandSetBlipName(blip)

	return blip
end

function ShowSubtitle(subtitle, length)
	Citizen.CreateThread(function()
		local timestamp = GetGameTimer()

		while (timestamp + length) > GetGameTimer() do
			Citizen.Wait(0)

			SetTextFont(0)
		    SetTextProportional(0)
		    SetTextScale(0.4, 0.4)
		    SetTextColour(255, 255, 255, 255)
		    SetTextDropShadow(0, 0, 0, 0,255)
		    SetTextEdge(1, 0, 0, 0, 255)
		    SetTextDropShadow()

		    SetTextEntry("STRING")
		    AddTextComponentString(subtitle)

		    DrawText(0.25, 0.93)
		end
	end)
end

function GlobalEvent(event, ...) 
	TriggerServerEvent('never-quests:globalEvent', event, ...)
end

function TalkWithPerson(name, quest)
	Citizen.CreateThread(function()
		local ped = GetPlayerPed(-1)
		local coords = {x = GetEntityCoords(ped).x, y = GetEntityCoords(ped).y, z = GetEntityCoords(ped).z - 1.0}

		RequestModel(quest.model)

		while not HasModelLoaded(quest.model) do
			Citizen.Wait(25)
		end

		TriggerEvent('never-cinemamode:force', true)
		
		DoScreenFadeOut(500)
		Citizen.Wait(750)

		local person = CreatePed(5, quest.model, quest.location.x, quest.location.y, quest.location.z, quest.location.heading, false, true)

		PlayAnimation(person, quest.animation.group, quest.animation.id)

		Markers.HideAll()

		SetEntityCoords(ped, quest.interact.x, quest.interact.y, quest.interact.z)
		SetEntityHeading(ped, quest.interact.heading)

		TaskGoToEntity(ped, person, -1, 2.0, 1.0, 1073741824.0, 0)
		SetPedKeepTask(ped, true)

		Citizen.Wait(100)

		SetupCamera(quest.camera)

		DoScreenFadeIn(500)
		Citizen.Wait(quest.length)

		DoScreenFadeOut(500)
		Citizen.Wait(750)

		DestroyCamera()
		SetEntityCoords(ped, coords.x, coords.y, coords.z)
		FreezeEntityPosition(ped, false)
		DeleteEntity(person)
		
		Markers.ShowAll()
		
		TriggerEvent('never-cinemamode:force', false)

		DoScreenFadeIn(500)
	end)
end

function PlayAnimation(ped, group, animation, settings)
	if group ~= nil then
		Citizen.CreateThread(function()
			RequestAnimDict(group)

			while not HasAnimDictLoaded(group) do
	        	Citizen.Wait(100)
	      	end

	      	if settings == nil then
		      	TaskPlayAnim(ped, group, animation, 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)
		    else 
		    	local speed = 1.0
		    	local speedMultiplier = -1.0
		    	local duration = 1.0
		    	local flag = 0
		    	local playbackRate = 0

		    	if settings["speed"] ~= nil then
		    		speed = settings["speed"]
		    	end

		    	if settings["speedMultiplier"] ~= nil then
		    		speedMultiplier = settings["speedMultiplier"]
		    	end

		    	if settings["duration"] ~= nil then
		    		duration = settings["duration"]
		    	end

		    	if settings["flag"] ~= nil then
		    		flag = settings["flag"]
		    	end

		    	if settings["playbackRate"] ~= nil then
		    		playbackRate = settings["playbackRate"]
		    	end

		      	TaskPlayAnim(ped, group, animation, speed, speedMultiplier, duration, flag, playbackRate, 0, 0, 0)
		    end
		end)
	else
		TaskStartScenarioInPlace(ped, animation, 0, true)
	end
end

function SetupCamera(coordinates)
	if cam ~= nil then
		DestroyCamera()
	end

	cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
					
	SetCamCoord(cam, coordinates.x, coordinates.y, coordinates.z)
	SetCamRot(cam, coordinates.rX, coordinates.rY, coordinates.rZ)
	SetCamActive(cam,  true)
	
	RenderScriptCams(true,  false,  0,  true,  true)
	
	SetCamCoord(cam, coordinates.x, coordinates.y, coordinates.z)
end

function DestroyCamera()
	if cam ~= nil then
		if DoesCamExist(cam) then
			RenderScriptCams(false, false, 0, 1, 0)
			DestroyCam(cam)

			cam = nil
		end
	end
end

function Identifier()
	return ESX.GetPlayerData().identifier
end

function CacheQuests()
	for k,v in pairs(Quests) do
		CachedQuests[k] = 1
	end

	MySQL.fetchAll('SELECT * FROM quests WHERE identifier=@identifier',
		{
			["@identifier"] = Identifier()
		},
		function(fetched)
			if fetched ~= nil then
				for i=1, #fetched, 1 do
					local row = fetched[i]

					CachedQuests[row.person] = row.quest
				end
			end
		end
	)
end

function UpdateQuest(person, quest)
	CachedQuests[person] = quest

	MySQL.fetchAll('SELECT * FROM quests WHERE identifier=@identifier AND person=@person',
		{
			["@person"] = person,
			["@identifier"] = Identifier()
		},
		function(fetched)
			if fetched ~= nil and fetched[1] ~= nil then
				MySQL.execute('UPDATE quests SET quest=@quest WHERE identifier=@identifier AND person=@person',
					{
						["@quest"] = quest,
						["@person"] = person,
						["@identifier"] = Identifier()
					}
				)
			else
				MySQL.execute('INSERT INTO quests (identifier, person, quest) VALUES (@identifier, @person, @quest)',
					{
						["@quest"] = quest,
						["@person"] = person,
						["@identifier"] = Identifier()
					}
				)
			end
		end
	)
end

function GetQuestObjective(quest)
	local objective = CachedQuests[quest]

	if objective == nil then
		objective = 1
	end

	return objective
end

local alarms = {}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)

		for id,alarm in pairs(alarms) do
			if alarm["blip"] ~= nil then
				if alarm["delay"] > 0 then
					if (alarm["timestamp"] + alarm["delay"]) < GetGameTimer() then
						TriggerEvent('never-quests:removeAlarm', id)
					end
	 			end
			end
		end
	end
end)

RegisterNetEvent('never-quests:alarm')
AddEventHandler('never-quests:alarm', function(id, x, y, z, message, delay)
	if PlayerData.job.name == 'police' then
		ESX.ShowNotification(message)

		local blip = AddBlipForCoord(x, y, z)

		SetBlipSprite(blip, 161)
		SetBlipScale(blip, 2.0)
		SetBlipColour(blip, 3)

		PulseBlip(blip)

	    BeginTextCommandSetBlipName("STRING")
	    AddTextComponentString('Alarm')
		EndTextCommandSetBlipName(blip)

		if delay == nil then
			delay = 0
		end

		alarms[id] = {
			["blip"] = blip,
			["timestamp"] = GetGameTimer(),
			["delay"] = delay
		}
	end
end)

RegisterNetEvent('never-quests:updateAlarm')
AddEventHandler('never-quests:updateAlarm', function(id, x, y, z)
	if PlayerData.job.name == 'police' then
		if alarms[id]["blip"] ~= nil then
			RemoveBlip(alarms[id]["blip"])

			local blip = AddBlipForCoord(x, y, z)

			SetBlipSprite(blip, 161)
			SetBlipScale(blip, 2.0)
			SetBlipColour(blip, 3)

			PulseBlip(blip)

		    BeginTextCommandSetBlipName("STRING")
		    AddTextComponentString('Alarm')
			EndTextCommandSetBlipName(blip)

			alarms[id] = {
				["blip"] = blip,
				["timestamp"] = alarms[id]["timestamp"],
				["delay"] = alarms[id]["delay"]
			}
		end
	end
end)

RegisterNetEvent('never-quests:removeAlarm')
AddEventHandler('never-quests:removeAlarm', function(id)
	if alarms[id]["blip"] ~= nil then
		RemoveBlip(alarms[id]["blip"])

		alarms[id]["blip"] = nil
		alarms[id]["delay"] = 0
		alarms[id]["timestamp"] = 0
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(player)
	PlayerData = player

	SetupQuests()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)