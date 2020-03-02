ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

math.randomseed(os.time()) 

--- Pour les numero du style XXX-XXXX
--[[
function getPhoneRandomNumber()
    local numBase0 = math.random(100,999)
    local numBase1 = math.random(0,9999)
    local num = string.format("%03d-%04d", numBase0, numBase1 )
	return num
end ]]--

 function getPhoneRandomNumber()
     return '073' .. math.random(1000000,9999999)
 end

--- Exemple pour les numero du style 06XXXXXXXX
-- function getPhoneRandomNumber()
--     return '0' .. math.random(600000000,699999999)
-- end



local ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) 
    ESX = obj 
    ESX.RegisterServerCallback('chrono:getItemAmount', function(source, cb, item)
        print('chrono:getItemAmount call item : ' .. item)
        local xPlayer = ESX.GetPlayerFromId(source)
        local items = xPlayer.getInventoryItem(item)
        if items == nil then
            cb(0)
        else
            cb(items.count)
        end
    end)
end)

ESX.RegisterUsableItem('phone', function(source)   
    local xPlayer = ESX.GetPlayerFromId(source)
    local phone = xPlayer.getInventoryItem('phone')
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    local phoneQ = xPlayer.getInventoryItem('phone').count
    local phoneOffQ = xPlayer.getInventoryItem('phoneoff').count
    if phoneQ > 0 then
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Du stängde av telefonen.', length = 3500, style = { ['background-color'] = '#ad0000', ['color'] = '#fff' } })
        xPlayer.addInventoryItem('phoneoff', phoneQ)
        xPlayer.removeInventoryItem('phone', phoneQ)
    elseif phoneOffQ > 0 then
        xPlayer.addInventoryItem('phone', phoneOffQ)
        xPlayer.removeInventoryItem('phoneoff', phoneOffQ)
        end
end)

ESX.RegisterUsableItem('phoneoff', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local phone = xPlayer.getInventoryItem('phone')
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    local phoneQ = xPlayer.getInventoryItem('phoneoff').count
    local phoneOffQ = xPlayer.getInventoryItem('phone').count
    if phoneQ > 0 then
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Du startade telefonen.', length = 3500, style = { ['background-color'] = '#007ecc', ['color'] = '#fff' } })
        xPlayer.addInventoryItem('phone', phoneQ)
        xPlayer.removeInventoryItem('phoneoff', phoneQ)
        end
end)



--====================================================================================
--  Utils
--====================================================================================
function getSourceFromIdentifier(identifier, cb)
    TriggerEvent("es:getPlayers", function(users)
        for k , user in pairs(users) do
            if (user.getIdentifier ~= nil and user.getIdentifier() == identifier) or (user.identifier == identifier) then
                cb(k)
                return
            end
        end
    end)
    cb(nil)
end
function getNumberPhone(identifier)
    local result = MySQL.Sync.fetchAll("SELECT users.phone_number FROM users WHERE users.identifier = @identifier", {
        ['@identifier'] = identifier
    })
    if result[1] ~= nil then
        return result[1].phone_number
    end
    return nil
end
function getIdentifierByPhoneNumber(phone_number) 
    local result = MySQL.Sync.fetchAll("SELECT users.identifier FROM users WHERE users.phone_number = @phone_number", {
        ['@phone_number'] = phone_number
    })
    if result[1] ~= nil then
        return result[1].identifier
    end
    return nil
end

ESX.RegisterServerCallback('chrono:getIdentity', function(source, cb)		
    local identity = getIdentity(source)		
    cb(identity)		
end)		
function getIdentity(source)		
    local identifier = GetPlayerIdentifiers(source)[1]		
    local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})		
    if result[1] ~= nil then		
        local identity = result[1]		
        return {		
            job = identity['job'],		
            firstname = identity['firstname'],		
            lastname = identity['lastname']		
        }		
    else		
        return nil		
    end		
end

function getPlayerID(source)
    local identifiers = GetPlayerIdentifiers(source)
    local player = getIdentifiant(identifiers)
    return player
end

function getIdentifiant(id)
    for _, v in ipairs(id) do
        return v
    end
end


