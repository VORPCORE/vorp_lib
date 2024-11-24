--TODO: use the lib class and get streaming module to load the models

--- parent class / Superclass / Parent class
---@class Entity
---@field private New fun(self: Entity, handle: integer, netid: integer, data: table): Entity
---@field private netid integer
---@field private handle integer
---@field private PlaceOnGround fun(self: Entity, data: table)
---@field private TrackEntity fun(handle: integer)
---@field private RemoveTrackedEntity fun(handle: integer)
---@field private GetNetID fun(self: Entity): integer
---@field public GetHandle fun(self: Entity): integer
---@field public DeleteEntity fun(self: Entity)
---@field public LoadModel fun(data: table) static
---@field public GetTrackedEntities fun(): table static
---@field public GetNumberOfTrackedEntities fun(): integer static
local Entity = {}
Entity.__index = Entity
Entity.__call = function()
    return "Entity"
end

--- Derived class / Subclass / Child class
---@class Entity.Ped : Entity
---@field private New fun(self: Entity.Ped, handle: integer, netid: integer, data: table): Entity.Ped
---@field public Create fun(self: Entity.Ped, data: table): Entity.Ped
---@field public SetRandomOutfitVariation fun(self: Entity.Ped, data: table)
---@field public GetHandle fun(self: Entity.Ped): integer
---@field public Delete fun(self: Entity.Ped)
---@field public parent Entity.Ped
Entity.Ped = setmetatable({}, Entity)
Entity.Ped.__index = Entity.Ped

---@class Entity.Object : Entity
---@field private New fun(self: Entity.Object, handle: integer, netid: integer, data: table): Entity.Object
---@field public Create fun(self: Entity.Object, data: table): Entity.Object
---@field public SetEntityRotation fun(self: Entity.Object, data: table)
---@field public GetHandle fun(self: Entity.Object): integer
---@field public Delete fun(self: Entity.Object)
---@field public parent Entity.Object
Entity.Object = setmetatable({}, Entity)
Entity.Object.__index = Entity.Object


---@class Entity.Vehicle : Entity
---@field private New fun(self: Entity.Vehicle, handle:integer, netid: integer, data: table): Entity.Vehicle
---@field public Create fun(self: Entity.Vehicle, data: table): Entity.Vehicle
---@field public Enter fun(self: Entity.Vehicle)
---@field public SetPedIntoVehicle fun(self: Entity.Vehicle, data: table)
---@field public GetHandle fun(self: Entity.Vehicle): integer
---@field public Delete fun(self: Entity.Vehicle)
---@field public parent Entity.Vehicle
Entity.Vehicle = setmetatable({}, Entity)
Entity.Vehicle.__index = Entity.Vehicle

---@type table<integer, integer> Keep track of entities created
local entityTracker = {}
------------------------------------
--* BASE CLASS / SUPERCLASS / PARENT CLASS
function Entity:New(handle, netid, data)
    ---@Constructor
    local properties = { handle = handle, netid = netid }
    local instance = setmetatable(properties, Entity)
    instance:PlaceOnGround(data.Options)
    instance.TrackEntity(handle)
    return instance
end

---@methods
function Entity:GetHandle()
    return self.handle
end

function Entity:GetNetID()
    return self.netid
end

function Entity:PlaceOnGround(data)
    if not data?.PlaceOnGround then return end
    PlaceEntityOnGroundProperly(self.handle, false)
end

--if entity is networked then delete it on the server
function Entity:DeleteNetworkedEntity()
    if self.netid or NetworkDoesNetworkIdExist(self.netid) then
        TriggerServerEvent('vorp_library:Server:DeleteEntity', self.netid)
        self.netid = nil
    end
end

-- does player has control of entity
function Entity:RequestControlOfEntity()
    if NetworkHasControlOfEntity(self.handle) == 1 then return end
    NetworkRequestControlOfEntity(self.handle)
    local startTime = GetGameTimer()
    repeat Wait(0) until NetworkHasControlOfEntity(self.handle) or (GetGameTimer() - startTime) > 2000
    if (GetGameTimer() - startTime) > 2000 then
        error(('Failed to request control of entity: %d'):format(self.handle))
    end
end

function Entity:DeleteEntity()
    if not DoesEntityExist(self.handle) then return end
    self:DeleteNetworkedEntity()
    self:RequestControlOfEntity()
    DeleteEntity(self.handle)
    Entity.RemoveTrackedEntity(self.handle)
    self.handle = nil
end

function Entity:SetHeading(data)
    if not data.Pos?.w then return end
    SetEntityHeading(self.handle, data.Pos.w)
end

------------------------------------
--* STATIC FUNCTIONS
function Entity.LoadModel(data)
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
end

