local LIB <const> = Import 'class'

print("^3WARNING: ^7module POINTS is a work in progress use it at your own risk")

---@class POINTS
local Points = {}

local REGISTERED_POINTS <const> = {}

local GetEntityCoords <const> = GetEntityCoords
local Wait <const> = Wait

local points <const> = LIB.Class:Create({

    constructor = function(self, data)
        self.points = data.Arguments
        self.onEnter = data.OnEnter
        self.onExit = data.OnExit
        self.isRegistered = false
        self.isActive = false
    end,

    set = {

        -- add ids as keys for the points
        sortPoints = function(self)
            local sortedPoints = {}
            for _, point in ipairs(self.points) do
                sortedPoints[point.id] = point

                if point.debug and not self.debugActive then
                    self:DebugPoints()
                end
            end
            self.points = sortedPoints
        end,

        -- update points by id
        UpdatePoint = function(self, id, data)
            local point = self.points[id]
            if point then
                point = data
            end
        end,

        RemovePoint = function(self, id)
            local point = self.points[id]
            if point then
                point = nil
            end
        end,

        PausePoint = function(self, id)
            local point = self.points[id]
            if point then
                point.deActivate = true
            end
        end,

        ResumePoint = function(self, id)
            local point = self.points[id]
            if point then
                point.deActivate = false
            end
        end,


        DebugPoints = function(self)
            if self.debugActive then return end
            self.debugActive = true

            CreateThread(function()
                while self.debugActive do
                    for _, point in pairs(self.points) do
                        if point.debug and not point.deActivate then
                            DrawMarker(
                                0x94FDAE17,
                                point.center.x, point.center.y, -320.0,
                                0.0, 0.0, 0.0,
                                0.0, 0.0, 0.0,
                                point.radius * 2.0, point.radius * 2.0, 400.0,
                                0, 255, 0, 255,
                                false, false, 2, nil, nil,
                                false, false
                            )
                        end
                    end
                    Wait(0)
                end
            end)
        end,

        Start = function(self)
            if self.isActive then return print('already active') end
            self.isActive = true

            if self.isRegistered then return print('already registered') end
            self.isRegistered = true

            self:sortPoints()

            CreateThread(function()
                while self.isActive do
                    local playerCoords <const> = GetEntityCoords(PlayerPedId())

                    for _, point in pairs(self.points) do
                        local distance <const> = #(playerCoords - point.center)
                        if not point.deActivate then
                            if distance <= point.radius then
                                if not point.hasEntered then
                                    point.hasEntered = true
                                    self.onEnter(point, distance)
                                end
                            else
                                if point.hasEntered then
                                    point.hasEntered = false
                                    self.onExit(point, distance)
                                end
                            end
                        end
                    end
                    Wait(self.points?.wait or 500)
                end
            end)
        end,


        Pause = function(self)
            if not self.isActive then return print('its not active to pause it') end
            self.isActive = false
        end,

        Resume = function(self)
            if self.isActive then return print('its already active to resume it') end
            self.isActive = false
            self.isRegistered = false
            self:Start()
        end,

        Destroy = function(self)
            self.isActive = nil
            self.isRegistered = nil
            self.points = {}
            self = nil -- does it actually destroy the instance ?
        end,
    },

    get = {
        IsPointActive = function(self, id)
            return not self.points[id]?.deActivate
        end,

        IsPointInside = function(self, id)
            return self.points[id]?.hasEntered
        end,

        IsPointOutside = function(self, id)
            return not self.points[id]?.hasEntered
        end,
    },

    OnEnter = function(self, point, distance)
        self.onEnter(point, distance)
    end,

    OnExit = function(self, point)
        self.onExit(point)
    end

})


function Points:Register(data, state)
    local instance <const> = points:New(data)
    if state then
        instance:Start()
    end

    REGISTERED_POINTS[#REGISTERED_POINTS + 1] = instance
    return instance
end

--CLEAN UP
AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then
        return
    end
    print("^3CLEANUP^7 cleaning up all registered points")
    for _, self in ipairs(REGISTERED_POINTS) do
        self:Destroy()
    end
end)

return {
    Points = Points
}


-- points are in a radius

--example
--[[
local LIB <const> = Import 'points'

local point = LIB.Points:Register({
    Arguments = {
        {
            id = 'point',                             -- unique id for the point
            center = vector3(2843.49, 474.49, 64.03), -- must be vector3
            radius = 15.0,
            wait = 500,                               --ms optional
            debug = true,                             --optional
            deActivate = true,                        --optional if you dont want this point to be active now you can activate it later
        },
        {
            id = 'point2',                            -- unique id for the point
            center = vector3(2884.03, 484.19, 66.73), -- must be vector3
            radius = 10.0,
            wait = 500,                               --ms optional
            debug = true,                             --optional
        },
    },

    OnEnter = function(point, distance)
        print("enter", point.id, distance)
    end,

    OnExit = function(point)
        print('exit', point.id)
    end
}, true) -- starts right away if true

--check is activated
RegisterCommand('check', function()
    print(point:IsPointActive('point2'))
end, false)

--pause
RegisterCommand('pause', function()
    point:Pause()
end, false)

--isinside
RegisterCommand('isinside', function()
    print(point:IsPointInside('point2'))
end, false)

--isinside
RegisterCommand('isoutside', function()
    print(point:IsPointOutside('point2'))
end, false)

-- isexited

RegisterNetEvent('vorp:SelectedCharacter', function()
    if not point then return end
    point:Start()
end)

--OPTIONAL
point:OnEnter(function(self)
    print(self.args.id)
end)

point:OnExit(function(self)
    print(self.args.id)
end) ]]

-- Point:Resume()
-- Point:Pause()
-- Point:Remove()
-- Point:Destroy()
-- Point:Start()