function getOrGeneratePhoneNumber (sourcePlayer, identifier, cb)
    local sourcePlayer = sourcePlayer
    local identifier = identifier
    local myPhoneNumber = getNumberPhone(identifier)
    if myPhoneNumber == '0' or myPhoneNumber == nil then
        repeat
            myPhoneNumber = getPhoneRandomNumber()
            local id = getIdentifierByPhoneNumber(myPhoneNumber)
        until id == nil
        MySQL.Async.insert("UPDATE users SET phone_number = @myPhoneNumber WHERE identifier = @identifier", { 
            ['@myPhoneNumber'] = myPhoneNumber,
            ['@identifier'] = identifier
        }, function ()
            cb(myPhoneNumber)
        end)
    else
        cb(myPhoneNumber)
    end
end


--Dispatch--
RegisterServerEvent('qalle:jobS')
AddEventHandler('qalle:jobS', function(phoneNumber, message, position, dipatch2)

    local _source = source
    local xPlayer1 = ESX.GetPlayerFromId(_source)
    
    local xPlayers = ESX.GetPlayers()
    local dispatch = dipatch2
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        local numPosition      = position
        local sourcePlayer = xPlayer.source
        local identifier = xPlayer.identifier
        if phoneNumber == 'drug' then
            if xPlayer.job.name == 'police' then
                TriggerClientEvent('qalle:job', xPlayer.source, phoneNumber, message, position, xPlayer1.get('phoneNumber'), dispatch)
            end
        end
        if phoneNumber == 'police' then
            if xPlayer.job.name == 'police' then
                TriggerClientEvent('qalle:job', xPlayer.source, phoneNumber, message, position, xPlayer1.get('phoneNumber'), dispatch)
            end
        end
        if phoneNumber == 'ambulance' then
            if xPlayer.job.name == 'ambulance' then
                TriggerClientEvent('qalle:job', xPlayer.source, phoneNumber, message, position, xPlayer1.get('phoneNumber'), dispatch)
            end
        end
        if phoneNumber == 'mecano' then
            if xPlayer.job.name == 'mecano' then
                TriggerClientEvent('qalle:job', xPlayer.source, phoneNumber, message, position, xPlayer1.get('phoneNumber'), dispatch)
            end
        end
        if phoneNumber == 'cardealer' then
            if xPlayer.job.name == 'cardealer' then
                TriggerClientEvent('qalle:job', xPlayer.source, phoneNumber, message, position, xPlayer1.get('phoneNumber'), dispatch)
            end
        end
        if phoneNumber == 'taxi' then
            if xPlayer.job.name == 'taxi' then
                TriggerClientEvent('qalle:job', xPlayer.source, phoneNumber, message, position, xPlayer1.get('phoneNumber'), dispatch)
            end
        end
        if phoneNumber == 'Securitas' then
            if xPlayer.job.name == 'Securitas' then
                TriggerClientEvent('qalle:job', xPlayer.source, phoneNumber, message, position, xPlayer1.get('phoneNumber'), dispatch)
            end
        end
        if phoneNumber == 'bennys' then
            if xPlayer.job.name == 'bennys' then
                TriggerClientEvent('qalle:job', xPlayer.source, phoneNumber, message, position, xPlayer1.get('phoneNumber'), dispatch)
            end
        end            
    end
end)

RegisterServerEvent('chrono:stopDispatch')
AddEventHandler('chrono:stopDispatch', function(dispatchRequestId, policeDispatch)
  TriggerClientEvent('chrono:stopDispatch', -1, dispatchRequestId, getIdentity(source), policeDispatch)
end)    

RegisterServerEvent('chrono:stopDispatch2')
AddEventHandler('chrono:stopDispatch2', function(dispatchRequestId, policeDispatch)
  TriggerClientEvent('chrono:stopDispatch2', -1, dispatchRequestId, getIdentity(source), policeDispatch)
end)  


--====================================================================================
--  Contacts
--====================================================================================
function getContacts(identifier)
    local result = MySQL.Sync.fetchAll("SELECT * FROM phone_users_contacts WHERE phone_users_contacts.identifier = @identifier", {
        ['@identifier'] = identifier
    })
    return result
