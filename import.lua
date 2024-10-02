local function canProcceed()
    local version <const> = _VERSION
    local resourceName    = GetCurrentResourceName() ~= "vorp_lib"
    local isLibStarted    = GetResourceState("vorp_lib") == 'started'
    isLibStarted          = resourceName and isLibStarted
    if not isLibStarted then return false, 'vorp_lib must must be ensured before this resource' end
    if not version:find("5.4") then return false, "This library requires lua 5.4 enable it in your fxmanifest" end
    return true
end

local result, message = canProcceed()
if not result then
    return error(("^1[ERROR] ^3%s^0"):format(message))
end

local side <const>    = IsDuplicityVersion() and 'server' or 'client'
local loadedModules   = {}
local importModules   = {}
importModules.__index = importModules
importModules.__call  = function()
    return "importModules"
end

function importModules:GetPath(file)
    local resource, path

    if file:sub(1, 1) == "@" then
        resource = file:match("@(.-)/")
        path = file:match("@.-/(.+)")
    elseif string.find(file, "/") then
        resource = GetCurrentResourceName()
        path = file
    else
        resource = "vorp_lib"
        path = ("%s/modules/%s.lua"):format(side, file)
    end

    if not path:match("%.lua$") then
        path = path .. ".lua"
    end

    return resource, path
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
        local rawLua = LoadResourceFile(resource, path)
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
    local results = {}
    local data = self:Normalize(value)

    for _, file in ipairs(data) do
        local resource, path = self:GetPath(file)
        local module = self:LoadModule(resource, path)
        for k, v in pairs(module) do
            results[k] = v
        end
    end
    return results
end

function importModules:New(moduels)
    local import = setmetatable({}, self)
    return import:GetModules(moduels)
end

---@alias modules
---|> "single"  # Import "module1"
---|> "multiple"  # Import({ "module1", "module2" })
---|>"@resources" # Import("@resource/module1/file.lua") specify @resource/folder(if any)/file.lua

--- [documentation]() **learn how to use it**
---@param modules modules Import a module or multiple modules from the library or any resource localy **see examples below**
local function Import(modules)
    return importModules:New(modules)
end

_ENV.Import = Import --- _ENV allows to use the function in the global scope
