local format = string.format
local insert = table.insert

local ESX = nil
local ready = false
local job = nil
local DEBUG = GetConvarIntAsBool('DebugBilcenter')
local actionPending = nil
local inMenu = nil
local thisResource = GetCurrentResourceName()
local ZERO = vector3(0,0,0)
local enableInteriors = GetConvarIntAsBool('BilcenterInterior')
local Interiors = {
    {
        name = 'shr_int',
        active = false,
        loadDistance = 100,
        unloadDistance = 125,
        center = vector3(-40.618, -1099.558, 26.422),
        entitySets = {
            csr_beforeMission = true,
            -- shutter_open = true,
        },
    },
}
local camera = nil
local displayedVehicle = nil
local displayedVehicleMutex = Mutex:new()

local TestDriveDecorName = 'NERP_TESTDRIVE'
DecorRegister(TestDriveDecorName, 3) -- Integer, hash of dealership name

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    debuglog('esx:playerLoaded with job',xPlayer.job.name,xPlayer.job.grade)
    job = xPlayer.job
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob',function(ESXJob)
    debuglog('esx:setJob with job',ESXJob.name,ESXJob.grade)
    job = ESXJob
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == thisResource then
        resetDealershipState(false, true)
        BusyspinnerOff()
        if IsScreenFadedOut() then
            DoScreenFadeIn(100)
        end
    end
end)

RegisterNetEvent('nerp_bilcenter:delete_vehicle')
AddEventHandler ('nerp_bilcenter:delete_vehicle', function(netID)
    if NetworkDoesEntityExistWithNetworkId(netID) then
        local entity = NetworkGetEntityFromNetworkId(netID)
        if NetworkHasControlOfEntity(entity) then
            if IsEntityAVehicle(entity) then
                SetEntityAsMissionEntity(entity, true, true)
                DeleteEntity(entity)
                SetTimeout(100,function()
                    if DoesEntityExist(entity) and IsEntityAVehicle(entity) then
                        fuckup('Networked vehicle delete malfunction!', netID, 'did not go away!')
                    end
                end)
            else
                fuckup('Networked vehicle delete malfunction!', netID, 'is not a vehicle!')
            end
        end
    end
end)

RegisterNetEvent('nerp_bilcenter:vehicle_killorder')
AddEventHandler ('nerp_bilcenter:vehicle_killorder', function(plate, model)
    local hash = GetHashKey(model)
    while string.len(plate) < 8 do
        plate = plate .. ' '
    end

    debuglog('Killorder: "'..plate..'"', model, hash)
    
    local iterator, vehicle = FindFirstVehicle()
    local candidatePlate = GetVehicleNumberPlateText(vehicle)
    local thisModel = GetEntityModel(vehicle)
    local continue = true

    if candidatePlate == plate and thisModel == hash then
        continue = false
    end

    while continue do
        continue, vehicle = FindNextVehicle(iterator)
        candidatePlate = GetVehicleNumberPlateText(vehicle)
        thisModel = GetEntityModel(vehicle)
        if candidatePlate == plate and thisModel == hash then
            continue = false
        end
    end

    EndFindVehicle(iterator)

    if thisModel == hash and candidatePlate == plate then -- That is, if the iterator actually found it!
        if NetworkHasControlOfEntity(vehicle) then -- If it's not ours, we don't care!
            debuglog('Removed',plate)
            SetEntityAsMissionEntity(vehicle, true, true)
            DeleteEntity(vehicle)
        end
    end

end)

RegisterNetEvent('nerp_bilcenter:testdrive_release')
AddEventHandler ('nerp_bilcenter:testdrive_release', function(netID, dealershipHash)
    if NetworkDoesEntityExistWithNetworkId(netID) and NetworkHasControlOfNetworkId(netID) then
        local entity = NetworkGetEntityFromNetworkId(netID)
        if IsEntityAVehicle(entity) then
            SetVehicleDoorsLocked(entity, 0)
            DecorSetInt(entity, TestDriveDecorName, dealershipHash)
            debuglog('Released for test drive:', netID)
        else
            fuckup('Got told to release', netID,'for testdrive, but that is not a vehicle!')
        end
    else
        fuckup('Got told to release', netID, 'for testdrive, but I am not in control of any such entity!')
    end
end)

RegisterNetEvent('nerp_bilcenter:registered_release')
AddEventHandler ('nerp_bilcenter:registered_release', function(netID)
    if NetworkDoesEntityExistWithNetworkId(netID) and NetworkHasControlOfNetworkId(netID) then
        local entity = NetworkGetEntityFromNetworkId(netID)
        if IsEntityAVehicle(entity) then
            SetVehicleDoorsLocked(entity, 0)
            debuglog('Released after registration:', netID)
        else
            fuckup('Got told to release', netID,'after registration, but that is not a vehicle!')
        end
    else
        fuckup('Got told to release', netID, 'after registration, but I am not in control of any such entity!')
    end        
end)

RegisterNetEvent('nerp_bilcenter:error')
AddEventHandler ('nerp_bilcenter:error',function(message)
    if BusyspinnerIsOn() then
        BusyspinnerOff()
    end
    log('Error:',message)
    -- TriggerEvent('chat:addMessage', {args={'NERP Bilcenter', message}, color={255,0,0}})
    makeToast(_('toast_error'), message)
    resetDealershipState()
end)

RegisterNetEvent('nerp_bilcenter:success')
AddEventHandler ('nerp_bilcenter:success', function(message)
    if BusyspinnerIsOn() then
        BusyspinnerOff()
    end
    log('Success:',message)
    makeToast(_('toast_success'), message)
end)

