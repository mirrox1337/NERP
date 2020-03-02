ESX              = nil
local Categories = {}
local Vehicles   = {}
local MySQLReady = false

local deleteWhitelist = {
    cardealer = true,
}
local invoiceWhitelist = {
    cardealer = true,
}
local knownPlates = nil
local LETTERS = {}
local modelHashes = nil

-- For faster lookups
local insert = table.insert
local char = string.char
local random = math.random

for i=65, 90 do
    insert(LETTERS, char(i))
end

-- For esx_vehicleshop compatibility
local CompatCategories
local CompatVehicles

TriggerEvent('esx:getSharedObject', function(obj)

    ESX = obj

    debuglog('Registering Server Callback esx_vehicleshop:getCategories')
    ESX.RegisterServerCallback('esx_vehicleshop:getCategories', function(source, cb)
        debuglog('esx_vehicleshop:getCategories called by', source)
        if CompatCategories then
            cb(CompatCategories)
        else
            MySQL.Async.fetchAll('SELECT * FROM vehicle_categories', {},
            function(_categories)
                cb(_categories)
                CompatCategories = _categories
            end)
        end
    end)

    debuglog('Registering Server Callback esx_vehicleshop:getVehicles')
    ESX.RegisterServerCallback('esx_vehicleshop:getVehicles', function(source, cb)
        debuglog('esx_vehicleshop:getVehicles called by', source)
        if CompatVehicles then
            cb(CompatVehicles)
        else
            MySQL.Async.fetchAll('SELECT * FROM vehicles', {},
            function(_vehicles)
                cb(_vehicles)
                CompatVehicles = _vehicles
            end)
        end
    end)

end)
TriggerEvent('esx_phone:registerNumber', 'cardealer', _('dealer_customers'), false, false)
TriggerEvent('esx_society:registerSociety', 'cardealer', _('cardealer'), 'society_cardealer', 'society_cardealer', 'society_cardealer', {type = 'private'})
debuglog('Enabled!') -- If it's not enabled, this won't show up, see? Clever!

function jobQualify(xPlayerJob, job, minGrade)
    minGrade = minGrade or 0
    if xPlayerJob.name == job and xPlayerJob.grade >= minGrade then
        return true
    end

    return false
end

function isBoss(xPlayerJob, compare)
    -- debugTable('xPlayerJob',xPlayerJob)
    if Config.BossRank[compare] then
        if xPlayerJob.name == compare and xPlayerJob.grade >= Config.BossRank[compare] then
            return true
        end
    else
        log('CRITICAL: No boss rank configured for', compare)
    end
    return false
end

function vehicleModelHashLookup(hash)
    if not modelHashes then
        local hashes = {}
        local orderableVehicles = MySQL.Sync.fetchAll(
            [[
                SELECT `model`, `name`, `price`
                FROM `vehicles`;
            ]]
        )
        for i, vehicle in ipairs(orderableVehicles) do
            local hashKey = GetHashKey(vehicle.model)
            hashes[hashKey] = {
                label = vehicle.name,
                model = vehicle.model,
                price = vehicle.price,
            }
        end
        modelHashes = hashes;
    end
    return modelHashes[hash]
end

