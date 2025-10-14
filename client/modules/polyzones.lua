local CLASS <const> = Import('class').Class --[[@as CLASS]]

local PlayerPedId <const> = PlayerPedId
local GetEntityCoords <const> = GetEntityCoords
local DrawLine <const> = DrawLine
local Wait <const> = Wait
local GetGameTimer <const> = GetGameTimer
local vector3 <const> = vector3

local math <const> = math
local cos <const> = math.cos
local sin <const> = math.sin
local abs <const> = math.abs

local DEBUG_COLOR <const> = { r = 255, g = 215, b = 0, a = 200 }
local DEBUG_HEIGHT <const> = 2.0

---@class POLYZONES
local PolyZones = {}

local REGISTERED_ZONES <const> = {}

local function toVector3(value, fallbackZ)
    if value == nil then
        error("polyzone: expected vector3, got nil")
    end

    local valueType <const> = type(value)
    if valueType == "vector3" then
        return value
    end

    if valueType ~= "table" then
        error(("polyzone: expected table or vector3, received %s"):format(valueType))
    end

    local x = value.x or value[1]
    local y = value.y or value[2]
    local z = value.z or value[3] or fallbackZ or 0.0

    assert(x and y, "polyzone: vector3 definition requires x and y")

    return vector3(x + 0.0, y + 0.0, z + 0.0)
end

local function clonePoints(points, defaultZ)
    local buffer <const> = {}
    for i = 1, #points do
        buffer[i] = toVector3(points[i], defaultZ)
    end
    return buffer
end

local function pointInPolygon(point, polygon)
    local px <const> = point.x
    local py <const> = point.y

    local inside = false
    local j = #polygon

    for i = 1, #polygon do
        local vertex <const> = polygon[i]
        local previous <const> = polygon[j]

        local cond = (vertex.y > py) ~= (previous.y > py)
        if cond then
            local yDelta <const> = previous.y - vertex.y
            if yDelta ~= 0.0 then
                local ratio <const> = (py - vertex.y) / yDelta
                local intersection <const> = vertex.x + ratio * (previous.x - vertex.x)
                if px < intersection then
                    inside = not inside
                end
            end
        end
        j = i
    end

    return inside
end

local function pointInBox(point, center, length, width, heading)
    local offset <const> = point - center
    local rad <const> = math.rad(heading)

    local localX <const> = cos(rad) * offset.x + sin(rad) * offset.y
    local localY <const> = -sin(rad) * offset.x + cos(rad) * offset.y

    return abs(localX) <= width * 0.5 and abs(localY) <= length * 0.5
end