RegisterNetEvent('nerp_bilcenter:open_order_menu')
AddEventHandler ('nerp_bilcenter:open_order_menu', function(job, locationName, actionNumber, vehicleList)
    if actionPending then
        if BusyspinnerIsOn() then
            BusyspinnerOff()
        end
        inMenu = actionPending
        actionPending = nil
        ESX.UI.Menu.CloseAll() -- Kill conflicting menus
        
        local menuData = bakeOrderableVehicleList(vehicleList)
        showOrderMenu(menuData, vehicleList, job, locationName)
        
        local camData = safeLookup(Config, 'Locations', job, locationName, 'Points', 'Cam')
        if camData then
            setCamera(camData.Location, camData.Rotation)
        else
            fuckup('The camera location for', job, 'at', locationName, 'is broken!')
        end
        
        local initialVehicle = vehicleList[menuData[1].name][1]
        debuglog('Initial vehicle:', initialVehicle.model)
        local spawnData = safeLookup(Config, 'Locations', job, locationName, 'Points', 'Spawn')
        if spawnData then
            SetTimeout(Config.FadeTime, function()
                setDisplayedVehicle(spawnData, initialVehicle, false)
            end)
        else
            fuckup('The spawn location for', job, 'at', locationName, 'is broken!')
        end
    end
end)

RegisterNetEvent('nerp_bilcenter:open_sales_menu')
AddEventHandler ('nerp_bilcenter:open_sales_menu', function(job, locationName, actionNumber, vehicleList)
    if actionPending then
        if BusyspinnerIsOn() then
            BusyspinnerOff()
        end
        inMenu = actionPending
        actionPending = nil
        ESX.UI.Menu.CloseAll()

        local menuData = bakeSalesVehicleList(vehicleList)
        showSalesMenu(menuData, vehicleList, job, locationName)
    end
end)

RegisterNetEvent('nerp_bilcenter:open_boss_menu')
AddEventHandler ('nerp_bilcenter:open_boss_menu', function(job, money, jobGrades, employeeList, employeeCount)
    if actionPending then
        if BusyspinnerIsOn() then
            BusyspinnerOff()
        end
        inMenu = actionPending
        actionPending = nil
        ESX.UI.Menu.CloseAll()
        local menuData = bakeBossMenu(job, employeeCount, money, employeeList)
        showBossMenu(menuData, job, employeeList, jobGrades)
    end
end)

function bakeBossMenu(job, employeeCount, money, employeeList)
    local menuData = {}
    local alreadyHired = nil

    local closestPlayer = findClosestPlayer(nil, 5.0, DEBUG)

    if closestPlayer then
        for name,data in pairs(employeeList) do
            if name == closestPlayer.name then -- WTF happens when two people have the same damn name on Steam?!
                alreadyHired = closestPlayer.name
                debuglog(alreadyHired, 'is already hired')
                break
            end
        end
    end

    if alreadyHired then
        insert(menuData, {
            label = _('already_hired', alreadyHired),
            value = { action = 'nobody' },
            type = 'item_standard',
        })
    elseif closestPlayer then
        insert(menuData, {
            label = _('hire_player', closestPlayer.name),
            value = { action = 'hire', job = job, player = closestPlayer },
            type = 'item_standard',
        })
    else
        insert(menuData, {
            label = _('hire_no_player'),
            value = { action = 'nobody' },
            type = 'item_standard',
        })
    end

    insert(menuData, {
        label = _('handle_emplyees', employeeCount),
        value = { action = 'manage_employees'},
        type = 'item_standard',
    })

    insert(menuData, {
        label = _('handle_money', ESX.Math.GroupDigits(money)),
        value = {action = 'manage_money', money = money, job = job },
        type = 'item_standard',
    })

    return menuData
end

function showBossMenu(menuData, job, employeeList, jobGrades)
    ESX.UI.Menu.Open(
        'default',
        GetCurrentResourceName(),
        'nerp_bilcenter_boss',
        {
            title = _('boss_menu', _(job)),
            align = 'top-left',
            elements = menuData,
        },
        function(selection, menu) -- Confirm
            if type(selection.current.value) == 'table' then
                local data = selection.current.value

                if data.action == 'nobody' then
                    -- Nuffin'
                elseif data.action == 'hire' then

                    getConfirmation(_('confirm_hire', data.player.name, _(job)), function(confirmed)
                        if confirmed then
                            TriggerServerEvent('nerp_bilcenter:hire', data.job, data.player.serverID)
                            resetDealershipState()
                            BeginTextCommandBusyspinnerOn(resourcePrefix('awaiting_server'))
                            EndTextCommandBusyspinnerOn(0)
                        end
                    end)

                elseif data.action == 'manage_employees' then

                    local employeeMenu = bakeEmployeeMenu(job, employeeList, jobGrades)
                    showEmployeeMenu(employeeMenu, jobGrades)

                elseif data.action == 'manage_money' then

                    local moneyMenu = bakeFinancialMenu(data.job, data.money)
                    showFinancialMenu(moneyMenu, data.money)

                end
            end
        end,
        function(selection, menu) -- Cancel
            menu.close()
            resetDealershipState()
        end
    )
end

function bakeFinancialMenu(job, money)
    local menuData = {}
    insert(menuData, {
        label = _('deposit_money'),
        value = {action = 'deposit', job = job},
        type = 'item_standard',
    })
    insert(menuData, {
        label = _('withdraw_money'),
        value = {action = 'withdraw', job = job},
        type = 'item_standard',
    })
    return menuData
end

