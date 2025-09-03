local CLASS <const> = Import('class').Class --[[@as CLASS]]

local COMMANDS_REGISTERED <const> = {}

local ERROR_TYPES <const> = {
    MISSING_ARGUMENTS = 'missing_arguments',
    PERMISSION = 'missing_permission',
    TARGET = 'missing_target',
    ACTIVE = 'command_active',
}



---@class COMMANDS
local Command <const> = CLASS:Create({

    constructor = function(self, name, params)
        self.name = name
        self.isActive = false
        self.permissions = params.Permissions
        self.suggestion = params.Suggestion or {}
        self.execute = params.OnExecute
        self.error = params.OnError
        self.isRegistered = false
    end,

    set = {

        ---@public methods
        Remove = function(self)
            TriggerEvent("chat:removeSuggestion", ("/%s"):format(self.name))
            RegisterCommand(self.name, function() end, false)
            self.isActive = false
            self.isRegistered = false
            COMMANDS_REGISTERED[self.name] = nil
        end,

        AddSuggestion = function(self)
            local suggestion <const> = self.suggestion
            local newArguments <const> = {}

            if not suggestion then
                return
            end

            if type(suggestion) ~= 'table' then
                return self.error(ERROR_TYPES.INVALID_SUGGESTION)
            end

            if suggestion.Arguments and next(suggestion.Arguments) then
                for i = 1, #suggestion.Arguments do
                    table.insert(newArguments, {
                        name = suggestion.Arguments[i].name,
                        help = suggestion.Arguments[i].help
                    })
                end

                TriggerEvent("chat:addSuggestion", ("/%s"):format(self.name), suggestion.Description or "", newArguments)
            else
                if self.error then
                    self.error(ERROR_TYPES.INVALID_SUGGESTION)
                end
            end
        end,

        RemoveSuggestion = function(self)
            TriggerEvent("chat:removeSuggestion", ("/%s"):format(self.name))
        end,

        Pause = function(self)
            if not self.isActive then return print('command already paused') end
            self.isActive = false
        end,

        Resume = function(self)
            if self.isActive then return print('command already resumed') end
            self.isActive = true
        end,

        Destroy = function(self)
            self:Remove()
            self.isRegistered = false
            COMMANDS_REGISTERED[self.name] = nil
            self = nil
        end,

        Start = function(self, addSuggestion)
            if self.isActive then return print('command already running') end
            self.isActive = true

            if self.isRegistered then return print('command already registered') end
            self.isRegistered         = true

            local permissions <const> = self.permissions and next(self.permissions) and self.permissions or false
            local isRestricted        = false
            local principal           = nil
            if permissions then
                isRestricted = permissions?.Ace and true or false
                principal    = permissions?.Ace and permissions?.Ace or nil
                if principal and type(principal) ~= 'string' then
                    error('command ace must be a string to automatically add the user to the ace group, other wise remove it')
                end
            end

            if addSuggestion then
                self:AddSuggestion()
            end

            RegisterCommand(self.name, function(_, args, rawCommand)
                if not self.isActive then return self.error(ERROR_TYPES.ACTIVE) end

                local validateError <const> = self:_validate(args)
                if validateError then
                    return self.error and self.error(validateError)
                end

                args = self:_getTypes(args)

                self.execute(args, rawCommand, self)
            end, isRestricted)

            -- we need to send to server to add the ace group, player will have to do it manually
        end,

    },

    OnExecute = function(self, callback)
        self.execute = callback
    end,

    OnError = function(self, callback)
        self.error = callback
    end,

    ---@private methods
    _validate = function(self, args)
        local requiredError <const> = self:_isRequiredArgument(args)
        if requiredError then
            return requiredError
        end
        return false
    end,

    _isRequiredArgument = function(self, args)
        for i = 1, #self.suggestion.Arguments do
            if self.suggestion.Arguments[i].required and (not args[i] or args[i] == "") then
                return ERROR_TYPES.MISSING_ARGUMENTS
            end
        end
    end,

    _getTypes = function(self, args)
        local suggestion <const> = self.suggestion
        if suggestion?.Arguments and next(suggestion.Arguments) then
            for i = 1, #suggestion.Arguments do
                local type <const> = suggestion.Arguments[i].type
                if type then
                    if type == 'number' or type == 'integer' then
                        args[i] = tonumber(args[i])
                    elseif type == 'message' then
                        local messageArgs = {}
                        for j = i, #args do
                            messageArgs[#messageArgs + 1] = args[j]
                        end
                        args[i] = table.concat(messageArgs, " ")
                    end
                end
            end
        end
        return args
    end
})

local function isCommandRegistered(name)
    local isRegistered <const> = GetRegisteredCommands()
    for _, command in ipairs(isRegistered) do
        if command.name == name then
            return command.resource
        end
    end
end

function Command:Register(name, params, state)
    if not name then
        error('must provide a name for the command')
    end

    if type(name) ~= 'string' then
        error('command name must be a string')
    end

    local isRegistered <const> = isCommandRegistered(name)
    if isRegistered then
        error(('command %s is already registered by %s'):format(name, isRegistered))
    end

    local instance <const> = Command:New(name, params)
    COMMANDS_REGISTERED[name] = instance
    if state then
        instance:Start(params.AddSuggestion)
    end

    return instance
end

--CLEAN UP
AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end

    print("^3CLEANUP^7 cleaning up all registered commands")

    for _, self in pairs(COMMANDS_REGISTERED) do
        self:Destroy()
    end
end)

-- FOR DEBUGGING
AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    Wait(5000)
    -- for when we restart the resouce to test the commands
    if not LocalPlayer.state.IsInSession then return end -- if not then its not restarting the resource


    for _, self in pairs(COMMANDS_REGISTERED) do
        if self.isActive then
            if self.permissions?.Ace then
                if self.suggestion?.Arguments and next(self.suggestion.Arguments) then
                    self:AddSuggestion()
                end
            else
                -- if ace then add suggestion if any

                if self.suggestion?.Arguments and next(self.suggestion.Arguments) then
                    self:AddSuggestion()
                end
            end
        end
    end
end)

-- if any was active then add suggestions when player enters character
RegisterNetEvent('vorp:SelectedCharacter', function()
    for _, self in pairs(COMMANDS_REGISTERED) do
        if self.isActive then
            if self.permissions?.Ace then
                if self.suggestion?.Arguments and next(self.suggestion.Arguments) then
                    self:AddSuggestion()
                end
            else
                if self.suggestion?.Arguments and next(self.suggestion.Arguments) then
                    self:AddSuggestion()
                end
            end
        end
    end
end)

return {
    Command = Command
}