end
function addContact(source, identifier, number, display)
    local sourcePlayer = tonumber(source)
    MySQL.Async.insert("INSERT INTO phone_users_contacts (`identifier`, `number`,`display`) VALUES(@identifier, @number, @display)", {
        ['@identifier'] = identifier,
        ['@number'] = number,
        ['@display'] = display,
    },function()
        notifyContactChange(sourcePlayer, identifier)
    end)
end
function updateContact(source, identifier, id, number, display)
    local sourcePlayer = tonumber(source)
    MySQL.Async.insert("UPDATE phone_users_contacts SET number = @number, display = @display WHERE id = @id", { 
        ['@number'] = number,
        ['@display'] = display,
        ['@id'] = id,
    },function()
        notifyContactChange(sourcePlayer, identifier)
    end)
end
function deleteContact(source, identifier, id)
    local sourcePlayer = tonumber(source)
    MySQL.Sync.execute("DELETE FROM phone_users_contacts WHERE `identifier` = @identifier AND `id` = @id", {
        ['@identifier'] = identifier,
        ['@id'] = id,
    })
    notifyContactChange(sourcePlayer, identifier)
end
function deleteAllContact(identifier)
    MySQL.Sync.execute("DELETE FROM phone_users_contacts WHERE `identifier` = @identifier", {
        ['@identifier'] = identifier
    })
end
function notifyContactChange(source, identifier)
    local sourcePlayer = tonumber(source)
    local identifier = identifier
    if sourcePlayer ~= nil then 
        TriggerClientEvent("chrono:contactList", sourcePlayer, getContacts(identifier))
    end
end

RegisterServerEvent('chrono:addContact')
AddEventHandler('chrono:addContact', function(display, phoneNumber)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    addContact(sourcePlayer, identifier, phoneNumber, display)
end)

RegisterServerEvent('chrono:updateContact')
AddEventHandler('chrono:updateContact', function(id, display, phoneNumber)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    updateContact(sourcePlayer, identifier, id, phoneNumber, display)
end)

RegisterServerEvent('chrono:deleteContact')
AddEventHandler('chrono:deleteContact', function(id)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    deleteContact(sourcePlayer, identifier, id)
end)

--====================================================================================
--  Messages
--====================================================================================
function getMessages(identifier)
    local result = MySQL.Sync.fetchAll("SELECT phone_messages.* FROM phone_messages LEFT JOIN users ON users.identifier = @identifier WHERE phone_messages.receiver = users.phone_number", {
         ['@identifier'] = identifier
    })
    return result
    --return MySQLQueryTimeStamp("SELECT phone_messages.* FROM phone_messages LEFT JOIN users ON users.identifier = @identifier WHERE phone_messages.receiver = users.phone_number", {['@identifier'] = identifier})
end

RegisterServerEvent('chrono:_internalAddMessage')
AddEventHandler('chrono:_internalAddMessage', function(transmitter, receiver, message, owner, cb)
    cb(_internalAddMessage(transmitter, receiver, message, owner))
end)

function _internalAddMessage(transmitter, receiver, message, owner)
    local Query = "INSERT INTO phone_messages (`transmitter`, `receiver`,`message`, `isRead`,`owner`) VALUES(@transmitter, @receiver, @message, @isRead, @owner);"
    local Query2 = 'SELECT * from phone_messages WHERE `id` = @id;'
	local Parameters = {
        ['@transmitter'] = transmitter,
        ['@receiver'] = receiver,
        ['@message'] = message,
        ['@isRead'] = owner,
        ['@owner'] = owner
    }
    local id = MySQL.Sync.insert(Query, Parameters)
    return MySQL.Sync.fetchAll(Query2, {
        ['@id'] = id
    })[1]
end

function addMessage(source, identifier, phone_number, message)
    local sourcePlayer = tonumber(source)
    local otherIdentifier = getIdentifierByPhoneNumber(phone_number)
    local myPhone = getNumberPhone(identifier)
    if otherIdentifier ~= nil then 
        local tomess = _internalAddMessage(myPhone, phone_number, message, 0)
        getSourceFromIdentifier(otherIdentifier, function (osou)
            if tonumber(osou) ~= nil then 
                -- TriggerClientEvent("chrono:allMessage", osou, getMessages(otherIdentifier))
                TriggerClientEvent("chrono:receiveMessage", tonumber(osou), tomess)
            end
        end) 
    end
    local memess = _internalAddMessage(phone_number, myPhone, message, 1)
    TriggerClientEvent("chrono:receiveMessage", sourcePlayer, memess)
