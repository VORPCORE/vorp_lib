local LIB = Import { 'gameEvents', 'dataview' }
local GameEvents = LIB.GameEvents --[[@as GameEvents]]
local DataView = LIB.DataView
local Events = {}
Events.__index = Events
Events.__call = function()
    return "Events"
end

---@constructor
function Events:new(name, group, callback)
    ---@properties
    local properties = {
        eventHash = name,
        eventGroup = group,
        eventCallback = callback,
        isRunning = false
    }
    return setmetatable(properties, Events)
end

---@methods
function Events:Register(name, group, callback)
    if type(name) == 'string' then
        name = joaat(name)
    end
    return Events:new(name, group, callback)
end

-- start event look for this instance
function Events:Start()
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
                            local eventDataStruct = DataView.ArrayBuffer(8 * data.datasize)
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
end

function Events:Stop()
    self.isRunning = false
end

function Events:GetData(event, eventDataStruct) -- Memory address pull
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
end

function Events:AllocateData(event, eventDataStruct) --memory pre-allocation
    for p = 0, event.datasize - 1, 1 do
        local current_data_element = event.dataelements[p]
        if current_data_element and current_data_element.type == 'float' then
            eventDataStruct:SetFloat32(8 * p, 0)
        else
            eventDataStruct:SetInt32(8 * p, 0)
        end
    end
end

return {
    Event = Events
}
-- example usage

--local LIB = Import 'events'
--
--local Event = LIB.Event:Register('EVENT_PED_CREATED', 0, function(data)
--    print(json.encode(data))
--end)
--
--Event:Start()
--
--Event:Stop()
