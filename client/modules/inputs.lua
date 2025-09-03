local CLASS <const> = Import('class').Class --[[@as CLASS]]
local REGISTERED_INPUTS <const> = {}

local Wait <const> = Wait

--TODO: add support for distance check on press etc

---@class INPUTS
local Inputs = {}

---@type table<string, function>
local INPUT_TYPES <const> = {
    Press = IsControlJustPressed,
    Hold = IsControlPressed,
    Release = IsControlJustReleased
}

-- there is a ton of controls, so make sure to pass the hash, or for general use you can pass these strings
-- they need to be tested to see if they work
---@type table<string, string>
local INPUT_KEYS <const> = {
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

local input = CLASS:Create({
    constructor = function(self, data)
        self.callback = data.callback
        self.inputType = data.inputType
        self.isRunning = data.isRunning
        self.inputs = data.inputs or { customParams = {} }
    end,

    ---@public methods
    set = {

        Destroy = function(self)
            self.isRunning = false
            self = nil
        end,

        RemoveKey = function(self, key)
            for index, input in ipairs(self.inputs) do
                -- input key was preserved for this
                if input.key == key then
                    table.remove(self.inputs, index)
                    break
                end
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


        Update = function(self, data, key)
            if not data then
                error("data is required")
            end

            if type(data) ~= "table" then
                error("data must be a table")
            end

            if not key then
                error("key is required if using multiple inputs")
            end

            for _, input in ipairs(self.inputs) do
                -- input key was preserved for this
                if input.key == key then
                    input.customParams = data
                    break
                end
            end
        end,
    },

    Start = function(self)
        if self.isRunning then return end
        self.isRunning = true

        CreateThread(function()
            while self.isRunning do
                Wait(0)
                for _, input in ipairs(self.inputs) do
                    if input.inputType(0, input.keyHash) then
                        self.callback(input, input.customParams)
                    end
                end
            end
        end)
    end,

    get = {
        GetIsRunning = function(self)
            return self.isRunning
        end,
    }
}, 'INPUTS')


local function initializeInputs(inputParams)
    local function normalizeKey(key)
        if type(key) == 'string' then
            if not INPUT_KEYS[key] then
                local sub <const> = string.sub(key, 1, 1) -- if its just a letter then check table
                if sub then
                    if not INPUT_KEYS[key] then
                        error(('input does not exist with this letter: %s'):format(key, sub))
                    end
                end
                key = joaat(key)
            end
            key = INPUT_KEYS[key]
        end

        return key
    end

    for _, value in ipairs(inputParams) do
        if not INPUT_TYPES[value.inputType] then
            error(('input type %s does not exist, available are: Press, Hold, Release'):format(value.inputType))
        end

        value.keyHash = normalizeKey(value.key)
        value.inputType = INPUT_TYPES[value.inputType]
    end

    inputParams.inputs = inputParams
    return inputParams
end

function Inputs:Register(inputParams, callback, state)
    inputParams = initializeInputs(inputParams)
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
    Inputs = Inputs
}
