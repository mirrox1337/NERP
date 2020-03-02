AddEventHandler( "playerConnecting", function(name, setReason )
	local identifier = GetPlayerIdentifiers(source)[1]
	if not isWhiteListed(identifier) then
		setReason("Du är inte whitelistad!")
		print("(" .. identifier .. ") " .. name .. " har sparkats eftersom han inte är whitelistad!")
		CancelEvent()
    end
end)

-- Chat Command to add someone in WhiteList
TriggerEvent('es:addGroupCommand', 'whitelist', "mod", function(source, args, user)
	if #args == 2 then
		if isWhiteListed(args[2]) then
			TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, args[2] .. " är redan whitelistad!")
		else
			addWhiteList(args[2])
			TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, args[2] .. " har blivit whitelistad!")
		end
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Felaktig identifierare!")
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Otillräckliga rättigheter!")
end)

-- Chat Command för att ta bort någons whitelist
TriggerEvent('es:addGroupCommand', 'removewhitelist', "superadmin", function(source, args, user)
	if #args == 2 then
		if isWhiteListed(args[2]) then
			removeWhiteList(args[2])
			TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, args[2] .. " är inte längre whitelistad!")
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, args[2] .. " är inte whitelistad från!")
		end
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Felaktig identifierare!")
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Otillräckliga rättigheter!")
end)

function addWhiteList(identifier)
	MySQL.Sync.execute("INSERT INTO user_whitelist (`identifier`, `whitelisted`) VALUES (@identifier, @whitelisted)",{['@identifier'] = identifier, ['@whitelisted'] = 1})
end

function removeWhiteList(identifier)
	MySQL.Sync.execute("DELETE FROM user_whitelist WHERE identifier = @identifier", {['@identifier'] = identifier})
end

function isWhiteListed(identifier)
	local result = MySQL.Sync.fetchScalar("SELECT whitelisted FROM user_whitelist WHERE identifier = @username AND whitelisted = 1", {['@username'] = identifier})
	if result then
		return true
	end
	return false
end


-- Kommando för att lägga till / ta bort någons whitelist
AddEventHandler('rconCommand', function(commandName, args)
	if commandName == 'whitelist' then
		if #args ~= 1 then
			RconPrint("Användande: whitelistadd [hexid]\n")
			CancelEvent()
			return
		end
		if isWhiteListed(args[1]) then
			RconPrint(args[1] .. " är redan whitelistad!\n")
			CancelEvent()
		else
			addWhiteList(args[1])
			RconPrint(args[1] .. " har blivit whitelistad!\n")
			CancelEvent()
		end
	elseif commandName == 'wlremove' then
		if #args ~= 1 then
			RconPrint("Användande: whitelistremove [hexid]\n")
			CancelEvent()
			return
		end
		if isWhiteListed(args[1]) then
			removeWhiteList(args[1])
			RconPrint(args[1] .. " är nu borttagen från whitelist!\n")
			CancelEvent()
		else
			RconPrint(args[1] .. " är inte whitelistad!\n")
			CancelEvent()
		end
	end
end)