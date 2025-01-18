local LIB <const> = Import "class"

---@class Prompts
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

function Prompts:SetUpSinglePrompt(data)
    local group <const> = GetRandomIntInRange(0, 0xffffff)
    local prompt <const> = UiPromptRegisterBegin()
    local text <const> = VarString(10, 'LITERAL_STRING', data.promptLabel)
    UiPromptSetControlAction(prompt, data.promptKey)
    UiPromptSetText(prompt, text)
    UiPromptSetEnabled(prompt, true)
    UiPromptSetVisible(prompt, true)
    data.promptMode(prompt, data)
    UiPromptSetGroup(prompt, group, 0)
    UiPromptRegisterEnd(prompt)
    return group, prompt
end

function Prompts:SetUpMultiplePrompts(data)
    local group <const> = GetRandomIntInRange(0, 0xffffff)

    for _, value in ipairs(data.prompts) do
        local prompt <const> = UiPromptRegisterBegin()
        local text <const> = VarString(10, 'LITERAL_STRING', value.promptLabel)
        UiPromptSetControlAction(prompt, value.promptKey)
        UiPromptSetText(prompt, text)
        UiPromptSetEnabled(prompt, true)
        UiPromptSetVisible(prompt, true)
        value.promptMode(prompt, value)
        UiPromptSetGroup(prompt, group, 0)
        UiPromptRegisterEnd(prompt)
        value.promptID = prompt
    end
    return group, data.prompts
end

function Prompts:NormalizePromptKey(promptKey)
    if not promptKey then return print('promptKey is nil to get promptID from multiple prompts you need to pass the promptKey as a string or hash') end

    if type(promptKey) == 'string' then
        local sub = string.sub(promptKey, 1, 1)
        if #sub == 1 then
            if not promptKeys[promptKey] then return print('promptKey', promptKey, ' does not exist') end
            promptKey = promptKeys[promptKey]
        else
            promptKey = joaat(promptKey)
        end
    end
    -- returns hash key
    return promptKey
end

