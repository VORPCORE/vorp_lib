--todo: this file cant be imported it will run with the library and manage the density multipliers at runtime allowing other scripts to change the density multipliers, like changing values temporary without affecting your default values
-- add a config for these values
local multipliers = {
    AnimalDensity         = {
        enable = false, -- enable disable them
        value = 0.0     -- default values can be adjusted in here
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
    NEWBORDEAUX = { --STDENIS ?
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

-- decided to separate it in two threads to avoid slowing down the thread since it needs to be run at all frames
CreateThread(function()
    repeat Wait(2000) until LocalPlayer.state.IsInSession

    while true do
        local sleep = 1000
        if multipliers.ParkedVehicleDensity.enable then
            sleep = 0
            SetParkedVehicleDensityMultiplierThisFrame(multipliers.ParkedVehicleDensity.temp_value or multipliers.ParkedVehicleDensity.value)
        end
        if multipliers.RandomVehicleDensity.enable then
            sleep = 0
            SetRandomVehicleDensityMultiplierThisFrame(multipliers.RandomVehicleDensity.temp_value or multipliers.RandomVehicleDensity.value)
        end
        if multipliers.ScenarioAnimalDensity.enable then
            sleep = 0
            SetScenarioAnimalDensityMultiplierThisFrame(multipliers.ScenarioAnimalDensity.temp_value or multipliers.ScenarioAnimalDensity.value)
        end
        if multipliers.ScenarioHumanDensity.enable then
            sleep = 0
            SetScenarioHumanDensityMultiplierThisFrame(multipliers.ScenarioHumanDensity.temp_value or multipliers.ScenarioHumanDensity.value)
        end
        if multipliers.ScenarioPedDensity.enable then
            sleep = 0
            SetScenarioPedDensityMultiplierThisFrame(multipliers.ScenarioPedDensity.temp_value or multipliers.ScenarioPedDensity.value)
        end
        Wait(sleep)
    end
end)

CreateThread(function()
    repeat Wait(2000) until LocalPlayer.state.IsInSession

    while true do
        local sleep = 1000
        if multipliers.ParkedVehicleDensity.enable then
            sleep = 0
            SetParkedVehicleDensityMultiplierThisFrame(multipliers.ParkedVehicleDensity.temp_value or multipliers.ParkedVehicleDensity.value)
        end
        if multipliers.RandomVehicleDensity.enable then
            sleep = 0
            SetRandomVehicleDensityMultiplierThisFrame(multipliers.RandomVehicleDensity.temp_value or multipliers.RandomVehicleDensity.value)
        end
        if multipliers.ScenarioAnimalDensity.enable then
            sleep = 0
            SetScenarioAnimalDensityMultiplierThisFrame(multipliers.ScenarioAnimalDensity.temp_value or multipliers.ScenarioAnimalDensity.value)
        end
        if multipliers.ScenarioHumanDensity.enable then
            sleep = 0
            SetScenarioHumanDensityMultiplierThisFrame(multipliers.ScenarioHumanDensity.temp_value or multipliers.ScenarioHumanDensity.value)
        end
        if multipliers.ScenarioPedDensity.enable then
            sleep = 0
            SetScenarioPedDensityMultiplierThisFrame(multipliers.ScenarioPedDensity.temp_value or multipliers.ScenarioPedDensity.value)
        end
        Wait(sleep)
    end
end)


exports('GetDensityMultipliers', function(name)
    if not name then return multipliers end
    return multipliers[name]
end)

-- FROM SERVER SIDE
RegisterNetEvent('vorp_lib:Client:SetDefaultDensityMultiplier', function(name, value, enable)
    if not multipliers[name] then return error(("^1[ERROR] ^3%s^0 is not a valid density multiplier"):format(name)) end
    if enable then
        multipliers[name].enable = enable
        multipliers[name].value = value
    end
end)

RegisterNetEvent('vorp_lib:Client:SetTemporaryDensityMultiplier', function(name, value, enable)
    if not multipliers[name] then return error(("^1[ERROR] ^3%s^0 is not a valid density multiplier"):format(name)) end
    if enable then
        multipliers[name].enable = enable
        multipliers[name].temp_value = value
    end
end)

RegisterNetEvent('vorp_lib:Client:RemoveTemporaryDensityMultiplier', function(name)
    if not multipliers[name] then return error(("^1[ERROR] ^3%s^0 is not a valid density multiplier"):format(name)) end
    multipliers[name].enable = false
    multipliers[name].temp_value = nil
end)