end

function setReadMessageNumber(identifier, num)
    local mePhoneNumber = getNumberPhone(identifier)
    MySQL.Sync.execute("UPDATE phone_messages SET phone_messages.isRead = 1 WHERE phone_messages.receiver = @receiver AND phone_messages.transmitter = @transmitter", { 
        ['@receiver'] = mePhoneNumber,
        ['@transmitter'] = num
    })
end


function deleteMessage(msgId)
    MySQL.Sync.execute("DELETE FROM phone_messages WHERE `id` = @id", {
        ['@id'] = msgId
    })
end

function deleteAllMessageFromPhoneNumber(source, identifier, phone_number)
    local source = source
    local identifier = identifier
    local mePhoneNumber = getNumberPhone(identifier)
    MySQL.Sync.execute("DELETE FROM phone_messages WHERE `receiver` = @mePhoneNumber and `transmitter` = @phone_number", {['@mePhoneNumber'] = mePhoneNumber,['@phone_number'] = phone_number})
end

function deleteAllMessage(identifier)
    local mePhoneNumber = getNumberPhone(identifier)
    MySQL.Sync.execute("DELETE FROM phone_messages WHERE `receiver` = @mePhoneNumber", {
        ['@mePhoneNumber'] = mePhoneNumber
    })
end

RegisterServerEvent('chrono:sendMessage')
AddEventHandler('chrono:sendMessage', function(phoneNumber, message)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    addMessage(sourcePlayer, identifier, phoneNumber, message)
end)

RegisterServerEvent('chrono:sendMessage2')     
AddEventHandler('chrono:sendMessage2', function(number, message)       
    local src = source      
    local sourcePlayer = tonumber(src)      
    local identifier = getPlayerID(src)         
    local xPlayer = ESX.GetPlayerFromId(src)        
    local xPlayers = ESX.GetPlayers()       
    for i=1, #xPlayers do       
        local xPlayer2 = ESX.GetPlayerFromId(xPlayers[i])       
        if xPlayer2.job.name == number then     
            addMessage(sourcePlayer, identifier, xPlayer2.get('phoneNumber'), message)      
        end     
    end     
end)


RegisterServerEvent('chrono:deleteMessage')
AddEventHandler('chrono:deleteMessage', function(msgId)
    deleteMessage(msgId)
end)

RegisterServerEvent('chrono:deleteMessageNumber')
AddEventHandler('chrono:deleteMessageNumber', function(number)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    deleteAllMessageFromPhoneNumber(sourcePlayer,identifier, number)
    -- TriggerClientEvent("chrono:allMessage", sourcePlayer, getMessages(identifier))
end)

RegisterServerEvent('chrono:deleteAllMessage')
AddEventHandler('chrono:deleteAllMessage', function()
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    deleteAllMessage(identifier)
end)

RegisterServerEvent('chrono:setReadMessageNumber')
AddEventHandler('chrono:setReadMessageNumber', function(num)
    local identifier = getPlayerID(source)
    setReadMessageNumber(identifier, num)
end)

RegisterServerEvent('chrono:deleteALL')
AddEventHandler('chrono:deleteALL', function()
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    deleteAllMessage(identifier)
    deleteAllContact(identifier)
    appelsDeleteAllHistorique(identifier)
    TriggerClientEvent("chrono:contactList", sourcePlayer, {})
    TriggerClientEvent("chrono:allMessage", sourcePlayer, {})
    TriggerClientEvent("appelsDeleteAllHistorique", sourcePlayer, {})
end)

--====================================================================================
--  Gestion des appels
--====================================================================================
local AppelsEnCours = {}
local PhoneFixeInfo = {}
local lastIndexCall = 10

function getHistoriqueCall (num)
    local result = MySQL.Sync.fetchAll("SELECT * FROM phone_calls WHERE phone_calls.owner = @num ORDER BY time DESC LIMIT 120", {
        ['@num'] = num
    })
    return result
end

function sendHistoriqueCall (src, num) 
    local histo = getHistoriqueCall(num)
    TriggerClientEvent('chrono:historiqueCall', src, histo)
