ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


function getIdentity(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			identifier = identity['identifier'],
			firstname = identity['firstname'],
			lastname = identity['lastname'],
			dateofbirth = identity['dateofbirth'],
			sex = identity['sex'],
			height = identity['height']
			
		}
	else
		return nil
	end
end

 AddEventHandler('chatMessage', function(source, name, message)
      if string.sub(message, 1, string.len("/")) ~= "/" then
          local name = getIdentity(source)
		TriggerClientEvent("sendProximityMessageMe", -1, source, name.firstname, message)
      end
      CancelEvent()
  end)
--[[
RegisterCommand('twt', function(source, args, rawCommand)
    local playerName = GetCharacterName(source)
    local msg = rawCommand:sub(4)
    TriggerClientEvent('chat:addMessage', -1, {
       template = '<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.6.3/css/all.css" integrity="sha384-UHRtZLI+pbxtHCWp1t77Bi1L4ZtiqrqD80Kn4Z8NTSRyMA2Fd33n5dQ8lWUE00s/" crossorigin="anonymous"><div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(28, 160, 242, 0.6); border-radius: 5px;"><i class="fab fa-twitter"></i> @{0}:<br> {1}</div>',
        args = { playerName, msg }
    })
end, false)
--]]
RegisterCommand('galaxy', function(source, args, rawCommand)
    local playerName = GetCharacterName(source)
    local msg = rawCommand:sub(7)
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div style="padding: 0.8vw; margin: 1.0vw; background-color: rgba(140, 20, 252, 0.7);border-radius:5px;">^0<i class="fas fa-wine-glass"></i> ^0Galaxy Club<br>{0}</br></div>',
        args = { msg }
    })
end, false)

RegisterCommand('polisen',function(source, args, rawCommand)
   local name = GetCharacterName(source)
    local msg = rawCommand:sub(8)
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div style="padding: 0.8vw; margin: 0.8vw;background-color: rgba(0, 0, 255, 0.7);border-radius:5px;">^0<i class="fas fa-star"></i> ^0Polismyndigheten<br>{0}</br> </div>',
        args = { msg }
    })
end, false)

RegisterCommand('banken',function(source, args, rawCommand)
    local name = GetCharacterName(source)
     local msg = rawCommand:sub(7)
     TriggerClientEvent('chat:addMessage', -1, {
         template = '<div style="padding: 0.8vw; margin: 0.8vw;background-color: rgb(0,0,0, 0.7);border-radius:5px;">^0<i class="fas fa-university"></i> ^0Centralbanken<br>{0}</br> </div>',
         args = { msg }
     })
 end, false)

 RegisterCommand('bilcenter',function(source, args, rawCommand)
    local name = GetCharacterName(source)
     local msg = rawCommand:sub(11)
     TriggerClientEvent('chat:addMessage', -1, {
         template = '<div style="padding: 0.8vw; margin: 0.8vw;background-color: rgb(59, 57, 6, 0.7);border-radius:5px;">^0<i class="fas fa-car"></i> ^0Bilcenter<br>{0}</br> </div>',
         args = { msg }
     })
 end, false)

 RegisterCommand('mekonomen',function(source, args, rawCommand)
    local name = GetCharacterName(source)
     local msg = rawCommand:sub(10)
     TriggerClientEvent('chat:addMessage', -1, {
         template = '<div style="padding: 0.8vw; margin: 0.8vw;background-color: rgba(108, 122, 137, 0.7);border-radius:5px;">^0<i class="fas fa-wrench"></i> ^0Mekonomen<br>{0}</br> </div>',
         args = { msg }
     })
 end, false)


 RegisterCommand('bennys',function(source, args, rawCommand)
    local name = GetCharacterName(source)
     local msg = rawCommand:sub(7)
     TriggerClientEvent('chat:addMessage', -1, {
         template = '<div style="padding: 0.8vw; margin: 0.8vw;background-color: rgba(108, 122, 137, 0.7);border-radius:5px;">^0<i class="fas fa-wrench"></i> ^0Bennys<br>{0}</br> </div>',
         args = { msg }
     })
 end, false)

 RegisterCommand('securitas',function(source, args, rawCommand)
    local name = GetCharacterName(source)
     local msg = rawCommand:sub(10)
     TriggerClientEvent('chat:addMessage', -1, {
         template = '<div style="padding: 0.8vw; margin: 0.8vw;background-color: rgb(124, 70, 145, 0.7);border-radius:5px;">^0<i class="fas fa-user-secret"></i> ^0Securitas<br>{0}</br> </div>',
         args = { msg }
     })
 end, false)

 RegisterCommand('uber',function(source, args, rawCommand)
    local name = GetCharacterName(source)
     local msg = rawCommand:sub(5)
     TriggerClientEvent('chat:addMessage', -1, {
         template = '<div style="padding: 0.8vw; margin: 0.8vw;background-color: rgb(255,180,20, 0.7);border-radius:5px;">^0<i class="fab fa-uber"></i> ^0Uber<br>{0}</br> </div>',
         args = { msg }
     })
 end, false)

RegisterCommand('sjukvården',function(source, args, rawCommand)
    local name = GetCharacterName(source)
     local msg = rawCommand:sub(12)
     TriggerClientEvent('chat:addMessage', -1, {
         template = '<div style="padding: 0.8vw; margin: 0.8vw;background-color: rgba(207, 0, 15, 0.7);border-radius:5px;">^0<i class="fas fa-ambulance"></i> ^0Sjukvården<br>{0}</br> </div>',
         args = { msg }
     })
 end, false)

--RegisterCommand('ooc', function(source, args, rawCommand)
   -- local playerName = GetPlayerName(source)
   -- local msg = rawCommand:sub(4)
   -- TriggerClientEvent('chat:addMessage', -1, {
       -- template = '<div style="padding: 0.8vw; margin: 1.0vw; background-color: rgba(177, 239, 185, 0.7);border-radius:5px;">^0<i class="fas fa-globe"></i> {0}:<br>{1}</br></div>',
       -- args = { playerName, msg }
  --  })
--end, false)

TriggerEvent('es:addCommand', 'pm', function(source, args, user)
    if(GetPlayerName(tonumber(args[2])) or GetPlayerName(tonumber(args[3])))then
    local player = tonumber(args[2])
    table.remove(args, 2)
    table.remove(args, 1)
    
    TriggerEvent("es:getPlayerFromId", player, function(target)
    TriggerClientEvent('chatMessage', player, "PM", {214, 214, 214}, "^2 Från ^5"..GetPlayerName(source).. " [" .. source .. "]: ^7" ..table.concat(args, " "))
    TriggerClientEvent('chatMessage', source, "PM", {214, 214, 214}, "^3 Skickat till ^5"..GetPlayerName(player).. ": ^7" ..table.concat(args, " "))
    end)
    else
    TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Incorrect player ID!")
    end
    end, function(source, args, user)
    TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficienct permissions!")
end)
  



function GetCharacterName(source)
    local result = MySQL.Sync.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier', {
        ['@identifier'] = GetPlayerIdentifiers(source)[1]
    })

    if result[1] and result[1].firstname and result[1].lastname then
        if Config.OnlyFirstname then
            return result[1].firstname
        else
            return ('%s %s'):format(result[1].firstname, result[1].lastname)
        end
    else
        return GetPlayerName(source)
    end
end