local prompt = LIB.Class:Create({
    constructor   = function(self, data)
        if data.isMultiple then
            self.promptGroup, self.prompts = Prompts:SetUpMultiplePrompts(data)
        else
            self.promptType = data.promptType
            self.promptGroup, self.promptID = Prompts:SetUpSinglePrompt(data)
        end

        self.callback = data.callback
        self.isRunning = data.isRunning
        self.promptLabel = data.promptLabel
        self.groupLabel = data.groupLabel
        self.isMultiple = data.isMultiple
    end,

    get           = {
        GetPromptID = function(self, promptKey)
            if not self.isMultiple then return self.promptID end

            promptKey = Prompts:NormalizePromptKey(promptKey)

            for i = 1, #self.prompts do
                if self.prompts[i].promptKey == promptKey then
                    return self.prompts[i].promptID
                end
            end
        end,
        GetPromptGroup = function(self)
            return self.promptGroup
        end,
        GetPromptControlAction = function(self)
            return self:GetPromptKeyName(self.promptKey)
        end,
        GetPromptKeyName = function(self, promptKey) -- only hash
            if not self.isMultiple then return print('this is for multiple prompts only') end

            promptKey = Prompts:NormalizePromptKey(promptKey)

            for key, value in pairs(promptKeys) do
                if value == promptKey then
                    return { promptKey = key, promptHash = value }
                end
            end

            print('prompt key does not exist, available keys are')
            return { promptKey = nil, promptHash = promptKey }
        end,
        GetPromptLabel = function(self, promptKey)
            if not self.isMultiple then return self.promptLabel end

            promptKey = Prompts:NormalizePromptKey(promptKey)

            for i = 1, #self.prompts do
                if self.prompts[i].promptKey == promptKey then
                    return self.prompts[i].promptLabel
                end
            end
        end,
        GetPromptGroupLabel = function(self)
            return self.groupLabel
        end,
        IsPromptRunning = function(self)
            return self.isRunning
        end
    },

    set           = {
        SetPromptLabel = function(self, label, promptKey)
            if not self.isMultiple then
                if not label then return print('label is nil') end
                UiPromptSetText(self.promptID, VarString(10, 'LITERAL_STRING', label))
                self.promptLabel = label
            else
                if not label then return print('label is nil') end
                UiPromptSetText(self:GetPromptID(promptKey), VarString(10, 'LITERAL_STRING', label))
                self.promptLabel = label
            end
        end,
        SetPromptGroupLabel = function(self, label)
            self.groupLabel = label
        end,
        SetPromptEnabled = function(self, enabled, promptKey)
            if not self.isMultiple then
                UiPromptSetEnabled(self.promptID, enabled)
            else
                UiPromptSetEnabled(self:GetPromptID(promptKey), enabled)
            end
        end,
        SetPromptVisible = function(self, visible, promptKey)
            if not self.isMultiple then
                UiPromptSetVisible(self.promptID, visible)
            else
                UiPromptSetVisible(self:GetPromptID(promptKey), visible)
            end
        end,
        SetPromptMashMode = function(self, mashCount, promptKey)
            if not self.isMultiple then
                UiPromptSetMashMode(self.promptID, mashCount)
            else
                UiPromptSetMashMode(self:GetPromptID(promptKey), mashCount)
            end
        end,
        SetPromptMashIndefinitelyMode = function(self, promptKey)
            if not self.isMultiple then
                UiPromptSetMashIndefinitelyMode(self.promptID)
            else
                UiPromptSetMashIndefinitelyMode(self:GetPromptID(promptKey))
            end
        end,
        SetPromptGroup = function(self, group, promptKey)
            if not self.isMultiple then
                UiPromptSetGroup(self.promptID, group, 0)
            else
                UiPromptSetGroup(self:GetPromptID(promptKey), group, 0)
            end
        end,
    },

    Remove        = function(self)
        if not self.isMultiple then
            UiPromptDelete(self.promptID)
            self.promptID = nil
        else
            for _, value in ipairs(self.prompts) do
                UiPromptDelete(value.promptID)
            end
        end
        self.promptGroup = nil
        self.promptType = nil
        self.callback = nil
        self.isRunning = nil
        self.promptLabel = nil
        self.groupLabel = nil
        self.customParams = {}
    end,

    Pause         = function(self)
        if not self.isRunning then return end
        self.isRunning = false
    end,

    Resume        = function(self, ...)
        self:Update(...) -- constantly update the thread with new key and value this allows for use to update these values in the callback
        if self.isRunning then return end
        self.isRunning = false
        self:Start(self)
    end,

    Start         = function(self, ...)
        if self.isRunning then return end
        self.isRunning = true

        if self.isMultiple then
            self:StartMultiple(...)
        else
            self:StartSingle(...)
        end
    end,

    Update        = function(self, ...)
        self.customParams = { ... }
    end,

    StartSingle   = function(self)
        CreateThread(function()
            while self.isRunning do
                local groupLabel <const> = VarString(10, 'LITERAL_STRING', self.groupLabel)
                UiPromptSetActiveGroupThisFrame(self.promptGroup, groupLabel, 0, 0, 0, 0)
                if self.promptType(self.promptID, 0) then
                    self.callback(self:GetPromptKeyName(self.promptKey), self, table.unpack(self.customParams))
                end
                Wait(0)
            end
        end)
    end,

    StartMultiple = function(self)
        CreateThread(function()
            while self.isRunning do
                local groupLabel <const> = VarString(10, 'LITERAL_STRING', self.groupLabel)
                UiPromptSetActiveGroupThisFrame(self.promptGroup, groupLabel, 0, 0, 0, 0)
                for _, value in ipairs(self.prompts) do
                    if value.promptType(value.promptID, 0) then
                        self.callback(self:GetPromptKeyName(value.promptKey), self, table.unpack(self.customParams))
                    end
                end
                Wait(0)
            end
        end)
    end
})

function Prompts:isArrayOfTables(t)
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

