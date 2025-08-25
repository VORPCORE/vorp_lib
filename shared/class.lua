local class <const> = {}

print("^3WARNING: ^7module CLASS is a work in progress use it at your own risk")
--TODO: add private methods

function class:Create(base)
    local cls   = {}
    cls.__index = cls
    setmetatable(cls, { __index = base })
    --[[ local private_data = setmetatable({}, { __mode = "k" }) ]]
    function cls:New(...)
        local numArgs = select('#', ...)
        local firstArg = select(1, ...)
        local instance = {}

        if numArgs == 1 and type(firstArg) == "table" then
            instance = setmetatable(firstArg, cls)
        else
            instance = setmetatable({}, cls)
        end

        if instance.constructor then
            instance:constructor(...)
        elseif cls.constructor then
            cls.constructor(instance, ...)
        end
        -- private_data[instance] = {}
        return instance
    end

    function cls:super(...)
        if base and base.constructor then
            base.constructor(self, ...)
        end
    end

    --[[    -- Set private data for the instance
    function cls:setPrivate(key, value)
        private_data[self][key] = value
    end

    -- Get private data for the instance
    function cls:getPrivate(key)
        return private_data[self][key]
    end ]]

    cls.__index = function(self, key)
        local val = rawget(cls, key)
        if val then
            return val
        elseif cls.get and cls.get[key] then
            return function(_, ...)
                return cls.get[key](self, ...)
            end
        elseif cls.set and cls.set[key] then
            return function(_, ...)
                return cls.set[key](self, ...)
            end
        else
            return base and base[key]
        end
    end


    cls.__newindex = function(self, key, value)
        if cls.set and cls.set[key] then
            cls.set[key](self, value)
        else
            rawset(self, key, value)
        end
    end
    --[[
    cls.__newindex = function(self, key, value)
        if private_data[self] and private_data[self][key] then
            print("Cannot modify private field: " .. tostring(key))
        elseif cls.set and cls.set[key] then
            cls.set[key](self, value)
        else
            rawset(self, key, value)
        end
    end
 ]]

    return cls
end

return {
    Class = class,
}


-- constructor can be a table or a number of arguments
-- exmaple

--[[
class:Create({
    constructor = function(self, data)
        self.any = data.any
        self.any_2 = data.any_2
        self.any_3 = data.any_3
    end
})

local event = class:New({  any = 0,  any_2= "any_2", any_3= {}})

-- OR

class:Create({
    constructor = function(self, name, group, callback  )
        self.eventHash = name
        self.eventGroup = group
        self.eventCallback = callback
    end
})

local event = class:New("name", "group", "callback")

-- ]]