function showFinancialMenu(menuData, money)
    ESX.UI.Menu.Open(
        'default',
        GetCurrentResourceName(),
        'nerp_bilcenter_financial',
        {
            title = _('transfer_money'),
            align = 'top-left',
            elements = menuData,
        },
        function(selected, menu)  -- CÖNFÖÖÖRM!!!
            local data = selected.current.value
            if data.action == 'deposit' then
                getAmount(_('deposit_amount', _(data.job)), function(amount)
                    if amount then
                        TriggerServerEvent('nerp_bilcenter:financial_transaction', 'deposit', data.job, amount)
                        resetDealershipState()
                        BeginTextCommandBusyspinnerOn(resourcePrefix('awaiting_server'))
                        EndTextCommandBusyspinnerOn(0)
                    end
                end)
            elseif data.action == 'withdraw' then
                getAmount(_('withdraw_amount', _(data.job)), function(amount)
                    if amount then
                        TriggerServerEvent('nerp_bilcenter:financial_transaction', 'withdraw', data.job, amount)
                        resetDealershipState()
                        BeginTextCommandBusyspinnerOn(resourcePrefix('awaiting_server'))
                        EndTextCommandBusyspinnerOn(0)
                    end
                end)
            end
        end,
        function(selected, menu) -- KÄNZEL
            menu.close()
        end
    )
end

function bakeEmployeeMenu(job, employeeList, jobGrades)
    local menuData = {}
    for name, data in pairs(employeeList) do
        insert(menuData, {
            label = _('employee_listing', name, jobGrades[data.job_grade].label),
            value = { name = name, data = data, job = job },
            type = 'item_standard',
        })
    end
    table.sort(menuData, function(a,b)
        return a.value.name < b.value.name
    end)
    return menuData
end

function showEmployeeMenu(menuData, jobGrades)
    ESX.UI.Menu.Open(
        'default',
        GetCurrentResourceName(),
        'nerp_bilcenter_employees',
        {
            title = _('employee_menu'),
            align = 'top-left',
            elements = menuData,
        },
        function (selected, menu) -- Selected
            local value = selected.current.value
            local menuData = bakeChangeRankMenu(value, jobGrades)
            showRankChangeMenu(menuData, value.name)
        end,
        function (selected, menu) -- Cancelled
            menu.close()
        end
    )
end

function bakeChangeRankMenu(current, jobGrades)
    local menuData = {}

    for grade, data in pairs(jobGrades) do
        if current.data.job_grade == grade then
            insert(menuData, {
                label = _('grade_current', grade, data.label, ESX.Math.GroupDigits(data.salary)),
                value = { grade = grade, job = current.job, identifier = current.data.identifier },
                type = 'item_standard',
            })
        else
            insert(menuData, {
                label = _('grade', grade, data.label, ESX.Math.GroupDigits(data.salary)),
                value = { grade = grade, job = current.job, identifier = current.data.identifier },
                type = 'item_standard',
            })
        end
    end
    table.sort(menuData, function(a,b)
        return a.value.grade < b.value.grade
    end)
    insert(menuData, {
        label = _('fire_employee'),
        value = { grade = -1, job = current.job, identifier = current.data.identifier },
        type = 'item_standard',
    })
    return menuData
end

function showRankChangeMenu(menuData, name)
    ESX.UI.Menu.Open(
        'default',
        GetCurrentResourceName(),
        'nerp_bilcenter_change_rank',
        {
            title = _('set_rank', name),
            align = 'top-left',
            elements = menuData,
        },
        function (selected, menu) -- Selected
            local data = selected.current.value
            if data.grade >= 0 then
                TriggerServerEvent('nerp_bilcenter:set_rank',name, data.identifier, data.job, data.grade)
                resetDealershipState()
                BeginTextCommandBusyspinnerOn(resourcePrefix('awaiting_server'))
                EndTextCommandBusyspinnerOn(0)
            else
                getConfirmation(_('confirm_fire', name), function(confirmed)
                    if confirmed then
                        TriggerServerEvent('nerp_bilcenter:fire', name, data.identifier, data.job)
                        resetDealershipState()
                        BeginTextCommandBusyspinnerOn(resourcePrefix('awaiting_server'))
                        EndTextCommandBusyspinnerOn(0)
                    end
                end)
            end
        end,
        function (selected, menu) -- Cancelled
            menu.close()
        end
    )
end

function findClosestPlayer(point, maxDistance, fallbackSelf)

    local found = false

    local myself = PlayerPedId()
    point = point or GetEntityCoords(myself)

    maxDistance = maxDistance or 10.0
    local closestDistance = maxDistance
    local closestLocation = nil
    local closestPlayer = nil
    local closestPed = nil

    for i, clientID in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(clientID)
        if ped ~= myself then
            local location = GetEntityCoords(ped)
            local distance = #( point - location )
            if not closestDistance or distance <= closestDistance then
                found = true
                closestDistance = distance
                closestPed = ped
                closestLocation = {
                    x = location.x,
                    y = location.y,
                    z = location.z,
                }
                closestPlayer = clientID
            end
        end
    end

    if found then
        return {
            distance = closestDistance,
            ped = closestPed,
            clientID = closestPlayer,
            location = closestLocation,
            serverID = GetPlayerServerId(closestPlayer),
            name = GetPlayerName(closestPlayer),
        }
    elseif fallbackSelf then
        local selfLocation = GetEntityCoords(myself)
        local selfDistance = #( point - selfLocation)
        local selfPlayer = PlayerId()
        return {
            distance = selfDistance,
            ped = myself,
            clientID = selfPlayer,
            location = {
                selfLocation.x,
                selfLocation.y,
                selfLocation.z,
            },
            serverID = GetPlayerServerId(selfPlayer),
            name = GetPlayerName(selfPlayer),
        }
    end
end

