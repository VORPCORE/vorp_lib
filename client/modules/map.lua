local LIB <const>          = Import 'class'

---@type table<number, Blip>
local blipsTracker <const> = {}
local blipColors <const>   = {
    blue = "BLIP_MODIFIER_MP_COLOR_1",
    red = "BLIP_MODIFIER_MP_COLOR_2",
    purple = "BLIP_MODIFIER_MP_COLOR_3",
    orange = "BLIP_MODIFIER_MP_COLOR_4",
    aqua = "BLIP_MODIFIER_MP_COLOR_5",
    yellow = "BLIP_MODIFIER_MP_COLOR_6",
    pink = "BLIP_MODIFIER_MP_COLOR_7",
    green = "BLIP_MODIFIER_MP_COLOR_8",
    brown = "BLIP_MODIFIER_MP_COLOR_9", -- needs finish up the rest
    lightgreen = "BLIP_MODIFIER_MP_COLOR_10",
    turquoise = "BLIP_MODIFIER_MP_COLOR_11",
    lightpurple = "BLIP_MODIFIER_MP_COLOR_12",
    lightblue2 = "BLIP_MODIFIER_MP_COLOR_13",
    lightorange = "BLIP_MODIFIER_MP_COLOR_14",
    lightred = "BLIP_MODIFIER_MP_COLOR_15",
    lightpink = "BLIP_MODIFIER_MP_COLOR_16",
    lightgray = "BLIP_MODIFIER_MP_COLOR_17",
    black = "BLIP_MODIFIER_MP_COLOR_18",
    darkred = "BLIP_MODIFIER_MP_COLOR_19",
    darkgreen = "BLIP_MODIFIER_MP_COLOR_20",
    darkblue = "BLIP_MODIFIER_MP_COLOR_21",
    darkyellow = "BLIP_MODIFIER_MP_COLOR_22",
    darkpurple = "BLIP_MODIFIER_MP_COLOR_23",
    darklightblue = "BLIP_MODIFIER_MP_COLOR_24",
    darkwhite = "BLIP_MODIFIER_MP_COLOR_25",
    darkgray = "BLIP_MODIFIER_MP_COLOR_26",
    darkbrown = "BLIP_MODIFIER_MP_COLOR_27",
    darklightgreen = "BLIP_MODIFIER_MP_COLOR_28",
    darklightyellow = "BLIP_MODIFIER_MP_COLOR_29",
    darklightpurple = "BLIP_MODIFIER_MP_COLOR_30",
    lightyellow = "BLIP_MODIFIER_MP_COLOR_31",
    white = "BLIP_MODIFIER_MP_COLOR_32",
}

--* BASE CLASS / SUPER CLASS / PARENT CLASS
---@class Map
local Map                  = LIB.Class:Create({

    constructor = function(self, handle)
        self.handle = handle
    end,

    set = {

        RemoveBlip = function(self)
            if not DoesBlipExist(self.handle) then
                return
            end
            RemoveBlip(self.handle)
            self:RemoveTrackedBlip(self.handle)
        end,

        SetName = function(self, name)
            if not name then return end
            SetBlipName(self.handle, name)
        end,

        SetCoords = function(self, pos)
            if not pos then return end
            SetBlipCoords(self.handle, pos.x, pos.y, pos.z)
        end,

        SetStyle = function(self, style)
            if not style then return end
            BlipSetStyle(self.handle, style)
        end,

        SetSprite = function(self, sprite)
            if not sprite then return end
            SetBlipSprite(self.handle, sprite, false)
        end,

        AddModifier = function(self, modifier)
            if not modifier then return end
            BlipAddModifier(self.handle, modifier)
        end,

        -- same as above but only colors in case they want to use blue,red,yellow as key values
        AddModifierColor = function(self, modifier)
            if not blipColors[modifier] then return error(('Color does not exist'):format(modifier)) end
            BlipAddModifier(self.handle, modifier)
        end,

        RemoveModifier = function(self, modifier)
            BlipRemoveModifier(self.handle, modifier)
        end
    },

    get = {
        GetHandle = function(self)
            return self.handle
        end,
    },

    GetBlipColor = function(_, color)
        local function errorCatch(value)
            if not blipColors[value] then error(('Color not valid %s'):format(value), 2) end
        end

        if type(color) ~= "table" then
            color = { color }
        end
        local t = {}

        for k, value in ipairs(color) do
            errorCatch(value)
            t[k] = blipColors[value]
        end

        return table.unpack(t) -- multiple or single colors
    end,

    TrackBlips = function(_, handle)
        blipsTracker[handle] = handle
    end,

    RemoveTrackedBlip = function(_, handle)
        blipsTracker[handle] = nil
    end,

    GetTrackedBlips = function()
        return blipsTracker
    end,

})

