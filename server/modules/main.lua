--DELETE ENTITY SERVERSIDE
RegisterNetEvent('vorp_library:Server:DeleteEntity', function(netid)
    local _source = source
    local entity = NetworkGetEntityFromNetworkId(netid)
    if DoesEntityExist(entity) then
        DeleteEntity(entity)
    end
end)


--TODO WIP
LIB = {}


--LIB.TriggerClientEvent(2, GetCurrentResourceName(), "setPedDensity", {})

-- resourcename will already be parsed by the client event
--LIB.RegisterNetEvent("setPedDensity", setPedDensity)

-- SERVER SIDE ONLY

--local Debug = false
--function LIB.TriggerClientEvent(id, resourcename, eventname, ...)
--    if not id then
--        error(("TriggerClientEvent: %s %s source cannot be null"):format(resourcename, eventname))
--    end
--
--    if Debug then -- allows to debug the events
--        print(("TriggerClientEvent: %s %s %s"):format(resourcename, eventname, json.encode(..., { indent = true })))
--    end
--
--    local target = id > 0 and id or -1 -- todo: multiple targets ?
--    local data = msgpack.pack_args(...)
--    TriggerClientEventInternal(resourcename .. ":server:" .. eventname, target, data, #data)
--end
--
--function LIB.RegisterNetEvent(eventname, func)
--    -- keep track of events? can check if there is duplicated?
--    RegisterNetEvent(eventname, function(t)
--        local _source = source
--        if t == nil then return func(_source) end
--        t = msgpack.unpack(t)
--        return func(_source, t)
--    end)
--end
