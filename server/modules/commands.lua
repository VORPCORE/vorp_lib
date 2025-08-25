local LIB <const> = Import 'class'

---@type table<string, {}>
local COMMANDS_REGISTERED <const> = {}

---@type table<string, string>
local ERROR_TYPES <const> = {
    MISSING_ARGUMENTS = 'missing_arguments',
    MISSING_PERMISSION = 'missing_permission',
    MISSING_TARGET = 'missing_target',
    MISSING_STATE = 'missing_state',
    MISSING_USER = 'missing_user',
    MISSING_GROUP = 'missing_group',
    MISSING_JOB = 'missing_job',
    MISSING_GRADE = 'missing_grade',
    MISSING_CHARACTER = 'missing_character',
    ACTIVE = 'command_active',
}

local function hasPermissions(permissions, character, user, source)
    local allowed = false
    local errorType = ""

    if not permissions?.Jobs and not permissions?.Groups and not permissions?.CharIds then
        return true, nil
    end

    if (not permissions?.Jobs or not next(permissions?.Jobs)) and
        (not permissions?.Groups or not next(permissions?.Groups)) and
        (not permissions?.CharIds or not next(permissions?.CharIds)) then
        return true, nil
    end


    if permissions?.Jobs?[character.job] then
        -- if is a table then has ranks to check
        if type(permissions.Jobs[character.job]) == "table" then
            if permissions.Jobs[character.job][character.grade] then
                allowed = true
            else
                errorType = ERROR_TYPES.MISSING_GRADE
            end
        else -- if is bool only need job
            allowed = true
        end
    else
        errorType = ERROR_TYPES.MISSING_JOB
    end

    if allowed then return true, nil end

    if permissions?.Groups?.users then
        if not user and source then
            user = Core.getUser(source)
        end

        if permissions.Groups.users[user.group] then
            return true, nil
        else
            errorType = ERROR_TYPES.MISSING_GROUP
        end
    end

    if permissions?.Groups?.characters then
        if permissions.Groups.characters[character.group] then
            return true, nil
        else
            errorType = ERROR_TYPES.MISSING_GROUP
        end
    end


    if permissions?.CharIds?[character.charIdentifier] then
        return true, nil
    else
        errorType = ERROR_TYPES.MISSING_CHARACTER
    end

    return false, errorType
end



