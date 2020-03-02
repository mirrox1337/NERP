function TchatGetMessageChannel (channel, cb)
    MySQL.Async.fetchAll("SELECT * FROM phone_app_chat WHERE channel = @channel ORDER BY time DESC LIMIT 100", { 
        ['@channel'] = channel
    }, cb)
end

function TchatAddMessage (channel, message)
  local Query = "INSERT INTO phone_app_chat (`channel`, `message`) VALUES(@channel, @message);"
  local Query2 = 'SELECT * from phone_app_chat WHERE `id` = @id;'
  local Parameters = {
    ['@channel'] = channel,
    ['@message'] = message
  }
  MySQL.Async.insert(Query, Parameters, function (id)
    MySQL.Async.fetchAll(Query2, { ['@id'] = id }, function (reponse)
      TriggerClientEvent('chrono:tchat_receive', -1, reponse[1])
    end)
  end)
end


RegisterServerEvent('chrono:tchat_channel')
AddEventHandler('chrono:tchat_channel', function(channel)
  local sourcePlayer = tonumber(source)
  TchatGetMessageChannel(channel, function (messages)
    TriggerClientEvent('chrono:tchat_channel', sourcePlayer, channel, messages)
  end)
end)

RegisterServerEvent('chrono:tchat_addMessage')
AddEventHandler('chrono:tchat_addMessage', function(channel, message)
  TchatAddMessage(channel, message)
end)