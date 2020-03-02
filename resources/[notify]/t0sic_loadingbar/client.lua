loadingbar = function(text, time)
    SendNUIMessage({
        action = 'open',
        label = text,
        time = time
    })
end