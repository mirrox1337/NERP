local allowed = {
	"steam:110000110c9fe9e",
	"steam:110000106425ae3",
	"steam:11000010adda13c",
	"steam:110000106a8a576",
	"steam:110000109fc5375",
	"steam:11000010a74de80",
	"steam:11000010ae016b0"
}

AddEventHandler('chatMessage', function(source, n, msg)
	local identifier = GetPlayerIdentifiers(source)[1]
	if msg == "/ped" then 
		CancelEvent()
		if checkAllowed(identifier) then
			TriggerClientEvent('nerp-pedmenu:ped', source)
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Du har inte tillgång till detta kommando', style = { ['background-color'] = '#b00000', ['color'] = '#fff' } })
		end
	end
end)

function checkAllowed(id)
	for k, v in pairs(allowed) do
		if id == v then
			return true
		end
	end
	
	return false
end