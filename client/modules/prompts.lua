local LIB <const> = Import "class"

local GetEntityCoords <const> = GetEntityCoords
local UiPromptSetActiveGroupThisFrame <const> = UiPromptSetActiveGroupThisFrame
local VarString <const> = VarString

print("^3WARNING: ^7module PROMPTS is a work in progress use it at your own risk")

---@class PROMPTS
local Prompts = {}

local promptTypes <const> = {
    Hold = UiPromptHasHoldModeCompleted,
    Press = UiPromptIsJustPressed,
    Release = UiPromptIsJustReleased,
    Standard = UiPromptHasStandardModeCompleted,
    Pressed = UiPromptIsPressed,
    Released = UiPromptIsReleased,
    Mash = UiPromptHasMashModeCompleted
}

local promptModes <const> = {
    Hold = function(prompt, mode)
        UiPromptSetHoldMode(prompt, mode.holdTime or 1000)
    end,
    Timed = function(prompt, mode)
        UiPromptSetPressedTimedMode(prompt, mode.timedMode or 5000)
    end,
    Mash = function(prompt, mode)
        UiPromptSetMashMode(prompt, mode.mashCount or 5)
    end,
    Standard = function(prompt, mode)
        UiPromptSetStandardMode(prompt, mode.releaseMode or true)
    end,
    Standardized = function(prompt, mode)
        UiPromptSetStandardizedHoldMode(prompt, mode.eventHash or 'MEDIUM_TIMED_EVENT')
    end
}

