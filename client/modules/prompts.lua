local CLASS <const> = Import('class').Class --[[@as CLASS]]

local GetEntityCoords <const> = GetEntityCoords
local UiPromptSetActiveGroupThisFrame <const> = UiPromptSetActiveGroupThisFrame
local VarString <const> = VarString
local DrawMarker <const> = DrawMarker
local Wait <const> = Wait

---@class PROMPTS
local Prompts = {}

local instances = {}

local PROMPT_TYPES <const> = {
    Hold = UiPromptHasHoldModeCompleted,
    Press = UiPromptIsJustPressed,
    Release = UiPromptIsJustReleased,
    Standard = UiPromptHasStandardModeCompleted,
    Pressed = UiPromptIsPressed,
    Released = UiPromptIsReleased,
    Mash = UiPromptHasMashModeCompleted
}

local PROMPT_MODES <const> = {
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


local PROMPT_KEYS <const> = {
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

--TODO: listen on vorp menu change to pause locations and resume when menu is closed for optimisation

local prompt <const> = CLASS:Create({
    constructor   = function(self, data)
        self:_SetUpPrompts(data)
        self.locations = data.locations
        self.callback = data.callback
        self.marker = data.marker
        self.sleep = data.sleep
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
        SetLabel                = function(self, label, key)
            if type(label) ~= 'string' then return print('label must be a string') end

            local value <const> = self.prompts[key]
            if not value then return print(('prompt not found with key %s'):format(key)) end

            UiPromptSetText(value.handle, VarString(10, 'LITERAL_STRING', label))
            value.label = label
        end,

        SetEnabled              = function(self, enabled, key)
            local value <const> = self.prompts[key]
            if not value then return print(('prompt not found with key %s'):format(key)) end

            UiPromptSetEnabled(value.handle, enabled)
        end,

        SetVisible              = function(self, visible, key)
            local value <const> = self.prompts[key]
            if not value then return print(('prompt not found with key %s'):format(key)) end

            UiPromptSetVisible(value.handle, visible)
        end,

        SetMashMode             = function(self, mashCount, key)
            local value <const> = self.prompts[key]
            if not value then return print(('prompt not found with key %s'):format(key)) end

            UiPromptSetMashMode(value.handle, mashCount)
        end,

        SetMashIndefinitelyMode = function(self, key)
            local value <const> = self.prompts[key]
            if not value then return print(('prompt not found with key %s'):format(key)) end

            UiPromptSetMashIndefinitelyMode(value.handle)
        end,
        Destroy                 = function(self)
            for _, value in ipairs(self.prompts) do
                UiPromptDelete(value.handle)
            end
            self.isRunning = false

            for i, instance in ipairs(instances) do
                if instance == self then
                    table.remove(instances, i)
                    break
                end
            end
            self = nil
        end,

        -- removes entry for this specific prompt
        Remove                  = function(self, key)
            local value <const> = self.prompts[key]
            if not value then return print(('prompt not found with key %s'):format(key)) end
            UiPromptDelete(value.handle)
            self.prompts[key] = nil

            if not next(self.prompts) then
                self:Destroy()
            end
        end,

        Pause                   = function(self)
            if not self.isRunning then return end
            self.isRunning = false
        end,

        Resume                  = function(self)
            if self.isRunning then return end
            self:Start()
        end,

        PauseLocation           = function(self, index)
            local value <const> = self.locations[index]
            if not value then return print(('location not found with index %s'):format(index)) end
            value.pause = true
        end,

        ResumeLocation          = function(self, index)
            local value <const> = self.locations[index]
            if not value then return print(('location not found with index %s'):format(index)) end
            value.pause = false
        end,

        RemoveLocation          = function(self, index)
            local value <const> = self.locations[index]
            if not value then return print(('location not found with index %s'):format(index)) end
            table.remove(self.locations, index)
        end,

        AddLocation             = function(self, location)
            table.insert(self.locations, location)
        end,

        SetLocationLabel        = function(self, index, label)
            local value <const> = self.locations[index]
            if not value then return print(('location not found with index %s'):format(index)) end
            value.label = label
        end,

        Start                   = function(self)
            if self.isRunning then return end
            self.isRunning = true

            if self.marker then
                self:_CreateMarker()
            end

            CreateThread(function()
                while self.isRunning do
                    local sleep = self.sleep or 700

                    for index, value in ipairs(self.locations) do
                        if not value.pause then
                            local distance <const>      = #(GetEntityCoords(PlayerPedId()) - value.coords)
                            local distanceCheck <const> = value.distance or 2.0

                            if distance <= distanceCheck then
                                sleep = 0
                                UiPromptSetActiveGroupThisFrame(self.group, VarString(10, 'LITERAL_STRING', value.label), 0, 0, 0, 0)

                                for _, prompt in ipairs(self.prompts) do
                                    if prompt._promptType(prompt.handle) then
                                        self.callback(prompt, index, self)
                                    end
                                end
                            end
                        end
                    end

                    Wait(sleep)
                end
            end)
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
            PROMPT_MODES[value.mode](prompt, value)
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
                local sleep = self.sleep or 700
                for _, value in ipairs(self.locations) do
                    if not value.pause then
                        local distance <const> = #(GetEntityCoords(PlayerPedId()) - value.coords)
                        if distance <= value.marker.distance then
                            sleep = 0
                            DrawMarker(
                                value.marker.type,
                                value.coords.x, value.coords.y, value.coords.z,
                                0.0, 0.0, 0.0,
                                0.0, 0.0, 0.0,
                                value.marker.scale.x, value.marker.scale.y, value.marker.scale.z,
                                value.marker.color.r, value.marker.color.g, value.marker.color.b, value.marker.color.a,
                                false, false, 2, false, nil,
                                false, false
                            )
                        end
                    end
                end

                Wait(sleep)
            end
        end)
    end,
})


local initializePrompts = function(data)
    local function normalizeKey(value)
        if not PROMPT_KEYS[value.key] then
            local containsUnderscore <const> = string.find(value.key, '_')
            if not containsUnderscore then
                error(('prompt key %s does not exist, available keys are %s'):format(value.key, table.concat(PROMPT_KEYS, ', ')))
            end
            return joaat(value.key)
        end
        return PROMPT_KEYS[value.key]
    end

    -- if isArray then
    for _, value in ipairs(data.prompts) do
        if not PROMPT_TYPES[value.type] then
            error(('prompt type %s does not exist, available types are %s'):format(value.type, table.concat(PROMPT_TYPES, ', ')))
        end

        -- if type is a hash then no need to convert
        if type(value.key) == 'string' then
            value.keyHash = normalizeKey(value)
        else
            value.keyHash = value.key
        end

        if not PROMPT_MODES[value.mode] then
            error(('prompt mode %s does not exist, available modes are %s'):format(value.mode, table.concat(PROMPT_MODES, ', ')))
        end

        value._promptType = PROMPT_TYPES[value.type]
    end

    return data
end


function Prompts:Register(data, callback, state)
    local processedData <const> = initializePrompts(data)
    processedData.callback = callback
    processedData.locations = data.locations
    processedData.marker = data.marker
    processedData.sleep = data.sleep

    local instance <const> = prompt:New(processedData)

    table.insert(instances, instance)

    if state then
        instance:Start()
    end


    return instance
end

-- resume pause when menus are open or closed for optimisation
AddEventHandler("vorp_menu:closemenu", function()
    for _, instance in ipairs(instances) do
        if instance and instance.Resume then
            instance:Resume()
        end
    end
end)

AddEventHandler("vorp_menu:openmenu", function()
    for _, instance in ipairs(instances) do
        if instance and instance.Pause then
            instance:Pause()
        end
    end
end)

return {
    Prompts = Prompts,
}
