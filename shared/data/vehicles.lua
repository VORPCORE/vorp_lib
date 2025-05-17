local Vehicles = {}
Vehicles.Boats = {
    [`rowboat`] = {
        model = "rowboat",
        hash = `rowboat`,
    },
}
Vehicles.Wagons = {}


return {
    Vehicles = Vehicles
}


--example usage
--[[ local LIB = Import "vehicles"
local boat = LIB.Vehicles.Boats -- table of boats
 ]]