---@static
local promptKeys <const> = {
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




local prompt = LIB.Class:Create({
    constructor   = function(self, data)
        self:_SetUpPrompts(data)
        self.coords = data.coords
        self.distance = data.distance
        self.label = data.label
        self.callback = data.callback
        self.marker = data.marker
        self.sleep = data.sleep
        self.isRunning = false
    end,

    get           = {
        GetHandle = function(self, key)
            return self.prompts?[key].handle
        end,

        GetPromptGroup = function(self, key)
            return self.prompts?[key].group
        end,

        GetGroupLabel = function(self, key)
            return self.prompts?[key].label
        end,

        IsRunning = function(self)
            return self.isRunning
        end,

    },
    -- updates the prompt data
    set           = {
        SetLabel = function(self, label, key)
            if type(label) ~= 'string' then return print('label must be a string') end

            local value <const> = self.prompts[key]
            if not value then return print(('prompt not found with key %s'):format(key)) end

            UiPromptSetText(value.handle, VarString(10, 'LITERAL_STRING', label))
            value.label = label
        end,

        SetGroupLabel = function(self, label)
            if type(label) ~= 'string' then return print('label must be a string') end
            self.groupLabel = label
        end,

        SetEnabled = function(self, enabled, key)
            local value <const> = self.prompts[key]
            if not value then return print(('prompt not found with key %s'):format(key)) end

            UiPromptSetEnabled(value.handle, enabled)
        end,

        SetVisible = function(self, visible, key)
            local value <const> = self.prompts[key]
            if not value then return print(('prompt not found with key %s'):format(key)) end

            UiPromptSetVisible(value.handle, visible)
        end,

        SetMashMode = function(self, mashCount, key)
            local value <const> = self.prompts[key]
            if not value then return print(('prompt not found with key %s'):format(key)) end

            UiPromptSetMashMode(value.handle, mashCount)
        end,

        SetMashIndefinitelyMode = function(self, key)
            local value <const> = self.prompts[key]
            if not value then return print(('prompt not found with key %s'):format(key)) end

            UiPromptSetMashIndefinitelyMode(value.handle)
        end,
    },

    _SetUpPrompts = function(self, data)
        local group <const> = GetRandomIntInRange(0, 0xffffff)

        for _, value in ipairs(data.prompts) do
            local prompt <const> = UiPromptRegisterBegin()
            local text <const> = VarString(10, 'LITERAL_STRING', value.label)
            UiPromptSetControlAction(prompt, value.keyHash)
            UiPromptSetText(prompt, text)
            UiPromptSetEnabled(prompt, true)
            UiPromptSetVisible(prompt, true)
            promptModes[value.mode](prompt, value)
            UiPromptSetGroup(prompt, group, 0)
            UiPromptRegisterEnd(prompt)
            value.handle = prompt
        end
        self.group = group
        self.prompts = data.prompts
    end,

    _CreateMarker = function(self)
        CreateThread(function()
            while self.isRunning do
                local distance <const> = #(GetEntityCoords(PlayerPedId()) - self.coords)
                if distance <= self.marker.distance then
                    DrawMarker(
                        self.marker.type,
                        self.coords.x, self.coords.y, self.coords.z,
                        0.0, 0.0, 0.0,
                        0.0, 0.0, 0.0,
                        self.marker.scale.x, self.marker.scale.y, self.marker.scale.z,
                        self.marker.color.r, self.marker.color.g, self.marker.color.b, self.marker.color.a,
                        false, false, 2, false, nil,
                        false, false
                    )
                end

                Wait(0)
            end
        end)
    end,

    Destroy       = function(self)
        for _, value in ipairs(self.prompts) do
            UiPromptDelete(value.handle)
        end
        self.isRunning = false
        self = nil
    end,

    -- removes entry for this specific prompt
    Remove        = function(self, key)
        local value <const> = self.prompts[key]
        if not value then return print(('prompt not found with key %s'):format(key)) end
        UiPromptDelete(value.handle)
        self.prompts[key] = nil

        if not next(self.prompts) then
            self:Destroy()
        end
    end,

    Pause         = function(self)
        if not self.isRunning then return end
        self.isRunning = false
    end,

    Resume        = function(self)
        if self.isRunning then return end
        self:Start()
    end,

    Start         = function(self)
        if self.isRunning then return end
        self.isRunning = true

        if self.marker then
            self:_CreateMarker()
        end

        CreateThread(function()
            self:_SortPrompts()
            while self.isRunning do
                -- can add here distance check to display prompts
                local distance              = #(GetEntityCoords(PlayerPedId()) - self.coords)
                local distanceCheck <const> = self.distance or 2.0
                local sleep                 = self.sleep or 700

                if distance <= distanceCheck then
                    sleep = 0
                    UiPromptSetActiveGroupThisFrame(self.group, VarString(10, 'LITERAL_STRING', self.label), 0, 0, 0, 0)

                    for _, value in pairs(self.prompts) do
                        if value._promptType(value.handle) then
                            self.callback(value, self)
                        end
                    end
                end
                Wait(sleep)
            end
        end)
    end,
    -- allows to use key input as index to avoid loops
    _SortPrompts  = function(self)
        -- only once
        if self.isSorted then return end
        self.isSorted = true

        local sortedPrompts = {}
        for _, value in ipairs(self.prompts) do
            sortedPrompts[value.keyHash] = value
        end
        self.prompts = sortedPrompts
    end
})


function Prompts:InitializePrompts(data)
    local function normalizeKey(value)
        if not promptKeys[value.key] then
            local containsUnderscore <const> = string.find(value.key, '_')
            if not containsUnderscore then
                error(('prompt key %s does not exist, available keys are %s'):format(value.key, table.concat(promptKeys, ', ')))
            end
            return joaat(value.key)
        end
        return promptKeys[value.key]
    end

    -- if isArray then
    for _, value in ipairs(data.prompts) do
        if not promptTypes[value.type] then
            error(('prompt type %s does not exist, available types are %s'):format(value.type, table.concat(promptTypes, ', ')))
        end

        -- if type is a hash then no need to convert
        if type(value.key) == 'string' then
            value.keyHash = normalizeKey(value)
        end

        if not promptModes[value.mode] then
            error(('prompt mode %s does not exist, available modes are %s'):format(value.mode, table.concat(promptModes, ', ')))
        end

        value._promptType = promptTypes[value.type]
    end

    return data
end

-- support only one way to register prompts if multiple and they want one just add one array lol
function Prompts:Register(data, callback, state)
    local processedData = self:InitializePrompts(data)
    processedData.callback = callback
    processedData.coords = data.coords
    processedData.distance = data.distance
    processedData.label = data.label
    processedData.marker = data.marker
    processedData.sleep = data.sleep

    local instance = prompt:New(processedData)
    if state then
        instance:Start()
    end

    return instance
end

return {
    Prompts = Prompts,
}
