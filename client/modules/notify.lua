local LIB = Import { "dataview", "class" }
local DataView = LIB.DataView

---@class Notify
---@field public Left fun( self:Notify, title: string, subtitle: string, dict: string, icon: string, duration: number, color: string?): nil
---@field public Tip fun( self:Notify, tipMessage: string, duration?: number): nil
---@field public Top fun( self:Notify, message: string, location: string, duration?: number): nil
---@field public RightTip fun( self:Notify, tipMessage: string, duration?: number): nil
---@field public Objective fun( self:Notify, message: string, duration?: number): nil
---@field public SimpleTop fun( self:Notify, title: string,subTitle:string, duration?: number): nil
---@field public RightAdvanced fun( self:Notify, text: string, dict: string, icon: string, text_color: string, duration?: number, quality?: number, showquality?: boolean): nil
---@field public BasicTop fun( self:Notify, text: string, duration?: number): nil
---@field public Center fun( self:Notify, text: string, duration?: number, text_color?: string): nil
---@field public BottomRight fun( self:Notify, text: string, duration?: number): nil
---@field public Fail fun( self:Notify, title: string, subtitle: string, duration?: number): nil
---@field public Dead fun( self:Notify, title: string, audioRef: string, audioName: string, duration?: number): nil
---@field public Update fun( self:Notify, title: string, message: string, duration?: number): nil
---@field public Warning fun( self:Notify, title: string, message: string, audioRef: string, audioName: string, duration?: number): nil
---@field public NotifyLeftRank fun( self:Notify, title: string, subtitle: string, dict: string, texture: string, duration?: number, color?: string): nil
local Notify = {}

local function bigInt(text)
    local string1 = DataView.ArrayBuffer(16)
    string1:SetInt64(0, text)
    return string1:GetInt64(0)
end

local function loadTextures(dict)
    if not HasStreamedTextureDictLoaded(dict) then
        RequestStreamedTextureDict(dict, true)
        repeat Wait(0) until HasStreamedTextureDictLoaded(dict)
    end
end

