local LIB <const> = Import "class"
local REGISTERED_INPUTS <const> = {}

local Wait <const> = Wait

print("^3WARNING: ^7module INPUTS is a work in progress use it at your own risk")

---@class INPUTS
local Inputs = {}

---@type table<string, function>
local inputTypes <const> = {
    Press = IsControlJustPressed,
    Hold = IsControlPressed,
    Release = IsControlJustReleased
}

-- there is a ton of controls, so make sure to pass the hash, or for general use you can pass these strings
-- they need to be tested to see if they work
---@type table<string, string>
local inputKeys <const> = {
    A = `INPUT_MOVE_LEFT_ONLY`,
    B = `INPUT_OPEN_SATCHEL_MENU`,
    C = `INPUT_LOOK_BEHIND`,
    D = `INPUT_MOVE_RIGHT_ONLY`,
    E = `INPUT_ENTER`,
    F = `INPUT_MELEE_ATTACK`,
    G = `INPUT_INTERACT_ANIMAL`,
    H = `INPUT_WHISTLE`,
    I = `INPUT_QUICK_USE_ITEM`,
    J = `INPUT_OPEN_JOURNAL`,
    L = `INPUT_PLAYER_MENU`,
    M = `INPUT_MAP`,
    N = `INPUT_PUSH_TO_TALK`,
    O = `INPUT_VEH_HEADLIGHT`,
    P = `INPUT_FRONTEND_PAUSE`,
    Q = `INPUT_COVER`,
    R = `INPUT_RELOAD`,
    S = `INPUT_MOVE_DOWN_ONLY`,
    U = `INPUT_AIM_IN_AIR`,
    V = `INPUT_NEXT_CAMERA`,
    W = `INPUT_MOVE_UP_ONLY`,
    X = `INPUT_GAME_MENU_TAB_RIGHT_SECONDARY`,
    Z = `INPUT_GAME_MENU_TAB_LEFT_SECONDARY`,
    ["1"] = `INPUT_SELECT_QUICKSELECT_SIDEARMS_LEFT`,
    ["2"] = `INPUT_SELECT_QUICKSELECT_DUALWIELD`,
    ["3"] = `INPUT_SELECT_QUICKSELECT_SIDEARMS_RIGHT`,
    ["4"] = `INPUT_SELECT_QUICKSELECT_UNARMED`,
    ["5"] = `INPUT_SELECT_QUICKSELECT_MELEE_NO_UNARMED`,
    ["6"] = `INPUT_SELECT_QUICKSELECT_SECONDARY_LONGARM`,
    ["7"] = `INPUT_SELECT_QUICKSELECT_THROWN`,
    ["8"] = `INPUT_SELECT_QUICKSELECT_PRIMARY_LONGARM`
}

local input = LIB.Class:Create({
    constructor = function(self, data)
        self._keyHash = data._keyHash
        self.key = data.key
        self.inputType = data.inputType
        self.callback = data.callback
        self._inputType = data._inputType
        self.isRunning = data.isRunning
        self.isMultiple = data.isMultiple or false

        if data.isMultiple then
            self.inputs = data.inputs or { customParams = {} }
        else
            self.customParams = {}
        end
    end,

    set = {
        Destroy = function(self)
            self.isRunning = false
            self = nil
        end,
        -- only if is multiple then remove the key
        RemoveKey = function(self, key)
            if self.isMultiple then
                for index, input in ipairs(self.inputs) do
                    if input.key == key then
                        table.remove(self.inputs, index)
                        break
                    end
                end
            else
                print("only usable for multiple inputs")
            end
        end,

        Pause = function(self)
            if not self.isRunning then return end
            self.isRunning = false
        end,

        Resume = function(self)
            if self.isRunning then return end
            self.isRunning = false
            self:Start()
        end,


        Update = function(self, data, key) -- only accept tables
            if not data then
                error("data is required")
            end

            if type(data) ~= "table" then
                error("data must be a table")
            end

            if self.isMultiple then
                if not key then
                    error("key is required if using multiple inputs")
                end

                for _, input in ipairs(self.inputs) do
                    if input.key == key then
                        input.customParams = data
                        break
                    end
                end
            else
                self.customParams = data
            end
        end,

        Start = function(self, ...)
            if self.isMultiple then
                self:StartMultiple(...)
            else
                self:StartSingle(...)
            end
        end,

        StartSingle = function(self)
            if self.isRunning then return end
            self.isRunning = true

            CreateThread(function()
                while self.isRunning do
                    Wait(0)
                    if self._inputType(0, self._keyHash) then
                        self.callback(self, self.customParam)
                    end
                end
            end)
            -- can support draw text ? or html text on screen ?
        end,

        StartMultiple = function(self)
            if self.isRunning then return end
            self.isRunning = true

            CreateThread(function()
                while self.isRunning do
                    Wait(0)
                    for _, input in ipairs(self.inputs) do
                        if input._inputType(0, input._keyHash) then
                            self.callback(input, input.customParams)
                        end
                    end
                end
            end)
            -- can support draw text ? or html text on screen ?
        end
    }
})