function generateUniquePlate(depth)
    depth = depth or 0
    if depth > 10 then
        log('Recursion too deep looking for unique plate! Returning nil! This will not be pretty, but it is better than hanging the server. Nil value complaints further down comes from here!')
        return
    end

    if not knownPlates then
        local rows = MySQL.Sync.fetchAll(
            [[
                SELECT `plate` FROM `owned_vehicles`
                UNION SELECT `plate` FROM `dealership_vehicles`
                ;
            ]]
        )
        local platesSeen = {}
        for i, row in ipairs(rows) do
            platesSeen[row.plate] = true
        end
        knownPlates = platesSeen
    end

    local plate = ''

    for i=1, 3 do
        plate = plate .. LETTERS[random(#LETTERS)]
    end
    plate = plate .. ' '
    plate = plate .. string.format('%03d', random(999))

    if knownPlates[plate] then
        plate = generateUniquePlate(depth)
    else
        knownPlates[plate] = true
    end
    return plate

end

function getOrderableVehicleList(job, callback)
    MySQL.Async.fetchAll(
        [[
            SELECT `vehicles`.`name`, `model`, `price`, `vehicle_categories`.`label` as "category"
            FROM `vehicles`
            INNER JOIN `vehicle_categories`
                ON `vehicle_categories`.`name` = `vehicles`.`category`
            ORDER BY `category`, `name`;
        ]],
        {},
        function (results)
            local vehicleList = {}
            for i,row in ipairs(results) do
                if not vehicleList[row.category] then
                    vehicleList[row.category] = {}
                end
                insert(vehicleList[row.category], {
                    name = row.name,
                    model = row.model,
                    price = row.price,
                })
            end
            callback(vehicleList)
        end
    )
end

function getEmployeeList(job, callback)
    MySQL.Async.fetchAll(
        [[
            SELECT
                `users`.`name` as `name`,
                `identifier`,
                `job_grade`,
                `job_grades`.`label` as `label`,
                `job_grades`.`salary` as `salary`
            FROM `users`
            LEFT JOIN `job_grades`
                ON `users`.`job` = `job_grades`.`name`
            WHERE
                `users`.`job` = @job
            ;
        ]],
        {
            ['@job'] = job,
        },
        function(rows)
            local employees = {}
            for i,dude in ipairs(rows) do
                employees[dude.name] = {
                    job = job,
                    identifier = dude.identifier,
                    job_grade = dude.job_grade,
                    label = dude.label,
                }
            end
            -- debugTable('Employees', employees)
            callback(employees, #rows)
        end
    )
end

function getJobGrades(job, callback)
    MySQL.Async.fetchAll(
        [[
            SELECT
                `grade`,
                `job_grades`.`label` as `label`,
                `salary`
            FROM `job_grades`
            INNER JOIN `jobs`
                ON `job_grades`.`job_name` = `jobs`.`name`
            WHERE
                `job_grades`.`job_name` = @job
            ORDER BY `grade`;
        ]],
        {
            ['@job'] = job,
        },
        function(rows)
            local grades = {}
            for i, row in ipairs(rows) do
                grades[row.grade] = {
                    label = row.label,
                    salary = row.salary,
                }
            end
            callback(grades)
        end
    )
end

function getVehiclesInStock(job, callback)
    MySQL.Async.fetchAll(
        [[
            SELECT `plate`, `model`, `label`, `vehicle`, `price`, `stored`
            FROM `dealership_vehicles`
            WHERE `job` = @job;
        ]],
        {
            ['@job'] = job,
        },
        callback
    )
end

function getVehiclePriceAndLabel(vehicleModel, callback)
    MySQL.Async.fetchAll(
        [[
            SELECT `name`, `price`
            FROM `vehicles`
            WHERE `model` = @model
            LIMIT 1;
        ]],
        {
            ['@model'] = vehicleModel,
        },
        function(rows)
            if rows[1] then
                callback(rows[1].price, rows[1].name)
            end
        end
    )
end

function setJob(identifier, job, rank, callback)
    MySQL.Async.execute(
        [[
            UPDATE `users` SET
                `job` = @job,
                `job_grade` = @rank
            WHERE
                `identifier` = @identifier
            LIMIT 1;
        ]],
        {
            ['@job'] = job,
            ['@rank'] = rank,
            ['@identifier'] = identifier,
        },
        function(rowsChanged)
            if callback then
                callback( (rowsChanged == 1) )
            end
        end
    )
end

function societyPays(societyName, amount, callback, overdraft)
    TriggerEvent('esx_addonaccount:getSharedAccount', societyName, function(account)
		if account and account.money >= amount then
            account.removeMoney(amount)
            callback(true, false)
        elseif account and overdraft then
            account.removeMoney(amount)
            callback(true, true)
		else
			callback(false, false)
		end
    end)
end
function societyCredit(societyName, amount, callback)
    TriggerEvent('esx_addonaccount:getSharedAccount', societyName, function(account)
        if account then
            account.addMoney(amount)
            callback(true)
        else
            callback(false)
        end
    end)
end
function societyMoney(societyName, callback)
    debuglog('Looking up money for', societyName)
    TriggerEvent('esx_addonaccount:getSharedAccount', societyName, function(account)
        if account then
            debuglog(societyName,'has',account.money)
            callback(account.money)
        else
            debuglog(societyName,'has no account')
            callback(0)
        end
    end)
end

function assignDealershipVehicle(plate, label, model, user, vehicleProps, job, price, callback)
    MySQL.Async.execute(
        [[
            INSERT INTO `dealership_vehicles`
                (`plate`, `label`, `model`, `user`, `vehicle`, `job`, `price`)
            VALUES
                (@plate, @label, @model, @user, @vehicle, @job, @price)
            ;
        ]],
        {
            ['@plate'] = plate,
            ['@label'] = label,
            ['@model'] = model,
            ['@user'] = user,
            ['@vehicle'] = json.encode(vehicleProps),
            ['@job'] = job,
            ['@price']   = price,
        },
        function(rowsChanged)
            callback( (rowsChanged > 0) )
        end
    )
end

function getDealershipVehicle(plate, model, callback)
    MySQL.Async.fetchAll(
        [[
            SELECT `label`, `vehicle`, `job`, `price`
            FROM `dealership_vehicles`
            WHERE `model` = @model AND `plate` = @plate
            LIMIT 1;
        ]],
        {
            ['@plate'] = plate,
            ['@model'] = model,
        },
        function (rows)
            if rows[1] then
                callback({
                    plate = plate,
                    model = model,
                    vehicleProps = rows[1].vehicle,
                    dealership = rows[1].job,
                    label = rows[1].label,
                    price = rows[1].price,
                })
            else
                callback()
            end
        end
    )
end

function logSoldVehicle(dealership, seller, buyer, model, plate)
    MySQL.Async.execute(
        [[
            INSERT INTO `dealership_sales`
                (`dealership`, `seller`, `buyer`, `model`, `plate`)
            VALUES
                (@dealership, @seller, @buyer, @model, @plate)
            ;
        ]],
        {
            ['@dealership'] = dealership,
            ['@seller'] = seller,
            ['@buyer'] = buyer,
            ['@model'] = model,
            ['@plate'] = plate,
        },
        function (rowsChanged)
            if rowsChanged ~= 1 then
                log('FAILED to log sale of', model, plate, 'at', dealership, 'by', seller, 'to', buyer)
            else
                log('Sales log:',seller,'sold', model, plate, 'to', buyer, 'at', dealership)
            end
        end
    )
end

function removeDealershipVehicle(dealership, plate, model, callback)
    MySQL.Async.execute(
        [[
            DELETE FROM `dealership_vehicles` WHERE
            `job` = @job
            AND `plate` = @plate
            AND `model` = @model
            LIMIT 1;
        ]],
        {
            ['@job'] = dealership,
            ['@plate'] = plate,
            ['@model'] = model,
        },
        function(rowsChanged)
            if rowsChanged ~= 1 then
                log('FAILED to remove', model, plate, 'from', dealership)
            end
            if callback then
                callback( (rowsChanged == 1) )
            end
        end
    )
end

function registerVehicle(owner, plate, vehicleProps, label, callback)
    MySQL.Async.execute(
        [[
            INSERT INTO `owned_vehicles`
                (`owner`, `plate`, `vehicle`, `vehiclename`)
            VALUES
                (@owner, @plate, @vehicle, @vehiclename)
            ;
        ]],
        {
            ['@owner'] = owner,
            ['@plate'] = plate,
            ['@vehicle'] = vehicleProps,
            ['@vehiclename'] = label,
        },
        function (rowsChanged)
            if rowsChanged == 1 then
                callback(true)
            else
                callback(false)
            end
        end
    )
end

function removeVehicleOwnership(identifier, plate, modelHash, callback)
    MySQL.Async.execute(
        [[
            DELETE FROM `owned_vehicles`
            WHERE
                `owner` = @owner
                AND `plate` = @plate
                AND JSON_EXTRACT(`vehicle`, "$.model") = @model
            LIMIT 1;
        ]],
        {
            ['@owner'] = identifier,
            ['@plate'] = plate,
            ['@model'] = modelHash,
        },
        function(rowsAffected)
            callback( (rowsAffected == 1) )
        end
    )
end

function verifyVehicleOwnership(identifier, plate, modelHash, callback)
    debuglog('Verifying that', identifier, 'owns', modelHash, plate)
    MySQL.Async.fetchAll(
        [[
            SELECT `plate`
            FROM `owned_vehicles`
            WHERE
                `owner` = @owner
                AND `plate` = @plate
                AND JSON_EXTRACT(`vehicle`, "$.model") = @model
            LIMIT 1;
        ]],
        {
            ['@owner'] = identifier,
            ['@plate'] = plate,
            ['@model'] = modelHash,
        },
        function(rows)
            if #rows == 1 then
                debuglog('Ownership verified')
                callback(true)
            else
                debuglog('Could not verify ownership')
                callback(false)
            end
        end
    )
end

function logIdentity(who)
    local idents = GetNumPlayerIdentifiers(who)
    if idents then
        local steam = ''
        for i = 0, idents-1 do
            local identifier = GetPlayerIdentifier(who, i)
            if string.sub(identifier, 1, 6) == 'steam:' then
                steam = string.sub(identifier, 7)
                break
            end
        end
        return string.format("[%i %s %s]", who, steam, GetPlayerName(who))
    else
        return string.format("[%s ?? ??]", who)
    end
end

RegisterNetEvent('nerp_bilcenter:register_vehicle')
AddEventHandler ('nerp_bilcenter:register_vehicle', function(target, plate, model, netID, supposedOwner)
    local source = source
    local xSource = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)
    if xSource and xTarget then
        getDealershipVehicle(plate, model, function(vehicle)
            if vehicle then
                if jobQualify(xSource.job, vehicle.dealership) then
                    registerVehicle(xTarget.identifier, plate, vehicle.vehicleProps, vehicle.label..' ('..plate..')', function(wasStored)
                        if wasStored then
                            TriggerEvent('nerp_keys:getKey', xTarget.identifier, 'carKey', plate, vehicle.label..' ('..plate..')')
                            logSoldVehicle(vehicle.dealership, xSource.identifier, xTarget.identifier, model, plate)
                            removeDealershipVehicle(vehicle.dealership, vehicle.plate, vehicle.model)
                            TriggerClientEvent('nerp_bilcenter:success', source, _('success_registration', vehicle.label, vehicle.plate, GetPlayerName(target)))
                            TriggerClientEvent('nerp_bilcenter:registered_release', supposedOwner, netID)
                        else
                            log('Failed to register', model, plate, 'to', logIdentity(target))
                            TriggerClientEvent('nerp_bilcenter:failure', source, _('error_not_registered'))
                        end
                    end)
                else
                    log(logIdentity(source), 'works at', xSource.job.name, 'and tried to sell', model, plate, 'belonging to', vehicle.dealership)
                    TriggerClientEvent('nerp_bilcenter:failure', source, _('access_denied'))
                end
            else
                log('Failed to look up vehicle', plate, model,'when', logIdentity(source), 'tried to register it to', logIdentity(target))
                TriggerClientEvent('nerp_bilcenter:failure', source, _('error_no_such_vehicle'))
            end
        end)
    else
        log('Failed to resolve ESX player for seller',logIdentity(source), 'or customer', logIdentity(target), 'while attempting to register', model, plate)
        TriggerClientEvent('nerp_bilcenter:error', source, _('error_failed_xplayer'))
    end
end)

RegisterNetEvent('nerp_bilcenter:return_vehicle')
AddEventHandler ('nerp_bilcenter:return_vehicle', function(plate, model)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        getDealershipVehicle(plate, model, function(vehicle)
            if vehicle then
                if jobQualify(xPlayer.job, vehicle.dealership) then
                    removeDealershipVehicle(vehicle.dealership, vehicle.plate, vehicle.model, function(removed)
                        if removed then
                            societyCredit('society_'..vehicle.dealership, vehicle.price, function(credited)
                                if credited then
                                    log(logIdentity(source),'returned', vehicle.model, vehicle.plate,'to manufacturer for $'..vehicle.price)
                                    TriggerClientEvent('nerp_bilcenter:success', source, _('success_returned', vehicle.label, vehicle.plate, ESX.Math.GroupDigits(vehicle.price)))
                                else
                                    log('Failed to credit', vehicle.dealership, '$'..vehicle.price,'when returning', vehicle.model, vehicle.plate, 'to manufacturer!')
                                    TriggerClientEvent('nerp_bilcenter:failure', source, _('error_generic_fuckup'))
                                end
                            end)
                        else
                            log('Failed to remove', plate, model, 'from dealership', vehicle.dealership..'! ')
                            TriggerClientEvent('nerp_bilcenter:failure', source, _('error_generic_fuckup'))
                        end
                    end)
                else
                    log(logIdentity(source), 'works at', xPlayer.job.name, 'and tried to return', model, plate, 'belonging to', vehicle.dealership)
                    TriggerClientEvent('nerp_bilcenter:failure', source, _('access_denied'))
                end
            else
                log('Failed to look up vehicle', plate, model,'when', logIdentity(source), 'tried to return it')
                TriggerClientEvent('nerp_bilcenter:failure', source, _('error_no_such_vehicle'))
            end
        end)
    else
        log('Failed to resolve ESX player for',logIdentity(source), 'while attempting to return', model, plate)
        TriggerClientEvent('nerp_bilcenter:error', source, _('error_failed_xplayer'))
    end
end)

RegisterNetEvent('nerp_bilcenter:log_invoice')
AddEventHandler ('nerp_bilcenter:log_invoice', function(target, job, amount)
    log(logIdentity(source),'invoiced',logIdentity(target), '$'..amount, 'on behalf of', job)
    local name = GetPlayerName(target)
    TriggerClientEvent('nerp_bilcenter:success', source, _('invoiced_amount', ESX.Math.GroupDigits(amount), name))
end)

RegisterNetEvent('nerp_bilcenter:purchase_new_vehicle')
AddEventHandler ('nerp_bilcenter:purchase_new_vehicle', function(job, location, vehicleModel, vehicleProps)
    local source = source

    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        if jobQualify(xPlayer.job, job) then
            getVehiclePriceAndLabel(vehicleModel, function(price, label)
                if price then
                    label = label or vehicleModel
                    societyPays('society_'..job, price, function(paid)
                        if paid then
                            local plate = generateUniquePlate()
                            debuglog('Generated plate',plate,'for new vehicle', vehicleModel)
                            vehicleProps.plate = plate
                            local user = xPlayer.identifier
                            assignDealershipVehicle(plate, label, vehicleModel, user, vehicleProps, job, price, function(stored)
                                if stored then
                                    TriggerClientEvent('nerp_bilcenter:success', source, _('success_transaction', label, ESX.Math.GroupDigits(price)))
                                    log(logIdentity(source), 'purchased a',label,'at',job,'for $'..price)
                                else
                                    TriggerClientEvent('nerp_bilcenter:error', source, _('error_generic_fuckup'))
                                    log('Failed to store the purchase of a',label,' for $'..price,'!! AFTER !! payment was made! Holy fuck!')
                                end
                            end)
                        else
                            TriggerClientEvent('nerp_bilcenter:error', source, _('error_insufficient_funds', label, ESX.Math.GroupDigits(price)))
                        end
                    end)
                else
                    log('Failed to look up price for vehicle purchase. No price for', vehicleName)
                    TriggerClientEvent('nerp_bilcenter:error', source, _('error_generic_fuckup'))
                end
            end)
        else
            log('Could not authorize',job,'vehicle purchase for', logIdentity(source))
            TriggerClientEvent('nerp_bilcenter:error', source, _('error_access_denied'))
        end
    else
        log('Failed to resolve ESX player for',logIdentity(source), 'while purchasing new vehicle')
        TriggerClientEvent('nerp_bilcenter:error', source, _('error_failed_xplayer'))
    end
end)

RegisterNetEvent('nerp_bilcenter:request_order_menu')
AddEventHandler ('nerp_bilcenter:request_order_menu', function(job, locationName, actionNumber, eventData)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        debuglog(logIdentity(source), 'requests the vehicle order menu for', job, 'at', locationName)
        local locationData = safeLookup(Config, 'Locations', job, locationName, 'Actions', actionNumber)
        if locationData then
            if jobQualify(xPlayer.job, job, locationData.MinGrade) then
                debuglog('...is qualified')
                getOrderableVehicleList(job, function(vehicleList)
                    TriggerClientEvent('nerp_bilcenter:open_order_menu',source, job, locationName, actionNumber, vehicleList)
                end)
            else
                log('Could not authorize',job,'order menu for', logIdentity(source))
                TriggerClientEvent('nerp_bilcenter:error', source, _('error_access_denied'))
            end
        else
            log('Could not resolve location from', job, locationName, actionNumber)
            TriggerClientEvent('nerp_bilcenter:error', source, _('error_location_invalid'))
        end
    else
        log('Failed to resolve ESX player for',logIdentity(source), 'while requesting order menu')
        TriggerClientEvent('nerp_bilcenter:error', source, _('error_failed_xplayer'))
    end
end)

RegisterNetEvent('nerp_bilcenter:request_sales_menu')
AddEventHandler ('nerp_bilcenter:request_sales_menu', function(job, locationName, actionNumber, eventData)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        debuglog(logIdentity(source), 'requests the vehicle sales menu for', job, 'at', locationName)
        local locationData = safeLookup(Config, 'Locations', job, locationName, 'Actions', actionNumber)
        if locationData then
            if jobQualify(xPlayer.job, job, locationData.MinGrade) then
                debuglog('...is qualified')
                getVehiclesInStock(job, function(vehicleList)
                    TriggerClientEvent('nerp_bilcenter:open_sales_menu', source, job, locationName, actionNumber, vehicleList)
                end)
            else
                log('Could not authorize',job,'sales menu for', logIdentity(source))
                TriggerClientEvent('nerp_bilcenter:error', source, _('error_access_denied'))
            end
        else
            log('Could not resolve location from', job, locationName, actionNumber)
            TriggerClientEvent('nerp_bilcenter:error', source, _('error_location_invalid'))
        end
    else
        log('Failed to resolve ESX player for',logIdentity(source), 'while requesting sales menu')
        TriggerClientEvent('nerp_bilcenter:error', source, _('error_failed_xplayer'))
    end
end)

RegisterNetEvent('nerp_bilcenter:testdrive_start')
AddEventHandler ('nerp_bilcenter:testdrive_start',function(job, plate, model, vehicleNetId, supposedOwner)
    local source = source
    MySQL.Async.execute(
        [[
            UPDATE `dealership_vehicles` SET
                `stored` = FALSE
            WHERE
                `plate` = @plate
                AND `model` = @model
                AND `job` = @job
            LIMIT 1;
        ]],
        {
            ['@plate'] = plate,
            ['@model'] = model,
            ['@job'] = job,
        },
        function(rowsChanged)
            log(logIdentity(source),'released',model,plate,'for test driving')
            debuglog('Updated: ',(rowsChanged == 1), ' - Dispatching release event to', logIdentity(supposedOwner))
            TriggerClientEvent('nerp_bilcenter:testdrive_release', supposedOwner, vehicleNetId, GetHashKey(job))
        end
    )
end)
RegisterNetEvent('nerp_bilcenter:testdrive_return')
AddEventHandler ('nerp_bilcenter:testdrive_return', function(job, locationName, netID, vehicleProps)
    local source = source
    local plate = vehicleProps.plate
    -- log('Returning "'..plate..'"')
    MySQL.Async.execute(
        [[
            UPDATE `dealership_vehicles` SET
            `stored` = TRUE, `vehicle` = @vehicleProps
            WHERE `plate` = @plate
            AND JSON_EXTRACT(`vehicle`, "$.model") = @model
            LIMIT 1;
        ]],
        {
            ['@model'] = vehicleProps.model,
            ['@plate'] = plate,
            ['@vehicleProps'] = json.encode(vehicleProps),
        },
        function (rowsUpdated)
            if rowsUpdated ~= 1 then
                log('Something *VERY* strange is going on. Vehicle with plates', plate,'was returned from test driving, but did not match any vehicle currently being testdriven!? Returned by', logIdentity(source))
            end
            log(logIdentity(source), 'returned test driven vehicle', plate)
            TriggerClientEvent('nerp_bilcenter:delete_vehicle', -1, netID)
            TriggerClientEvent('nerp_bilcenter:success', source, _('success_thanks'))
        end
    )
end)

RegisterNetEvent('nerp_bilcenter:sell_this_vehicle')
AddEventHandler ('nerp_bilcenter:sell_this_vehicle', function(job, locationName, netID, vehicleProps)
    local source = source
    debuglog(source,'nerp_bilcenter:sell_this_vehicle')
    local plate = vehicleProps.plate
    local modelHash = vehicleProps.model
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        verifyVehicleOwnership(xPlayer.identifier, plate, modelHash, function(isOwner)
            if isOwner then
                local modelData = vehicleModelHashLookup(modelHash)
                if modelData then
                    societyPays('society_'..job, modelData.price, function(paid)
                        if paid then
                            removeVehicleOwnership(xPlayer.identifier, plate, modelHash, function(wasRemoved)
                                if wasRemoved then
                                    xPlayer.addAccountMoney('bank', modelData.price)
                                    TriggerClientEvent('nerp_bilcenter:success', source, _('success_sold_vehicle', ESX.Math.GroupDigits(modelData.price), modelData.label, plate))
                                    TriggerClientEvent('nerp_bilcenter:vehicle_killorder', -1, plate, modelData.model)
                                    log(logIdentity(source),'was paid $'..modelData.price,'for their',modelData.label,'('..plate..') at', job)
                                    assignDealershipVehicle(plate, modelData.label, modelData.model, xPlayer.identifier, vehicleProps, job, modelData.price, function(stored)
                                        if not stored then
                                            log('Something went terribly wrong storing', modelData.label, plate, 'worth $'..modelData.price, 'in the inventory of', job)
                                        end
                                    end)
                                else
                                    TriggerClientEvent('nerp_bilcenter:error', source, _('error_generic_fuckup'))
                                    log('Failed to remove vehicle belonging to',logIdentity(source),'when they wanted to sell it. Fuck.')
                                end
                            end)
                        else
                            log(logIdentity(source),'tried to sell their', modelData.label..', but', job, 'could not afford it!')
                            TriggerClientEvent('nerp_bilcenter:error', source, _('error_dealership_cant_afford', ESX.Math.GroupDigits(modelData.price), modelData.label))
                        end
                    end)
                else
                    log(logIdentity(source),'tried to sell their vehicle with model hash', vehicleProps.model..', but that did not match any vehicles currently for sale by', job)
                    TriggerClientEvent('nerp_bilcenter:error', source, _('error_no_thanks'))
                end
            else
                TriggerClientEvent('nerp_bilcenter:error', source, _('error_not_your_vehicle'))
                log(logIdentity(source),'tried to sell a vehicle that does not belong to them!')
            end
        end)
    else
        log('Failed to resolve ESX player for',logIdentity(source), 'while processing sale of their vehicle')
        TriggerClientEvent('nerp_bilcenter:error', source, _('error_failed_xplayer'))
    end
end)

RegisterNetEvent('nerp_bilcenter:price_check')
AddEventHandler ('nerp_bilcenter:price_check', function(dealership, modelHash)
    local source = source
    debuglog(logIdentity(source),'did a price check on', modelHash)
    local modelData = vehicleModelHashLookup(modelHash)
    if modelData then
        TriggerClientEvent('nerp_bilcenter:success', source, _('success_price_check', modelData.label, ESX.Math.GroupDigits(modelData.price)))
    else
        TriggerClientEvent('nerp_bilcenter:error', source, _('error_no_thanks'))
    end
end)

RegisterNetEvent('nerp_bilcenter:insurance_claim')
AddEventHandler ('nerp_bilcenter:insurance_claim', function(job, plate, model, insuranceCost)
    local source = source

    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        if jobQualify(xPlayer.job, job) then
            MySQL.Async.execute(
                [[
                    UPDATE `dealership_vehicles`
                    SET `stored` = TRUE
                    WHERE
                        `plate` = @plate
                        AND `model` = @model
                        AND `job` = @job
                    LIMIT 1;
                ]],
                {
                    ['@plate'] = plate,
                    ['@model'] = model,
                    ['@job'] = job,
                },
                function(rowsChanged)
                    local success = (rowsChanged == 1)
                    debuglog('Insurance claim: ',success)
                    if success then
                        societyPays('society_'..job, insuranceCost, function(paid, overdraft)
                            if overdraft then
                                log(logIdentity(source), 'put', job, 'in the red paying $'..paid,'for the return of', plate)
                                TriggerClientEvent('nerp_bilcenter:success',source, _('insurance_overdraft', plate))
                            else
                                log(logIdentity(source), 'paid $'..insuranceCost,'for the return of', plate, 'from the account of', job)
                                TriggerClientEvent('nerp_bilcenter:success',source, _('insurance_ok', plate))
                            end
                            TriggerClientEvent('nerp_bilcenter:vehicle_killorder', -1, plate, model)
                        end, true)
                    else
                        log(logIdentity(source), 'tried to buy back a vehicle for', job, 'at', locationName..', but it seems it is already in the garage?! No idea what happened.')
                        TriggerClientEvent('nerp_bilcenter:failure', source, _('error_generic_fuckup'))
                    end
                end
            )
        end
    end
end)

RegisterNetEvent('nerp_bilcenter:request_vehicle_delete')
AddEventHandler ('nerp_bilcenter:request_vehicle_delete', function(supposedOwner, netID)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        if deleteWhitelist[xPlayer.job.name] then
            log(logIdentity(source), 'requests networked deletion of vehicle', netID, 'with supposed owner of', netID)
            TriggerClientEvent('nerp_bilcenter:delete_vehicle', supposedOwner, netID)
        else
            TriggerClientEvent('nerp_bilcenter:error', source, _('error_access_denied'))
            log(logIdentity(source), 'attempted to network-delete a vehicle, but does not have a job whitelisted for this!')
        end
    else
        log('Failed to resolve ESX player for',logIdentity(source), 'while requesting network vehicle deletion')
    end

end)

RegisterNetEvent('nerp_bilcenter:request_boss_menu')
AddEventHandler ('nerp_bilcenter:request_boss_menu', function(job, locationName, actionNumber, eventData)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local locationData = safeLookup(Config, 'Locations', job, locationName, 'Actions', actionNumber)
        if locationData then
            if jobQualify(xPlayer.job, job, locationData.MinGrade) then
                getJobGrades(job, function(jobGrades)
                    getEmployeeList(job, function(employeeList, employeeCount)
                        societyMoney('society_'..job, function(money)
                            log(logIdentity(source),'opened', job, 'boss menu')
                            TriggerClientEvent('nerp_bilcenter:open_boss_menu', source, job, money, jobGrades, employeeList, employeeCount)
                        end)
                    end)
                end)
            else
                log('Could not authorize',job,'boss menu for', logIdentity(source))
                TriggerClientEvent('nerp_bilcenter:error', source, _('error_access_denied'))
            end
        else
            log('Could not resolve location from', job, locationName, actionNumber)
            TriggerClientEvent('nerp_bilcenter:error', source, _('error_location_invalid'))
        end
    else
        log('Failed to resolve ESX player for',logIdentity(source), 'while authorizing boss menu')
        TriggerClientEvent('nerp_bilcenter:error', source, _('error_failed_xplayer'))
    end

end)

RegisterNetEvent('nerp_bilcenter:hire')
AddEventHandler ('nerp_bilcenter:hire', function(job, who)
    local source = source

    local xSource = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(who)

    if xSource and xTarget then
        if isBoss(xSource.job, job) then
            log(logIdentity(source),'hired',logIdentity(who),'at',job)
            xTarget.setJob(job, Config.NewhireRank[job] or 0)
            ESX.SavePlayer(xTarget)
            TriggerClientEvent('nerp_bilcenter:success', source, _('success_hired_someone', GetPlayerName(who)))
            TriggerClientEvent('nerp_bilcenter:success', who, _('success_got_hired', _(job)))
        else
            log('Could not authorize',logIdentity(source),'to hire',logIdentity(who),'at',job)
            TriggerClientEvent('nerp_bilcenter:error', source, _('error_access_denied'))
        end
    else
        log('Failed to resolve ESX player for',logIdentity(source),'or',logIdentity(who),'while one was trying to hire the other for',job)
        TriggerClientEvent('nerp_bilcenter:error', source, _('error_failed_xplayer'))
    end
end)

RegisterNetEvent('nerp_bilcenter:set_rank')
AddEventHandler ('nerp_bilcenter:set_rank', function(name, identifier, job, newRank)
    local source = source
    debuglog('Set rank for',identifier,job,newRank)
    local xSource = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromIdentifier(identifier)

    if xSource then
        -- debugTable('xSource.job', xSource.job)
        if isBoss(xSource.job, job) then
            getJobGrades(job, function(grades)
                debuglog('getJobGrades')
                if grades[newRank] then

                    if xTarget and xTarget.source then
                        xTarget.setJob(job, newRank)
                        name = xTarget.getName()
                        TriggerClientEvent('nerp_bilcenter:success', xTarget.source, _('success_got_new_rank',grades[newRank].label, _(job)))
                    end

                    setJob(identifier,job,newRank)

                    TriggerClientEvent('nerp_bilcenter:success', source, _('success_gave_new_rank', name, grades[newRank].label))
                    log(logIdentity(source),'set the rank of', identifier,'at', job, 'to', newRank)
                else
                    TriggerClientEvent('nerp_bilcenter:error', source, _('error_generic_fuckup'))
                    log(logIdentity(source),'tried to set the rank of',identifier,'at',job,'to',newRank..', but that is not a valid rank?!')
                end
            end)
        else
            log('Could not authorize',logIdentity(source),'set the rank of',identifier,'at',job)
            TriggerClientEvent('nerp_bilcenter:error', source, _('error_access_denied'))
        end
    else
        log('Failed to resolve ESX player for boss',logIdentity(source),'while trying to set rank at',job)
        TriggerClientEvent('nerp_bilcenter:error', source, _('error_failed_xplayer'))
    end
end)

RegisterNetEvent('nerp_bilcenter:fire')
AddEventHandler ('nerp_bilcenter:fire', function(name, identifier, job)
    local source = source
    local xSource = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromIdentifier(identifier)
    if xSource then
        if isBoss(xSource.job, job) then
            if xTarget and xTarget.source then
                xTarget.setJob(Config.Termination.job, Config.Termination.rank)
                name = xTarget.getName()
                TriggerClientEvent('nerp_bilcenter:error', xTarget.source, _('got_fired'), _(job))
            end

            setJob(identifier, Config.Termination.job, Config.Termination.rank)

            TriggerClientEvent('nerp_bilcenter:success', source, _('success_fired_someone', name))
            log(logIdentity(source),'fired', identifier,'from', job)
        else
            log('Could not authorize',logIdentity(source),'to fire',identifier,'at',job)
            TriggerClientEvent('nerp_bilcenter:error', source, _('error_access_denied'))
        end
    else
        log('Failed to resolve ESX player for boss',logIdentity(source),'when trying to fire someone from',job)
        TriggerClientEvent('nerp_bilcenter:error', source, _('error_failed_xplayer'))
    end
end)

RegisterNetEvent('nerp_bilcenter:financial_transaction')
AddEventHandler ('nerp_bilcenter:financial_transaction', function(action, job, amount)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        if isBoss(xPlayer.job, job) then
            if action == 'deposit' then
                local account = xPlayer.getAccount('bank')
                if account and account.money > amount then
                    xPlayer.removeAccountMoney('bank', amount)
                    societyCredit('society_'..job, amount, function(credited)
                        if credited then
                            TriggerClientEvent('nerp_bilcenter:success', source, _('success_deposit_money', ESX.Math.GroupDigits(amount)))
                            log(logIdentity(source),'deposited $'..amount,'into',job)
                        else
                            TriggerClientEvent('nerp_bilcenter:error', source, _('error_generic_fuckup'))
                            log(logIdentity(source),'deposited $'..amount,'into', job..', but the transfer somehow did not go through. Script bug?!')
                        end
                    end)
                else
                    log(logIdentity(source),'tried to deposit $'..amount,'into',job..', but they do not have the money!')
                    TriggerClientEvent('nerp_bilcenter:error', source, _('error_transfer_failed'))
                end
            elseif action == 'withdraw' then
                societyPays('society_'..job, amount, function(paid)
                    if paid then
                        xPlayer.addAccountMoney('bank', amount)
                        log(logIdentity(source),'withdrew $'..amount,'from',job)
                        TriggerClientEvent('nerp_bilcenter:success', source, _('success_withdraw_money', ESX.Math.GroupDigits(amount)))
                    else
                        log(logIdentity(source),'tried to withdraw $'..amount,'from',job..', but they do not have the money!')
                        TriggerClientEvent('nerp_bilcenter:error', source, _('error_transfer_failed'))
                    end
                end)
            end
        else
            log('Could not authorize',job,'money transfer for', logIdentity(source))
            TriggerClientEvent('nerp_bilcenter:error', source, _('error_access_denied'))
        end
    else
        log('Failed to resolve ESX player for',logIdentity(source), 'while attempting to',action,'money at',job)
        TriggerClientEvent('nerp_bilcenter:error', source, _('error_failed_xplayer'))
    end
end)

--[[
Fixa:
- Ändra rank på någon som inte är inne
- Sparka folk
--]]