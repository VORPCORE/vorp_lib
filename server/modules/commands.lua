local LIB <const> = Import 'class'

local ERROR_TYPES <const> = {
    ARGUMENTS = 'missing_arguments',
    PERMISSION = 'missing_permission',
    TARGET = 'missing_target',
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
        self.description = params.Description
        self.suggestion = params.Suggestion
        self.execute = params.OnExecute
        self.error = params.OnError
        self.ace = params.Ace
        self.target = params.Target or -1
        self.groups = params.Groups or {}
        self.jobs = params.Jobs or {}
    end,

    set = {

        Remove = function(self)
            TriggerClientEvent("chat:removeSuggestion", self.target, ("/%s"):format(self.name))
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

            TriggerClientEvent("chat:addSuggestion", self.target, ("/%s"):format(self.name), self.description, self.suggestion)
            RegisterCommand(self.name, function(source, args, rawCommand)
                if not self.isActive then return end

                local errorType <const> = self:ValidateCommand(source, args)
                if errorType then
                    if self.onError then
                        return self.error(errorType)
                    end
                    return self:OnError(errorType)
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
        end,

        ValidateCommand = function(self, source, args)
            if #self.suggestion ~= #args then
                return ERROR_TYPES.ARGUMENTS
            end

            if source == 0 then
                return ERROR_TYPES.TARGET
            end

            --[[   if self.groups then
                if next(self.groups) then
                    local user = self:GetData(source)
                    if not user then
                        return ERROR_TYPES.USER
                    end

                    local group = user.getGroup
                    if not self.groups[group] then
                        return ERROR_TYPES.GROUP
                    end
                end
            end

            if self.jobs then
                if next(self.jobs) then
                    local user = self:GetData(source)
                    if not user then
                        return ERROR_TYPES.USER
                    end

                    local job = user.getUsedCharacter.job
                    if not self.jobs[job] then
                        return ERROR_TYPES.JOB
                    end
                end
            end ]]
        end,

        UpdateTarget = function(self, target)
            self.target = target
        end,
        -- not needed for most people, only for those who dont know what they are doing
        --[[    UpdateGroupEntry = function(self, group, state)
            if not self.groups[group] then
                return print(('group %s not found use AddGroupEntry first'):format(group))
            end
            self.groups[group] = state
        end,

        AddGroupEntry = function(self, group, state)
            if self.groups[group] then
                return print(('group %s already exists use UpdateGroupEntry instead'):format(group))
            end
            self.groups[group] = state
        end,

        RemoveGroupEntry = function(self, group)
            self.groups[group] = nil
        end,

        UpdateJobEntry = function(self, job, data)
            -- insert to the table
            if not self.jobs[job] then
                return print(('job %s not found use AddJobEntry first'):format(job))
            end
            self.jobs[job] = data
        end,

        AddJobEntry = function(self, job)
            if self.jobs[job] then
                return print(('job %s already exists use UpdateJobEntry instead'):format(job))
            end
            self.jobs[job] = {}
        end,

        RemoveJobEntry = function(self, job)
            self.jobs[job] = nil
        end,

        UpdateJobGradeState = function(self, job, grade, state)
            if not self.jobs[job] then
                return print(('job %s not found use AddJobEntry first'):format(job))
            end

            if not self.jobs[job][grade] then
                return print(('grade %s not found use AddJobGradeEntry first'):format(grade))
            end

            self.jobs[job][grade] = state
        end,

        AddJobGradeEntry = function(self, job, grade, state)
            if not self.jobs[job] then
                return print(('job %s not found use UpdateJobEntry first'):format(job))
            end

            if self.jobs[job][grade] then
                return print(('grade %s already exists use UpdateJobGradeState instead'):format(grade))
            end

            self.jobs[job][grade] = state
        end, ]]

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
    if state then
        instance:Resume()
    end

    return instance
end

--[[ return {
    Command = Command
}
 ]]

-- on the server side we can add more options to the command
local command <const> = LIB.Command:Register("commandName", {
    Description = "description of command suggestion",
    Target = -1, -- add suggestion for all players or add the source, and or update the target
    Suggestion = {
        { name = "Id",  help = "player id" },
        { name = "msg", help = "message" }
    },          -- to register chat suggestions
    Ace = true, -- restrict command
    -- this is just to make it easier, but its not neccessary for most people
    --[[   Groups = { admin = true }, -- only these groups can use the command, this uses vorp system, leave false to not use or remove the table
    Jobs = {                   -- leave false to not use or remove the table
        police = {             -- name of the job, if all grades are allowed just do jobname= true instead of table
            [0] = false,       --block this grade
            [1] = true         --allow this grade
        }
    },                         -- only these jobs can use the command, this uses vorp system ]]
    OnExecute = function(source, args, rawCommand, command)
        local user = Core.getUser(source)
        if not user then return end

        local user_group = user.getGroup
        local character_group = user.getUsedCharacter.group
        local character_job = user.getUsedCharacter.job
        local character_grade = user.getUsedCharacter.grade

        print(user_group, character_group, character_job, character_grade)
    end,
    OnError = function(error)
        if error == 'missing_arguments' then
            print('command usage: /commandName <id> <msg>')
        end

        if error == 'missing_permission' then
            print('you do not have permission to use this command')
        end

        if error == 'missing_target' then
            print('you must be a player to use this command')
        end
    end,

}, false) -- this param allows to not register just yet if true registers right away ]]

-- once character is loaded and you want to send to a specific player
-- useful for commands that are not available for all players update target before calling resume and state was false
command:UpdateTarget(source)
command:Resume()
