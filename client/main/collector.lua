-- collect entity created by the entity modules
local ENTITIES <const> = {}
ENTITIES.Objects = {}
ENTITIES.Peds = {}
ENTITIES.Vehicles = {}


--set exports
exports('TrackEntity', function(entity)
    if entity == 'object' then
        table.insert(ENTITIES.Objects, entity)
    elseif entity == 'ped' then
        table.insert(ENTITIES.Peds, entity)
    elseif entity == 'vehicle' then
        table.insert(ENTITIES.Vehicles, entity)
    end
end)

exports('UntrackEntity', function(entity)
    if entity == 'object' then
        table.remove(ENTITIES.Objects, entity)
    elseif entity == 'ped' then
        table.remove(ENTITIES.Peds, entity)
    elseif entity == 'vehicle' then
        table.remove(ENTITIES.Vehicles, entity)
    end
end)


exports('GetAllEntities', function()
    return ENTITIES
end)

exports('GetAllObjects', function()
    return ENTITIES.Objects
end)

-- example local objects = exports.vorp_lib:GetAllObjects()
-- local numObjects = #objects

exports('GetAllPeds', function()
    return ENTITIES.Peds
end)

exports('GetAllVehicles', function()
    return ENTITIES.Vehicles
end)


--on resource stop
AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end

    for _, types in pairs(ENTITIES) do
        for _, entity in ipairs(types) do
            if DoesEntityExist(entity) then
                DeleteEntity(entity)
            end
        end
    end
end)
