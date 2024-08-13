---@class Pad
---@field private New fun(self: Pad, key: string | number, callback: function, type: string, state: boolean): Pad
---@field private Init fun(self: Pad)
---@field public Destroy fun(self: Pad)
---@field public Pause fun(self: Pad)
---@field public Resume fun(self: Pad)
---@field public RegisterInput fun(key: string | number, callback: function, type: string, state: boolean): Pad | nil
---@field public key string | number
local Pad = {}
Pad.__index = Pad
Pad.__call = function()
    return "Pad"
end

---@static
local inputTypes = {
    Press = 'IsControlJustPressed',
    Hold = 'IsControlPressed',
    Release = 'IsControlJustReleased'
}

--todo: add more keys

---@static
local inputKeys = {
    W = "",
}

function Pad:New(key, callback, type, state)
    ---@constructor
    local properties = { key = key, callback = callback, inputType = type, state = state }
    return setmetatable(properties, Pad)
end

---@methods
function Pad:Init()
    Citizen.CreateThread(function()
        while self.state do
            Wait(0)
            if self.inputType(0, self.key) then
                self.callback(self)
            end
        end
    end)
end

function Pad:Destroy()
    self.state = nil
    self.key = nil
    self.callback = nil
    self.inputType = nil
end

function Pad:Pause()
    if not self.state then return end
    self.state = false
end

function Pad:Resume()
    if self.state then return end
    self.state = true
    self:Init()
end

---@static
---@param key string | number
---@param type string
function Pad.RegisterInput(key, callback, type, state)
    if not inputTypes[type] then return error(('input type %s does not exist, available types are %s'):format(type, table.concat(inputTypes, ', '))) end
    if inputKeys[key] then key = inputKeys[key] end
    local instance = Pad:New(key, callback, inputTypes[type], state)
    return instance
end

return {
    Pad = Pad
}