end

function saveAppels (appelInfo)
    if appelInfo.extraData == nil or appelInfo.extraData.useNumber == nil then
        MySQL.Async.insert("INSERT INTO phone_calls (`owner`, `num`,`incoming`, `accepts`) VALUES(@owner, @num, @incoming, @accepts)", {
            ['@owner'] = appelInfo.transmitter_num,
            ['@num'] = appelInfo.receiver_num,
            ['@incoming'] = 1,
            ['@accepts'] = appelInfo.is_accepts
        }, function()
            notifyNewAppelsHisto(appelInfo.transmitter_src, appelInfo.transmitter_num)
        end)
    end
    if appelInfo.is_valid == true then
        local num = appelInfo.transmitter_num
        if appelInfo.hidden == true then
            mun = "###-####"
        end
        MySQL.Async.insert("INSERT INTO phone_calls (`owner`, `num`,`incoming`, `accepts`) VALUES(@owner, @num, @incoming, @accepts)", {
            ['@owner'] = appelInfo.receiver_num,
            ['@num'] = num,
            ['@incoming'] = 0,
            ['@accepts'] = appelInfo.is_accepts
        }, function()
            if appelInfo.receiver_src ~= nil then
                notifyNewAppelsHisto(appelInfo.receiver_src, appelInfo.receiver_num)
            end
        end)
    end
end

function notifyNewAppelsHisto (src, num) 
    sendHistoriqueCall(src, num)
end

RegisterServerEvent('chrono:getHistoriqueCall')
AddEventHandler('chrono:getHistoriqueCall', function()
    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(source)
    local srcPhone = getNumberPhone(srcIdentifier)
    sendHistoriqueCall(sourcePlayer, num)
end)


