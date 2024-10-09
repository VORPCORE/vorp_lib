local LIB <const> = Import "classes"

---@class Inputs
---@field private New fun(self: Inputs, key: string | number, callback: function, type: string, state: boolean): Inputs
---@field public IsRunning function check if the instance is running
---@field public Start function start look up for input
---@field public Remove function destroy the instance
---@field public Pause  function pause the instance
---@field public Resume function resume the instance
---@field public Register fun(self: Inputs, key: string | number, callback: function, type: string, state: boolean?): Inputs
---@field public key string | number
local Inputs = {}

---@static
local inputTypes = {
    Press = IsControlJustPressed,
    Hold = IsControlPressed,
    Release = IsControlJustReleased
}

--todo: import input keys data instead of having them here
---@static
local inputKeys = {
    G = `INPUT_INTERACT_ANIMAL`,
}

local input = LIB.Class.Create({

    constructor = function(self, data)
        self.key = data.key
        self.callback = data.callback
        self.inputType = data.inputType
        self.isRunning = data.isRunning
    end,

    get = {
        IsRunning = function(self)
            return self.isRunning
        end,
    },

    set = {
        Remove = function(self)
            self.isRunning = nil
            self.key = nil
            self.callback = nil
            self.inputType = nil
        end,
        Pause = function(self)
            if not self.isRunning then return end
            self.isRunning = false
        end,
        Resume = function(self)
            if self.isRunning then return end
            self.isRunning = true
            self:Start()
        end,
        Start = function(self)
            if self.isRunning then return end
            self.isRunning = true
            CreateThread(function()
                while self.isRunning do
                    Wait(0)
                    if self.inputType(0, self.key) then
                        self.callback(self)
                    end
                end
            end)
        end,
    }
})


function Inputs:Register(key, callback, inputType, state)
    if not inputTypes[inputType] then
        error(('input type %s does not exist, available types are %s'):format(inputType, table.concat(inputTypes, ', ')))
    end

    if type(key) == 'string' then
        if not inputKeys[key] then
            error(('input key %s does not exist, available keys are %s'):format(key, table.concat(inputKeys, ', ')))
        end
        key = inputKeys[key]
    end
    local instance = input:new({ key = key, callback = callback, inputType = inputTypes[inputType] })
    if state then
        instance:Start()
    end
    return instance
end

return {
    Inputs = Inputs
}
