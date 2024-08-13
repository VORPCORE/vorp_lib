---@class Map
---@field private handle number
---@field private New fun(self:Map, handle:number):Map
---@field public RemoveBlip fun(self:Map)
---@field public SetName fun(self:Map, name:string)
---@field public SetCoords fun(self:Map, pos:vector)
---@field public SetStyle fun(self:Map, style:number)
---@field public SetScale fun(self:Map, scale:number)
---@field public SetSprite fun(self:Map, sprite:number)
---@field public AddModifier fun(self:Map, modifier:string)
---@field public RemoveModifier fun(self:Map, modifier:string)
---@field public GetHandle fun(self:Map):number
local Map = {}
Map.__index = Map
Map.__call = function()
    return "Map"
end

---@class Blip
---@field private InnitializeBlip fun(self:Blip, handle:number, params:table):Map
---@field public handle number
---@field public AddBlipForEntity fun(self:Blip, params:table):Map
---@field public AddBlipForCoords fun(self:Blip, params:table):Map
---@field public AddBlipForArea fun(self:Blip, params:table):Map
Map.Blip = setmetatable({}, Map)
Map.Blip.__index = Map.Blip


local blipsTracker = {}
local blipColors = {
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

---@constructor
function Map:New(handle)
    local properties = { handle = handle }
    return setmetatable(properties, Map)
end

---@methods
function Map:RemoveBlip()
    if not DoesBlipExist(self.handle) then return end
    RemoveBlip(self.handle)
    Map.RemoveTrackedBlip(self.handle)
end

function Map:SetName(name)
    if not name then return end
    SetBlipName(self.handle, name)
end

function Map:SetCoords(pos)
    if not pos then return end
    SetBlipCoords(self.handle, pos.x, pos.y, pos.z)
end

function Map:SetStyle(style)
    if not style then return end
    BlipSetStyle(self.handle, style)
end

function Map:SetScale(scale)
    if not scale then return end
    SetBlipScale(self.handle, scale)
end

function Map:SetSprite(sprite)
    if not sprite then return end
    SetBlipSprite(self.handle, sprite, false)
end

function Map:AddModifier(modifier)
    if not modifier then return end
    BlipAddModifier(self.handle, modifier)
end

-- same as above but only colors in case they want to use blue,red,yellow as key values
function Map:AddModifierColor(modifier)
    if not modifier then return end
    if not blipColors[modifier] then return error(('Color does not exist'):format(modifier)) end
    BlipAddModifier(self.handle, modifier)
end

function Map:RemoveModifier(modifier)
    if not modifier then return end
    BlipRemoveModifier(self.handle, modifier)
end

function Map:GetHandle()
    return self.handle
end

---@static functions

function Map.TrackBlip(handle)
    blipsTracker[handle] = handle
end

function Map.GetTrackedBlips()
    return blipsTracker
end

function Map.GetNumberOfTrackedBlips()
    return #blipsTracker
end

function Map.RemoveTrackedBlip(handle)
    blipsTracker[handle] = nil
end

--* DERIVED CLASS / SUB CLASS / CHILD CLASS
function Map.Blip:InnitializeBlip(handle, params)
    local startTime = GetGameTimer()

    repeat Wait(0) until DoesBlipExist(handle) or (GetGameTimer() - startTime) > 3000
    if not DoesBlipExist(handle) or (GetGameTimer() - startTime) > 3000 then
        error('Creation of Blip failed', 2)
    end

    Map.TrackBlip(handle)
    local instance = Map:New(handle)

    if not params.Options then return instance end
    local options = params.Options
    instance:SetSprite(options?.Sprite)
    instance:SetName(options?.Name)
    instance:SetStyle(options?.Style)
    instance:SetScale(options?.Scale)
    instance:AddModifier(options?.Modifier)
    instance:AddModifierColor(options?.Color)
    return instance
end

function Map.Blip:AddBlipForEntity(params)
    if not params.Entity or DoesEntityExist(params.Entity) then error('No handle provided OR Entity does not exist', 2) end
    local handle = BlipAddForEntity(params.Blip, params.Entity)
    return Map.Blip:InnitializeBlip(handle, params)
end

function Map.Blip:AddBlipForCoords(params)
    local handle = BlipAddForCoords(params.Blip, params.Pos.x, params.Pos.y, params.Pos.z)
    return Map.Blip:InnitializeBlip(handle, params)
end

function Map.Blip:AddBlipForArea(params)
    local handle = BlipAddForArea(params.Blip, params.Pos.x, params.Pos.y, params.Pos.z, params.Scale?.x or 0.0, params.Scale?.y or 0.0, params.Scale?.z or 0.0, params.P7 or 0)
    return Map.Blip:InnitializeBlip(handle, params)
end

function Map.Blip:AddBlipForRadius(params)
    local handle = BlipAddForRadius(params.Blip, params.Pos.x, params.Pos.y, params.Pos.z, params.Radius or 0.5)
    return Map.Blip:InnitializeBlip(handle, params)
end

function Map.Blip:GetBlipColor(color)
    local function errorCatch(value)
        if not blipColors[value] then error(('Color not valie %s'):format(value), 2) end
    end

    if type(color) ~= "table" then color = { color } end
    local t = {}

    for k, value in ipairs(color) do
        errorCatch(value)
        t[k] = blipColors[value]
    end

    return table.unpack(t) -- multiple or single colors
end

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then
        return
    end

    for key, value in ipairs(blipsTracker) do
        if DoesBlipExist(value) then
            RemoveBlip(value)
        end
    end
end)


return {
    Map = Map.Blip
}
