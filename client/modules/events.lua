-- ALL IS WIP
local Lib <const> = Import { 'gameEvents', 'dataview', "class" }
local GameEvents <const> = Lib.GameEvents
local CLASS <const> = Lib.Class --[[@as CLASS]]

local SCRIPT_EVENT_QUEUE_AI <const> = 0
local SCRIPT_EVENT_QUEUE_NETWORK <const> = 1
local EVENTS_TO_IGNORE <const> = {}
local REGISTERED_EVENTS <const> = {}

local GetNumberOfEvents <const> = GetNumberOfEvents
local GetEventAtIndex <const> = GetEventAtIndex
local Wait <const> = Wait
local InvokeNative <const> = Citizen.InvokeNative

---@class EVENTS
local Events = {}

local event <const> = CLASS:Create({

    constructor = function(self, name, group, callback)
        self.eventHash = name
        self.eventGroup = group
        self.eventCallback = callback
        self.isRunning = false
        self.developerMode = false
    end,

    set = {
        Pause = function(self)
            self.isRunning = false
        end,

        Resume = function(self)
            self:Start()
        end,

        Destroy = function(self)
            self.isRunning = false
            self = nil
        end,

        -- do not log events that are in the table to help with debug
        DevMode = function(self, turn_on, events)
            print("^3DEVMODE: ^7", turn_on, json.encode(events, { indent = true }))
            events = events or {}
            self.developerMode = turn_on

            if type(events) ~= "table" then
                events = { events }
            end


            if turn_on then
                for _, v in ipairs(events) do
                    if type(v) == "string" then
                        v = joaat(v)
                    end

                    if not EVENTS_TO_IGNORE[v] then
                        EVENTS_TO_IGNORE[v] = true
                    end
                end
            end
        end,

        Start = function(self)
            if not self.isRunning then
                self.isRunning = true
                self.allocate = self._AllocateData
                self.getData = self._GetData
                CreateThread(function()
                    local eventgroup <const> = self.eventGroup
                    while self.isRunning do
                        local size <const> = GetNumberOfEvents(eventgroup)
                        if size > 0 then
                            for i = 0, size - 1 do
                                local eventAtIndex <const> = GetEventAtIndex(eventgroup, i)

                                if self.developerMode then
                                    if not EVENTS_TO_IGNORE[eventAtIndex] then
                                        local data <const> = GameEvents[eventAtIndex]
                                        if data.datasize ~= 0 then
                                            local eventDataStruct <const> = Lib.DataView.ArrayBuffer(8 * data.datasize)
                                            self.allocate(data, eventDataStruct)
                                            local data_exists <const> = InvokeNative(0x57EC5FA4D4D6AFCA, eventgroup, i, eventDataStruct:Buffer(), data.datasize)
                                            local datafields = {}
                                            if data_exists then
                                                datafields = self.getData(data, eventDataStruct)
                                            end
                                            print("^3DEVMODE: EVENT AT INDEX^7", GameEvents[eventAtIndex]?.name, json.encode(datafields, { indent = true }))
                                        end
                                    end
                                else
                                    if self.eventHash == eventAtIndex and GameEvents[self.eventHash] then
                                        local data <const> = GameEvents[self.eventHash]

                                        if data.datasize ~= 0 then
                                            local eventDataStruct <const> = Lib.DataView.ArrayBuffer(8 * data.datasize)
                                            self.allocate(data, eventDataStruct)
                                            local data_exists <const> = InvokeNative(0x57EC5FA4D4D6AFCA, eventgroup, i, eventDataStruct:Buffer(), data.datasize)
                                            local datafields = {}
                                            if data_exists then
                                                datafields = self.getData(data, eventDataStruct)
                                            end


                                            self.eventCallback(datafields)
                                        else
                                            self.eventCallback()
                                        end
                                    end
                                end
                            end
                        end
                        Wait(0)
                    end
                end)
            end
        end,
    },

    _GetData = function(event, eventDataStruct)
        local datafields <const> = {}

        for p = 0, event.datasize - 1, 1 do
            local current_data_element <const> = event.dataelements[p]
            if current_data_element and current_data_element.type == 'float' then
                datafields[#datafields + 1] = eventDataStruct:GetFloat32(8 * p)
            else
                datafields[#datafields + 1] = eventDataStruct:GetInt32(8 * p)
            end
        end
        return datafields
    end,

    _AllocateData = function(event, eventDataStruct)
        for p = 0, event.datasize - 1, 1 do
            local current_data_element <const> = event.dataelements[p]
            if current_data_element and current_data_element.type == 'float' then
                eventDataStruct:SetFloat32(8 * p, 0)
            else
                eventDataStruct:SetInt32(8 * p, 0)
            end
        end
    end,
})

---@methods
function Events:Register(name, group, callback, state)
    if type(name) == 'string' then
        name = joaat(name)
    end

    if not GameEvents[name] then
        error(('Event %s does not exist in the data file'):format(name))
    end

    if group ~= SCRIPT_EVENT_QUEUE_AI and group ~= SCRIPT_EVENT_QUEUE_NETWORK then
        error('Invalid group provided. Must be either SCRIPT_EVENT_QUEUE_AI (0) or SCRIPT_EVENT_QUEUE_NETWORK (1).')
    end
    local instance <const> = event:New(name, group, callback)
    if state then
        instance:Start()
    end

    REGISTERED_EVENTS[#REGISTERED_EVENTS + 1] = instance

    return instance
end

--CLEAN UP
AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end

    print("^3CLEANUP^7 cleaning up all registered game events")

    for _, self in ipairs(REGISTERED_EVENTS) do
        self:Destroy()
    end
end)

return {
    Events = Events
}
