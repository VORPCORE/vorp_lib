-- TODO: add debug messages
local LIB <const> = Import { 'class' }
local Class <const> = LIB.Class

print("^3WARNING: ^7module ENTITY is a work in progress use it at your own risk")

---@type table<string, table<integer, integer>> Keep track of entities created
local entityTracker <const> = {
    Objects = {},
    Peds = {},
    Vehicles = {}
}

------------------------------------
--* BASE CLASS / SUPERCLASS / PARENT CLASS
--* ENTITY manager
---@class Entity
local Entity <const> = Class:Create({

    ---@Constructor
    constructor = function(self, handle, netid, entityType, model)
        self.handle = handle
        self.netid = netid
        self.entityType = entityType
        self.model = model
    end,

    ---@methods
    set = {

        DeleteEntity = function(self)
            if not DoesEntityExist(self.handle) then
                return
            end

            if self.netid and NetworkGetEntityIsNetworked(self.handle) then
                TriggerServerEvent('vorp_library:Server:DeleteEntity', self.netid)
            else
                SetEntityAsMissionEntity(self.handle, true, true)
                SetEntityAsNoLongerNeeded(self.handle)
                DeleteEntity(self.handle)
            end
            self:RemoveTrackedEntity(self.handle, self.entityType)
            self = nil
        end,
    },

    get = {
        GetHandle = function(self)
            return self.handle
        end,

        GetNetID = function(self)
            return self.netid
        end,

        GetModel = function(self)
            return self.model
        end,
    },

    RemoveTrackedEntitiesByHandle = function(_, handle, entityType)
        if not entityTracker[entityType] then return error('wrong entity type') end
        entityTracker[entityType][handle] = nil
        -- event or callback on entity was removed?
    end,

    GetTrackedEntitiesByType = function(_, entityType)
        if not entityTracker[entityType] then return error('wrong entity type') end
        return entityTracker[entityType]
    end,

    GetNumberOfTrackedEntitiesByType = function(_, entityType)
        if not entityTracker[entityType] then return error('wrong entity type') end
        return #entityTracker[entityType]
    end,

    LoadModel = function(_, data)
        local model = data.Model

        if not IsModelValid(model) then
            error(('Invalid model name or hash: %s'):format(tostring(model)), 2)
        end

        if not HasModelLoaded(model) then
            RequestModel(model, false)
            local startTime = GetGameTimer()
            repeat Wait(0) until HasModelLoaded(model) or (GetGameTimer() - startTime) > 3000

            if (GetGameTimer() - startTime) > 2000 then
                error(('Failed to load model: %s'):format(tostring(model)), 1)
            end
        end

        local timeout = data.Options?.Timeout
        if not timeout then return end
        SetTimeout(timeout, function()
            SetModelAsNoLongerNeeded(model)
        end)
    end,

    TrackEntity = function(_, handle, entityType)
        if not entityTracker[entityType] then return end
        entityTracker[entityType][handle] = handle
    end,

    ValidateEntity = function(_, handle)
        local startTime <const> = GetGameTimer()
        repeat Wait(0) until DoesEntityExist(handle) or (GetGameTimer() - startTime) > 5000
        if (GetGameTimer() - startTime) > 5000 then
            print('Failed to create entity, pool full?')
            return false
        end
        return true
    end,

    GetNetworkID = function(_, handle, isNetworked)
        local netid = nil
        if isNetworked then
            netid = NetworkGetNetworkIdFromEntity(handle)
        end

        return netid
    end,

    SetHeading = function(_, handle, data)
        if not data.Pos?.w then return end
        SetEntityHeading(handle, data.Pos.w)
    end,

    SetEntityRotation = function(_, handle, data)
        if not data?.Rot then return end
        SetEntityRotation(handle, data.Rot.x, data.Rot.y, data.Rot.z, data.Rot.Order or 1, data.Rot.P5 or false)
    end,

    SetPedIntoVehicle = function(_, handle, data)
        local ped = data.Seat?.Ped or PlayerPedId()
        local seat = data.Seat?.Index or -1
        SetPedIntoVehicle(ped, handle, seat)
    end,

    PlaceOnGround = function(_, handle, data)
        if not data?.PlaceOnGround then return end
        PlaceEntityOnGroundProperly(handle, false)
    end,
})


