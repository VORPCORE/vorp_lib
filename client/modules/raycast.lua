local CLASS <const> = Import('class').Class --[[@as CLASS]]

local vector3 <const> = vector3
local abs <const> = math.abs
local cos <const> = math.cos
local sin <const> = math.sin
local rad <const> = math.rad

local FLAGS <const> = {
    World = 1,
    Vehicles = 2,
    Peds = 4,
    Ragdolls = 8,
    Objects = 16,
    Pickups = 32,
    Glass = 64,
    Rivers = 128,
    Foliage = 256,
    All = 511
}

---@class RAYCAST_RESULT
---@field public hit boolean
---@field public state integer
---@field public handle integer
---@field public didHit integer
---@field public coords vector3
---@field public normal vector3
---@field public entity integer
---@field public material integer?

local function toVector3(value, label)
    if value == nil then
        error(("raycast: %s is required"):format(label), 3)
    end

    local valueType <const> = type(value)
    if valueType == "vector3" then
        return value
    end

    if valueType ~= "table" then
        error(("raycast: %s must be a vector3 or table, received %s"):format(label, valueType), 3)
    end

    local x <const> = value.x or value[1]
    local y <const> = value.y or value[2]
    local z <const> = value.z or value[3]

    if x == nil or y == nil or z == nil then
        error(("raycast: %s requires x, y and z values"):format(label), 3)
    end

    return vector3(x + 0.0, y + 0.0, z + 0.0)
end

local function rotationToDirection(rotation)
    local pitch <const> = rad(rotation.x)
    local yaw <const> = rad(rotation.z)
    local cosPitch <const> = abs(cos(pitch))

    return vector3(-sin(yaw) * cosPitch, cos(yaw) * cosPitch, sin(pitch))
end

local function buildResult(state, handle, didHit, hitCoords, surfaceNormal, entityHit, materialHash)
    return {
        state = state,
        handle = handle,
        didHit = didHit,
        hit = didHit == 1,
        coords = hitCoords,
        normal = surfaceNormal,
        entity = entityHit,
        material = materialHash
    }
end

local function getShapeTestResult(handle)
    if GetShapeTestResultIncludingMaterial then
        local state, didHit, hitCoords, surfaceNormal, materialHash, entityHit = GetShapeTestResultIncludingMaterial(handle)
        return buildResult(state, handle, didHit, hitCoords, surfaceNormal, entityHit, materialHash)
    end

    local state, didHit, hitCoords, surfaceNormal, entityHit = GetShapeTestResult(handle)
    return buildResult(state, handle, didHit, hitCoords, surfaceNormal, entityHit)
end

---@class RAYCAST
local RaycastClass <const> = CLASS:Create({
    Flags = FLAGS,

    ---@param startCoords vector3 | {x:number, y:number, z:number}
    ---@param endCoords vector3 | {x:number, y:number, z:number}
    ---@param flags integer?
    ---@param ignoreEntity integer?
    ---@param options {traceType?: integer, timeout?: integer, wait?: integer}?
    ---@return RAYCAST_RESULT
    Cast = function(self, startCoords, endCoords, flags, ignoreEntity, options)
        local start <const> = toVector3(startCoords, "startCoords")
        local finish <const> = toVector3(endCoords, "endCoords")
        local mask <const> = flags or self.Flags.All
        local target <const> = ignoreEntity or PlayerPedId()
        local traceType <const> = options?.traceType or 7
        local timeout <const> = options?.timeout or 1000
        local delay <const> = options?.wait or 0

        local handle <const> = StartShapeTestLosProbe(
            start.x, start.y, start.z,
            finish.x, finish.y, finish.z,
            mask,
            target,
            traceType
        )

        local startTime <const> = GetGameTimer()
        local result = getShapeTestResult(handle)

        while result.state == 1 do
            if (GetGameTimer() - startTime) > timeout then
                break
            end

            Wait(delay)
            result = getShapeTestResult(handle)
        end

        return result
    end,

    ---@param distance number?
    ---@param flags integer?
    ---@param ignoreEntity integer?
    ---@param options {offset?: vector3|{x:number,y:number,z:number}, traceType?: integer, timeout?: integer, wait?: integer}?
    ---@return RAYCAST_RESULT
    FromCamera = function(self, distance, flags, ignoreEntity, options)
        local camCoords <const> = GetGameplayCamCoord()
        local camRotation <const> = GetGameplayCamRot(2)
        local direction <const> = rotationToDirection(camRotation)
        local origin <const> = options?.offset and (camCoords + toVector3(options.offset, "options.offset")) or camCoords
        local rayDistance <const> = distance or 10.0
        local destination <const> = origin + (direction * rayDistance)

        return self:Cast(origin, destination, flags, ignoreEntity, options)
    end,

    ---@param entity integer
    ---@param distance number?
    ---@param flags integer?
    ---@param ignoreEntity integer?
    ---@param options {offset?: vector3|{x:number,y:number,z:number}, traceType?: integer, timeout?: integer, wait?: integer}?
    ---@return RAYCAST_RESULT
    FromEntity = function(self, entity, distance, flags, ignoreEntity, options)
        if not entity or not DoesEntityExist(entity) then
            error("raycast: entity does not exist", 2)
        end

        local origin <const> = GetEntityCoords(entity)
        local offset <const> = options?.offset and toVector3(options.offset, "options.offset") or vector3(0.0, 0.0, 0.0)
        local direction <const> = GetEntityForwardVector(entity)
        local rayDistance <const> = distance or 10.0
        local start <const> = origin + offset
        local destination <const> = start + (direction * rayDistance)

        return self:Cast(start, destination, flags, ignoreEntity or entity, options)
    end
}, "RAYCAST")

local Raycast <const> = RaycastClass:New()

return {
    Raycast = Raycast
}
