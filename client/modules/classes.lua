local Class = {}
function Class.Create(base)
    local cls = {}
    cls.__index = cls
    setmetatable(cls, { __index = base })

    function cls:new(o)
        o = o or {}
        local instance = setmetatable(o, cls)
        if instance.constructor then
            instance:constructor(o)
        elseif cls.constructor then
            cls.constructor(instance, o)
        end
        return instance
    end

    function cls:super(...)
        if base and base.constructor then
            base.constructor(self, ...)
        end
    end

    cls.__index = function(self, key)
        local val = rawget(cls, key)
        if val then
            return val
        elseif cls.get and cls.get[key] then
            return cls.get[key](self)
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

    return cls
end

return {
    Class = Class,
}
-- example 