RegisterServerEvent('chrono:internal_startCall')
AddEventHandler('chrono:internal_startCall', function(source, phone_number, rtcOffer, extraData)
    if FixePhone[phone_number] ~= nil then
        onCallFixePhone(source, phone_number, rtcOffer, extraData)
        return
    end
    
    local rtcOffer = rtcOffer
    if phone_number == nil or phone_number == '' then 
        print('BAD CALL NUMBER IS NIL')
        return
    end

    local hidden = string.sub(phone_number, 1, 1) == '#'
    if hidden == true then
        phone_number = string.sub(phone_number, 2)
    end

    local indexCall = lastIndexCall
    lastIndexCall = lastIndexCall + 1

    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(source)

    local srcPhone = ''
    if extraData ~= nil and extraData.useNumber ~= nil then
        srcPhone = extraData.useNumber
    else
        srcPhone = getNumberPhone(srcIdentifier)
    end
    local destPlayer = getIdentifierByPhoneNumber(phone_number)
    local is_valid = destPlayer ~= nil and destPlayer ~= srcIdentifier
    AppelsEnCours[indexCall] = {
        id = indexCall,
        transmitter_src = sourcePlayer,
        transmitter_num = srcPhone,
        receiver_src = nil,
        receiver_num = phone_number,
        is_valid = destPlayer ~= nil,
        is_accepts = false,
        hidden = hidden,
        rtcOffer = rtcOffer,
        extraData = extraData
    }
    

    if is_valid == true then
        getSourceFromIdentifier(destPlayer, function (srcTo)
            if srcTo ~= nill then
                AppelsEnCours[indexCall].receiver_src = srcTo
                TriggerEvent('chrono:addCall', AppelsEnCours[indexCall])
                TriggerClientEvent('chrono:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
                TriggerClientEvent('chrono:waitingCall', srcTo, AppelsEnCours[indexCall], false)
            else
                TriggerEvent('chrono:addCall', AppelsEnCours[indexCall])
                TriggerClientEvent('chrono:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
            end
        end)
    else
        TriggerEvent('chrono:addCall', AppelsEnCours[indexCall])
        TriggerClientEvent('chrono:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
    end

end)

RegisterServerEvent('chrono:startCall')
AddEventHandler('chrono:startCall', function(phone_number, rtcOffer, extraData)
    TriggerEvent('chrono:internal_startCall',source, phone_number, rtcOffer, extraData)
end)

RegisterServerEvent('chrono:candidates')
AddEventHandler('chrono:candidates', function (callId, candidates)
    -- print('send cadidate', callId, candidates)
    if AppelsEnCours[callId] ~= nil then
        local source = source
        local to = AppelsEnCours[callId].transmitter_src
        if source == to then 
            to = AppelsEnCours[callId].receiver_src
        end
        -- print('TO', to)
        TriggerClientEvent('chrono:candidates', to, candidates)
    end
end)


RegisterServerEvent('chrono:acceptCall')
AddEventHandler('chrono:acceptCall', function(infoCall, rtcAnswer)
    local id = infoCall.id
    if AppelsEnCours[id] ~= nil then
        if PhoneFixeInfo[id] ~= nil then
            onAcceptFixePhone(source, infoCall, rtcAnswer)
            return
        end
        AppelsEnCours[id].receiver_src = infoCall.receiver_src or AppelsEnCours[id].receiver_src
        if AppelsEnCours[id].transmitter_src ~= nil and AppelsEnCours[id].receiver_src~= nil then
            AppelsEnCours[id].is_accepts = true
            AppelsEnCours[id].rtcAnswer = rtcAnswer
            TriggerClientEvent('chrono:acceptCall', AppelsEnCours[id].transmitter_src, AppelsEnCours[id], true)
            TriggerClientEvent('chrono:acceptCall', AppelsEnCours[id].receiver_src, AppelsEnCours[id], false)
            saveAppels(AppelsEnCours[id])
        end
    end
end)




RegisterServerEvent('chrono:rejectCall')
AddEventHandler('chrono:rejectCall', function (infoCall)
    local id = infoCall.id
    if AppelsEnCours[id] ~= nil then
        if PhoneFixeInfo[id] ~= nil then
            onRejectFixePhone(source, infoCall)
            return
        end
        if AppelsEnCours[id].transmitter_src ~= nil then
            TriggerClientEvent('chrono:rejectCall', AppelsEnCours[id].transmitter_src)
        end
        if AppelsEnCours[id].receiver_src ~= nil then
            TriggerClientEvent('chrono:rejectCall', AppelsEnCours[id].receiver_src)
        end

        if AppelsEnCours[id].is_accepts == false then 
            saveAppels(AppelsEnCours[id])
        end
        TriggerEvent('chrono:removeCall', AppelsEnCours)
        AppelsEnCours[id] = nil
    end
end)

RegisterServerEvent('chrono:appelsDeleteHistorique')
AddEventHandler('chrono:appelsDeleteHistorique', function (numero)
    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(source)
    local srcPhone = getNumberPhone(srcIdentifier)
    MySQL.Sync.execute("DELETE FROM phone_calls WHERE `owner` = @owner AND `num` = @num", {
        ['@owner'] = srcPhone,
        ['@num'] = numero
    })
end)

function appelsDeleteAllHistorique(srcIdentifier)
    local srcPhone = getNumberPhone(srcIdentifier)
    MySQL.Sync.execute("DELETE FROM phone_calls WHERE `owner` = @owner", {
        ['@owner'] = srcPhone
    })
end

RegisterServerEvent('chrono:appelsDeleteAllHistorique')
AddEventHandler('chrono:appelsDeleteAllHistorique', function ()
    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(source)
    appelsDeleteAllHistorique(srcIdentifier)
end)










































--====================================================================================
--  OnLoad
--====================================================================================
AddEventHandler('es:playerLoaded',function(source)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    getOrGeneratePhoneNumber(sourcePlayer, identifier, function (myPhoneNumber)
        TriggerClientEvent("chrono:myPhoneNumber", sourcePlayer, myPhoneNumber)
        TriggerClientEvent("chrono:contactList", sourcePlayer, getContacts(identifier))
        TriggerClientEvent("chrono:allMessage", sourcePlayer, getMessages(identifier))
    end)
end)



  

-- Just For reload
RegisterServerEvent('chrono:allUpdate')
AddEventHandler('chrono:allUpdate', function()
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    local num = getNumberPhone(identifier)
    TriggerClientEvent("chrono:myPhoneNumber", sourcePlayer, num)
    TriggerClientEvent("chrono:contactList", sourcePlayer, getContacts(identifier))
    TriggerClientEvent("chrono:allMessage", sourcePlayer, getMessages(identifier))
    TriggerClientEvent('chrono:getBourse', sourcePlayer, getBourse())
    sendHistoriqueCall(sourcePlayer, num)
end)


AddEventHandler('onMySQLReady', function ()
    -- MySQL.Async.fetchAll("DELETE FROM phone_messages WHERE (DATEDIFF(CURRENT_DATE,time) > 10)")
end)

--====================================================================================
--  App bourse
--====================================================================================
function getBourse()
    --  Format
    --  Array 
    --    Object
    --      -- libelle type String    | Nom
    --      -- price type number      | Prix actuelle
    --      -- difference type number | Evolution 
    -- 
    -- local result = MySQL.Sync.fetchAll("SELECT * FROM `recolt` LEFT JOIN `items` ON items.`id` = recolt.`treated_id` WHERE fluctuation = 1 ORDER BY price DESC",{})
    local result = {
        {
            libelle = 'Google',
            price = 125.2,
            difference =  -12.1
        },
        {
            libelle = 'Microsoft',
            price = 132.2,
            difference = 3.1
        },
        {
            libelle = 'Amazon',
            price = 120,
            difference = 0
        }
    }
    return result
end

--====================================================================================
--  App ... WIP
--====================================================================================


-- SendNUIMessage('onchronoRTC_receive_offer')
-- SendNUIMessage('onchronoRTC_receive_answer')

-- RegisterNUICallback('chronoRTC_send_offer', function (data)


-- end)


-- RegisterNUICallback('chronoRTC_send_answer', function (data)


-- end)



function onCallFixePhone (source, phone_number, rtcOffer, extraData)
    local indexCall = lastIndexCall
    lastIndexCall = lastIndexCall + 1

    local hidden = string.sub(phone_number, 1, 1) == '#'
    if hidden == true then
        phone_number = string.sub(phone_number, 2)
    end
    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(source)

    local srcPhone = ''
    if extraData ~= nil and extraData.useNumber ~= nil then
        srcPhone = extraData.useNumber
    else
        srcPhone = getNumberPhone(srcIdentifier)
    end

    AppelsEnCours[indexCall] = {
        id = indexCall,
        transmitter_src = sourcePlayer,
        transmitter_num = srcPhone,
        receiver_src = nil,
        receiver_num = phone_number,
        is_valid = false,
        is_accepts = false,
        hidden = hidden,
        rtcOffer = rtcOffer,
        extraData = extraData,
        coords = FixePhone[phone_number].coords
    }
    
    PhoneFixeInfo[indexCall] = AppelsEnCours[indexCall]

    TriggerClientEvent('chrono:notifyFixePhoneChange', -1, PhoneFixeInfo)
    TriggerClientEvent('chrono:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
end



function onAcceptFixePhone(source, infoCall, rtcAnswer)
    local id = infoCall.id
    
    AppelsEnCours[id].receiver_src = source
    if AppelsEnCours[id].transmitter_src ~= nil and AppelsEnCours[id].receiver_src~= nil then
        AppelsEnCours[id].is_accepts = true
        AppelsEnCours[id].forceSaveAfter = true
        AppelsEnCours[id].rtcAnswer = rtcAnswer
        PhoneFixeInfo[id] = nil
        TriggerClientEvent('chrono:notifyFixePhoneChange', -1, PhoneFixeInfo)
        TriggerClientEvent('chrono:acceptCall', AppelsEnCours[id].transmitter_src, AppelsEnCours[id], true)
        TriggerClientEvent('chrono:acceptCall', AppelsEnCours[id].receiver_src, AppelsEnCours[id], false)
        saveAppels(AppelsEnCours[id])
    end
end

function onRejectFixePhone(source, infoCall, rtcAnswer)
    local id = infoCall.id
    PhoneFixeInfo[id] = nil
    TriggerClientEvent('chrono:notifyFixePhoneChange', -1, PhoneFixeInfo)
    TriggerClientEvent('chrono:rejectCall', AppelsEnCours[id].transmitter_src)
    if AppelsEnCours[id].is_accepts == false then
        saveAppels(AppelsEnCours[id])
    end
    AppelsEnCours[id] = nil
    
end