function bakeSalesVehicleList(vehicleList)
    local menuData = {}
    
    local closestPlayer = findClosestPlayer(nil, 5.0, DEBUG)
    if closestPlayer then
        insert(menuData, {
            label = _('invoice_player', closestPlayer.name),
            value = { action = 'invoice', player = closestPlayer },
            type = 'item_standard',
        })
    else
        insert(menuData, {
            label = _('invoice_no_player'),
            value = { action = 'nobody' },
            type = 'item_standard',
        })
    end

    for index, vehicleData in ipairs(vehicleList) do
        local hash = GetHashKey(vehicleData.model)
        if IsModelValid(hash) then
            vehicleData.hash = hash
            insert(menuData, {
                label = _('sales_item', vehicleData.label, vehicleData.plate, ESX.Math.GroupDigits(vehicleData.price)),
                value = { action = 'vehicle', vehicle = index, player = closestPlayer },
                type = 'item_standard',
            })
            vehicleData.vehicle = json.decode(vehicleData.vehicle)
        else
            fuckup(vehicleData.label, vehicleData.plate, 'is for sale, but has invalid model', vehicleData.model)
        end
    end
    return menuData
end

function getAmount(title, callback)
    ESX.UI.Menu.Open(
        'dialog',
        GetCurrentResourceName(),
        'nerp_bilcenter_get_amount',
        {
            title = title
        },
        function(data, menu) -- OK
            if string.match(data.value, "^%d+$") then
                local amount = tonumber(data.value)
                callback(amount)
            else
                callback()
            end
            menu.close()
        end,
        function(data, menu) -- Cancel
            callback()
            menu.close()
        end
    )
end

function showSalesMenu(menuData, vehicleList, job, locationName)
    ESX.UI.Menu.Open(
        'default',
        GetCurrentResourceName(),
        'nerp_bilcenter_sales',
        {
            title = _('sell_vehicle'),
            align = 'top-left',
            elements = menuData,
        },
        function(selection, menu) -- Confirm item
            if type(selection.current.value) == 'table' then
                local data = selection.current.value
                if data.action == 'vehicle' then
                    if vehicleList[data.vehicle] then
                        local thisVehicle = vehicleList[data.vehicle]
                        local vehicleMenuData = bakeSalesSpecificVehicleData(thisVehicle, data.player)
                        showSalesSpecificVehicleMenu(vehicleMenuData, thisVehicle, job, locationName)
                    else
                        fuckup('Sales menu fuckup:  Invalid vehicle', data.vehicle)
                    end
                elseif data.action == 'invoice' then

                    if data.player then
                        getAmount(_('invoice_player', data.player.name), function(amount)
                            if amount and amount > 0 then
                                TriggerServerEvent('esx_billing:sendBill', data.player.serverID, 'society_'..job, _(job), amount)
                                TriggerServerEvent('nerp_bilcenter:log_invoice', data.player.serverID, job, amount)
                            else
                                debuglog('Invalid invoice amount entered and rejected')
                            end
                        end)
                    else
                        fuckup('Offering invoice menu item without a valid player!')
                    end

                elseif data.action == 'nobody' then
                    -- Do nothing
                else
                    fuckup('Unknown action', data.action,'in sales menu?!')
                end
            else
                fuckup('Sales menu is completely broken?!')
            end
        end,
        function(selection, menu) -- Cancel
            resetDealershipState()
        end,
        function(selection, topLevelMenu) -- Change selection
            -- NOOP this? Deployment is handled in submenu
        end
    )
end

function bakeSalesSpecificVehicleData(thisVehicle, player)
    local menuData = {}

    if thisVehicle.stored then
        insert(menuData, {
            label = _('test_drive'),
            value = {action = 'testdrive'},
            type = 'item_standard',
        })
        if player then
            insert(menuData, {
                label = _('assign_vehicle', thisVehicle.plate, player.name),
                value = {action = 'assign', player = player, vehicle = thisVehicle},
                type = 'item_standard',
            })
        else
            insert(menuData, {
                label = _('assign_no_player'),
                value = {action = 'noop'},
                type = 'item_standard',
            })
        end
        insert(menuData, {
            label = _('return_to_manufacturer'),
            value = {action = 'return', vehicle = thisVehicle },
            type = 'item_standard',
        })
    else
        local insuranceCost = math.floor( Config.InsuranceCostMultiplier * thisVehicle.price )
        insert(menuData, {
            label = _('insurance_claim', ESX.Math.GroupDigits(insuranceCost)),
            value = {action = 'insurance', model = thisVehicle.model, plate = thisVehicle.plate, cost = insuranceCost},
            type = 'item_standard',
        })
    end
    return menuData
end

