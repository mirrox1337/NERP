local Keys = {
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

local Markers = {}
local CurrentAction = nil
local CurrentActionData = nil
local LastClick = 0

Marker = {}

Citizen.CreateThread(function()
	while true do
		if PlayerData ~= nil and PlayerData.job ~= nil then
			local ped = GetPlayerPed(-1)
			local coords = GetEntityCoords(ped)

			if CurrentAction ~= nil and CurrentActionData ~= nil and CurrentActionData.position ~= nil then
				if GetDistanceBetweenCoords(coords, CurrentActionData.position.x, CurrentActionData.position.y, CurrentActionData.position.z, true) > 1.5 then
					if CurrentActionData.exitCallback ~= nil then
						CurrentActionData.exitCallback()
					end
				end
			end

			CurrentAction = nil
			CurrentActionData = nil

			for i=1, #Markers, 1 do 
				local marker = Markers[i]
				local job = marker.job

				if PlayerData ~= nil then
					if job == nil then
						job = PlayerData.job.name
					end

					if PlayerData.job.name == job and PlayerData.job.grade >= marker.jobGrade then
						if GetDistanceBetweenCoords(coords, marker.position.x, marker.position.y, marker.position.z, true) < 5 then
							if marker.hideMarker ~= true then
								DrawMarker(27, marker.position.x, marker.position.y, marker.position.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 0.5, 0, 255, 0, 255, false, false, 2, false, false, false, false)
							end

							if GetDistanceBetweenCoords(coords, marker.position.x, marker.position.y, marker.position.z, true) < 1.5 then
								CurrentAction = marker.id
								CurrentActionData = marker
							end
						end
					end
				end
			end

			if CurrentAction ~= nil then
				SetTextComponentFormat('STRING')
	     		AddTextComponentString(CurrentActionData.message)
		  
	     		DisplayHelpTextFromStringLabel(0, 0, 1, -1)

	     		local jobCorrect = false

	     		if PlayerData.job.name == CurrentActionData.job or CurrentActionData.job == nil then
	     			if PlayerData.job.grade >= CurrentActionData.jobGrade then
	     				jobCorrect = true
	     			end
	     		end

	     		if IsControlPressed(0, Keys['E']) and jobCorrect and (LastClick + 3000) < GetGameTimer() then
	     			CurrentActionData.callback()

	     			LastClick = GetGameTimer()
	     		end
			end
		end

		Citizen.Wait(0)
	end
end)

function Marker.AddMarker(id, position, message, job, jobGrade, callback, exitCallback, hideMarker)
	table.insert(Markers, {
		id = id,
		position = position,
		message = message,
		job = job,
		jobGrade = jobGrade,
		callback = callback,
		exitCallback = exitCallback,
		hideMarker = hideMarker
	})
end