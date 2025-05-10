-- here we will add a register command classs for players to use

local LIB <const> = Import 'class'

local ERROR_TYPES <const> = {
    ARGUMENTS = 'missing_arguments',
    PERMISSION = 'missing_permission',
    TARGET = 'missing_target',
    STATE = 'missing_state',
}

---@class Command
local Command <const> = LIB.Class:Create({
    ---@Constructor
    constructor = function(self, name, params, state)
        self.name = name
        self.isActive = state
        self.description = params.Description
        self.suggestion = params.Suggestion
        self.execute = params.OnExecute
        self.error = params.OnError
        self.ace = params.Ace
    end,

    set = {

        Remove = function(self)
            TriggerEvent("chat:removeSuggestion", ("/%s"):format(self.name))
            RegisterCommand(self.name, function() end, false)
            exports.vorp_lib:UnTrackCommand(self.name)
            self.isActive = false
        end,

        Pause = function(self)
            if not self.isActive then return end
            self.isActive = false
        end,

        Resume = function(self)
            if self.isActive then return end
            self.isActive = true

            TriggerEvent("chat:addSuggestion", ("/%s"):format(self.name), self.description, self.suggestion)
            RegisterCommand(self.name, function(source, args, rawCommand)
                if not self.isActive then return end

                if self.suggestion ~= #args then
                    if self.onError then
                        return self.error(ERROR_TYPES.ARGUMENTS)
                    end
                    return self:OnError(ERROR_TYPES.ARGUMENTS)
                end

                if self.callback then
                    return self.execute(source, args, rawCommand, self)
                end

                self:OnExecute(source, args, rawCommand, self)
            end, self.ace)
        end,

        Destroy = function(self)
            self:Remove()
            self = nil
        end,

        OnExecute = function(self, callback)
            self.onExecute = callback
        end,

        OnError = function(self, callback)
            self.onError = callback
        end
    }

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
    if state then
        instance:Resume()
    end

    return instance
end

return {
    Command = Command
}

-- example usage client side

--[[ local command <const> = LIB.Command:Register("commandName", {
    Description = "description of command suggestion",
    Suggestion = {
        { name = "Id",  help = "player id" },
        { name = "msg", help = "message" }
    },          -- to register chat suggestions
    Ace = true, -- restrict command
    OnExecute = function(source, args, rawCommand, command)
        print(source, args, rawCommand)
        command:Destroy()
    end,
    OnError = function(error)
        if error == 'missing_arguments' then
            print('command usage: /commandName <id> <msg>')
        end
    end
}, true) -- this param allows to not register just yet if true registers right away ]]

--[[ -- when character is loaded
command:Destroy() -- destroy and remove command
command:Pause()   -- pause execution of the command
command:Resume()  -- resume execution of the command

-- if not defined onExecute or onError, it will use the default ones
command:OnExecute(function(source, args, rawCommand, commands)
    print(source, args, rawCommand)
    commands:Destroy()
end)

command:OnError(function(error)
    if error == 'missing_arguments' then
        print('command usage: /commandName <id> <msg>')
    end
end)
 ]]