function showSalesSpecificVehicleMenu(menuData, vehicleData, job, locationName)
    if vehicleData.stored then
        
        local spawnLocation = safeLookup(Config, 'Locations', job, locationName, 'Points', 'Spawn')

        if spawnLocation and setDisplayedVehicle(spawnLocation, vehicleData, true) then
            ESX.Game.SetVehicleProperties(displayedVehicle, vehicleData.vehicle)
            SetVehicleDirtLevel(displayedVehicle, 0.0)
            SetVehicleDoorsLocked(displayedVehicle, 2)
            local camData = safeLookup(Config, 'Locations', job, locationName, 'Points', 'Cam')
            if camData then
                setCamera(camData.Location, camData.Rotation)
            else
                fuckup('The camera location for', job, 'at', locationName, 'is broken!')
            end

        else
            debuglog('Failed to set displayed vehicle! Probably another vehicle in the way.')
        end

    end

    ESX.UI.Menu.Open(
        'default',
        GetCurrentResourceName(),
        'nerp_bilcenter_sales_details',
        {
            title = _('sales_item', vehicleData.label, vehicleData.plate, ESX.Math.GroupDigits(vehicleData.price)),
            align = 'top-left',
            elements = menuData,
        },
        function(selection, menu) -- Confirm item
            
            if type(selection.current.value) == 'table' then
                local data = selection.current.value
                if data.action == 'noop' then
                    -- Do nothing, obviously
                elseif data.action == 'testdrive' then

                    if not displayedVehicle then
                        makeToast(_('toast_error'),_('error_no_vehicle'))
                    else

                        getConfirmation(_('confirm_testdrive', vehicleData.plate), function(confirmed)
                            if confirmed then
                                local netID = NetworkGetNetworkIdFromEntity(displayedVehicle)
                                local owner = GetPlayerServerId(NetworkGetEntityOwner(displayedVehicle))
                                TriggerServerEvent('nerp_bilcenter:testdrive_start', job, vehicleData.plate, vehicleData.model, netID, owner)
                                resetDealershipState(true)
                            end
                        end)

                    end

                elseif data.action == 'assign' then

                    if not displayedVehicle then
                        makeToast(_('toast_error'),_('error_no_vehicle'))
                    else
                        getConfirmation(
                            _('confirm_registration', data.vehicle.label, data.vehicle.plate, data.player.name),
                            function(confirmed)
                                if confirmed then
                                    BeginTextCommandBusyspinnerOn(resourcePrefix('awaiting_server'))
                                    EndTextCommandBusyspinnerOn(0)
                                    local netID = NetworkGetNetworkIdFromEntity(displayedVehicle)
                                    local owner = GetPlayerServerId(NetworkGetEntityOwner(displayedVehicle))
                                    TriggerServerEvent('nerp_bilcenter:register_vehicle', data.player.serverID, data.vehicle.plate, data.vehicle.model, netID, owner)
                                    resetDealershipState(true)
                                end
                            end
                        )
                    end

                elseif data.action == 'return' then

                    getConfirmation(
                        _('confirm_return', data.vehicle.label, ESX.Math.GroupDigits(data.vehicle.price)),
                        function(confirmed)
                            if confirmed then
                                BeginTextCommandBusyspinnerOn(resourcePrefix('awaiting_server'))
                                EndTextCommandBusyspinnerOn(0)
                                local netID = NetworkGetNetworkIdFromEntity(displayedVehicle)
                                local owner = GetPlayerServerId(NetworkGetEntityOwner(displayedVehicle))
                                TriggerServerEvent('nerp_bilcenter:return_vehicle', data.vehicle.plate, data.vehicle.model)
                                resetDealershipState()
                            end
                        end
                    )

                elseif data.action == 'insurance' then

                    getConfirmation(_('confirm_insurance', ESX.Math.GroupDigits(data.cost), data.plate), function(confirmed)
                        if confirmed then
                            TriggerServerEvent('nerp_bilcenter:insurance_claim', job, data.plate, data.model, data.cost)
                            resetDealershipState()
                        end
                    end)

                else
                    fuckup('Unknown menu action in sales menu:', data.action)
                end
            end
        end,
        function(selection, menu) -- Cancel
            menu.close()
            releaseCamera()
            NetworkFadeOutEntity(displayedVehicle)
            Citizen.Wait(500)
            removeDisplayedVehicle()
        end
    )
end

function bakeOrderableVehicleList(vehicleList)
    local menuData = {}
    for category, vehicles in pairs(vehicleList) do
        local vehicleOptions = {}
        for i, vehicle in ipairs(vehicles) do
            local hash = GetHashKey(vehicle.model)
            if IsModelValid(hash) then
                vehicle.hash = hash
                insert(vehicleOptions, _('order_item', vehicle.name, ESX.Math.GroupDigits(vehicle.price)))
            else
                fuckup(category,vehicle.name,'('..vehicle.model..') does not have a valid model!')
            end
        end
        insert(menuData, {
            name = category,
            label = category,
            value = 0,
            type = 'slider',
            options = vehicleOptions,
        })
    end

    table.sort(menuData, function(a,b)
        return a.name < b.name
    end)
    
    return menuData
end

function showOrderMenu(menuData, vehicleList, job, locationName)
    ESX.UI.Menu.Open(
        'default', -- Menu type
        GetCurrentResourceName(), -- Return-to resource
        'nerp_bilcenter_order', -- "Namespace"
        { -- Description
            title = _('order_vehicle'),
            align = 'top-left',
            elements = menuData,
        },
        function(selection, topLevelMenu) -- Confirm
            local selectedVehicle = vehicleList[selection.current.name][selection.current.value + 1]
            getConfirmation(
                _('confirm_order', selectedVehicle.name, ESX.Math.GroupDigits(selectedVehicle.price)),
                function(confirmed)
                    if confirmed then
                        local vehicleProps = ESX.Game.GetVehicleProperties(displayedVehicle)
                        resetDealershipState()
                        BeginTextCommandBusyspinnerOn(resourcePrefix('awaiting_server'))
                        EndTextCommandBusyspinnerOn(0)
                        TriggerServerEvent('nerp_bilcenter:purchase_new_vehicle', job, locationName, selectedVehicle.model, vehicleProps)
                    end
                end
            )
        end,
        function(selection, topLevelMenu) -- Cancel
            resetDealershipState()
        end,
        function(selection, topLevelMenu) -- Change selecion
            local selectedVehicle = vehicleList[selection.current.name][selection.current.value + 1]
            local spawnLocation = safeLookup(Config, 'Locations', job, locationName, 'Points', 'Spawn')
            if spawnLocation then
                setDisplayedVehicle(spawnLocation, selectedVehicle, false)
            else
                fuckup('The spawn location for', job, 'at', locationName, 'is broken!')
            end
        end
    )
end

function deployBlips()
    if Config.Blips then
        for i, data in ipairs(Config.Blips) do
            if data.Active then
                local blip = AddBlipForCoord(data.Location)
                SetBlipAsShortRange(blip, true)

                SetBlipSprite  (blip, data.Sprite)
                SetBlipColour  (blip, data.Color)
                SetBlipScale   (blip, data.Scale)
            
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(_(data.String))
                EndTextCommandSetBlipName(blip)
            end
        end
    end
end

function getCamera()
    if camera then
        if DoesCamExist(camera) then
            return camera
        end
    end

    camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
    return camera
end