--* DERIVED CLASS / SUB CLASS / CHILD CLASS
---@class Blip: Map
local Blip                 = LIB.Class:Create(Map)

function Blip:CreateBlip(blipType, params)
    local handle

    if blipType == 'entity' then
        if not params.Entity or not DoesEntityExist(params.Entity) then
            error('No handle provided OR Entity does not exist', 2)
        end
        handle = BlipAddForEntity(params.Blip, params.Entity)
    end

    if blipType == 'coords' then
        if not params.Pos or not type(params.Pos) == 'table' then
            error('No position provided', 2)
        end
        handle = BlipAddForCoords(params.Blip, params.Pos.x, params.Pos.y, params.Pos.z)
    end

    if blipType == 'area' then
        if not params.Pos or not type(params.Pos) == 'table' or not params.Scale or not type(params.Scale) == 'table' then
            error('No position provided', 2)
        end
        handle = BlipAddForArea(params.Blip, params.Pos.x, params.Pos.y, params.Pos.z, params.Scale.x, params.Scale.y, params.Scale.z, params.P7 or 0)
    end

    if blipType == 'radius' then
        if not params.Pos or not type(params.Pos) == 'table' then
            error('No position provided', 2)
        end
        handle = BlipAddForRadius(params.Blip, params.Pos.x, params.Pos.y, params.Pos.z, params.Radius or 0.5)
    end

    local startTime <const> = GetGameTimer()
    repeat Wait(0) until DoesBlipExist(handle) or (GetGameTimer() - startTime) > 5000
    if not DoesBlipExist(handle) or (GetGameTimer() - startTime) > 5000 then
        error('Creation of Blip failed', 2)
    end

    Map:TrackBlips(handle)
    local instance <const> = Blip:New(handle)

    local options <const> = params.Options
    if not options then
        return instance
    end

    instance:SetSprite(options?.Sprite)
    instance:SetName(options?.Name)
    instance:SetStyle(options?.Style)
    instance:AddModifier(options?.Modifier)
    instance:AddModifierColor(options?.Color)

    if params.OnCreate then
        params.OnCreate(instance)
    end

    return instance
end

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then
        return
    end

    for handle, _ in pairs(blipsTracker) do
        if DoesBlipExist(handle) then
            RemoveBlip(handle)
        end
    end
end)


return {
    Map = Blip
}

-- EXAMPLE
--[[ local LIB <const> = Import 'map'

local blip = LIB.Map:CreateBlip('radius', {
    Entity = ped,
    Pos = vector3(0, 0, 0),
    Radius = 10.0,
    P7 = 0,
    Blip = 1,
    Scale = vector3(1.0, 1.0, 1.0),
    Options = { -- optional
        Sprite = 1,
        Name = 'Test',
        Style = 1,
        Modifier = 'BLIP_MODIFIER_MP_COLOR_1', -- int or string
        Color = 'blue',                        -- internal color name
    },
    OnCreate = function(instance)
        print('Created', instance.handle)
    end
}) ]]

--[[ local handle = blip:GetHandle()
blip:SetName('Test')
blip:SetCoords(vector3(0, 0, 0))
blip:SetStyle(1)
blip:AddModifier('BLIP_MODIFIER_MP_COLOR_1')
blip:AddModifierColor('blue')
blip:RemoveModifier('BLIP_MODIFIER_MP_COLOR_1')
blip:RemoveModifierColor('blue')
 ]]

-- get blipcolor
-- to use on your own scripts?
-- local blue, red, yellow = LIB.Map:GetBlipColor({ 'blue', 'red', 'yellow' }) -- singe string or multiple colors
-- BlipAddModifier(blip, blue)