function Entity.TrackEntity(handle)
    -- might need to check if entities are networked or not and have a separated table for networked entities.
    entityTracker[handle] = handle
    -- not sure this is needed since the ids vary from clients.
    -- TriggerEvent('vorp_lib:OnPedCreated', handle) -- listen for the event, note that this entity is only valid for the client who created
end

function Entity.GetTrackedEntities()
    return entityTracker
end

function Entity.GetNumberOfTrackedEntities()
    return #entityTracker
end

function Entity.RemoveTrackedEntity(handle)
    entityTracker[handle] = nil
end

-----------------------------------
--* DERIVED CLASSES / SUBCLASSES / CHILD CLASSES
function Entity.Ped:New(handle, netid, data)
    ---@constructor Entity.Ped
    local properties = { parent = Entity:New(handle, netid, data) }
    return setmetatable(properties, Entity.Ped)
end

--- create ped entity
---@param data table
---@return Entity.Ped
function Entity.Ped:Create(data)
    Entity.LoadModel(data)
    local handle = CreatePed(data.Model, data.Pos.x, data.Pos.y, data.Pos.z, data.Pos?.w or 0.0, data.IsNetworked, data.ScriptHostPed, data.P7, data.P8)
    repeat Wait(0) until DoesEntityExist(handle)
    local netid
    if data.IsNetworked then netid = NetworkGetNetworkIdFromEntity(handle) end
    local instance = Entity.Ped:New(handle, netid, data)
    -- set options if available
    if not data.Options then return instance end
    instance:SetRandomOutfitVariation(data.Options)
    if not data.Options?.Extra then return instance end
    data.Options.Extra(instance)
    return instance
end

--- get entity handle
---@return integer
function Entity.Ped:GetHandle()
    return self.parent:GetHandle()
end

--- set random outfit variation
function Entity.Ped:SetRandomOutfitVariation(data)
    if not data.RandomVaritation then return end
    SetRandomOutfitVariation(self:GetHandle(), true)
end

function Entity.Ped:Delete()
    self.parent:DeleteEntity()
end

--* OBJECTS
function Entity.Object:New(handle, netid, data)
    ---@constructor
    return setmetatable({ parent = Entity:New(handle, netid, data) }, Entity.Object)
end

function Entity.Object:Create(data)
    Entity.LoadModel(data)
    local handle = CreateObject(data.Model, data.Pos.x, data.Pos.y, data.Pos.z, data.IsNetworked, data.ScriptHostPed, data.P7, data.P8)
    repeat Wait(0) until DoesEntityExist(handle)
    local netid
    if data.IsNetworked then netid = NetworkGetNetworkIdFromEntity(handle) end
    local instance = Entity.Object:New(handle, netid, data)
    instance:SetHeading(data)
    if not data.Options then return instance end
    if not data.Options?.Extra then return instance end
    data.Options.Extra(instance)
    return instance
end

function Entity.Object:GetHandle()
    return self.parent:GetHandle()
end

function Entity.Object:SetEntityRotation(data)
    SetEntityRotation(self:GetHandle(), data.Rot.x, data.Rot.y, data.Rot.z, data.Rot.Order or 1, data.Rot.P5)
end

function Entity.Object:Delete()
    self.parent:DeleteEntity()
end

--* VEHICLES
function Entity.Vehicle:New(handle, netid, data)
    ---@constructor
    local properties = { parent = Entity:New(handle, netid, data) }
    return setmetatable(properties, Entity.Vehicle)
end

function Entity.Vehicle:Create(data)
    Entity.LoadModel(data)
    local handle = CreateVehicle(data.Model, data.Pos.x, data.Pos.y, data.Pos.z, data.Pos?.w or 0.0, data.IsNetworked, data.ScriptHostPed, data.P7, data.P8)
    repeat Wait(0) until DoesEntityExist(handle)
    local netid
    if data.IsNetworked then netid = NetworkGetNetworkIdFromEntity(handle) end
    local instance = Entity.Vehicle:New(handle, netid, data)
    if not data.Options then return instance end
    instance:SetPedIntoVehicle(data.Options)
    if not data.Options?.Extra then return instance end
    data.Options.Extra(instance)
    return instance
end

function Entity.Vehicle:GetHandle()
    return self.parent:GetHandle()
end

function Entity.Vehicle:SetPedIntoVehicle(data)
    SetPedIntoVehicle(data.Seat?.Ped or PlayerPedId(), self:GetHandle(), data.Seat?.Index or -1)
end

function Entity.Vehicle:Delete()
    self.parent:DeleteEntity()
end

-- support for deleting entities created by this resource
AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end

    for key, value in pairs(entityTracker) do
        if DoesEntityExist(value) then
            DeleteEntity(value)
        end
    end

    if not next(entityTracker) then return end
    print('Deleted all entities created by this resource')
end)


return {
    Ped = Entity.Ped,
    Object = Entity.Object,
    Vehicle = Entity.Vehicle
}