function setCamera(location, rotation)
    local cam = getCamera()
    SetCamCoord(cam, location)
    SetCamRot(cam, rotation, 2)
    SetFocusPosAndVel(location, ZERO)
    if not IsCamActive(cam) then
        DoScreenFadeOut(Config.FadeTime)
        SetTimeout(Config.FadeTime, function()
            SetCamActive(cam, true)
            RenderScriptCams(true, false, 0, false, false, false)
            DoScreenFadeIn(Config.FadeTime)
        end)
    end
    return cam
end

function releaseCamera(isStopping)
    local cam = getCamera()
    if IsCamActive(cam) then
        if isStopping then
            ClearFocus()
            SetCamActive(cam, false)
            RenderScriptCams(false, false, 0, false, false, false)
        else
            DoScreenFadeOut(Config.FadeTime)
            SetTimeout(Config.FadeTime, function()
                ClearFocus()
                SetCamActive(cam, false)
                RenderScriptCams(false, false, 0, false, false, false)
                DoScreenFadeIn(Config.FadeTime)
            end)
        end
    end
end

function removeDisplayedVehicle()
    if displayedVehicle then
        if DoesEntityExist(displayedVehicle) and IsEntityAVehicle(displayedVehicle) then
            if NetworkGetEntityIsNetworked(displayedVehicle) then
                local owner = NetworkGetEntityOwner(displayedVehicle)
                if owner ~= PlayerId() then
                    local serverOwner = GetPlayerServerId(owner)
                    TriggerServerEvent('nerp_bilcenter:request_vehicle_delete', serverOwner, NetworkGetNetworkIdFromEntity(displayedVehicle))
                    return true
                end
            end

            DeleteEntity(displayedVehicle)
            displayedVehicle = nil

        else
            debuglog(displayedVehicle, 'not found')
            displayedVehicle = nil
        end
    end
    return false
end

function syncLoadModel(hash, timeout)
    
    if not HasModelLoaded(hash) then
        timeout = timeout or 5000
        local begin = GetGameTimer()
        RequestModel(hash)
        while not HasModelLoaded(hash) and GetGameTimer() < begin + timeout do
            Citizen.Wait(0)
        end
    end

    if HasModelLoaded(hash) then
        return true
    end

    fuckup('Timed out loading model', hash)
    return false

end

function setDisplayedVehicle(location, vehicleData, networked)
    
    displayedVehicleMutex:await()

    if displayedVehicle and DoesEntityExist(displayedVehicle) then
        local dispatched = removeDisplayedVehicle()
        if dispatched then
            Citizen.Wait(1000)
            displayedVehicle = nil
        end
    end

    if networked then
        if IsAnyVehicleNearPoint(location.Location, 5.0) then
            displayedVehicleMutex:release()
            return false
        end
    end

    if not syncLoadModel(vehicleData.hash) then
        displayedVehicleMutex:release()
        return
    end

    local vehicle = CreateVehicle(
        vehicleData.hash,
        location.Location,
        location.Rotation.z,
        networked,
        false
    )

    SetModelAsNoLongerNeeded(vehicleData.hash)

    if DoesEntityExist(vehicle) then
        SetEntityRotation(vehicle, location.Rotation, 2, true)
        SetVehicleDoorsLocked(vehicle, 2)
        SetVehicleOnGroundProperly(vehicle)
        SetVehicleHasBeenOwnedByPlayer(vehicle, true)
        SetVehicleDirtLevel(vehicle, 0.0)
        if not networked then
            FreezeEntityPosition(vehicle, true)
            SetEntityCollision(vehicle, false, false)
            SetVehicleNumberPlateText(vehicle,'')
        else
            NetworkFadeInEntity(vehicle)
        end
        displayedVehicle = vehicle
        displayedVehicleMutex:release()
        return true
    else
        fuckup('Failed to spawn display vehicle', vehicleData.model)
    end
    
    displayedVehicleMutex:release()
end

function disableControlsExcept(...)
    for group=0, 31 do
        DisableAllControlActions(group)
    end
    for i,control in ipairs({...}) do
        EnableControlAction(0, control, true)
    end
end

function lockControlsToMenu()
    disableControlsExcept(
        18,  -- ESX Menu ENTER
        177, -- ESX Menu BACKSPACE
        27,  -- ESX Menu TOP [...WTF ESX?]
        173, -- ESX Menu DOWN
        174, -- ESX Menu LEFT
        175, -- ESX Menu RIGHT
        200, -- INPUT_FRONTEND_PAUSE_ALTERNATE, usually bound to Esc, so the pause menu can still be accessed
        245, -- INPUT_MP_TEXT_CHAT_ALL, usually T, so commands can be issued
        249  -- INPUT_PUSH_TO_TALK, usually N, so voice chat keeps working
    )
end

function debugText(where, what)
    if DEBUG then
        SetDrawOrigin(where)
        BeginTextCommandDisplayText('STRING')
        SetTextCentre(true)
        SetTextOutline()
        SetTextColour(255, 0, 0, 128)
        AddTextComponentSubstringPlayerName(tostring(what))
        EndTextCommandDisplayText(0.0, 0.0)
        ClearDrawOrigin()
    end
end

function getConfirmation(question, callback)
    if not confirmCounter then
        confirmCounter = 0
    else
        confirmCounter = confirmCounter + 1
    end
    debuglog('Seeing confirmation:', question)
    ESX.UI.Menu.Open(
        'default',
        GetCurrentResourceName(),
        'nerp_bilcenter_confirm_'..confirmCounter,
        {
            title = question,
            align = 'top-left',
            elements = {
                {label = _('confirm_no'),  value = 'no'},
                {label = _('confirm_yes'), value = 'yes'},
            },
        },
        function (selection, menu)
            menu.close()
            if selection.current.value == 'yes' then
                callback(true)
            else
                callback(false)
            end
        end,
        function (selection, menu)
            menu.close()
            callback(false)
        end
    )
