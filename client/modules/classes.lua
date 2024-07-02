local function Classes(base)
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

-- EXAMPLE 1 traditional class system for Lua
-- START BY  CALLING THE CONSTRUCTOR OF THE BASE CLASS TO SET THE DEFAULT VALUES
--BaseClass = Classes()
--
--function BaseClass:constructor()
--    self.name = "Unknown"
--    self.age = 0
--end
--
---- use methods to set get or anything else
--function BaseClass:speak()
--    print("Hello, my name is " .. self.name)
--end
--
--function BaseClass:pee()
--    print(self.name .. " is peeing")
--end
--
---- THIS SYSTEM ALSO OFFERS automatic setters and getters just like it's done in real OOP
--BaseClass.set = {
--
--    name = function(self, value)
--        self.name = value
--    end,
--
--    age = function(self, value)
--        self.age = value
--    end
--}
--
--BaseClass.get = {
--    name = function(self)
--        return self.name
--    end,
--    age = function(self)
--        return self.age
--    end
--}
--
---- this will auto set the values and get them if the above has been set up
--BaseClass.name = "MyName"
--BaseClass.age = 10
--print(BaseClass.name, BaseClass.age)

-- create new instances , old instances will not be affected it will retain the old values and  also have the new values added by the new instance
--local dogInstance = Dog:new({ name = "Buddy", age = 4, breed = "Beagle" })  -- ADD MORE PROPERTIES IF YOU WANT or override the existing ones
--dogInstance:speak() -- Output: Hello, my name is Buddy and I am a Beagle
--print(dogInstance.name, dogInstance.age, dogInstance.breed) -- Output: Buddy 4 Beagle


---- Example of usage with automatic setters and getters
----INHERITANCE PASS THE BASE CLASS TO THE DERIVED CLASS
--local Dog = Classes(BaseClass)
--function Dog:constructor()
--    self.name = "Dog"
--    self.age = 0
--    self:super(self.name) -- call the constructor of the base class using super  just like in real OOP
--end
--
---- SET UP AUTOMATIC GETTERS AND SETTERS
--Dog.set = {
--
--    name = function(self, value)
--        self.name = value
--    end,
--
--    age = function(self, value)
--        self.age = value
--    end
--}
--
--Dog.get = {
--
--    name = function(self)
--        return self.name
--    end,
--
--    age = function(self)
--        return self.age
--    end
--}
---- and set them like this
--Dog.name = "Dog"
--Dog.age = 5
--print(Dog.name, Dog.age)
--
---- OR USE THE SETTERS AND GETTERS IN A TRADITIONAL WAY IN LUA
--function Dog:getName()
--    return self.name
--end
--
--function Dog:getAge()
--    return self.age
--end
--
--function Dog:setAge(value)
--    self.age = value
--end
--
--function Dog:setName(value)
--    self.name = value
--end
--
--Dog:setAge(10)
--Dog:setName("Bobby")
--print(Dog:getName())
--print(Dog:getAge())
--
--
---- EXAMPLE 2
---- JAVASCRIPT LIKE CLASS SYSTEM FOR LUA  THIS IS ONLY FOR THE PURPOSE OF EMULATING A REAL CLASS SYSTEM IN LUA AND BECASUE I HAVE NOTHING ELSE TO DO *lies* it's just fun to see how Lua can emulate a class system like JavaScript
---- EXAMPLES OF USAGE OF THE CLASS SYSTEM WITH BASE CLASS AND DERIVED CLASSES OFFERING INHERITANCE FEATURES USING "KEYWORDS" LIKE `constructor`, `set`, `get` FOR AN EASY WAY TO UNDERSTAND REAL WORLD EXAMPLES
-----@class BaseClass
-----@field name string
-----@field age number
-----@field speak function
-----@field pee function
-----@field constructor function
-----@field new function
--BaseClass = Classes({
--
--    ---@constructor
--    constructor = function(self)
--        ---@properties
--        self.name = "Unknown"
--        self.age = 0
--    end,
--
--    ---@methods
--    speak = function(self)
--        print("Hello, my name is " .. self.name)
--    end,
--
--    pee = function(self)
--        print(self.name .. " is peeing")
--    end
--})
-----@class Dog : BaseClass
-----@field bark function
-----@field constructor function
-----@field set table
-----@field get table
-----@field name string
-----@field age number
--local Dog = BaseClass:new({
--
--    ---@constructor
--    constructor = function(self)
--        ---@properties
--        self.name = "Dog"
--        self.age = 0
--        self:super(self.name) -- call the constructor of the base class using super  just like in real OOP
--    end,
--
--    ---@setters
--    set = {
--        name = function(self, value)
--            self.name = value
--        end,
--        age = function(self, value)
--            self.age = value
--        end
--    },
--
--    ---@getters
--    get = {
--        name = function(self)
--            return self.name
--        end,
--
--        age = function(self)
--            return self.age
--        end
--    },
--
--    ---@methods
--    bark = function(self)
--        print("Woof!" .. self.name)
--    end,
--
--})
-----@class Cat : BaseClass
-----@field meow function
-----@field constructor function
-----@field set table
-----@field get table
-----@field name string
-----@field age number
--local Cat = BaseClass:new({
--    ---@constructor
--    constructor = function(self)
--        self.name = "Cat"
--        self.age = 0
--    end,
--
--    ---@setters
--    set = {
--
--        name = function(self, value)
--            self.name = value
--        end,
--
--        age = function(self, value)
--            self.age = value
--        end
--    },
--
--    ---@getters
--    get = {
--        name = function(self)
--            return self.name
--        end,
--
--        age = function(self)
--            return self.age
--        end
--    },
--
--    ---@methods
--    meow = function(self)
--        print("Meow!" .. self.name)
--    end
--
--})
--
--Dog.name = "Dog"
--Dog.age = 5
--Dog:speak()
--Dog:bark()
--
--Cat.name = "Cat"
--Cat.age = 3
--Cat:speak()
--Cat:meow()

return {
    CreateClass = Classes,
}

-- useage
--local LIB = Import 'class'
--local Classes = LIB.CreateClass
