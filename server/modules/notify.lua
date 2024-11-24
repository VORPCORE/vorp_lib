local LIB = Import "class"
--! only works if the client side is loaded might need to make this and the client a shared module so only loads once

---@class Notify
local Notify = {}

local class = LIB.Class:Create({
    constructor = function(self)
        return setmetatable({}, Notify)
    end,

    Left = function(self, source, title, subtitle, dict, icon, duration, color)
        TriggerClientEvent("vorp_lib:client:Left", source, title, subtitle, dict, icon, duration, color)
    end,
    Tip = function(self, source, tipMessage, duration)
        TriggerClientEvent("vorp_lib:client:Tip", source, tipMessage, duration)
    end,
    Top = function(self, source, message, location, duration)
        TriggerClientEvent("vorp_lib:client:Top", source, message, location, duration)
    end,

    RightTip = function(self, source, tipMessage, duration)
        TriggerClientEvent("vorp_lib:client:RightTip", source, tipMessage, duration)
    end,

    SimpleTop = function(self, source, title, subtitle, duration)
        TriggerClientEvent("vorp_lib:client:SimpleTop", source, title, subtitle, duration)
    end,

    RightAdvanced = function(self, source, text, dict, icon, text_color, duration, quality, showquality)
        TriggerClientEvent("vorp_lib:client:RightAdvanced", source, text, dict, icon, text_color, duration, quality, showquality)
    end,

    BasicTop = function(self, source, text, duration)
        TriggerClientEvent("vorp_lib:client:BasicTop", source, text, duration)
    end,
    Objective = function(self, source, message, duration)
        TriggerClientEvent("vorp_lib:client:Objective", source, message, duration)
    end,

    Center = function(self, source, text, duration, text_color)
        TriggerClientEvent("vorp_lib:client:Center", source, text, duration, text_color)
    end,

    BottomRight = function(self, source, text, duration)
        TriggerClientEvent("vorp_lib:client:BottomRight", source, text, duration)
    end,

    Fail = function(self, source, title, subtitle, duration)
        TriggerClientEvent("vorp_lib:client:Fail", source, title, subtitle, duration)
    end,

    Dead = function(self, source, title, audioRef, audioName, duration)
        TriggerClientEvent("vorp_lib:client:Dead", source, title, audioRef, audioName, duration)
    end,

    Update = function(self, source, title, message, duration)
        TriggerClientEvent("vorp_lib:client:Update", source, title, message, duration)
    end,

    Warning = function(self, source, title, message, audioRef, audioName, duration)
        TriggerClientEvent("vorp_lib:client:Warning", source, title, message, audioRef, audioName, duration)
    end,

    LeftRank = function(self, source, title, subtitle, dict, texture, duration, color)
        TriggerClientEvent("vorp_lib:client:LeftRank", source, title, subtitle, dict, texture, duration, color)
    end,

})

return {
    Notify = class:new()
}
