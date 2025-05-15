local LIB <const> = Import 'class'

local Points <const> = LIB.Class:Create({

    constructor = function(self, data)
        self.args = data.Arguments
        self.onEnter = data.OnEnter
        self.onExit = data.OnExit
        self.isRegistered = false
        self.isActive = false
        self.hasEntered = false
        self.hasExited = false
    end,

    set = {

        Start = function(self)
            if self.isActive then return print('already active') end
            self.isActive = true

            if self.isRegistered then return print('already registered') end
            self.isRegistered = true

            CreateThread(function()
                while self.isActive do
                    local playerCoords <const> = GetEntityCoords(PlayerPedId())
                    local distance <const> = #(playerCoords - self.args.coords)
                    if distance <= self.args.distance then
                        if not self.hasEntered then
                            self.onEnter(self, distance)
                            self.hasEntered = true
                        end
                    else
                        if self.hasEntered then
                            self.onExit(self)
                            self.hasEntered = false
                        end
                    end
                    Wait(self.args?.wait or 500)
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
            self.isActive = false
            self.isRegistered = false
            self.hasEntered = false
            self.hasExited = false
            self = nil -- does it actually destroy the instance ?
        end,

        UpdateCoords = function(self, coords)
            self.args.coords = coords
        end,

        UpdateDistance = function(self, distance)
            self.args.distance = distance
        end,


    },

    OnEnter = function(self)
        self.onEnter(self)
    end,

    OnExit = function(self)
        self.onExit(self)
    end

})

function Points:Register(data, state)
    local instance <const> = Points:New(data)
    if state then
        instance:Start()
    end
    return instance
end

return {
    Points = Points
}

--example

--[[ local LIB <const> = Import 'points'

local point = LIB.Points:Register({
    Arguments = {
        id = 'point', -- in case we add multiple points we can identify them ?
        coords = vector3(0, 0, 0),
        distance = 10.0,
        wait = 500, --ms
    },

    OnEnter = function(self, points)
        print(points)
    end,
    OnExit = function(self)
        print('exit')
    end
}, true) --start right away ? best to wait on char select ?

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
