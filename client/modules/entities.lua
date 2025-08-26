local LIB <const> = Import  'class' 

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
    constructor = function(self, entityType, data)
        self.model = data.Model
        ---@private
        self._entityType = entityType

        self:_LoadModel(data)

        if self._entityType == 'Peds' then
            self.handle = CreatePed(data.Model, data.Pos.x, data.Pos.y, data.Pos.z, data.Pos?.w or 0.0, data.IsNetworked, data.ScriptHostPed, data.P7, data.P8)
        elseif self._entityType == 'Objects' then
            self.handle = CreateObject(data.Model, data.Pos.x, data.Pos.y, data.Pos.z, data.IsNetworked, data.ScriptHostObj, data.Dynamic, data.P7, data.P8)
            self:_SetHeading(data.Pos)
        elseif self._entityType == 'Vehicles' then
            self.handle = CreateVehicle(data.Model, data.Pos.x, data.Pos.y, data.Pos.z, data.Pos?.w or 0.0, data.IsNetworked, data.ScriptHostVeh, data.DontAutoCreateDraftAnimals, data.P8)
        end

        if not self:_ValidateEntity() then
            return print(('Failed to create entity, pool full? entity type: %s handle: %s is networked: %s'):format(self._entityType, self.handle, data.IsNetworked))
        end

        self:_PlaceOnGround(data.Options)
        self:_SetEntityRotation(data.Options)
        self:_SetPedIntoVehicle(data.Options)

        self:_TrackEntity()

        if data.IsNetworked then
            self.netid = NetworkGetNetworkIdFromEntity(self.handle)
        end

        self.OnDelete = data?.OnDelete

        if data.OnCreate then
            data.OnCreate(self)
        end
    end,

    ---@methods
    -- public setters
    set = {

        Delete = function(self)
            if not DoesEntityExist(self.handle) then
                return
            end

            if self.OnDelete then
                self.OnDelete(self.handle, self.netid)
            end

            if self.netid and NetworkGetEntityIsNetworked(self.handle) then
                TriggerServerEvent('vorp_library:Server:DeleteEntity', self.netid)
            else
                SetEntityAsMissionEntity(self.handle, true, true)
                SetEntityAsNoLongerNeeded(self.handle)
                DeleteEntity(self.handle)
            end

            self:_RemoveTrackedEntity()
            exports.vorp_lib:UntrackEntity(self.handle, self._entityType)

            self.OnDelete = nil
            self.handle = nil
            self.netid = nil
            self.model = nil
            self._entityType = nil
        end,

        SetPosition = function(self, pos) -- accepts vector3 vector4 or table with heading as w
            if not pos then return end

            if pos.x and pos.w then
                return SetEntityCoordsAndHeading(self.handle, pos.x, pos.y, pos.z, pos.w, false, false, false)
            end

            if pos.x then
                return SetEntityCoords(self.handle, pos.x, pos.y, pos.z, false, false, false, true)
            end

            if pos.w then
                return SetEntityHeading(self.handle, pos.w)
            end
        end,
    },

    -- public methods
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

    ---@private methods
    _RemoveTrackedEntity = function(self)
        if not REGISTERED_ENTITIES[self._entityType] then return end
        REGISTERED_ENTITIES[self._entityType][self.handle] = nil
    end,

    _GetTrackedEntitiesByType = function(self)
        if not REGISTERED_ENTITIES[self._entityType] then return end
        return REGISTERED_ENTITIES[self._entityType]
    end,

    _GetNumberOfTrackedEntitiesByType = function(self)
        if not REGISTERED_ENTITIES[self._entityType] then return end
        return #REGISTERED_ENTITIES[self._entityType]
    end,

    _LoadModel = function(self, data)
        local model = self.model

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

        local timeout = data?.Options?.Timeout
        if not timeout then return end
        SetTimeout(timeout, function()
            SetModelAsNoLongerNeeded(model)
        end)
    end,

    _TrackEntity = function(self)
        if not REGISTERED_ENTITIES[self._entityType] then return end
        REGISTERED_ENTITIES[self._entityType][self.handle] = self.handle -- as a local to this script
        exports.vorp_lib:TrackEntity(self.handle, self._entityType)      -- as a global for all scripts
    end,

    _ValidateEntity = function(self)
        if self.handle == 0 then return false end

        local startTime <const> = GetGameTimer()
        repeat Wait(0) until DoesEntityExist(self.handle) or (GetGameTimer() - startTime) > 5000
        if (GetGameTimer() - startTime) > 5000 then
            print('Failed to create entity, pool full?')
            return false
        end

        return true
    end,


    _SetHeading = function(self, data)
        if not data.w then return end
        SetEntityHeading(self.handle, data.w)
    end,

    _SetEntityRotation = function(self, data)
        if not data.Rot?.Pos then return end
        SetEntityRotation(self.handle, data.Rot.Pos.x, data.Rot.Pos.y, data.Rot.Pos.z, data.Rot.Order or 1, data.Rot.P5 or false)
    end,

    _SetPedIntoVehicle = function(self, data)
        local ped = data.Seat?.Ped or PlayerPedId()
        local seat = data.Seat?.Index or -1
        SetPedIntoVehicle(ped, self.handle, seat)
    end,

    _PlaceOnGround = function(self, data)
        if not data?.PlaceOnGround then return end
        PlaceEntityOnGroundProperly(self.handle, false)
    end,
})


-----------------------------------
--* DERIVED CLASSES / SUBCLASSES / CHILD CLASSES
--* PEDS
---@class PED : ENTITY
local Ped <const> = LIB.Class:Create(Entity)

function Ped:Create(data)
    local instance <const> = Ped:New('Peds', data)

    if not data.Options then
        SetRandomOutfitVariation(instance.handle, true) -- without this the ped will not be visible
        return instance
    else
        if data.Options?.OutfitPreset then
            EquipMetaPedOutfitPreset(instance.handle, data.Options?.OutfitPreset,true)
        else
            SetRandomOutfitVariation(instance.handle, true)
        end
    end

    return instance
end

------------------------------------
--* DERIVED CLASSES / SUBCLASSES / CHILD CLASSES
--* OBJECTS
---@class OBJECT : ENTITY
local Object <const> = LIB.Class:Create(Entity)

function Object:Create(data)
    return Object:New('Objects', data)
end

------------------------------------
--* DERIVED CLASSES / SUBCLASSES / CHILD CLASSES
--* VEHICLES
---@class VEHICLE : ENTITY
local Vehicle <const> = LIB.Class:Create(Entity)

function Vehicle:Create(data)
    return Vehicle:New('Vehicles', data)
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
