local onServer     = IsDuplicityVersion()
local thisResource = GetCurrentResourceName()

-- Localized for lookup speed
local format   = string.format
local fxtrace  = Citizen.Trace

function printf(formatting, ... )
    fxtrace(format(formatting, ... ))
end

function log( ... )
    local numElements = select('#', ...)
    local elements    = { ... }
    local line        = ''

    for i=1,numElements do
        local entry = elements[i]
        if i > 1 then
            line = line .. ' ' .. tostring(entry)
        else
            line = tostring(entry)
        end
    end

    if onServer then
        local time = os.date("%H:%M:%S")
        printf("[%s] <%s> %s\n", time, thisResource, line)
    else
        printf("%s\n", line)
    end
end

function debuglog(...)
    if GetConvarIntAsBool('DebugBilcenter') then
        log('Debug:', ...)
        if not onServer then
            TriggerServerEvent(thisResource..':debuglog',...)
        end
    end
end

function debugTable(header, tableRef, depth)
    depth = depth or 0
    if depth > 0 or GetConvarIntAsBool('DebugBilcenter') then
        debuglog(string.rep('  ',depth),header,'= {')
        for key, value in pairs(tableRef) do
            if type(value) == 'table' then
                debugTable(key,value,depth + 1)
            else
                debuglog(string.rep('  ', depth+1),key,'=',value)
            end
        end
        debuglog(string.rep('  ', depth),'}')
    end
end

if onServer then
    RegisterNetEvent(thisResource..':debuglog')
    AddEventHandler(thisResource..':debuglog', function(...)
        if GetConvarIntAsBool('DebugBilcenter') then
            log(source, 'Debug:', ... )
        end
    end)
    RegisterNetEvent(thisResource..':fuckup')
    AddEventHandler (thisResource..':fuckup', function(...)
        log(source, 'Fuckup:', ...)
    end)
end

function GetConvarIntAsBool( varName, default )
    default = default or 0
    local value = GetConvarInt(varName, default)
    if value > 0 then
        return true
    else
        return false
    end
end

function safeLookup(hash, ...)
    local path = {...}
    for _, step in ipairs(path) do
        if hash[step] then
            hash = hash[step]
        else
            return false
        end
    end
    return hash
end

Mutex = {}
local MutexCount = 0

function Mutex:new()

    MutexCount = MutexCount + 1

    local object = {
        id       = MutexCount,
        occupied = false,
    }

    setmetatable(object, self)
    self.__index = self

    return object
end

function Mutex:await()
    while self.occupied do
        Citizen.Wait(0)
    end
    self.occupied = true
end

function Mutex:release()
    self.occupied = false
end