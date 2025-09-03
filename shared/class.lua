local class <const> = {}

function class:Create(base, className)
    local cls <const> = {}
    setmetatable(cls, { __index = base })

    local current_class_context      = nil
    local private_properties <const> = setmetatable({}, { __mode = "k" })
    local private_owners <const>     = setmetatable({}, { __mode = "k" })

    -- mark as class
    cls.__is_class                   = true
    cls._class_name                  = className or
        (base and base._class_name and (base._class_name .. " (extended)") or "Class")

    local function isPrivate(key)
        return type(key) == "string" and key:sub(1, 1) == "_"
    end
    local function isClass(t)
        return type(t) == "table" and rawget(t, "__is_class") == true
    end

    if base and type(base) == "table" and not isClass(base) then
        for k, v in pairs(base) do
            cls[k] = v
        end

        base = nil -- no superclass in this case these are just members
        setmetatable(cls, nil)
    end

    function cls:New(...)
        local n  = select("#", ...)
        local a1 = select(1, ...)
        local inst
        if n == 1 and type(a1) == "table" then
            inst = setmetatable(a1, cls)
        else
            inst = setmetatable({}, cls)
        end
        private_properties[inst] = {}

        local old = current_class_context
        current_class_context = cls
        if inst.constructor then
            inst:constructor(...)
        elseif cls.constructor then
            cls.constructor(inst, ...)
        end

        current_class_context = old
        return inst
    end

    function cls:super(...)
        if base?.constructor then
            local old = current_class_context
            current_class_context = base
            base.constructor(self, ...)
            current_class_context = old
        end
    end

    local index    = function(self, key)
        if isPrivate(key) then
            local owner = private_owners[self] and private_owners[self][key]
            if owner and current_class_context ~= owner then
                error(("Cannot access private member '%s' from outside class %s"):format(tostring(key), owner._class_name or "Unknown"))
            end

            if private_properties[self] and private_properties[self][key] then
                return private_properties[self][key]
            end
        end

        local val = rawget(cls, key)
        if val ~= nil then
            if isPrivate(key) and type(val) == "function" and current_class_context ~= cls then
                return function()
                    error(("Cannot call private method '%s' from outside class %s"):format(tostring(key), cls._class_name))
                end
            end
            if type(val) == "function" then
                return function(instance, ...)
                    local old = current_class_context
                    current_class_context = cls
                    local r = val(instance, ...)
                    current_class_context = old
                    return r
                end
            end
            return val
        end

        if base?.get?[key] then
            local getter = base.get[key]
            return function(_, ...)
                local old = current_class_context
                current_class_context = base
                local result = getter(self, ...)
                current_class_context = old
                return result
            end
        end

        if cls?.get?[key] then
            local getter = cls.get[key]
            return function(_, ...)
                local old = current_class_context
                current_class_context = cls
                local result = getter(self, ...)
                current_class_context = old
                return result
            end
        end

        if base?.set?[key] then
            local setter = base.set[key]
            return function(_, ...)
                local old = current_class_context
                current_class_context = base
                local result = setter(self, ...)
                current_class_context = old
                return result
            end
        end

        if cls?.set?[key] then
            local setter = cls.set[key]
            return function(_, ...)
                local old = current_class_context
                current_class_context = cls
                local result = setter(self, ...)
                current_class_context = old
                return result
            end
        end


        if isClass(base) then
            local bval = rawget(base, key)

            if bval then
                if isPrivate(key) and type(bval) == "function" and current_class_context ~= base then
                    return function()
                        error(("Cannot call private method '%s' from outside class %s"):format(tostring(key), base._class_name or "Unknown"))
                    end
                end

                if type(bval) == "function" then
                    return function(instance, ...)
                        local old = current_class_context
                        current_class_context = base
                        local r = bval(instance, ...)
                        current_class_context = old
                        return r
                    end
                end
                return bval
            end

            if base?.get[key] then
                local getter = base.get[key]
                return function(_, ...)
                    local old = current_class_context
                    current_class_context = base
                    local result = getter(self, ...)
                    current_class_context = old
                    return result
                end
            end

            if base?.set[key] then
                local setter = base.set[key]
                return function(_, ...)
                    local old = current_class_context
                    current_class_context = base
                    local result = setter(self, ...)
                    current_class_context = old
                    return result
                end
            end
        end

        return nil
    end

    local newIndex = function(self, key, value)
        if isPrivate(key) then
            local owner = private_owners[self] and private_owners[self][key]
            if owner and current_class_context ~= owner then
                error(("Cannot modify private member '%s' from outside class %s"):format(tostring(key), owner._class_name or "Unknown"))
            end

            if not private_properties[self] then private_properties[self] = {} end
            if not private_owners[self] then private_owners[self] = {} end

            private_owners[self][key] = current_class_context or cls
            private_properties[self][key] = value
            return
        end

        if cls.set and cls.set[key] then
            local setter = cls.set[key]
            return (function(instance, val)
                local old = current_class_context
                current_class_context = cls
                local result = setter(instance, val)
                current_class_context = old
                return result
            end)(self, value)
        else
            rawset(self, key, value)
        end
    end

    cls.__index    = index
    cls.__newindex = newIndex

    return cls
end

return {
    Class = class,
}
