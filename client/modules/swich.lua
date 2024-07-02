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

---EXAMPLE
--local result = Switch(1) -- parameter is the value to be checked
--    :case("hello", function()
--        return "Hello, World!"
--    end)
--    :case(1, function()
--        return "World, Hello!"
--    end)
--    :case(true, function()
--        return "World, Hello!"
--    end)
--    :default(function()
--        return "Hello, Hello!"
--    end)
--    :execute()
--
--print("Result:", result)
--

---@class Interval
---@field callback fun():any
---@field delay integer
---@field id string
---@field execute fun(self:Interval):any
local Interval = {}
Interval.__index = Interval
Interval.__call = function()
    return "Interval"
end

---@constructor
function Interval:new(callback, delay, id)
    local properties = { callback = callback, delay = delay or 1000, id = id }
    return setmetatable(properties, self)
end

---@methods
function Interval:execute()
    Citizen.CreateThreadNow(function()
        while true do
            self.callback()
            Wait(self.delay)
        end
    end)
end

---@initializer
function SetInterval(callback, delay, id)
    local interval = Interval:new(callback, delay, id)
    interval:execute()
    return interval
end

-- example
--local instance = SetInterval(function()
--    print("Hello, World!")
--end, 1000, "hello")

---@param t table the table to iterate either array or dictionary
---@param func fun(k:any, v:any)
---@param array boolean? use ipairs or pairs
local function forEach(t, func, array)
    if not t and type(t) ~= "table" then return end

    if array then
        for k, v in ipairs(t) do func(k, v) end
    else
        for k, v in pairs(t) do func(k, v) end
    end
end

---EXAMPLE
--local t = { 1, 2, 3, 4, 5 }
--forEach(t, function(k, v) -- built in nil check and type check
--    print(k, v)
--end, true)

return {
    Switch = switch,
    Foreach = forEach,
    SetInterval = SetInterval
}
