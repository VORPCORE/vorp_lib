local Vehicles = {}

local function createEntry(model, extra)
    local entry <const> = {
        model = model,
        hash = joaat(model),
    }

    if extra then
        for key, value in pairs(extra) do
            entry[key] = value
        end
    end

    return entry
end

Vehicles.Boats = {
    -- [`rowboat`] = createEntry("rowboat"),
}

Vehicles.Wagons = {
    -- [`wagon02x`] = createEntry("wagon02x"),
}

Vehicles.Coaches = {
    -- [`coach2`] = createEntry("coach2"),
}

Vehicles.Carts = {
    -- [`cart01`] = createEntry("cart01"),
}

Vehicles.Trains = {
    -- [`northsteamer01x`] = createEntry("northsteamer01x"),
}

return {
    Vehicles = Vehicles
}

-- example usage
--[[ local LIB = Import("vehicles")
local boats = LIB.Vehicles.Boats
local wagons = LIB.Vehicles.Wagons
]]
