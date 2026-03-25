local CLASS <const> = Import('class').Class --[[@as CLASS]]

---@class LOGGER_CONTEXT: table<string, any>

---@class LOGGER_OPTIONS
---@field public resource string?
---@field public prefix string?
---@field public debug boolean?
---@field public colorize boolean?

local LEVELS <const> = {
    INFO = { label = "INFO", color = "^2" },
    WARN = { label = "WARN", color = "^3" },
    ERROR = { label = "ERROR", color = "^1" },
    DEBUG = { label = "DEBUG", color = "^4" }
}

local function getResourceName()
    local invoking = GetInvokingResource and GetInvokingResource() or nil
    if invoking and invoking ~= "" then
        return invoking
    end

    return GetCurrentResourceName()
end

local function padTime(value)
    return ("%02d"):format(value)
end

local function getServerTime()
    return os.date("%H:%M:%S")
end

local function getClientTime()
    local totalSeconds <const> = math.floor(GetGameTimer() / 1000)
    local hours <const> = math.floor(totalSeconds / 3600) % 24
    local minutes <const> = math.floor((totalSeconds % 3600) / 60)
    local seconds <const> = totalSeconds % 60

    return ("%s:%s:%s"):format(padTime(hours), padTime(minutes), padTime(seconds))
end

local function getTime()
    if IsDuplicityVersion() then
        return getServerTime()
    end

    return getClientTime()
end

local function encodeValue(value)
    local valueType <const> = type(value)
    if valueType == "string" then
        return value
    end

    if valueType == "number" or valueType == "boolean" then
        return tostring(value)
    end

    if value == nil then
        return "nil"
    end

    if valueType == "table" and json and json.encode then
        local ok, encoded = pcall(json.encode, value)
        if ok and encoded then
            return encoded
        end
    end

    return tostring(value)
end

local function buildContext(context)
    if context == nil then
        return nil
    end

    if type(context) ~= "table" then
        return tostring(context)
    end

    local parts <const> = {}
    for key, value in pairs(context) do
        parts[#parts + 1] = ("%s=%s"):format(tostring(key), encodeValue(value))
    end

    table.sort(parts)

    if #parts == 0 then
        return nil
    end

    return table.concat(parts, " ")
end

local function applyColor(enabled, color, text)
    if enabled == false then
        return text
    end

    return ("%s%s^7"):format(color, text)
end

local function normalizeLevel(level)
    local key <const> = tostring(level or "INFO"):upper()
    return LEVELS[key] and key or "INFO"
end

---@class LOGGER
local LoggerClass <const> = CLASS:Create({
    constructor = function(self)
        self.debugEnabled = false
    end,

    ---@param level string
    ---@param message any
    ---@param context LOGGER_CONTEXT?
    ---@param options LOGGER_OPTIONS?
    Log = function(self, level, message, context, options)
        local normalizedLevel <const> = normalizeLevel(level)
        local metadata <const> = LEVELS[normalizedLevel]
        local shouldForceDebug <const> = options?.debug == true

        if normalizedLevel == "DEBUG" and not self.debugEnabled and not shouldForceDebug then
            return
        end

        local colorize <const> = options?.colorize ~= false
        local resourceName <const> = options?.resource or getResourceName()
        local timestamp <const> = getTime()
        local prefix <const> = options?.prefix and ("[%s] "):format(options.prefix) or ""
        local contextString <const> = buildContext(context)

        local resourcePart <const> = applyColor(colorize, "^6", ("[%s]"):format(resourceName))
        local timePart <const> = applyColor(colorize, "^5", ("[%s]"):format(timestamp))
        local levelPart <const> = applyColor(colorize, metadata.color, ("[%s]"):format(metadata.label))
        local body <const> = ("%s%s"):format(prefix, tostring(message))

        local line = ("%s %s %s %s"):format(resourcePart, timePart, levelPart, body)
        if contextString then
            line = ("%s | %s"):format(line, contextString)
        end

        print(line)
    end,

    ---@param message any
    ---@param context LOGGER_CONTEXT?
    ---@param options LOGGER_OPTIONS?
    Info = function(self, message, context, options)
        self:Log("INFO", message, context, options)
    end,

    ---@param message any
    ---@param context LOGGER_CONTEXT?
    ---@param options LOGGER_OPTIONS?
    Warn = function(self, message, context, options)
        self:Log("WARN", message, context, options)
    end,

    ---@param message any
    ---@param context LOGGER_CONTEXT?
    ---@param options LOGGER_OPTIONS?
    Error = function(self, message, context, options)
        self:Log("ERROR", message, context, options)
    end,

    ---@param message any
    ---@param context LOGGER_CONTEXT?
    ---@param options LOGGER_OPTIONS?
    Debug = function(self, message, context, options)
        self:Log("DEBUG", message, context, options)
    end,

    ---@param enabled boolean
    SetDebugEnabled = function(self, enabled)
        self.debugEnabled = enabled == true
    end,

    ---@return boolean
    GetDebugEnabled = function(self)
        return self.debugEnabled
    end
}, "LOGGER")

local Logger <const> = LoggerClass:New()

return {
    Logger = Logger
}