function Prompts:IsSingleString(data, isArray)
    --! dont think this is needed you can just loop over the register? either way it will stay here for future decisions
    if isArray then
        for key, value in ipairs(data) do
            if not promptTypes[value.promptType] then
                error(('prompt type %s does not exist, available types are %s'):format(value.promptType, table.concat(promptTypes, ', ')))
            end

            -- if type is a hash then no need to convert
            if type(value.promptKey) == 'string' then
                if not promptKeys[value.promptKey] then
                    local containsUnderscore <const> = string.find(value.promptKey, '_')
                    if not containsUnderscore then
                        error(('prompt key %s does not exist, available keys are %s'):format(value.promptKey, table.concat(promptKeys, ', ')))
                    else
                        -- contains undersocre is a string
                        value.promptKey = joaat(value.promptKey)
                    end
                else
                    value.promptKey = promptKeys[value.promptKey]
                end
            end

            if not promptModes[value.promptMode] then
                error(('prompt mode %s does not exist, available modes are %s'):format(value.promptMode, table.concat(promptModes, ', ')))
            end

            value.promptType = promptTypes[value.promptType]
            value.promptMode = promptModes[value.promptMode]
        end
        data.isMultiple = true
        data.prompts = data
        return data
    end


    if not promptTypes[data.promptType] then
        error(('prompt type %s does not exist, available types are %s'):format(data.promptType, table.concat(promptTypes, ', ')))
    end

    if type(data.promptKey) == 'string' then
        if not promptKeys[data.promptKey] then
            local containsUnderscore <const> = string.find(data.promptKey, '_')
            if not containsUnderscore then
                error(('prompt key %s does not exist, available keys are %s'):format(data.promptKey, table.concat(promptKeys, ', ')))
            else
                data.promptKey = joaat(data.promptKey)
            end
        else
            data.promptKey = promptKeys[data.promptKey]
        end
    end

    data.isMultiple = false
    data.promptType = promptTypes[data.promptType]
    data.promptMode = promptModes[data.promptMode]

    return data
end

function Prompts:Register(data, groupLabel, callback)
    local isTable <const> = self:isArrayOfTables(data)
    if not isTable then
        error(('data must be a table or array, got %s'):format(type(data)))
    end

    if isTable then
        data = self:IsSingleString(data, true)
    else
        data = self:IsSingleString(data, false)
    end

    data.callback = callback
    data.groupLabel = groupLabel
    local instance <const> = prompt:new(data)
    return instance
end

return {
    Prompts = Prompts,
}

--[[
------------------------------------------------------------------------------------------------------------------
-- register multiple prompts to the same group
local data = {
    { promptType = 'Press', promptKey = 'G', promptLabel = 'Standard Prompt', promptMode = 'Standard' },
    { promptType = 'Press', promptKey = 'E', promptLabel = 'Standard Prompt', promptMode = 'Standard' }
}

-- supports table of data with single or multiple prompts
local prompt = Prompts:Register(data, "group label", function(input, prompt, ...)
    -- LOOK UP WITH STRING OR HASH
    if input.promptKey == 'G' or input.promptHash == `INPUT_INTERACT_ANIMAL` then
        prompt:SetPromptLabel('G pressed', 'G')
    end

    if input.promptKey == 'E' then
        prompt:SetPromptLabel('E pressed', 'E')
    end
end)
-- do distance check to start and stop prompts
prompt:Resume(...)
-------------------------------------------------------------------------------------------------------------------
-- single prompt
local data = { promptType = 'Press', promptKey = 'E', promptLabel = 'Standard Prompt', promptMode = 'Standard' }
local prompt = Prompts:Register(data, "group label", function(input, prompt, key, value)
    -- promt E was pressed
    print(key, value)
end)
-- do distance check to start and stop prompts
prompt:Resume(...)

-------------------------------------------------------------------------------------------------------------------
--* register multiple prompts without being in the same group
local prompts = {}
local data = {
    { promptType = 'Press', promptKey = 'G', promptLabel = 'Standard Prompt', promptMode = 'Standard' },
}
for _, value in ipairs(data) do
    prompts[#prompts + 1] = Prompts:Register(value, "group label", function(input, prompt, key,value)
        if input.promptKey == 'G' then
            prompt:SetPromptLabel('G pressed')
        end

        if input.promptKey == 'E' then
            prompt:SetPromptLabel('E pressed')
        end
    end)
end
-- do distance check to start and stop prompts
for key, value in ipairs(prompts) do
    local coords = GetEntityCoords(PlayerPedId())
    local promptCoords = GetEntityCoords(value:GetPromptID())
    local distance = #(coords - promptCoords)

    if distance < 2 then         -- if key or value have changed you need to update the prompts data you sending
        value:Resume(key, value) -- -- this data will be updated throught the callback
    end

    if distance > 2 then
        value:Pause() -- will make the prompt stop displaying
    end
end
-------------------------------------------------------------------------------------------------------------------
]]
