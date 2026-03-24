local Animals = {}

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

Animals.Horses = {
    -- [`a_c_horse_arabian_white`] = createEntry("a_c_horse_arabian_white"),
}

Animals.Domestic = {
    -- [`a_c_dogamericanfoxhound_01`] = createEntry("a_c_dogamericanfoxhound_01"),
}

Animals.Wild = {
    -- [`a_c_alligator_01`] = createEntry("a_c_alligator_01"),
}

Animals.Birds = {
    -- [`a_c_duck_01`] = createEntry("a_c_duck_01"),
}

Animals.Fish = {
    -- [`a_c_fishbluegil_01_ms`] = createEntry("a_c_fishbluegil_01_ms"),
}

return {
    Animals = Animals
}

-- example usage
--[[ local LIB = Import("animals")
local horses = LIB.Animals.Horses
local wildAnimals = LIB.Animals.Wild
]]
