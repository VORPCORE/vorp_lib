-- here we will add a register command classs for players to use

local LIB <const> = Import 'class'

local COMMANDS_REGISTERED <const> = {}

local ERROR_TYPES <const> = {
    ARGUMENTS = 'missing_arguments',
    PERMISSION = 'missing_permission',
    TARGET = 'missing_target',
    ACTIVE = 'command_active',
}

local function isRequiredArgument(self, args)
    for i = 1, #self.suggestion.arguments do
        if self.suggestion.arguments[i].required and (not args[i] or args[i] == "") then
            return ERROR_TYPES.MISSING_ARGUMENTS
        end
    end
end

local function validate(self, args)
    local requiredError <const> = isRequiredArgument(self, args)
    if requiredError then
        return requiredError
    end

    return false
end
-- need to check if args are empty
local function checkType(self, args)
    local suggestion <const> = self.suggestion
    if suggestion?.Arguments then
        for i = 1, #suggestion.Arguments do
            local type <const> = suggestion.Arguments[i].type
            if type == 'player' then
                args[i] = tonumber(args[i])
            elseif type == 'number' then
                if not tonumber(args[i]) then
                    args[i] = tonumber(args[i])
                end
            end
        end
    end

    return true, args
end

---@class Command
local Command <const> = LIB.Class:Create({

    constructor = function(self, name, params, state)
        self.name = name
        self.isActive = state
        self.permissions = params.Permissions
        self.suggestion = params.Suggestion or {}
        self.execute = params.OnExecute
        self.error = params.OnError
        self.isRegistered = false
    end,

    set = {

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

                TriggerEvent("chat:addSuggestion", ("/%s"):format(self.name), suggestion.description, newArguments)
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

        Start = function(self)
            if self.isActive then return print('command already resumed') end
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

            RegisterCommand(self.name, function(source, args, rawCommand)
                if not self.isActive then return self.error(ERROR_TYPES.ACTIVE) end

                local validateError <const> = validate(self, args)
                if validateError then
                    return self.error and self.error(validateError) or print(validateError)
                end

                local typeError <const> = checkType(self, args)
                if typeError then
                    return self.error and self.error(typeError) or print(typeError)
                end

                self.execute(source, args, rawCommand, self)
            end, isRestricted)

            -- we need to send to server to add the ace group, player will have to do it manually
        end,

        Destroy = function(self)
            self:Remove()
            self.isRegistered = false
            COMMANDS_REGISTERED[self.name] = nil
            self = nil
        end,
    },

    OnExecute = function(self, callback)
        self.execute = callback
    end,

    OnError = function(self, callback)
        self.error = callback
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

    local instance = Command:New(name, params, state)
    COMMANDS_REGISTERED[name] = instance
    if state then
        instance:Start()
    end

    return instance
end

RegisterNetEvent('vorp:SelectedCharacter', function()
    -- here we start the commands registered
    for _, command in pairs(COMMANDS_REGISTERED) do
        if command.isActive then             -- if its  active that means user want to register the command right away
            if command.permissions?.Ace then -- if not ace
                if command.suggestion?.Arguments and next(command.suggestion.Arguments) then
                    command:AddSuggestion()
                end
            else
                -- if ace then add suggestion if any
                if command.suggestion?.Arguments and next(command.suggestion.Arguments) then
                    command:AddSuggestion()
                end
            end
        end
    end
end)

--[[ return {
    Command = Command
} ]]

-- example usage client side

local command <const> = LIB.Command:Register("commandName", {

    Suggestion = {
        Description = "description of command suggestion",
        arguments = {
            { name = "Id",  help = "player id", type = "player", required = true },
            { name = "msg", help = "message",   type = "string", required = true }
        }
    },

    Permissions = {
        Ace = "group.admin", -- or false
    },

    OnExecute = function(source, args, rawCommand, self)
        print(source, args, rawCommand)
    end,

    OnError = function(error)
        if error == 'missing_arguments' then
            print('command usage: /commandName <id> <msg>')
        end
    end
}, true) -- this param allows to not register just yet if true registers right away

--[[ -- when character is loaded

-- if not defined onExecute or onError, it will use the default ones
command:OnExecute(function(source, args, rawCommand)
    print(source, args, rawCommand)
    commands:Destroy()
end)

command:OnError(function(error)
    if error == 'missing_arguments' then
        print('command usage: /commandName <id> <msg>')
    end
end)
 ]]
