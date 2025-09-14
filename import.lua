local function canProcceed()
    local resourceName <const> = GetCurrentResourceName() ~= "vorp_lib"
    local isLibStarted <const> = GetResourceState("vorp_lib") == 'started'
    local noLib <const>        = resourceName and isLibStarted
    if not noLib then return false, 'vorp_lib must must be ensured before this resource' end
    return true
end

local result <const>, message <const> = canProcceed()
if not result then
    return error(("^1[ERROR] ^3%s^0"):format(message))
end

local side <const>          = IsDuplicityVersion() and 'server' or 'client'
local loadedModules <const> = {}


local importModules <const> = {}
importModules.__index       = importModules
importModules.__call        = function()
    return "importModules"
end


local content <const> = {
    -- data files for the path
    client_data = {
        gameEvents = true,
    },
    -- model names
    shared_data = {
        animals = true,
        peds = true,
        vehicles = true,
    },
    -- shared files for the path
    shared = {
        class = true,
        functions = true,
        notify = true,
    },
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
        -- is shared file
        if content.shared[file] then
            path = ("shared/%s"):format(file)
        elseif content.client_data[file] then
            path = ("client/data/%s"):format(file)
        elseif content.shared_data[file] then
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
    loadedModules[resource] = loadedModules[resource] or {}

    local cached <const> = loadedModules[resource][path]
    if cached ~= nil then
        return cached
    end

    local raw <const> = LoadResourceFile(resource, path)
    assert(raw, ("Failed to load file: %s/%s does not exist or the path is wrong"):format(resource, path))

    local env <const> = setmetatable({}, { __index = _ENV })
    local chunk, err = load(raw, ("@%s/%s"):format(resource, path), 't', env)
    assert(chunk, err)

    local ok <const>, ret <const> = pcall(chunk)
    assert(ok, ret)

    local mod <const> = ret ~= nil and ret or env
    loadedModules[resource][path] = mod
    return mod
end

function importModules:GetModules(value)
    local results <const> = {}
    local data <const> = self:Normalize(value)

    for _, file in ipairs(data) do
        local resource <const>, path <const> = self:GetPath(file)
        local mod <const> = self:LoadModule(resource, path)

        if type(mod) == "table" then
            for k, v in pairs(mod) do
                results[k] = v
            end
        else
            local name <const> = path:match("([^/%.]+)%.lua$") or path
            results[name] = mod
        end
    end
    return results
end

function importModules:New(moduels)
    local import <const> = setmetatable({}, self)
    return import:GetModules(moduels)
end

--- [documentation](https://docs.vorp-core.com/api-reference/lib) **learn how to use it**
---@param modules table| string Import a module or multiple modules from the library or from any resource
function Import(modules)
    return importModules:New(modules)
end

_ENV.Import = Import