local class = LIB.Class:Create({

    constructor = function(self)
        return setmetatable({}, Notify)
    end,

    Left = function(self, title, subtitle, dict, icon, duration, color)
        local structConfig = DataView.ArrayBuffer(8 * 7)
        structConfig:SetInt32(8 * 0, tonumber(duration or 3000))
        local structData = DataView.ArrayBuffer(8 * 8)
        structData:SetInt64(8 * 1, bigInt(VarString(10, "LITERAL_STRING", title)))
        structData:SetInt64(8 * 2, bigInt(VarString(10, "LITERAL_STRING", subtitle)))
        structData:SetInt32(8 * 3, 0)
        structData:SetInt64(8 * 4, bigInt(joaat(dict)))
        structData:SetInt64(8 * 5, bigInt(joaat(icon)))
        structData:SetInt64(8 * 6, bigInt(joaat(color or "COLOR_WHITE")))

        Citizen.InvokeNative(0x26E87218390E6729, structConfig:Buffer(), structData:Buffer(), 1, 1)
        -- SET_STREAMED_TEXTURE_DICT_AS_NO_LONGER_NEEDED
        Citizen.InvokeNative(0x4ACA10A91F66F1E2, dict)
    end,
    Tip = function(self, tipMessage, duration)
        local structConfig = DataView.ArrayBuffer(8 * 7)
        structConfig:SetInt32(8 * 0, tonumber(duration or 3000))
        structConfig:SetInt32(8 * 1, 0)
        structConfig:SetInt32(8 * 2, 0)
        structConfig:SetInt32(8 * 3, 0)

        local structData = DataView.ArrayBuffer(8 * 3)
        structData:SetUint64(8 * 1, bigInt(VarString(10, "LITERAL_STRING", tipMessage)))

        Citizen.InvokeNative(0x049D5C615BD38BAD, structConfig:Buffer(), structData:Buffer(), 1)
    end,
    Top = function(self, message, location, duration)
        local structConfig = DataView.ArrayBuffer(8 * 7)
        structConfig:SetInt32(8 * 0, tonumber(duration or 3000))

        local structData = DataView.ArrayBuffer(8 * 5)
        structData:SetInt64(8 * 1, bigInt(VarString(10, "LITERAL_STRING", location)))
        structData:SetInt64(8 * 2, bigInt(VarString(10, "LITERAL_STRING", message)))

        Citizen.InvokeNative(0xD05590C1AB38F068, structConfig:Buffer(), structData:Buffer(), 0, 1)
    end,

    RightTip = function(self, tipMessage, duration)
        local structConfig = DataView.ArrayBuffer(8 * 7)
        structConfig:SetInt32(8 * 0, tonumber(duration or 3000))

        local structData = DataView.ArrayBuffer(8 * 3)
        structData:SetInt64(8 * 1, bigInt(VarString(10, "LITERAL_STRING", tipMessage)))

        Citizen.InvokeNative(0xB2920B9760F0F36B, structConfig:Buffer(), structData:Buffer(), 1)
    end,

    Objective = function(self, message, duration)
        Citizen.InvokeNative(0xDD1232B332CBB9E7, 3, 1, 0)

        local structConfig = DataView.ArrayBuffer(8 * 7)
        structConfig:SetInt32(8 * 0, tonumber(duration or 3000))

        local structData = DataView.ArrayBuffer(8 * 3)
        local strMessage = VarString(10, "LITERAL_STRING", message)
        structData:SetInt64(8 * 1, bigInt(strMessage))

        Citizen.InvokeNative(0xCEDBF17EFCC0E4A4, structConfig:Buffer(), structData:Buffer(), 1)
    end,

    SimpleTop = function(self, title, subtitle, duration)
        local structConfig = DataView.ArrayBuffer(8 * 7)
        structConfig:SetInt32(8 * 0, tonumber(duration or 3000))

        local structData = DataView.ArrayBuffer(8 * 7)
        structData:SetInt64(8 * 1, bigInt(VarString(10, "LITERAL_STRING", title)))
        structData:SetInt64(8 * 2, bigInt(VarString(10, "LITERAL_STRING", subtitle)))

        Citizen.InvokeNative(0xA6F4216AB10EB08E, structConfig:Buffer(), structData:Buffer(), 1, 1)
    end,

    RightAdvanced = function(self, text, dict, icon, text_color, duration, quality, showquality)
        loadTextures(dict)

        local structConfig = DataView.ArrayBuffer(8 * 7)
        structConfig:SetInt32(8 * 0, tonumber(duration or 3000))
        structConfig:SetInt64(8 * 1, bigInt(VarString(10, "LITERAL_STRING", "Transaction_Feed_Sounds")))
        structConfig:SetInt64(8 * 2, bigInt(VarString(10, "LITERAL_STRING", "Transaction_Positive")))

        local structData = DataView.ArrayBuffer(8 * 10)
        structData:SetInt64(8 * 1, bigInt(VarString(10, "LITERAL_STRING", text)))
        structData:SetInt64(8 * 2, bigInt(VarString(10, "LITERAL_STRING", dict)))
        structData:SetInt64(8 * 3, bigInt(joaat(icon)))
        structData:SetInt64(8 * 5, bigInt(joaat(text_color or "COLOR_WHITE")))
        if showquality then
            structData:SetInt32(8 * 6, quality or 1)
        end

        Citizen.InvokeNative(0xB249EBCB30DD88E0, structConfig:Buffer(), structData:Buffer(), 1)
        -- SET_STREAMED_TEXTURE_DICT_AS_NO_LONGER_NEEDED
        Citizen.InvokeNative(0x4ACA10A91F66F1E2, dict)
    end,

    BasicTop = function(self, text, duration)
        local structConfig = DataView.ArrayBuffer(8 * 7)
        structConfig:SetInt32(8 * 0, tonumber(duration or 3000))

        local structData = DataView.ArrayBuffer(8 * 7)
        structData:SetInt64(8 * 1, bigInt(VarString(10, "LITERAL_STRING", text)))

        Citizen.InvokeNative(0x7AE0589093A2E088, structConfig:Buffer(), structData:Buffer(), 1)
    end,

    Center = function(self, text, duration, text_color)
        local structConfig = DataView.ArrayBuffer(8 * 7)
        structConfig:SetInt32(8 * 0, tonumber(duration or 3000))

        local structData = DataView.ArrayBuffer(8 * 4)
        structData:SetInt64(8 * 1, bigInt(VarString(10, "LITERAL_STRING", text)))
        structData:SetInt64(8 * 2, bigInt(joaat(text_color or "COLOR_PURE_WHITE")))

        Citizen.InvokeNative(0x893128CDB4B81FBB, structConfig:Buffer(), structData:Buffer(), 1)
    end,

    BottomRight = function(self, text, duration)
        local structConfig = DataView.ArrayBuffer(8 * 7)
        structConfig:SetInt32(8 * 0, tonumber(duration or 3000))

        local structData = DataView.ArrayBuffer(8 * 5)
        structData:SetInt64(8 * 1, bigInt(VarString(10, "LITERAL_STRING", text)))

        Citizen.InvokeNative(0x2024F4F333095FB1, structConfig:Buffer(), structData:Buffer(), 1)
    end,

    Fail = function(self, title, subtitle, duration)
        local structConfig = DataView.ArrayBuffer(8 * 5)

        local structData = DataView.ArrayBuffer(8 * 9)
        structData:SetInt64(8 * 1, bigInt(VarString(10, "LITERAL_STRING", title)))
        structData:SetInt64(8 * 2, bigInt(VarString(10, "LITERAL_STRING", subtitle)))

        local result = Citizen.InvokeNative(0x9F2CC2439A04E7BA, structConfig:Buffer(), structData:Buffer(), 1)
        SetTimeout(duration or 3000, function()
            Citizen.InvokeNative(0x00A15B94CBA4F76F, result)
        end)
    end,

    Dead = function(self, title, audioRef, audioName, duration)
        local structConfig = DataView.ArrayBuffer(8 * 5)

        local structData = DataView.ArrayBuffer(8 * 9)
        structData:SetInt64(8 * 1, bigInt(VarString(10, "LITERAL_STRING", title)))
        structData:SetInt64(8 * 2, bigInt(VarString(10, "LITERAL_STRING", audioRef)))
        structData:SetInt64(8 * 3, bigInt(VarString(10, "LITERAL_STRING", audioName)))

        local result = Citizen.InvokeNative(0x815C4065AE6E6071, structConfig:Buffer(), structData:Buffer(), 1)
        SetTimeout(duration or 3000, function()
            Citizen.InvokeNative(0x00A15B94CBA4F76F, result)
        end)
    end,

    Update = function(self, title, message, duration)
        local structConfig = DataView.ArrayBuffer(8 * 5)

        local structData = DataView.ArrayBuffer(8 * 9)
        structData:SetInt64(8 * 1, bigInt(VarString(10, "LITERAL_STRING", title)))
        structData:SetInt64(8 * 2, bigInt(VarString(10, "LITERAL_STRING", message)))

        local result = Citizen.InvokeNative(0x339E16B41780FC35, structConfig:Buffer(), structData:Buffer(), 1)
        SetTimeout(duration or 3000, function()
            Citizen.InvokeNative(0x00A15B94CBA4F76F, result)
        end)
    end,

    Warning = function(self, title, message, audioRef, audioName, duration)
        local structConfig = DataView.ArrayBuffer(8 * 5)

        local structData = DataView.ArrayBuffer(8 * 9)
        structData:SetInt64(8 * 1, bigInt(VarString(10, "LITERAL_STRING", title)))
        structData:SetInt64(8 * 2, bigInt(VarString(10, "LITERAL_STRING", message)))
        structData:SetInt64(8 * 3, bigInt(VarString(10, "LITERAL_STRING", audioRef)))
        structData:SetInt64(8 * 4, bigInt(VarString(10, "LITERAL_STRING", audioName)))

        local result = Citizen.InvokeNative(0x339E16B41780FC35, structConfig:Buffer(), structData:Buffer(), 1)
        SetTimeout(duration or 3000, function()
            Citizen.InvokeNative(0x00A15B94CBA4F76F, result)
        end)
    end,

    LeftRank = function(self, title, subtitle, dict, texture, duration, color)
        loadTextures(dict)
        duration = duration or 5000
        local dict = joaat(dict or "TOASTS_MP_GENERIC")
        texture = joaat(texture or "toast_mp_standalone_sp")
        local string1 = VarString(10, "LITERAL_STRING", title)
        local string2 = VarString(10, "LITERAL_STRING", subtitle)

        local struct1 = DataView.ArrayBuffer(8 * 8)
        local struct2 = DataView.ArrayBuffer(8 * 10)

        struct1:SetInt32(8 * 0, duration)
        struct2:SetInt64(8 * 1, bigInt(string1))
        struct2:SetInt64(8 * 2, bigInt(string2))
        struct2:SetInt64(8 * 4, bigInt(dict))
        struct2:SetInt64(8 * 5, bigInt(texture))
        struct2:SetInt64(8 * 6, bigInt(joaat(color or "COLOR_WHITE")))
        struct2:SetInt32(8 * 7, 1)
        Citizen.InvokeNative(0x3F9FDDBA79117C69, struct1:Buffer(), struct2:Buffer(), 1, 1)
        -- SET_STREAMED_TEXTURE_DICT_AS_NO_LONGER_NEEDED
        Citizen.InvokeNative(0x4ACA10A91F66F1E2, dict)
    end,

    Test = function(self)
        local testText = "This is a test notification"
        local testDuration = 3000
        local testWaitDuration = 4000
        local testDict = "generic_textures"
        local testIcon = "tick"
        local testColor = "COLOR_WHITE"
        local testLocation = "top_center"

        self:Left(testText, testText, testDict, testIcon, testDuration, testColor)
        print("^2Displaying: NotifyLeft")
        Wait(testWaitDuration)
        self:Tip(testText, testDuration)
        print("^2Displaying: NotifyTip")
        Wait(testWaitDuration)
        self:Top(testText, testLocation, testDuration)
        print("^2Displaying: NotifyTop")
        Wait(testWaitDuration)
        self:RightTip(testText, testDuration)
        print("^2Displaying: NotifyRightTip")
        Wait(testWaitDuration)
        self:Objective(testText, testDuration)
        print("^2Displaying: NotifyObjective")
        Wait(testWaitDuration)
        self:SimpleTop(testText, testText, testDuration)
        print("^2Displaying: NotifySimpleTop")
        Wait(testWaitDuration)
        self:RightAdvanced(testText, testDict, testIcon, testColor, testDuration)
        print("^2Displaying: NotifyAvanced")
        Wait(testWaitDuration)
        self:BasicTop(testText, testDuration)
        print("^2Displaying: NotifyBasicTop")
        Wait(testWaitDuration)
        self:Center(testText, testDuration)
        print("^2Displaying: NotifyCenter")
        Wait(testWaitDuration)
        self:BottomRight(testText, testDuration)
        print("^2Displaying: NotifyBottomRight")
        Wait(testWaitDuration)
        self:Fail(testText, testText, testDuration)
        print("^2Displaying: NotifyFail")
        Wait(testWaitDuration)
        self:Dead(testText, testDict, testIcon, testDuration)
        print("^2Displaying: NotifyDead")
        Wait(testWaitDuration)
        self:Update(testText, testText, testDuration)
        print("^2Displaying: NotifyUpdate")
        Wait(testWaitDuration)
        self:Warning(testText, testText, testDict, testIcon, testDuration)
        print("^2Displaying: NotifyWarning")
        Wait(testWaitDuration)
        self:LeftRank(testText, testText, testDict, testIcon, testDuration, testColor)
        print("^2Displaying: NotifyLeftRank")
    end

})

local notification = class:new()

CreateThread(function()
    local strings = { "Left", "Tip", "Top", "RightTip", "Objective", "SimpleTop", "RightAdvanced", "BasicTop", "Center", "BottomRight", "Fail", "Dead", "Update", "Warning", "LeftRank" }
    for _, string in ipairs(strings) do
        RegisterNetEvent(("vorp_lib:client:%s"):format(string), function(...)
            notification[string](...)
        end)
    end
end)


return {
    Notify = notification
}

-- example
-- local LIB = Import 'notify'
-- local Notify = LIB.Notify
-- Notify:Left("Title", "Subtitle", "generic_textures", "tick", 3000, "COLOR_WHITE")