end

function resetDealershipState(keepVehicle, stopping)
    if inMenu then
        ESX.UI.Menu.CloseAll()
    end
    inMenu = nil
    actionPending = nil
    releaseCamera(stopping)
    if not keepVehicle then
        if stopping then
            removeDisplayedVehicle()
        else
            SetTimeout(Config.FadeTime, function()
                removeDisplayedVehicle()
            end)
        end
    else
        displayedVehicle = nil
    end
end

function handleActions(playerPed, camCoord, locations, job, grade)
    
    local pedLocation = GetEntityCoords(playerPed)

    if inMenu then

        lockControlsToMenu()

        if #(pedLocation - inMenu.Location) > inMenu.Range or IsControlJustPressed(0, 200) then
            -- Out of iteract range (pushed?) or INPUT_FRONTEND_PAUSE_ALTERNATE (Esc) was pressed
            resetDealershipState()
        end

    elseif actionPending then
        marker(actionPending)
        if #(pedLocation - actionPending.Location) <= actionPending.Range then
            if not BusyspinnerIsOn() then
                BeginTextCommandBusyspinnerOn(resourcePrefix('awaiting_server'))
                EndTextCommandBusyspinnerOn(0)
            end
        else
            resetDealershipState()
        end
    else
        for name, data in pairs(locations) do
            if #(pedLocation - data.Center) <= data.Size then
                for actionNumber, action in ipairs(data.Actions) do
                    if (grade >= action.MinGrade) then
                        marker(action)
                        local pedDistance = #( action.Location - pedLocation)
                        if not inMenu and not actionPending and pedDistance <= action.Range and not BusyspinnerIsOn() then
                            BeginTextCommandDisplayHelp(resourcePrefix(action.Prompt))
                            EndTextCommandDisplayHelp(0, false, false, 0)
                            if IsControlJustPressed(0, 51) then
                                actionPending = action
                                TriggerServerEvent(action.Event, job, name, actionNumber, action.EventData)
                            end
                        end
                    end
                end
            end -- LOL, I know, I know
        end
    end
end

function handleMLO(coord)
    for i, MLO in ipairs(Interiors) do
        local distance = #(MLO.center - coord)
        if MLO.active then
            if distance > MLO.unloadDistance then
                if IsIplActive(MLO.name) then
                    RemoveIpl(MLO.name)
                    debuglog('Removing', MLO.name)
                end
                MLO.active = false
            end
        else
            if distance < MLO.loadDistance then

                if not IsIplActive(MLO.name) then
                    debuglog('Requesting IPL', MLO.name)
                    RequestIpl(MLO.name)
                end
                if MLO.entitySets then
                    local interior = GetInteriorAtCoords(MLO.center)
                    local boink = false
                    for entitySet, active in pairs(MLO.entitySets) do
                        if active then
                            if not IsInteriorEntitySetActive(interior, entitySet) then
                                debuglog('Activating entity set', entitySet)
                                ActivateInteriorEntitySet(interior, entitySet)
                                boink = true
                            else
                                debuglog('Entity set', entitySet, 'is already active')
                            end
                        else
                            if IsInteriorEntitySetActive(interior, entitySet) then
                                debuglog('Deactivating entity set', entitySet)
                                DeactivateInteriorEntitySet(interior, entitySet)
                                boink = true
                            else
                                debuglog('Entity set', entitySet, 'is already deactivated')
                            end
                        end
                    end
                    if boink then
                        RefreshInterior(interior)
                    end
                end
                MLO.active = true
            end
        end
    end
end

function interpolate(distance, range, maxAlpha, asInteger)
    maxAlpha = maxAlpha or 255
    distance = distance or 0
    range = range or 20.0
    if distance < range then
        local diff = range - distance
        local value = maxAlpha / range * diff
        if asInteger then
            return math.floor(value)
        else
            return value
        end
    else
        return 0
    end
end

function marker(marker, camCoord)
    camCoord = camCoord or GetFinalRenderedCamCoord()
    local distance = #( marker.Location - camCoord )
    local alpha = interpolate(distance, marker.DrawRange, marker.Color.a or 255, true)
    if alpha > 0 then
        DrawMarker(
            marker.Model or 0,
            marker.Location or vector3(0,0,0),
            marker.Direction or vector3(0,0,0),
            marker.Rotation or vector3(0,0,0),
            marker.Scale or vector3(1,1,1),
            marker.Color.r or 0,
            marker.Color.g or 0,
            marker.Color.b or 0,
            alpha,
            false, -- bobs
            false, -- face camera
            2, -- Unknown. R* uses 2 most often
            marker.Rotates or false,
            0, -- Texture dict
            0, -- Texture name
            false -- Draw on intersecting entities
        )
    end
end

function fuckup(...)
    TriggerServerEvent(thisResource..':fuckup', ...)
end

function resourcePrefix(someString)
    return format('%s_%s',thisResource,someString)
end

function makeToast(subject,message)
    local dict = 'char_carsite'
    local icon = 'char_carsite'

    withTxd(dict, function()
        BeginTextCommandThefeedPost("STRING")
        AddTextComponentSubstringPlayerName(message)
        EndTextCommandThefeedPostMessagetext(
            dict, -- texture dict
            icon, -- texture name
            true, -- fade
            0, -- icon type
            _('cardealer'), -- Sender
            subject
        )
    end)
end

function withTxd(txdName, callback, timeout)
    Citizen.CreateThread(function()
        
        if not HasStreamedTextureDictLoaded(txdName) then
            timeout = timeout or 5000
            local begin = GetGameTimer()
            RequestStreamedTextureDict(txdName)
            while not HasStreamedTextureDictLoaded(txdName) and GetGameTimer() < begin + timeout do
                Citizen.Wait(0)
            end
        end

        if HasStreamedTextureDictLoaded(txdName) then
            pcall(callback) -- Fuck the actual *result*, we just need to *not crash*...
        else
            fuckup('Timed out loading texture dictionary', txdName)
        end

        SetStreamedTextureDictAsNoLongerNeeded(txdName)
    end)
