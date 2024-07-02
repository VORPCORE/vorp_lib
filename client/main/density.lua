local multipliers = {
    AnimalDensity         = {
        enable = false,
        value = 0.0 -- default values can be adjusted in here
    },
    HumanDensity          = {
        enable = false,
        value = 0.0
    },
    PedDensity            = {
        enable = false,
        value = 0.0
    },
    VehicleDensity        = {
        enable = false,
        value = 0.0
    },
    ScenarioAnimalDensity = {
        enable = false,
        value = 0.0
    },
    ScenarioHumanDensity  = {
        enable = false,
        value = 0.0
    },
    ScenarioPedDensity    = {
        enable = false,
        value = 0.0
    },
    ParkedVehicleDensity  = {
        enable = false,
        value = 0.0
    },
    RandomVehicleDensity  = {
        enable = false,
        value = 0.0
    },

}

--TODO: add configHash support
local configHash = {
    BLACKWATER = {
        enable = false,
        value = 'BLACKWATER'
    },
    DEFAULT = {
        enable = false,
        value = 'DEFAULT'
    },
    NEWBORDEAUX = {
        enable = false,
        value = 'NEWBORDEAUX'
    },
    RHODES = {
        enable = false,
        value = 'RHODES'
    },
    STRAWBERRY = {
        enable = false,
        value = 'STRAWBERRY'
    },
    TUMBLEWEED = {
        enable = false,
        value = 'TUMBLEWEED'
    },
    VALENTINE = {
        enable = false,
        value = 'VALENTINE'
    },
    VANHORN = {
        enable = false,
        value = 'VANHORN'
    },
}

-- decided to separate in two threads to avoid slowing down the thread since it needs to be run at all frames
CreateThread(function()
    repeat Wait(2000) until LocalPlayer.state.IsInSession
    -- while true do
    --     local sleep = 1000

    --     if multipliers.ParkedVehicleDensity.enable then
    --         sleep = 0
    --         SetParkedVehicleDensityMultiplierThisFrame(multipliers.ParkedVehicleDensity.temp_value or multipliers.ParkedVehicleDensity.value)
    --     end
    --     if multipliers.RandomVehicleDensity.enable then
    --         sleep = 0
    --         SetRandomVehicleDensityMultiplierThisFrame(multipliers.RandomVehicleDensity.temp_value or multipliers.RandomVehicleDensity.value)
    --     end
    --     if multipliers.ScenarioAnimalDensity.enable then
    --         sleep = 0
    --         SetScenarioAnimalDensityMultiplierThisFrame(multipliers.ScenarioAnimalDensity.temp_value or multipliers.ScenarioAnimalDensity.value)
    --     end
    --     if multipliers.ScenarioHumanDensity.enable then
    --         sleep = 0
    --         SetScenarioHumanDensityMultiplierThisFrame(multipliers.ScenarioHumanDensity.temp_value or multipliers.ScenarioHumanDensity.value)
    --     end
    --     if multipliers.ScenarioPedDensity.enable then
    --         sleep = 0
    --         SetScenarioPedDensityMultiplierThisFrame(multipliers.ScenarioPedDensity.temp_value or multipliers.ScenarioPedDensity.value)
    --     end
    --     Wait(sleep)
    -- end
end)

CreateThread(function()
    repeat Wait(2000) until LocalPlayer.state.IsInSession

    -- while true do
    --     local sleep = 1000
    --     if multipliers.ParkedVehicleDensity.enable then
    --         sleep = 0
    --         SetParkedVehicleDensityMultiplierThisFrame(multipliers.ParkedVehicleDensity.temp_value or multipliers.ParkedVehicleDensity.value)
    --     end
    --     if multipliers.RandomVehicleDensity.enable then
    --         sleep = 0
    --         SetRandomVehicleDensityMultiplierThisFrame(multipliers.RandomVehicleDensity.temp_value or multipliers.RandomVehicleDensity.value)
    --     end
    --     if multipliers.ScenarioAnimalDensity.enable then
    --         sleep = 0
    --         SetScenarioAnimalDensityMultiplierThisFrame(multipliers.ScenarioAnimalDensity.temp_value or multipliers.ScenarioAnimalDensity.value)
    --     end
    --     if multipliers.ScenarioHumanDensity.enable then
    --         sleep = 0
    --         SetScenarioHumanDensityMultiplierThisFrame(multipliers.ScenarioHumanDensity.temp_value or multipliers.ScenarioHumanDensity.value)
    --     end
    --     if multipliers.ScenarioPedDensity.enable then
    --         sleep = 0
    --         SetScenarioPedDensityMultiplierThisFrame(multipliers.ScenarioPedDensity.temp_value or multipliers.ScenarioPedDensity.value)
    --     end
    --     Wait(sleep)
    -- end
end)



exports('GetDensityMultipliers', function(name)
    if not name then return multipliers end
    return multipliers[name]
end)

--! EITHER ALLOW CLIENT CHANGES OR WE ALLOW SERVER CHANGES ONLY FOR SECURITY USING THE NET EVENTS?

--[[
exports('SetDefaultDensityMultipliers', function(name, value, enable)
    if not multipliers[name] then return error(("^1[ERROR] ^3%s^0 is not a valid density multiplier"):format(name)) end
    if enable then
        multipliers[name].enable = enable
        multipliers[name].value = value
    end
end)
]]

-- this allows to set temporary density multipliers wihtout changing the default values sowe can use the getters
exports('SetTemporaryDensityMultipliers', function(name, value, enable)
    if not multipliers[name] then return error(("^1[ERROR] ^3%s^0 is not a valid density multiplier"):format(name)) end
    if enable then
        multipliers[name].enable = enable
        multipliers[name].temp_value = value
    end
end)

exports('RemoveTemporayDensityMultipliers', function(name)
    if not multipliers[name] then return error(("^1[ERROR] ^3%s^0 is not a valid density multiplier"):format(name)) end
    multipliers[name].enable = false
    multipliers[name].temp_value = nil
end)

--! allows to set the density multiplier from server
RegisterNetEvent('vorp_library:Client:SetDefaultDensityMultiplier', function(name, value, enable)
    if not multipliers[name] then return error(("^1[ERROR] ^3%s^0 is not a valid density multiplier"):format(name)) end
    if enable then
        multipliers[name].enable = enable
        multipliers[name].value = value
    end
end)

RegisterNetEvent('vorp_library:Client:SetTemporaryDensityMultiplier', function(name, value, enable)
    if not multipliers[name] then return error(("^1[ERROR] ^3%s^0 is not a valid density multiplier"):format(name)) end
    if enable then
        multipliers[name].enable = enable
        multipliers[name].temp_value = value
    end
end)

RegisterNetEvent('vorp_library:Client:RemoveTemporaryDensityMultiplier', function(name)
    if not multipliers[name] then return error(("^1[ERROR] ^3%s^0 is not a valid density multiplier"):format(name)) end
    multipliers[name].enable = false
    multipliers[name].temp_value = nil
end)
