local function canProcceed()
    local version <const>      = _VERSION
    local resourceName <const> = GetCurrentResourceName() ~= "vorp_lib"
    local isLibStarted <const> = GetResourceState("vorp_lib") == 'started'
    local noLib <const>        = resourceName and isLibStarted
    if not noLib then return false, 'vorp_lib must must be ensured before this resource' end
    if not version:find("5.4") then return false, "This library requires lua 5.4 enable in your fxmanifest script" end
    return true
end

local result <const>, message <const> = canProcceed()
if not result then
    return error(("^1[ERROR] ^3%s^0"):format(message))
end

local side <const>          = IsDuplicityVersion() and 'server' or 'client'
local loadedModules <const> = {}


local importModules   = {}
importModules.__index = importModules
importModules.__call  = function()
    return "importModules"
end

--- considered shared modules goes here
local shared <const>  = {
    class = true,
    functions = true,
}

local data <const>    = {
    client = {
        gameEvents = true
    },
    shared = {}
}

function importModules:GetPath(file)
    local resource, path

    if file:sub(1, 1) == "@" then
        -- resource contains @
        resource = file:match("@(.-)/")
        path = file:match("@.-/(.+)")
    elseif file:sub(1, 1) == "/" or file:sub(1, 1) == "." then
        -- own resource contains / or .
        resource = GetCurrentResourceName()
        path = file
    else
        -- lib contains no symbols
        resource = "vorp_lib"
        if shared[file] then
            path = ("shared/%s"):format(file)
        elseif data.client[file] then
            path = ("client/data/%s"):format(file)
        elseif data.shared[file] then
            path = ("shared/data/%s"):format(file)
        else
            path = ("%s/modules/%s"):format(side, file)
        end
    end

    return resource, path .. ".lua"
end

function importModules:Normalize(value)
    if type(value) ~= "table" then
        value = { value }
    end
    return value
end

function importModules:LoadModule(resource, path)
    if not loadedModules[resource] then
        loadedModules[resource] = {}
    end

    if not loadedModules[resource][path] then
        local rawLua <const> = LoadResourceFile(resource, path)
        if not rawLua then
            error("Failed to load file: " .. resource .. "/" .. path .. " does not exist or the path is wrong", 1)
        end
        local call, err = load(rawLua, path, 't', _ENV)
        assert(call, err)
        loadedModules[resource][path] = call
    end

    return loadedModules[resource][path]()
end

function importModules:GetModules(value)
    local results <const> = {}
    local data <const> = self:Normalize(value)

    for _, file in ipairs(data) do
        local resource <const>, path <const> = self:GetPath(file)
        local module <const> = self:LoadModule(resource, path)
        for k, v in pairs(module) do
            results[k] = v
        end
    end
    return results
end

function importModules:New(moduels)
    local import <const> = setmetatable({}, self)
    return import:GetModules(moduels)
end

--- [documentation]() **learn how to use it**
---@param modules table| string Import a module or multiple modules from the library or from any resource
function Import(modules)
    return importModules:New(modules)
end

_ENV.Import = Import

-- still thinking about this, either we store this in a table and use that variable or just access it directly
_ENV.NOTIFY = Import "notify" --[[@as Notify]]

-- avoid calling this export every time in your scripts
_ENV.CORE = exports.vorp_core:GetCore()


-- example of how to use it
-- Notify:Objective("Hello", "Hello", 5000, "success")
-- local result = Core.CallBack.TriggerAWait("Hello")

--as a variable but is too verbose
--_ENV.LIB = {}
--_ENV.LIB.Notify = Import "notify"
--_ENV.LIB.Core = exports.vorp_core:GetCore()

-- and then use it like this
-- LIB.Notify:Objective("Hello", "Hello", 5000, "success")
-- local result = LIB.Core.CallBack.TriggerAWait("Hello")
