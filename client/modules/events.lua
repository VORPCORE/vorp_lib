local LIB = Import { 'gameEvents', 'dataview', "class" }
local GameEvents = LIB.GameEvents --[[@as GameEvents]]

---@class Events
---@field public Register fun(self:Events, name:string|integer, group:integer, callback:fun(data:table):any):Events
---@field public Start fun(self:Events)
---@field public Pause fun(self:Events)
---@field public Resume fun(self:Events)
---@field public Destroy fun(self:Events)
local Events = {}

local event = LIB.Class:Create({

    constructor = function(self, name, group, callback)
        self.eventHash = name
        self.eventGroup = group
        self.eventCallback = callback
        self.isRunning = false
    end,

    set = {
        Start = function(self)
            if not self.isRunning then
                self.isRunning = true
                CreateThread(function()
                    local eventgroup = self.eventGroup
                    while self.isRunning do
                        local size = GetNumberOfEvents(eventgroup)
                        if size > 0 then
                            for i = 0, size - 1 do
                                local eventAtIndex = GetEventAtIndex(eventgroup, i)
                                if self.eventHash == eventAtIndex and GameEvents[self.eventHash] then
                                    local data = GameEvents[self.eventHash]
                                    local eventDataStruct = LIB.DataView.ArrayBuffer(8 * data.datasize)
                                    self:AllocateData(data, eventDataStruct)
                                    local data_exists = Citizen.InvokeNative(0x57EC5FA4D4D6AFCA, eventgroup, i, eventDataStruct:Buffer(), self.datasize)
                                    local datafields = {}
                                    if data_exists then
                                        datafields = self:GetData(data, eventDataStruct)
                                    end
                                    self.eventCallback(datafields)
                                end
                            end
                        end
                        Wait(0)
                    end
                end)
            end
        end,

        GetData = function(self, event, eventDataStruct)
            local datafields = {}

            for p = 0, event.datasize - 1, 1 do
                local current_data_element = event.dataelements[p]
                if current_data_element and current_data_element.type == 'float' then
                    datafields[#datafields + 1] = eventDataStruct:GetFloat32(8 * p)
                else
                    datafields[#datafields + 1] = eventDataStruct:GetInt32(8 * p)
                end
            end
            return datafields
        end,

        AllocateData = function(self, event, eventDataStruct)
            for p = 0, event.datasize - 1, 1 do
                local current_data_element = event.dataelements[p]
                if current_data_element and current_data_element.type == 'float' then
                    eventDataStruct:SetFloat32(8 * p, 0)
                else
                    eventDataStruct:SetInt32(8 * p, 0)
                end
            end
        end,

        Pause = function(self)
            self.isRunning = false
        end,

        Resume = function(self)
            self:Start()
        end,

        Destroy = function(self)
            self.isRunning = false
            self = nil
        end
    }

})

---@methods
function Events:Register(name, group, callback)
    if type(name) == 'string' then
        name = joaat(name)
    end

    if not GameEvents[name] then
        error(('Event %s does not exist in the data file'):format(name))
    end

    return event:new(name, group, callback)
end

return {
    Event = Events
}

-- example usage

--local LIB = Import 'events' -- imports the events module

--local Event = LIB.Event:Register('EVENT_PED_CREATED', 0, function(data) -- regiters an event listener to a instance
--    print(json.encode(data))
--end)

--Event:Start() -- starts the event listener for this instance
--Event:Pause() -- pauses the event listener for this instance
--Event:Resume() -- resumes the event listener for this instance
--Event:Destroy() -- destroys the event listener for this instance
