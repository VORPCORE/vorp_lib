local LIB = Import 'classes'

---@class Switch
---@field cases table
---@field value any
---@field public default fun(self:Switch, value:any):any
---@field public execute fun(self:Switch):any
local Switch = {}

local switchs = LIB.Class:Create({
    constructor = function(self, value)
        self.cases = {}
        self.default = nil
        self.value = value
    end,
    case = function(self, value, func)
        self.cases[value] = func
        return self
    end,
    default = function(self, func)
        self.default = func
        return self
    end,
    execute = function(self)
        local case_func = self.cases[self.value] or self.default
        if case_func then
            return case_func(self.value)
        end
    end
})


---@class Interval
---@field callback fun(self:Interval):any
---@field delay integer
---@field id string
---@field state boolean
---@field customArgs table
---@field private execute fun(self:Interval):any
---@field public Pause fun(self:Interval)
---@field public Resume fun(self:Interval, ...:any)
---@field public Destroy fun(self:Interval)
---@field public Update fun(self:Interval, ...:any)
local Interval = {}

local intervals = LIB.Class:Create({
    constructor = function(self, callback, delay, customArgs)
        self.callback = callback
        self.delay = delay or 1000
        self.state = true
        self.customArgs = customArgs or {}
    end,
    execute = function(self)
        CreateThread(function()
            while self.state do
                self.callback(self, table.unpack(self.customArgs))
                Wait(self.delay)
            end
        end)
    end,
    Destroy = function(self)
        self.callback = nil
        self.delay = nil
        self.state = nil
        self.customArgs = nil
    end,
    Pause = function(self)
        if not self.state then return print("interval is not running") end
        self.state = false
    end,
    Resume = function(self, ...)
        if self.state then return print("interval is already running") end
        self.state = true
        self.customArgs = { ... }
        self:execute()
    end,
    Update = function(self, ...)
        self.customArgs = { ... }
    end

})

---@initializers
local function switch(value)
    return switchs:new(value)
end
local function setInterval(callback, delay, customArgs)
    local interval = intervals:new(callback, delay, customArgs)
    return interval
end

return {
    Switch = switch,
    SetInterval = setInterval
}
