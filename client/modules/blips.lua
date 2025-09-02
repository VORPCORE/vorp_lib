local CLASS <const>              = Import('class').Class --[[@as CLASS]]

---@type table<number, Blip>
local REGISTERED_BLIPS <const> = {}

local BLIP_COLORS <const>           = {
    blue = "BLIP_MODIFIER_MP_COLOR_1",
    red = "BLIP_MODIFIER_MP_COLOR_2",
    purple = "BLIP_MODIFIER_MP_COLOR_3",
    orange = "BLIP_MODIFIER_MP_COLOR_4",
    aqua = "BLIP_MODIFIER_MP_COLOR_5",
    yellow = "BLIP_MODIFIER_MP_COLOR_6",
    pink = "BLIP_MODIFIER_MP_COLOR_7",
    green = "BLIP_MODIFIER_MP_COLOR_8",
    brown = "BLIP_MODIFIER_MP_COLOR_9", --todo: needs finish up the rest
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
---@class MAP
local Map                      = CLASS:Create({

    constructor = function(self, handle)
        self.handle = handle
        self:_TrackBlips()
    end,

    set = {

        Remove = function(self)
            if not DoesBlipExist(self.handle) then
                return
            end
            RemoveBlip(self.handle)
            self:_RemoveTrackedBlip()
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

        -- same as above but only BLIP_colors in case they want to use blue,red,yellow as key values
        AddModifierColor = function(self, modifier)
            if not modifier then return end
            if not BLIP_COLORS[modifier] then return error(('Color does not exist'):format(modifier)) end
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

        GetBlipColor = function(_, color)
            local function errorCatch(value)
                if not BLIP_COLORS[value] then error(('Color not valid %s'):format(value), 2) end
            end

            if type(color) ~= "table" then
                color = { color }
            end
            local t = {}

            for k, value in ipairs(color) do
                errorCatch(value)
                t[k] = BLIP_COLORS[value]
            end

            return table.unpack(t) -- multiple or single BLIP_colors
        end,
    },

    _TrackBlips = function(self)
        REGISTERED_BLIPS[self.handle] = self.handle
    end,

    _RemoveTrackedBlip = function(self)
        REGISTERED_BLIPS[self.handle] = nil
    end,

})

--* DERIVED CLASS / SUB CLASS / CHILD CLASS
---@class Blip: MAP
local Blip                     = CLASS:Create(Map)

function Blip:Create(blipType, params)
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

    local instance <const> = Blip:New(handle)

    local options <const> = params.Options
    if not options then
        return instance
    end

    instance:SetSprite(options?.sprite)
    instance:SetName(options?.name)
    instance:SetStyle(options?.style)
    instance:AddModifier(options?.modifier)
    instance:AddModifierColor(options?.color)

    if params.OnCreate then
        params.OnCreate(instance)
    end

    return instance
end

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end

    print("^3CLEANUP^7 cleaning up all created blips")

    for handle, _ in pairs(REGISTERED_BLIPS) do
        if DoesBlipExist(handle) then
            RemoveBlip(handle)
        end
    end
end)


return {
    Blips = Blip
}

