---@class Switch
---@field cases table
---@field default fun(self:Switch, value:any):any
---@field value any
---@field execute fun(self:Switch):any
local Switch = {}
Switch.__index = Switch
Switch.__call = function()
    return "Switch"
end

---@constructor
function Switch:new(value)
    local properties = { cases = {}, default = nil, value = value }
    return setmetatable(properties, self)
end

---@methods
function Switch:case(value, func)
    self.cases[value] = func
    return self
end

function Switch:default(func)
    self.default = func
    return self
end

function Switch:execute()
    local case_func = self.cases[self.value] or self.default
    if case_func then
        return case_func(self.value)
    end
end

---@initializer
local function switch(value)
    return Switch:new(value)
end

---@class Interval
---@field callback fun():any
---@field delay integer
---@field id string
---@field state boolean
---@field execute fun(self:Interval):any
local Interval = {}
Interval.__index = Interval
Interval.__call = function()
    return "Interval"
end

---@constructor
function Interval:new(callback, delay, id)
    local properties = { callback = callback, delay = delay or 1000, state = true }
    return setmetatable(properties, self)
end

---@methods
function Interval:execute()
    Citizen.CreateThread(function()
        while self.state do
            self.callback()
            Wait(self.delay)
        end
    end)
end

function Interval:Destroy()
    self.callback = nil
    self.delay = nil
    self.state = nil
end

---@initializer
local function setInterval(callback, delay)
    local interval = Interval:new(callback, delay)
    interval:execute()
    return interval
end

return {
    Switch = switch,
    SetInterval = setInterval
}
