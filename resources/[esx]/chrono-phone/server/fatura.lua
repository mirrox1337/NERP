ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function FaturaGetBilling (accountId, cb)
  local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll([===[
      SELECT * FROM billing WHERE identifier = @identifier
      ]===], { ['@identifier'] = xPlayer.identifier }, cb)
  end 

function getUserFatura(phone_number, firstname, cb)
  MySQL.Async.fetchAll("SELECT firstname, phone_number FROM users WHERE users.firstname = @firstname AND users.phone_number = @phone_number", {
    ['@phone_number'] = phone_number,
	['@firstname'] = firstname
  }, function (data)
    cb(data[1])
  end)
end

RegisterServerEvent('chrono:fatura_getBilling')
AddEventHandler('chrono:fatura_getBilling', function(phone_number, firstname)
  local sourcePlayer = tonumber(source)
  if phone_number ~= nil and phone_number ~= "" and firstname ~= nil and firstname ~= "" then
    getUserFatura(phone_number, firstname, function (user)
      local accountId = user and user.id
      FaturaGetBilling(accountId, function (billingg)
        TriggerClientEvent('chrono:fatura_getBilling', sourcePlayer, billingg)
      end)
    end)
  else
    FaturaGetBilling(nil, function (billingg)
      TriggerClientEvent('chrono:fatura_getBilling', sourcePlayer, billingg)
    end)
  end
end)


RegisterServerEvent("chrono:faturapayBill")
AddEventHandler("chrono:faturapayBill", function(id, sender, amount, target)
	local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
	local xTarget = ESX.GetPlayerFromIdentifier(sender)
	
if xTarget ~= nil then	
    if amount ~= nil then
        if xPlayer.getBank() >= amount then	

					MySQL.Async.execute('DELETE from billing WHERE id = @id', {
						['@id'] = id
					}, function(rowsChanged)
						xPlayer.removeAccountMoney('bank', amount)
						xTarget.addAccountMoney('bank', amount)

						TriggerClientEvent("esx:showNotification", src, "Du betalade en faktura på " .. amount .. ":-")
						TriggerClientEvent("esx:showNotification", sender, "Du har inte råd att betala denna fakturan.")
						TriggerClientEvent("esx:showNotification", xTarget.source, "Någon betalade en faktura på " .. amount .. ":-")

					end)
					
				else
					TriggerClientEvent("esx:showNotification", sender, "Du har inte råd att betala denna fakturan.")
					TriggerClientEvent("esx:showNotification", src, "Du betalade en faktura på " .. amount .. ":-")

					
				end

			else
				
				TriggerClientEvent("esx:showNotification", xTarget.source, "Du betalade en faktura på " .. amount .. ":-")
				
			end	
	
    end
	
end)
