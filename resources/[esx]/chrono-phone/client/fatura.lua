RegisterNetEvent("chrono:fatura_getBilling")
AddEventHandler("chrono:fatura_getBilling", function(billingg)
  SendNUIMessage({event = 'fatura_billingg', billingg = billingg})
end)

RegisterNUICallback('fatura_getBilling', function(data, cb)
  TriggerServerEvent('chrono:fatura_getBilling', data.label, data.amount, data.sender)
end)

RegisterNUICallback('faturapayBill', function(data)
  TriggerServerEvent('chrono:faturapayBill', data.id, data.sender, data.amount, data.target)
end)