local zone <const> = CLASS:Create({

    constructor = function(self, data)
        self.id = data.id or ("polyzone_%s"):format(GetGameTimer())
        self.zoneType = (data.type or "poly"):lower()
        self.sleep = data.sleep or 200
        self.sleepInside = data.sleepInside or 1
        self.debug = data.debug or false
        self.padding = data.padding or 1.5
        self.minZ = data.minZ
        self.maxZ = data.maxZ
        self.onEnter = data.onEnter or function() end
        self.onExit = data.onExit or function() end
        self.onInside = data.onInside
        self.debugThread = nil

        self:InitialiseShape(data)
        self.isActive = false
        self.isInside = false
    end,

    get = {
        GetId = function(self)
            return self.id
        end,

        GetType = function(self)
            return self.zoneType
        end,

        IsRunning = function(self)
            return self.isActive
        end,

        IsInside = function(self)
            return self.isInside
        end,
    },

    set = {
        SetCallbacks = function(self, cbEnter, cbExit, cbInside)
            if cbEnter then
                self.onEnter = cbEnter
            end
            if cbExit then
                self.onExit = cbExit
            end
            if cbInside then
                self.onInside = cbInside
            end
        end,

        UpdatePolygon = function(self, newPoints)
            assert(self.zoneType == "poly", "UpdatePolygon is only valid for polygon zones")
            self.points = clonePoints(newPoints, self.minZ or self.maxZ)
            self.center = self:CalculateCentroid(self.points)
            self:ComputeBounds()
        end,

        UpdateCircle = function(self, center, radius)
            assert(self.zoneType == "circle", "UpdateCircle is only valid for circle zones")
            self.center = toVector3(center, self.center and self.center.z or 0.0)
            self.radius = radius
            self:ComputeBounds()
        end,

        UpdateBox = function(self, center, length, width, heading)
            assert(self.zoneType == "box", "UpdateBox is only valid for box zones")
            self.center = toVector3(center, self.center and self.center.z or 0.0)
            self.length = length
            self.width = width
            self.heading = heading or self.heading or 0.0
            self:ComputeBounds()
        end,

        SetHeight = function(self, minZ, maxZ)
            self.minZ = minZ
            self.maxZ = maxZ
        end,

        SetDebug = function(self, enabled)
            self.debug = enabled
            if enabled and self.isActive then
                self:StartDebugLoop()
            end
        end,

        SetTickRates = function(self, outsideMs, insideMs)
            if outsideMs then
                self.sleep = outsideMs
            end
            if insideMs ~= nil then
                self.sleepInside = insideMs
            end
        end,

        Start = function(self)
            if self.isActive then return end
            self.isActive = true
            if self.debug then
                self:StartDebugLoop()
            end

            CreateThread(function()
                while self.isActive do
                    local ped <const> = PlayerPedId()
                    local coords <const> = GetEntityCoords(ped)

                    local inside = false
                    if self:WithinHeight(coords) and self:WithinRadius(coords) then
                        inside = self:IsInside(coords)
                    end

                    if inside then
                        if not self.isInside then
                            self.isInside = true
                            self.onEnter(self, coords)
                        elseif self.onInside then
                            self.onInside(self, coords)
                        end
                    else
                        if self.isInside then
                            self.isInside = false
                            self.onExit(self, coords)
                        end
                    end

                    local waitTime = inside and self.sleepInside or self.sleep
                    Wait(waitTime)
                end
            end)
        end,

        Pause = function(self)
            if not self.isActive then return end
            self.isActive = false
        end,

        Resume = function(self)
            if self.isActive then return end
            self:Start()
        end,

        Destroy = function(self)
            self.isActive = false
            self.isInside = false
            self.debug = false
            self.debugThread = nil
            self.points = nil
            self.center = nil
            self.sleep = nil
            self.sleepInside = nil
        end,
    },

    InitialiseShape = function(self, data)
        if self.zoneType == "poly" then
            assert(data.points and #data.points >= 3, "polyzone: polygon requires at least 3 points")
            self.points = clonePoints(data.points, data.minZ or data.maxZ or (data.center and data.center.z))
            self.center = data.center and toVector3(data.center, data.minZ) or self:CalculateCentroid(self.points)
        elseif self.zoneType == "circle" then
            self.center = toVector3(data.center, data.minZ or data.maxZ)
            self.radius = data.radius or data.size
            assert(self.radius, "polyzone: circle requires a radius")
        elseif self.zoneType == "box" then
            self.center = toVector3(data.center, data.minZ or data.maxZ)
            self.length = data.length or (data.size and (data.size.y or data.size[2]))
            self.width = data.width or (data.size and (data.size.x or data.size[1]))
            self.heading = data.heading or 0.0
            assert(self.length and self.width, "polyzone: box requires length and width")
        else
            error(("polyzone: zone type '%s' not supported"):format(self.zoneType))
        end

        self:ComputeBounds()
    end,

    ComputeBounds = function(self)
        if self.zoneType == "circle" then
            self.boundRadius = self.radius
        elseif self.zoneType == "box" then
            local halfLength <const> = self.length * 0.5
            local halfWidth <const> = self.width * 0.5
            self.boundRadius = (halfLength ^ 2 + halfWidth ^ 2) ^ 0.5
        else
            local center <const> = self.center
            local maxDistance = 0.0
            for _, point in ipairs(self.points) do
                local distance <const> = #(point - center)
                if distance > maxDistance then
                    maxDistance = distance
                end
            end
            self.boundRadius = maxDistance
        end
    end,

    CalculateCentroid = function(_, points)
        local area = 0.0
        local cx = 0.0
        local cy = 0.0

        local count <const> = #points
        for i = 1, count do
            local current <const> = points[i]
            local nextIndex <const> = (i % count) + 1
            local nextPoint <const> = points[nextIndex]

            local cross <const> = (current.x * nextPoint.y) - (nextPoint.x * current.y)
            area = area + cross
            cx = cx + (current.x + nextPoint.x) * cross
            cy = cy + (current.y + nextPoint.y) * cross
        end

        area = area * 0.5
        if area == 0.0 then
            return points[1]
        end

        local factor <const> = 1 / (6 * area)
        local centroidX <const> = cx * factor
        local centroidY <const> = cy * factor

        return vector3(centroidX, centroidY, points[1].z)
    end,

    WithinHeight = function(self, coords)
        if self.minZ and coords.z < self.minZ then
            return false
        end
        if self.maxZ and coords.z > self.maxZ then
            return false
        end
        return true
    end,

    WithinRadius = function(self, coords)
        if not self.boundRadius or not self.center then
            return true
        end
        local distance <const> = #(coords - self.center)
        return distance <= (self.boundRadius + self.padding)
    end,

    IsInside = function(self, coords)
        if self.zoneType == "circle" then
            return #(coords - self.center) <= self.radius
        end

        if self.zoneType == "box" then
            return pointInBox(coords, self.center, self.length, self.width, self.heading)
        end

        return pointInPolygon(coords, self.points)
    end,

    StartDebugLoop = function(self)
        if self.debugThread then
            return
        end

        self.debugThread = CreateThread(function()
            while self.isActive and self.debug do
                self:DrawDebug()
                Wait(0)
            end
            self.debugThread = nil
        end)
    end,

    DrawDebug = function(self)
        local color <const> = DEBUG_COLOR
        if self.zoneType == "circle" then
            local segments = 32
            local increment <const> = (math.pi * 2.0) / segments
            local minZ = self.minZ or self.center.z
            local maxZ = self.maxZ or (self.center.z + DEBUG_HEIGHT)
            for i = 0, segments - 1 do
                local angle <const> = i * increment
                local nextAngle <const> = (i + 1) * increment
                local pointA <const> = vector3(
                    self.center.x + (self.radius * cos(angle)),
                    self.center.y + (self.radius * sin(angle)),
                    minZ
                )
                local pointB <const> = vector3(
                    self.center.x + (self.radius * cos(nextAngle)),
                    self.center.y + (self.radius * sin(nextAngle)),
                    minZ
                )
                DrawLine(pointA, pointB, color.r, color.g, color.b, color.a)
                DrawLine(pointA + vector3(0.0, 0.0, maxZ - minZ), pointB + vector3(0.0, 0.0, maxZ - minZ), color.r, color.g, color.b, color.a)
                DrawLine(pointA, pointA + vector3(0.0, 0.0, maxZ - minZ), color.r, color.g, color.b, color.a)
            end
            return
        end

        if self.zoneType == "box" then
            local minZ = self.minZ or self.center.z
            local maxZ = self.maxZ or (self.center.z + DEBUG_HEIGHT)
            local halfL <const> = self.length * 0.5
            local halfW <const> = self.width * 0.5
            local rad <const> = math.rad(self.heading)
            local c <const> = cos(rad)
            local s <const> = sin(rad)

            local corners <const> = {}
            corners[1] = vector3(self.center.x + (c * halfW) - (s * halfL), self.center.y + (s * halfW) + (c * halfL), minZ)
            corners[2] = vector3(self.center.x + (c * halfW) + (s * halfL), self.center.y + (s * halfW) - (c * halfL), minZ)
            corners[3] = vector3(self.center.x - (c * halfW) + (s * halfL), self.center.y - (s * halfW) - (c * halfL), minZ)
            corners[4] = vector3(self.center.x - (c * halfW) - (s * halfL), self.center.y - (s * halfW) + (c * halfL), minZ)

            for i = 1, 4 do
                local nextIndex <const> = (i % 4) + 1
                local lowA <const> = corners[i]
                local lowB <const> = corners[nextIndex]
                local highA <const> = lowA + vector3(0.0, 0.0, maxZ - minZ)
                local highB <const> = lowB + vector3(0.0, 0.0, maxZ - minZ)

                DrawLine(lowA, lowB, color.r, color.g, color.b, color.a)
                DrawLine(highA, highB, color.r, color.g, color.b, color.a)
                DrawLine(lowA, highA, color.r, color.g, color.b, color.a)
            end
            return
        end

        local minZ = self.minZ or (self.points[1] and self.points[1].z) or 0.0
        local maxZ = self.maxZ or (minZ + DEBUG_HEIGHT)

        for i = 1, #self.points do
            local current <const> = self.points[i]
            local nextPoint <const> = self.points[(i % #self.points) + 1]

            local lowA <const> = vector3(current.x, current.y, minZ)
            local lowB <const> = vector3(nextPoint.x, nextPoint.y, minZ)
            local highA <const> = vector3(current.x, current.y, maxZ)
            local highB <const> = vector3(nextPoint.x, nextPoint.y, maxZ)

            DrawLine(lowA, lowB, color.r, color.g, color.b, color.a)
            DrawLine(highA, highB, color.r, color.g, color.b, color.a)
            DrawLine(lowA, highA, color.r, color.g, color.b, color.a)
        end
    end,
})

local function removeZone(instance)
    for index, registered in ipairs(REGISTERED_ZONES) do
        if registered == instance then
            table.remove(REGISTERED_ZONES, index)
            break
        end
    end
end

function PolyZones:Register(data, state)
    local instance <const> = zone:New(data)
    REGISTERED_ZONES[#REGISTERED_ZONES + 1] = instance

    if state then
        instance:Start()
    end

    return instance
end

function PolyZones:Destroy(instance)
    if instance then
        instance:Destroy()
        removeZone(instance)
    end
end

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then
        return
    end

    print("^3CLEANUP^7 cleaning up polyzones")
    for index = #REGISTERED_ZONES, 1, -1 do
        local instance <const> = REGISTERED_ZONES[index]
        if instance then
            instance:Destroy()
            REGISTERED_ZONES[index] = nil
        end
    end
end)

return {
    PolyZones = PolyZones
}