---@class Command
local Command <const> = LIB.Class:Create({

    constructor = function(self, name, params)
        self.name = name
        self.isActive = false
        self.suggestion = params.Suggestion
        self.execute = params.OnExecute
        self.error = params.OnError
        self.permissions = params.Permissions
        self.isRegistered = false
    end,

    set = {

        Remove = function(self)
            if not self.isRegistered then return print('command is not registered to be removed') end
            self.isRegistered = false

            TriggerClientEvent("chat:removeSuggestion", -1, ("/%s"):format(self.name))
            RegisterCommand(self.name, function() end, false)

            if self.permissions?.Ace then
                if IsPrincipalAceAllowed(self.permissions.Ace, ('command.%s'):format(self.name)) then
                    ExecuteCommand(('remove_ace %s %s %s'):format(self.permissions.Ace, ('command.%s'):format(self.name), "allow"))
                end
            end

            self.isActive = false
            COMMANDS_REGISTERED[self.name] = nil
        end,

        Pause = function(self)
            if not self.isActive then return end
            self.isActive = false
        end,

        AddSuggestion = function(self, target)
            local suggestion <const> = self.suggestion
            local newArguments <const> = {}

            if not suggestion then
                return
            end

            if type(suggestion) ~= 'table' then
                return
            end

            if suggestion.Arguments and next(suggestion.Arguments) then
                for i = 1, #suggestion.Arguments do
                    table.insert(newArguments, {
                        name = suggestion.Arguments[i].name,
                        help = suggestion.Arguments[i].help
                    })
                end

                TriggerClientEvent("chat:addSuggestion", target, ("/%s"):format(self.name), suggestion.Description, newArguments)
            end
        end,
        -- only remove suggestion from player
        RemoveSuggestion = function(self, target)
            if not target then return print('you must provide a target') end
            TriggerClientEvent("chat:removeSuggestion", target, ("/%s"):format(self.name))
            -- remove ace from player?
            if self.permissions?.Ace then
                if IsPrincipalAceAllowed(self.permissions.Ace, ('command.%s'):format(self.name)) then
                    ExecuteCommand(('remove_ace %s %s %s'):format(self.permissions.Ace, ('command.%s'):format(self.name), "allow"))
                end
            end
        end,

        Resume = function(self)
            if self.isActive then return end
            self.isActive = true
        end,

        Start = function(self)
            if self.isActive then return end
            self.isActive = true

            if self.isRegistered then return print('command is already registered') end
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

                local errorType <const> = self:validate(args, source, permissions)
                if errorType then
                    return self.error and self.error(errorType) or print(errorType)
                end

                args = self:getTypes(args)

                self.execute(source, args, rawCommand, self)
            end, isRestricted)

            if isRestricted and principal then
                if not IsPrincipalAceAllowed(principal, ('command.%s'):format(self.name)) then
                    ExecuteCommand(('add_ace %s %s %s'):format(principal, ('command.%s'):format(self.name), "allow"))
                end
            end
        end,

        Destroy = function(self)
            self:Remove()
            self.isRegistered = false
            COMMANDS_REGISTERED[self.name] = nil
            self = nil -- does it actually destroy it?
        end,

        isRequiredArgument = function(self, args)
            for i = 1, #self.suggestion.Arguments do
                if self.suggestion.Arguments[i].required and (not args[i] or args[i] == "") then
                    return ERROR_TYPES.MISSING_ARGUMENTS
                end
            end
        end,

        validate = function(self, args, source, permissions)
            local requiredError <const> = self:isRequiredArgument(args)
            if requiredError then
                return requiredError
            end

            if source == 0 then
                return ERROR_TYPES.MISSING_USER
            end

            if not permissions then
                return
            end

            if permissions.Ace then
                return
            end

            local user <const> = Core.getUser(source)
            if not user then
                return ERROR_TYPES.MISSING_USER
            end

            local allowed, errorType <const> = hasPermissions(permissions, user.getUsedCharacter, user, source)
            if allowed then
                return
            end

            return errorType
        end,

        getTypes = function(self, args)
            local arguments <const> = self.suggestion?.Arguments
            if arguments and next(arguments) then
                for i = 1, #arguments do
                    local type <const> = arguments[i].type
                    if type == 'integer' or type == "number" then
                        if not DoesPlayerExist(args[i]) then
                            return false, ERROR_TYPES.MISSING_USER
                        end
                        args[i] = tonumber(args[i])
                    elseif type == 'message' then
                        local messageArgs <const> = {}
                        for j = i, #args do
                            messageArgs[#messageArgs + 1] = args[j]
                        end
                        args[i] = table.concat(messageArgs, " ")
                    end
                end
            end

            return args
        end,
    },

    OnExecute = function(self, callback)
        self.execute = callback
    end,

    OnError = function(self, callback)
        self.error = callback
    end,

})


local function isCommandRegistered(name)
    local isRegistered <const> = GetRegisteredCommands()
    for _, command in ipairs(isRegistered) do
        if command.name == name then
            return command.resource
        end
    end
end


function Command:Register(commandName, params, state)
    if not commandName then
        error('must provide a name for the command')
    end

    if type(commandName) ~= 'string' then
        error('command name must be a string')
    end

    if params.Permissions?.Ace then
        if type(params.Permissions.Ace) ~= 'string' then
            error('command ace must be a string to automatically add the user to the ace group if he is not allowed to use the command, other wise remove it')
        end
    end

    local isRegistered <const> = isCommandRegistered(commandName)
    if isRegistered then
        error(('command %s is already registered by %s'):format(commandName, isRegistered))
    end

    local instance <const> = Command:New(commandName, params)
    COMMANDS_REGISTERED[commandName] = instance
    if state then
        instance:Start()
    end

    return instance
