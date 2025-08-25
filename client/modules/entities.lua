local LIB <const> = Import { 'class' }

print("^3WARNING: ^7module ENTITY is a work in progress use it at your own risk")

---@type table<string, table<integer, integer>> Keep track of entities created
local REGISTERED_ENTITIES <const> = {
    Objects = {},
    Peds = {},
    Vehicles = {}
}

------------------------------------
--* BASE CLASS / SUPERCLASS / PARENT CLASS
--* ENTITY manager
---@class ENTITY
local Entity <const> = LIB.Class:Create({

    ---@Constructor
    constructor = function(self, handle, netid, entityType, model, OnDelete)
        self.handle = handle
        self.netid = netid
        self.entityType = entityType
        self.model = model
        self.OnDelete = OnDelete
    end,

    ---@methods
    set = {

        Delete = function(self)
            if not DoesEntityExist(self.handle) then
                return
            end

            self.OnDelete(self.handle, self.netid)

            if self.netid and NetworkGetEntityIsNetworked(self.handle) then
                TriggerServerEvent('vorp_library:Server:DeleteEntity', self.netid)
            else
                SetEntityAsMissionEntity(self.handle, true, true)
                SetEntityAsNoLongerNeeded(self.handle)
                DeleteEntity(self.handle)
            end
            self:RemoveTrackedEntity(self.handle, self.entityType)
            exports.vorp_lib:UntrackEntity(self.handle, self.entityType)
        end,
    },

    get = {
        GetHandle = function(self)
            return self.handle
        end,

        GetNetId = function(self)
            return self.netid
        end,

        GetModel = function(self)
            return GetEntityModel(self.handle)
        end,

        GetRotation = function(self)
            return GetEntityRotation(self.handle)
        end,

        GetHeading = function(self)
            return GetEntityHeading(self.handle)
        end,

        GetPosition = function(self)
            return GetEntityCoords(self.handle)
        end,
    },

    --local to this resource
    RemoveTrackedEntitiesByHandle = function(_, handle, entityType)
        if not REGISTERED_ENTITIES[entityType] then return error('wrong entity type') end
        REGISTERED_ENTITIES[entityType][handle] = nil
    end,

    --local to this resource
    GetTrackedEntitiesByType = function(_, entityType)
        if not REGISTERED_ENTITIES[entityType] then return error('wrong entity type') end
        return REGISTERED_ENTITIES[entityType]
    end,

    --local to this resource
    GetNumberOfTrackedEntitiesByType = function(_, entityType)
        if not REGISTERED_ENTITIES[entityType] then return error('wrong entity type') end
        return #REGISTERED_ENTITIES[entityType]
    end,

    LoadModel = function(_, data)
        local model = data.Model

        if not IsModelValid(model) then
            error(('Invalid model name or hash: %s'):format(tostring(model)), 2)
        end

        if not HasModelLoaded(model) then
            RequestModel(model, false)
            local startTime = GetGameTimer()
            repeat Wait(0) until HasModelLoaded(model) or (GetGameTimer() - startTime) > 5000

            if (GetGameTimer() - startTime) >= 5000 then
                error(('Failed to load model: %s'):format(tostring(model)), 2)
            end
        end

        local timeout = data.Options?.Timeout
        if not timeout then return end
        SetTimeout(timeout, function()
            SetModelAsNoLongerNeeded(model)
        end)
    end,

    TrackEntity = function(_, handle, entityType)
        if not REGISTERED_ENTITIES[entityType] then return end
        REGISTERED_ENTITIES[entityType][handle] = handle -- as a local to this script
        exports.vorp_lib:TrackEntity(handle, entityType) -- as a global for all scripts
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
        if not data.w then return end
        SetEntityHeading(handle, data.w)
    end,

    SetEntityRotation = function(_, handle, data)
        if not data.Rot?.Pos then return end
        SetEntityRotation(handle, data.Rot.Pos.x, data.Rot.Pos.y, data.Rot.Pos.z, data.Rot.Order or 1, data.Rot.P5 or false)
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

    SetPosition = function(self, pos) -- accepts vector3 vector4 or table with heading as w
        if not pos then return end
        -- position and heading
        if pos.x and pos.w then
            return SetEntityCoordsAndHeading(self.handle, pos.x, pos.y, pos.z, pos.w, false, false, false)
        end

        -- just position
        if pos.x then
            return SetEntityCoords(self.handle, pos.x, pos.y, pos.z, false, false, false, true)
        end

        -- just heading
        if pos.w then
            return SetEntityHeading(self.handle, pos.w)
        end
    end,

})



