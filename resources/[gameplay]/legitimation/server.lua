local ESX = nil
-- ESX
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Open ID card
RegisterServerEvent('korkort:open')
AddEventHandler('korkort:open', function(ID, targetID)
print()
  local identifier = ESX.GetPlayerFromId(ID).identifier
  local _source = ESX.GetPlayerFromId(targetID).source
  MySQL.Async.fetchAll(
    'SELECT lastdigits FROM users WHERE identifier = @identifier', {['@identifier'] = identifier},
    function (result)
    if (result[1] ~= nil) then
      local lastdigits = result[1].lastdigits
      MySQL.Async.fetchAll(
        'SELECT firstname, lastname, dateofbirth, sex, height FROM characters WHERE lastdigits = @lastdigits', {['@lastdigits'] = lastdigits},
        function (result)
        if (result[1] ~= nil) then
          playerData = {firstname = result[1].firstname, lastname = result[1].lastname, dateofbirth = result[1].dateofbirth, sex = result[1].sex, height = result[1].height, lastdigits = lastdigits}
          TriggerClientEvent('korkort:open', _source, playerData)
        end
      end)
    end
  end)
end)
