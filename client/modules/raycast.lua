local CLASS <const>                       = Import('class').Class --[[@as CLASS]]

local vector3                             = vector3
local abs                                 = math.abs
local cos                                 = math.cos
local sin                                 = math.sin
local rad                                 = math.rad
local GetGameTimer                        = GetGameTimer
local Wait                                = Wait
local StartShapeTestLosProbe              = StartShapeTestLosProbe
local GetShapeTestResultIncludingMaterial = GetShapeTestResultIncludingMaterial
local GetGameplayCamCoord                 = GetGameplayCamCoord
local GetGameplayCamRot                   = GetGameplayCamRot
local DoesEntityExist                     = DoesEntityExist
local GetEntityCoords                     = GetEntityCoords
local GetEntityForwardVector              = GetEntityForwardVector

local FLAGS <const>                       = {
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

local function rotationToDirection(rotation)
    local pitch <const> = rad(rotation.x)
    local yaw <const> = rad(rotation.z)
    local cosPitch <const> = abs(cos(pitch))

    return vector3(-sin(yaw) * cosPitch, cos(yaw) * cosPitch, sin(pitch))
end

local function getShapeTestResult(handle)
    local state <const>, didHit <const>, hitCoords <const>, surfaceNormal <const>, materialHash <const>, entityHit <const> = GetShapeTestResultIncludingMaterial(handle)
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

---@class RAYCAST
local RaycastClass <const> = CLASS:Create({
    _Cast = function(self, startCoords, endCoords, flags, ignoreEntity, options)
        local start <const> = vector3(startCoords.x, startCoords.y, startCoords.z)
        local finish <const> = vector3(endCoords.x, endCoords.y, endCoords.z)
        flags = FLAGS[flags] or FLAGS.World
        local target <const> = ignoreEntity or PlayerPedId()
        local traceType <const> = options?.traceType or 7
        local timeout <const> = options?.timeout or 1000
        local delay <const> = options?.wait or 0

        local handle <const> = StartShapeTestLosProbe(start.x, start.y, start.z, finish.x, finish.y, finish.z, flags, target, traceType)

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

    FromCamera = function(self, distance, flags, ignoreEntity, options)
        local camCoords <const> = GetGameplayCamCoord()
        local camRotation <const> = GetGameplayCamRot(2)
        local direction <const> = rotationToDirection(camRotation)
        local origin <const> = options?.offset and (camCoords + vector3(options.offset.x, options.offset.y, options.offset.z)) or camCoords
        local rayDistance <const> = distance or 10.0
        local destination <const> = origin + (direction * rayDistance)

        return self:_Cast(origin, destination, flags, ignoreEntity, options)
    end,

    FromEntity = function(self, entity, distance, flags, ignoreEntity, options)
        if not DoesEntityExist(entity) then
            error("raycast: entity does not exist", 2)
        end

        local origin <const> = GetEntityCoords(entity)
        local offset <const> = options?.offset and vector3(options.offset.x, options.offset.y, options.offset.z) or vector3(0.0, 0.0, 0.0)
        local direction <const> = GetEntityForwardVector(entity)
        local rayDistance <const> = distance or 10.0
        local start <const> = origin + offset
        local destination <const> = start + (direction * rayDistance)

        return self:_Cast(start, destination, flags, ignoreEntity or entity, options)
    end
}, "RAYCAST")

local Raycast <const> = RaycastClass:New()

return {
    Raycast = Raycast
}
