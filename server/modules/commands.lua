local LIB <const> = Import 'class'

local COMMANDS <const> = {}
local ERROR_TYPES <const> = {
    ARGUMENTS = 'missing_arguments',
    PERMISSION = 'missing_permission',
    TARGET = 'missing_target',
    NOT_TARGET = 'not_target',
    STATE = 'missing_state',
    USER = 'missing_user',
    GROUP = 'missing_group',
    JOB = 'missing_job',
    GRADE = 'missing_grade',
}

---@class Command
local Command <const> = LIB.Class:Create({
    ---@Constructor
    constructor = function(self, name, params, state)
        self.name = name
        self.isActive = state
        self.chatSuggestion = params.ChatSuggestion
        self.execute = params.OnExecute
        self.error = params.OnError
        self.ace = params.Ace
        self.targets = params.Targets
        self.permissions = params.Permissions
    end,

    set = {

        Remove = function(self)
            TriggerClientEvent("chat:removeSuggestion", -1, ("/%s"):format(self.name))
            RegisterCommand(self.name, function() end, false)
            self.isActive = false
        end,

        Pause = function(self)
            if not self.isActive then return end
            self.isActive = false
        end,

        AddSuggestion = function(self, target)
            if self.ace or not self.chatSuggestion then return end
            if type(self.chatSuggestion) ~= 'table' then return end

            local suggestion <const> = self.chatSuggestion
            local newArguments <const> = {}

            if suggestion.arguments and next(suggestion.arguments) then
                for i = 1, 2 do
                    table.insert(newArguments, {
                        name = suggestion.arguments[i].name,
                        help = suggestion.arguments[i].help
                    })
                end

                TriggerClientEvent("chat:addSuggestion", target, ("/%s"):format(self.name), suggestion.description, newArguments)
            end
        end,

        RemoveSuggestion = function(self, target)
            if not target then return print('you must provide a target') end
            TriggerClientEvent("chat:removeSuggestion", target, ("/%s"):format(self.name))
        end,

        Resume = function(self)
            if self.isActive then return end
            self.isActive = true
            local permissions <const> = self.permissions and next(self.permissions) and self.permissions or false

            RegisterCommand(self.name, function(source, args, rawCommand)
                if not self.isActive then return end -- for global

                local function validate()
                    local allowed = false
                    local errorType = ""

                    if #self.suggestion.arguments ~= #args then
                        return ERROR_TYPES.ARGUMENTS
                    end

                    if source == 0 then
                        return ERROR_TYPES.USER
                    end

                    if not permissions then
                        return false
                    end

                    if permissions.Ace then
                        return false
                    end

                    local user <const> = Core.getUser(source)
                    if not user then
                        return ERROR_TYPES.USER
                    end

                    local user_group <const> = user.group
                    local character <const> = user.getUsedCharacter
                    local character_group <const> = character.group
                    local job <const> = user.job
                    local grade <const> = user.grade
                    -- here we will check for permissions

                    if permissions.Jobs and permissions.Jobs[job] then
                        -- is a table then has grades
                        if type(permissions.Jobs[job]) == "table" then
                            if permissions.Jobs[job][grade] then
                                allowed = true
                                errorType = ERROR_TYPES.GRADE
                            end
                        else
                            allowed = true
                            errorType = ERROR_TYPES.JOB
                        end
                    end

                    if permissions.Groups then
                        if permissions.Groups.users and permissions.Groups.users[user_group] then
                            allowed = true
                            errorType = ERROR_TYPES.GROUP
                        end

                        if permissions.Groups.characters and permissions.Groups.characters[character_group] then
                            allowed = true
                            errorType = ERROR_TYPES.GROUP
                        end
                    end

                    if permissions.CharactersId and permissions.CharactersId[character.id] then
                        allowed = true
                        errorType = ERROR_TYPES.CHARACTER
                    end

                    if allowed then
                        return
                    end

                    return errorType
                end

                local errorType <const> = validate()
                if errorType then
                    if self.error then
                        return self.error(errorType)
                    end
                    return self:OnError(errorType)
                end

                if self.suggestion and self.suggestion.arguments then
                    for i = 1, #self.suggestion.arguments do
                        local type <const> = self.suggestion.arguments[i].type
                        if type == 'player' then
                            if not DoesPlayerExist(args[i]) then
                                return ERROR_TYPES.USER
                            end
                            -- send as number
                            args[i] = tonumber(args[i])
                        elseif type == 'number' then
                            if not tonumber(args[i]) then
                                -- send as number
                                args[i] = tonumber(args[i])
                            end
                        end
                    end
                end

                if self.callback then
                    return self.execute(source, args, rawCommand, self)
                end

                self:OnExecute(source, args, rawCommand, self)
            end, permissions and permissions.Ace or false)
            --todo: add group automatically if restricted ?
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
        end,
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

    local instance <const> = Command:New(name, params, state)
    COMMANDS[name] = instance
    if state then
        instance:Resume()
    end

    return instance
end

-- add command suggestions when a character is selected only
AddEventHandler('vorp:SelectedCharacter', function(source, character)
    local function allowedForCommand(permissions)
        local allowed = false

        local character_group <const> = character.group
        local job <const> = character.job
        local grade <const> = character.grade

        if permissions.Jobs and permissions.Jobs[job] then
            if type(permissions.Jobs[job]) == "table" then
                if permissions.Jobs[job][grade] then
                    allowed = true
                end
            else
                allowed = true
            end
        end

        if permissions.Groups then
            if permissions.Groups.users then
                local user <const> = Core.getUser(source)
                if permissions.Groups.users[user.getGroup] then
                    allowed = true
                end
            end

            if permissions.Groups.characters and permissions.Groups.characters[character_group] then
                allowed = true
            end
        end

        if permissions.CharactersId and permissions.CharactersId[character.id] then
            allowed = true
        end

        return allowed
    end

    -- add suggestion for commands everytime they join the server
    for _, command in pairs(COMMANDS) do
        -- if not ace
        if command.permissions then
            if not command.permissions.Ace then
                if command.chatSuggestion then
                    if not command.chatSuggestion.target then
                        local allowed <const> = allowedForCommand(command.permissions)
                        if allowed then
                            command:AddSuggestion(source)
                        end
                    else
                        -- if target is -1 then add suggestion for all players
                        command:AddSuggestion(source)
                    end
                end
            else
                -- for ace
                command:AddSuggestion(source)
            end
        end
    end
end)

--[[ return {
    Command = Command
}
 ]]

-- registers chat suggestion on char selected based on the permissions you set, or default to all players
local command <const> = LIB.Command:Register("commandName", {
    --OPTIONAL
    ChatSuggestion = {
        description = "description of command suggestion",
        target = -1,                                                                -- if its to all players add-1 and will ignore the permissions otherwise remove it
        arguments = {
            { name = "Id",  help = "player id", type = "player", required = true }, -- required is optional
            { name = "msg", help = "message",   type = "string", required = true }  -- if type is player will check if player exists
        },
    },

    --OPTIONAL
    Permissions = {
        Ace = false, -- restrict command
        --OPTIONAL this users will have the chat suggestion added automatically when they join with their character.
        Groups = {
            users = {
                admin = true
            }, -- remove users to not use this,usually this is for admins
            characters = {
                admin = true
            }, -- character groups
        },     -- only these groups can use the command, this uses vorp system, leave false to not use or remove the table

        --OPTIONAL
        Jobs = {             -- leave false to not use or remove the table
            police = {       -- name of the job, if all grades are allowed just do jobname = true instead of table
                [0] = false, --block this grade
                [1] = true   --allow this grade
            }
        },

        --OPTIONAL
        CharactersId = {
            [1] = true, -- this character id is allowed to use the command
        },
    },

    OnExecute = function(source, args, rawCommand, self)
        print(source, args, rawCommand, self)
    end,

    OnError = function(error)
        -- based on your requirements you can use this to handle errors and apply your own notifications and translations
        if error == 'missing_arguments' then
            print('command usage: /commandName <id> <msg>')
        end

        if error == 'missing_permission' then
            print('you do not have permission to use this command')
        end

        if error == 'missing_target' then
            print('you must be a player to use this command')
        end

        if error == 'not_target' then
            print('you must be the target to use this command')
        end

        if error == 'missing_group' then
            print('this command is locked to a group admin')
        end

        if error == 'missing_job' then
            print('this command is locked to a job police')
        end

        if error == 'missing_grade' then
            print('this command is locked to a grade 1')
        end

        if error == 'missing_user' then
            print('user does not exist or id is missing')
        end

        if error == 'missing_state' then
            print('this command is disabled for now')
        end
    end,

}, false)
