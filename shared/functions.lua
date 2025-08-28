local LIB = Import 'class'

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
        self.value = value.value
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
---@field customArgs? table
---@field start? boolean
---@field public Start fun(self:Interval):any
---@field public Pause fun(self:Interval)
---@field public Resume fun(self:Interval, ...:any)
---@field public Destroy fun(self:Interval)
---@field public Update fun(self:Interval, ...:any)
local Interval = {}

local intervals = LIB.Class:Create({
    constructor = function(self, data)
        self.callback = data.callback
        self.delay = data.delay or 1000
        self.customArgs = data.customArgs or {}
        if data.start then
            self:Start()
        end
    end,

    Start = function(self)
        if not self.callback then return end
        if self.state then return print("interval is already running") end
        self.state = true
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
        local args = ... and { ... } or {}
        if self.state then return print("interval is already running") end
        self.customArgs = args
        self:Start()
    end,

    Update = function(self, ...)
        local args = ... and { ... } or {}
        self.customArgs = args
    end,

    GetState = function(self)
        return self.state
    end

})

--create a setTimeout function same as interval return ids so we can close it
local timeouts = LIB.Class:Create({
    constructor = function(self, data)
        self.callback = data.callback
        self.delay = data.delay or 1000
        self.customArgs = data.customArgs or {}
        if data.start then
            self:Start()
        end
    end,
    Start = function(self)
        if not self.callback then return end
        if not self.state then return end
        self.state = true
        CreateThread(function()
            Wait(self.delay)
            if not self.state then return end
            self.callback(table.unpack(self.customArgs))
        end)
    end,
    Destroy = function(self)
        self.state = nil
        self.callback = nil
        self.delay = nil
        self.customArgs = nil
    end,

    Pause = function(self)
        if not self.state then return print("timeout is not running to be paused") end
        self.state = false
    end,

    Resume = function(self, ...)
        local args = ... and { ... } or {}
        if self.state then return print("timeout is already running to be resumed") end
        self.state = true

        self.customArgs = args
        self:execute()
    end,

    Update = function(self, ...)
        local args = ... and { ... } or {}
        self.customArgs = args
    end,

    GetState = function(self)
        return self.state
    end

})


---@initializers
local function switch(value)
    return switchs:New({ value = value })
end
local function setInterval(callback, delay, customArgs, start)
    return intervals:New({ callback = callback, delay = delay, customArgs = customArgs, start = start })
end
local function setTimeout(callback, delay, customArgs, start)
    return timeouts:New({ callback = callback, delay = delay, customArgs = customArgs, start = start })
end


return {
    Switch = switch,
    SetInterval = setInterval,
    SetTimeout = setTimeout,
}