end

function handleSellDrivenVehicle(playerPed)
    
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if not GetPedInVehicleSeat(vehicle, -1) == playerPed then
        return
    end

    local vehicleCoords = GetEntityCoords(vehicle)
    
    local testDrive = nil
    if DecorExistOn(vehicle, TestDriveDecorName) then
        testDrive = DecorGetInt(vehicle, TestDriveDecorName)
    end

    for job, locations in pairs(Config.Locations) do
        if not testDrive or testDrive == GetHashKey(job) then
            for locationName, locationData in pairs(locations) do
                if locationData.SellVehicle then
                    local sellLocation = locationData.SellVehicle
                    local distance = #( vehicleCoords - sellLocation.Location )
                    if distance <= sellLocation.Range then
                        if not BusyspinnerIsOn() then
                            if testDrive then
                                BeginTextCommandDisplayHelp(resourcePrefix('prompt_return_vehicle'))
                            else
                                BeginTextCommandDisplayHelp(resourcePrefix('prompt_sell_vehicle'))
                            end
                            EndTextCommandDisplayHelp(0, false, false, 0)                            
                            if IsControlJustPressed(0, 121) then
                                if not BusyspinnerIsOn() then
                                    BeginTextCommandBusyspinnerOn(resourcePrefix('awaiting_server'))
                                    EndTextCommandBusyspinnerOn(0)
                                end

                                local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
                                local netID = NetworkGetNetworkIdFromEntity(vehicle)

                                if testDrive then
                                    TriggerServerEvent('nerp_bilcenter:testdrive_return', job, locationName, netID, vehicleProps)
                                else
                                    TriggerServerEvent('nerp_bilcenter:sell_this_vehicle', job, locationName, netID, vehicleProps)
                                end
                            elseif IsControlJustPressed(0, 86) then
                                if not BusyspinnerIsOn() then
                                    BeginTextCommandBusyspinnerOn(resourcePrefix('awaiting_server'))
                                    EndTextCommandBusyspinnerOn(0)
                                end
                                local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
                                TriggerServerEvent('nerp_bilcenter:price_check', job, vehicleProps.model)
                            end
                        end
                    else

                        if distance <= sellLocation.DrawRange then
                            local alpha = interpolate(distance, sellLocation.DrawRange, 200, true)
                            if alpha > 0 then
                                DrawMarker(
                                    29,
                                    sellLocation.Location,
                                    vector3(0,0,0), -- Direction
                                    vector3(0,0,0), -- Rotation
                                    vector3(1.5,1.5,1.5),
                                    255, 255, 0, alpha, -- Color
                                    false, -- bobs
                                    false, -- face camera
                                    2, -- Unknown. R* uses 2 most often (rotation order for rotation?)
                                    true, -- Rotates
                                    0, -- Texture dict
                                    0, -- Texture name
                                    false -- Draw on intersecting entities
                                )
                            end        
                        end
                    end
                end -- LOL, I know, I know.
            end
        end
    end
end
AddTextEntry(resourcePrefix('awaiting_server'), _('awaiting_server'))
AddTextEntry(resourcePrefix('prompt_sell_vehicle'), _('prompt_sell_vehicle'))
AddTextEntry(resourcePrefix('prompt_return_vehicle'), _('prompt_return_vehicle'))
for job, locations in pairs(Config.Locations) do
    for name, locationData in pairs(locations) do
        for i, action in ipairs(locationData.Actions) do
            AddTextEntry(resourcePrefix(action.Prompt), _(action.Prompt))
        end
    end
end

if DEBUG then

    RegisterCommand('fadestuck', function()
        if IsScreenFadedOut() then
            DoScreenFadeIn(100)
        end
    end)

    RegisterCommand('spinnerstuck', function()
        BusyspinnerOff()
    end)

    RegisterCommand('bilcenterbahleet', function()
        if GetConvarIntAsBool('DebugBilcenter') then
            local spawn = vector3(-49.369, -1097.380, 26.0)
            while IsAnyVehicleNearPoint(spawn, 15.0) do
                local vehicle = GetClosestVehicle(spawn, 15.0, 0, 71)
                if vehicle and vehicle > 0 then
                    SetEntityAsMissionEntity(vehicle, true, true)
                    DeleteEntity(vehicle)
                    debuglog(vehicle, 'Gone?')
                else
                    debuglog('Could not find the vehicle')
                end
            end
        end
    end)

end

Citizen.CreateThread(function()
    while true do
        if ready then

            local camCoord = nil
            local playerPed = PlayerPedId()

            if enableInteriors then
                camCoord = GetFinalRenderedCamCoord()
                handleMLO(camCoord)
            end

            if Config.Locations[job.name] then
                if not camCoord then
                    camCoord =  GetFinalRenderedCamCoord()
                end
                handleActions(playerPed, camCoord, Config.Locations[job.name], job.name, job.grade)
            end

            if IsPedInAnyVehicle(playerPed) then
                handleSellDrivenVehicle(playerPed)
            end

            Citizen.Wait(0)
        else
            if not ESX then
                debuglog('Requesting ESX object...')
                TriggerEvent('esx:getSharedObject', function(obj)
                    debuglog('Obtained ESX object')
                    ESX = obj
                end)
            end

            if not job then
                if ESX and ESX.PlayerData then
                    job = ESX.PlayerData.job
                end
            else
                debuglog('ESX ready. Job ready:', job.name, job.grade)
                deployBlips()
                ready = true
            end
            Citizen.Wait(100)
        end
    end
end)
