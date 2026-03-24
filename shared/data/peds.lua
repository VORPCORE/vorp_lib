local Peds = {}

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

Peds.Ambient = {
    -- [`a_m_m_blwlaborer_01`] = createEntry("a_m_m_blwlaborer_01"),
}

Peds.Law = {
    -- [`s_m_m_ambientlawrural_01`] = createEntry("s_m_m_ambientlawrural_01"),
}

Peds.Gangs = {
    -- [`g_m_m_unibanditos_01`] = createEntry("g_m_m_unibanditos_01"),
}

Peds.Shopkeepers = {
    -- [`u_m_m_sdtrapper_01`] = createEntry("u_m_m_sdtrapper_01"),
}

Peds.Story = {
    -- [`cs_dutch`] = createEntry("cs_dutch"),
}

Peds.Multiplayer = {
    -- [`mp_male`] = createEntry("mp_male"),
}

return {
    Peds = Peds
}

-- example usage
--[[ local LIB = Import("peds")
local ambientPeds = LIB.Peds.Ambient
local lawPeds = LIB.Peds.Law
]]
