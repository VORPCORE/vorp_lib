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

local promptKeys <const> = {
    G = `INPUT_INTERACT_ANIMAL`,
    E = 0xCEFD9220,
}

function Prompts:SetUpSinglePrompt(data)
    local group = GetRandomIntInRange(0, 0xffffff)
    local prompt = UiPromptRegisterBegin()
    local text = VarString(10, 'LITERAL_STRING', data.promptLabel)
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
    local group = GetRandomIntInRange(0, 0xffffff)

    for _, value in ipairs(data.prompts) do
        local prompt = UiPromptRegisterBegin()
        local text = VarString(10, 'LITERAL_STRING', value.promptLabel)
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
        self:Update(...) -- constantly update the thread with new key and value this allows for use to ket these values in the callback
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
                local groupLabel = VarString(10, 'LITERAL_STRING', self.groupLabel)
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
                local groupLabel = VarString(10, 'LITERAL_STRING', self.groupLabel)
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
    if isArray then
        for key, value in ipairs(data) do
            if not promptTypes[value.promptType] then
                error(('prompt type %s does not exist, available types are %s'):format(value.promptType, table.concat(promptTypes, ', ')))
            end

            if type(value.promptKey) == 'string' then
                if not promptKeys[value.promptKey] then
                    local sub = string.sub(value.promptKey, 1, 1) -- is it a single letter?
                    if #sub == 1 then
                        error(('prompt key %s does not exist, available keys are %s'):format(value.promptKey, table.concat(promptKeys, ', ')))
                    else
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
            local sub = string.sub(data.promptKey, 1, 1) -- is it a single letter?
            if #sub == 1 then
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
    local isTable = self:isArrayOfTables(data)
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
    local instance = prompt:new(data)
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