function Inputs:isArrayOfTables(t)
    if type(t) ~= "table" then
        return false
    end

    if type(t[1]) ~= "table" then
        return false
    end

    for k, _ in pairs(t) do
        if type(k) ~= "number" then
            return false
        end
    end

    return true
end

function Inputs:InitializeInputs(inputParams, isArray)
    local function normalizeKey(key)
        if type(key) == 'string' then
            if not inputKeys[key] then
                local sub <const> = string.sub(key, 1, 1) -- if its just a letter then check table
                if sub then
                    if not inputKeys[key] then
                        error(('input does not exist with this letter: %s'):format(key, sub))
                    end
                end
                key = joaat(key)
            end
            key = inputKeys[key]
        end

        return key
    end

    if isArray then
        for _, value in ipairs(inputParams) do
            if not inputTypes[value.inputType] then
                error(('input type %s does not exist, available are: Press, Hold, Release'):format(value.inputType))
            end

            value._keyHash = normalizeKey(value.key)
            value._inputType = inputTypes[value.inputType]
        end
        inputParams.isMultiple = true
        inputParams.inputs = inputParams
        return inputParams
    end

    if not inputTypes[inputParams.inputType] then
        error(('input type %s does not exist, available are: Press, Hold, Release'):format(inputParams.inputType))
    end

    inputParams._keyHash = normalizeKey(inputParams.key)
    inputParams._inputType = inputTypes[inputParams.inputType]

    return inputParams
end

function Inputs:Register(inputParams, callback, state)
    local isTable <const> = self:isArrayOfTables(inputParams)
    inputParams = self:InitializeInputs(inputParams, isTable)
    inputParams.callback = callback

    local instance <const> = input:New(inputParams)
    if state then
        instance:Start()
    end

    table.insert(REGISTERED_INPUTS, instance)

    return instance
end

-- CLEAN UP
AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end

    print("^3CLEANUP^7 cleaning up all registered inputs")

    for _, self in ipairs(REGISTERED_INPUTS) do
        self:Destroy()
    end
end)


return {
    Input = Inputs
}




--[[ EXAMPLES

local LIB <const> = Import "inputs"

-- register one input
local input = LIB.Input:Register({ inputType = "Release", key = "E" }, function(instance)
    print("Pressed", instance.key, instance.inputType)
end, true) -- state is true then it will start automatically

-- multiple inputs
local inputs = {
    { inputType = "Press",   key = "E" },
    { inputType = "Hold",    key = "W" },
    { inputType = "Release", key = "S" },
}

local inputs = LIB.Input:Register(inputs, function(input)
    if input.key == "E" then
        print("E was pressed")
    elseif input.key == "W" then
        print("W is held")
    elseif input.key == "S" then
        print("S was released")
    end
end, true)


]]