end

--CLEAN UP
AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end

    for _, command in pairs(COMMANDS_REGISTERED) do
        command:Destroy()
    end
end)

-- FOR DEBUGGING
AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    Wait(5000)
    -- for when we restart the resouce to test the commands
    if not LocalPlayer.state.IsInSession then return end -- if not then its not restarting the resource

    local character <const> = {
        job = LocalPlayer.state.Character.Job,
        grade = LocalPlayer.state.Character.Grade,
        group = LocalPlayer.state.Character.Group,
        charIdentifier = LocalPlayer.state.Character.CharId,
    }

    for _, command in pairs(COMMANDS_REGISTERED) do
        -- if its active then add suggestions?
        if command.isActive then
            if command.permissions?.Ace then
                if command.suggestion?.Arguments and next(command.suggestion.Arguments) then
                    local allowed <const> = hasPermissions(command.permissions, character, nil, source)
                    if allowed then
                        command:AddSuggestion(source)
                    end
                end
            else
                if command.suggestion?.Arguments and next(command.suggestion.Arguments) then
                    command:AddSuggestion(source)
                end
            end
        end
    end
end)


-- add command suggestions when a character is selected only
AddEventHandler('vorp:SelectedCharacter', function(source, character)
    for _, command in pairs(COMMANDS_REGISTERED) do
        -- if its active then add suggestions?
        if command.isActive then
            if command.permissions?.Ace then
                if command.suggestion?.Arguments and next(command.suggestion.Arguments) then
                    local allowed <const> = hasPermissions(command.permissions, character, nil, source)
                    if allowed then
                        command:AddSuggestion(source)
                    end
                end
            else
                if command.suggestion?.Arguments and next(command.suggestion.Arguments) then
                    command:AddSuggestion(source)
                end
            end
        end
    end
end)

--[[ return {
    Command = Command
}
 ]]


-- example from here
--[[ local LIB <const> = Import 'command'
local Commands <const> = LIB.Commands --@as Command --to get intellisense



-- registers chat suggestion on char selected based on the permissions you set, or default to all players
local command <const> = Commands:Register("commandName", {

    Suggestion = {
        Description = "description of command suggestion",
        Arguments = {
            { name = "Id",  help = "player id", type = "player",  required = true }, -- required is optional
            { name = "msg", help = "message",   type = "message", required = true }  -- if type is player will check if player exists
        },
    },

    Permissions = {
        Ace = 'group.admin', -- ace permisions will override any other permisions you set. remove if you dont want to use this
        --OPTIONAL
        Groups = {           -- remove this to not use groups checks

            users = {        -- from DB users table for admins
                admin = true
            },

            characters = { -- from DB characters table for admins/character groups/gangs
                gang = true
            },
        },

        --OPTIONAL
        Jobs = {       -- remove this to not use job checks

            POLICE = { -- leave true if no need to check grades other wise make it a table with the grades
                [0] = false,
                [1] = true
            }
        },

        --OPTIONAL
        CharIds = {
            [1] = true,
        },
    },

    OnExecute = function(source, args, rawCommand, self)
        print(source, args, rawCommand, self)
    end,

    OnError = function(error)
        if error == 'missing_arguments' then
            print('command usage: /commandName <id> <msg>')
        end
    end,

}, true) ]] -- if this is false then you need to resume the command manually yourself and add the chat suggestions manually too for each player.

-- command:Start() -- will resume the command when you paused it or when you register it with false


-- Option 2 use methods
--[[ command:OnExecute(function(source, args, rawCommand)
    print(source, args, rawCommand)
end)

command:OnError(function(error)
    if error == 'missing_arguments' then
        print('command usage: /commandName <id> <msg>')
    end
end) ]]


--! make sure this is in your server.cfg for adding ace permissions or remove it if you dont want to use ace permissions
--add_ace resource.vorp_lib command.add_ace allow
--add_ace resource.vorp_lib command.remove_ace allow
