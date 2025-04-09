local class <const> = {}

function class:Create(base)
    local cls   = {}
    cls.__index = cls
    setmetatable(cls, { __index = base })
    --[[ local private_data = setmetatable({}, { __mode = "k" }) ]]

    function cls:new(data)
        local instance = {}
        data = data or {}

        if type(data) == "table" then
            instance = setmetatable(data, cls)
        else
            instance = setmetatable({ value = data }, cls)
        end

        if instance.constructor then
            instance:constructor(data)
        elseif cls.constructor then
            cls.constructor(instance, data)
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