-----------------------------------
--* DERIVED CLASSES / SUBCLASSES / CHILD CLASSES
--* PEDS
---@class PED : ENTITY
local Ped <const> = LIB.Class:Create(Entity)

function Ped:Create(data)
    Entity:LoadModel(data)

    local handle <const> = CreatePed(data.Model, data.Pos.x, data.Pos.y, data.Pos.z, data.Pos?.w or 0.0, data.IsNetworked, data.ScriptHostPed, data.P7, data.P8)
    if not Entity:ValidateEntity(handle) then
        return
    end

    if data.Options?.OutfitPreset then
        EquipMetaPedOutfitPreset(handle, data.Options?.OutfitPreset)
    else
        SetRandomOutfitVariation(handle, true) -- without this the ped will not be visible
    end

    Entity:TrackEntity(handle, 'Peds')
    Entity:PlaceOnGround(handle, data.Options)

    local netid <const> = Entity:GetNetworkID(handle, data.IsNetworked)
    local instance <const> = Ped:New(handle, netid, 'Ped', data.Model, data?.OnDelete)

    if data.OnCreate then
        data.OnCreate(instance)
    end

    if not data.Options then
        return instance
    end

    return instance
end

------------------------------------
--* DERIVED CLASSES / SUBCLASSES / CHILD CLASSES
--* OBJECTS
---@class OBJECT : ENTITY
local Object <const> = LIB.Class:Create(Entity)

function Object:Create(data)
    Entity:LoadModel(data)

    local handle <const> = CreateObject(data.Model, data.Pos.x, data.Pos.y, data.Pos.z, data.IsNetworked, data.ScriptHostObj, data.Dynamic, data.P7, data.P8)
    if not Entity:ValidateEntity(handle) then
        return
    end

    Entity:TrackEntity(handle, 'Objects')
    Entity:PlaceOnGround(handle, data.Options)
    Entity:SetHeading(handle, data.Pos)
    Entity:SetEntityRotation(handle, data.Options)

    local netid <const> = Entity:GetNetworkID(handle, data.IsNetworked)
    local instance <const> = Object:New(handle, netid, 'Objects', data.Model, data?.OnDelete)


    if data.OnCreate then
        data.OnCreate(instance)
    end

    if not data.Options then
        return instance
    end


    return instance
end

------------------------------------
--* DERIVED CLASSES / SUBCLASSES / CHILD CLASSES
--* VEHICLES
---@class VEHICLE : ENTITY
local Vehicle <const> = LIB.Class:Create(Entity)

function Vehicle:Create(data)
    Entity:LoadModel(data)
    local handle <const> = CreateVehicle(data.Model, data.Pos.x, data.Pos.y, data.Pos.z, data.Pos?.w or 0.0, data.IsNetworked, data.ScriptHostVeh, data.DontAutoCreateDraftAnimals, data.P8)
    if not Entity:ValidateEntity(handle) then
        return
    end

    Entity:TrackEntity(handle, 'Vehicles')
    Entity:PlaceOnGround(handle, data.Options)
    Entity:SetPedIntoVehicle(handle, data.Options)

    local netid <const> = Entity:GetNetworkID(handle, data.IsNetworked)
    local instance <const> = Vehicle:New(handle, netid, 'Vehicles', data.Model, data?.OnDelete)

    if data.OnCreate then
        data.OnCreate(instance)
    end

    if not data.Options then
        return instance
    end

    return instance
end

-- support for deleting entities created by this resource
AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end

    for _, handles in pairs(REGISTERED_ENTITIES) do
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
local LIB <const> = Import 'entities'

local ped = LIB.Ped:Create({
    Model = 'A_C_COW',
    Pos = vector3(2854.6, 486.46, 63.98),
    IsNetworked = true,
    Options = {
        PlaceOnGround = true,
    },
    OnCreate = function(self)
        print('Ped created use your own logic here handle: ', self:GetHandle())
    end,
    OnDelete = function(handle, netid)
        print('Ped deleted handle: ', handle, 'netid: ', netid)
    end
})


]]