-----------------------------------
--* DERIVED CLASSES / SUBCLASSES / CHILD CLASSES
--* PEDS
---@class Ped
local Ped <const> = Class:Create(Entity)

function Ped:Create(data)
    Entity:LoadModel(data)

    local handle <const> = CreatePed(data.Model, data.Pos.x, data.Pos.y, data.Pos.z, data.Pos?.w or 0.0, data.IsNetworked, data.ScriptHostPed, data.P7, data.P8)
    if not Entity:ValidateEntity(handle) then
        return
    end
    SetRandomOutfitVariation(handle, true) -- without this the ped will not be visible

    Entity:TrackEntity(handle, 'Ped')
    Entity:PlaceOnGround(handle, data.Options)
    Entity:SetHeading(handle, data.Options)

    local netid <const> = Entity:GetNetworkID(handle, data.IsNetworked)
    local instance <const> = Ped:New(handle, netid, 'Ped', data.Model)

    if not data.Options then
        return instance
    end

    if data.OnCreate then
        data.OnCreate(instance)
    end

    return instance
end

------------------------------------
--* DERIVED CLASSES / SUBCLASSES / CHILD CLASSES
--* OBJECTS
---@class Object
local Object <const> = Class:Create(Entity)

function Object:Create(data)
    Entity:LoadModel(data)

    local handle <const> = CreateObject(data.Model, data.Pos.x, data.Pos.y, data.Pos.z, data.IsNetworked, data.ScriptHostPed, data.P7, data.P8)
    if not Entity:ValidateEntity(handle) then
        return
    end

    Entity:TrackEntity(handle, 'Object')
    Entity:PlaceOnGround(handle, data.Options)
    Entity:SetHeading(handle, data.Options)
    Entity:SetEntityRotation(handle, data.Options)

    local netid <const> = Entity:GetNetworkID(handle, data.IsNetworked)
    local instance <const> = Object:New(handle, netid, 'Object', data.Model)

    if not data.Options then
        return instance
    end

    if data.OnCreate then
        data.OnCreate(instance)
    end

    return instance
end

------------------------------------
--* DERIVED CLASSES / SUBCLASSES / CHILD CLASSES
--* VEHICLES
---@class Vehicle
local Vehicle <const> = Class:Create(Entity)

function Vehicle:Create(data)
    Entity:LoadModel(data)
    local handle <const> = CreateVehicle(data.Model, data.Pos.x, data.Pos.y, data.Pos.z, data.Pos?.w or 0.0, data.IsNetworked, data.ScriptHostPed, data.P7, data.P8)
    if not Entity:ValidateEntity(handle) then
        return
    end

    Entity:TrackEntity(handle, 'Vehicle')
    Entity:PlaceOnGround(handle, data.Options)
    Entity:SetHeading(handle, data.Options)
    Entity:SetEntityRotation(handle, data.Options)
    Entity:SetPedIntoVehicle(handle, data.Options)

    local netid <const> = Entity:GetNetworkID(handle, data.IsNetworked)
    local instance <const> = Vehicle:New(handle, netid, 'Vehicle', data.Model)

    if not data.Options then
        return instance
    end

    if data.OnCreate then
        data.OnCreate(instance)
    end

    return instance
end

-- support for deleting entities created by this resource
AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end

    for _, handles in pairs(entityTracker) do
        for handle, _ in pairs(handles) do
            if DoesEntityExist(handle) then
                DeleteEntity(handle)
            end
        end
    end

    print('Deleted all entities created by this resource')
end)


return {
    Ped = Ped,
    Object = Object,
    Vehicle = Vehicle
}

--[[ EXAMPLES
local LIB <const> = Import { 'entity' }

local ped = LIB.Ped:Create({
    Model = 'a_c_shep_01',
    Pos = vector3(0, 0, 0),
    IsNetworked = true,
    Options = {
        PlaceOnGround = true,
        OnCreate = function(instance)
            print('Ped created use your own logic here')
        end
    }
})
GetHandle()
ped:DeleteEntity()
]]
