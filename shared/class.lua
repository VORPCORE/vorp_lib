local class <const> = {}

print("^3WARNING: ^7module CLASS is a work in progress use it at your own risk")
--TODO: add private methods

function class:Create(base)
    local cls   = {}
    cls.__index = cls
    setmetatable(cls, { __index = base })
    --[[ local private_data = setmetatable({}, { __mode = "k" }) ]]

    function cls:new(o)
        o              = o or {}
        local instance = {}

        if type(o) == "table" then
            instance = setmetatable(o, cls)
        else
            instance = setmetatable({ value = o }, cls)
        end

        if instance.constructor then
            instance:constructor(o)
        elseif cls.constructor then
            cls.constructor(instance, o)
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
