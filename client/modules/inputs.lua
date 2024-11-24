local LIB <const> = Import "class"


---@class Inputs
---@field private New fun(self: Inputs, key: string | number, callback: function, type: string, state: boolean): Inputs
---@field private NormalizeKey fun(self: Inputs, key: string | number): string | number
---@field public IsRunning function check if the instance is running
---@field public Start function start look up for input
---@field public Remove function destroy the instance
---@field public Pause  function pause the instance
---@field public Resume function resume the instance
---@field public Register fun(self: Inputs, key: string | number, callback: function, type: string, state: boolean?): Inputs
---@field public key string | number
local Inputs = {}

---@static
local inputTypes <const> = {
    Press = IsControlJustPressed,
    Hold = IsControlPressed,
    Release = IsControlJustReleased
}

-- only essential keys
---@static
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
    UP = `INPUT_FRONTEND_UP`,
    DOWN = `INPUT_FRONTEND_DOWN`,
    LEFT = `INPUT_FRONTEND_LEFT`,
    RIGHT = `INPUT_FRONTEND_RIGHT`,
    RIGHTBRACKET = `INPUT_SNIPER_ZOOM_IN_ONLY`, -- mouse scroll up
    LEFTBRACKET = `INPUT_SNIPER_ZOOM_OUT_ONLY`, -- mouse scroll down
    MOUSE1 = `INPUT_ATTACK`,                    -- mouse left click
    MOUSE2 = `INPUT_AIM`,                       -- mouse right click
    MOUSE3 = `INPUT_SPECIAL_ABILITY`,           -- mouse middle click
    CTRL = `INPUT_DUCK`,
    TAB = `INPUT_TOGGLE_HOLSTER`,
    SHIFT = `INPUT_SPRINT`,
    SPACEBAR = `INPUT_JUMP`,
    ENTER = `INPUT_FRONTEND_ACCEPT`,
    BACKSPACE = `INPUT_FRONTEND_CANCEL`,
    LALT = `INPUT_PC_FREE_LOOK`,
    DEL = `INPUT_FRONTEND_DELETE`,
    PGUP = `INPUT_CREATOR_LT`,
    PGDN = `INPUT_CREATOR_RT`,
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
        self.key = data.key
        self.callback = data.callback
        self.inputType = data.inputType
        self.isRunning = data.isRunning
        self.customParams = {}
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

        Resume = function(self, ...)
            self:Update(...)
            if self.isRunning then return end
            self.isRunning = false
            self:Start()
        end,

        Update = function(self, ...)
            self.customParams = { ... }
        end,

        Start = function(self)
            if self.isRunning then return end
            self.isRunning = true
            CreateThread(function()
                while self.isRunning do
                    Wait(0)
                    if self.inputType(0, self.key) then
                        self.callback(self, table.unpack(self.customParams))
                    end
                end
            end)
        end,
    }
})

function Inputs:NormalizeKey(key)
    if type(key) == 'string' then
        local sub = string.sub(key, 1, 1)
        if sub then
            if not inputKeys[key] then
                error(('input key %s does not exist, available keys are %s'):format(key, table.concat(inputKeys, ', ')))
            end
            key = inputKeys[key]
        end
    end

    return key
end

function Inputs:Register(key, callback, inputType, state)
    if not inputTypes[inputType] then
        error(('input type %s does not exist, available types are %s'):format(inputType, table.concat(inputTypes, ', ')))
    end

    key = self:NormalizeKey(key)

    local instance = input:new({ key = key, callback = callback, inputType = inputTypes[inputType] })

    if state then
        instance:Start()
    end

    return instance
end

return {
    Inputs = Inputs
}
