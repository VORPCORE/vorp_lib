--todo: this file cant be imported it will run with the library and manage the density multipliers at runtime allowing other scripts to change the density multipliers, like changing values temporary without affecting your default values

local SetAmbientAnimalDensityMultiplierThisFrame = SetAmbientAnimalDensityMultiplierThisFrame
local SetAmbientHumanDensityMultiplierThisFrame = SetAmbientHumanDensityMultiplierThisFrame
local SetAmbientPedDensityMultiplierThisFrame = SetAmbientPedDensityMultiplierThisFrame
local SetVehicleDensityMultiplierThisFrame = SetVehicleDensityMultiplierThisFrame
local SetScenarioAnimalDensityMultiplierThisFrame = SetScenarioAnimalDensityMultiplierThisFrame
local SetScenarioHumanDensityMultiplierThisFrame = SetScenarioHumanDensityMultiplierThisFrame
local SetScenarioPedDensityMultiplierThisFrame = SetScenarioPedDensityMultiplierThisFrame
local SetParkedVehicleDensityMultiplierThisFrame = SetParkedVehicleDensityMultiplierThisFrame
local SetRandomVehicleDensityMultiplierThisFrame = SetRandomVehicleDensityMultiplierThisFrame

--* add a config for these values
local MULTIPLIERS <const> = {
    AnimalDensity         = {
        enable = false, -- enable disable them
        value = 0.0     -- default values can be adjusted in here 0.001 -> 1.0
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

--VEHICLE::SET_DISABLE_RANDOM_TRAINS_THIS_FRAME(bParam3);

-- decided to separate it in two threads to avoid slowing down the thread since it needs to be run at all frames
CreateThread(function()
    repeat Wait(2000) until LocalPlayer.state.IsInSession

    while true do
        local sleep = 1000
        if MULTIPLIERS.ParkedVehicleDensity.enable then
            sleep = 0
            SetParkedVehicleDensityMultiplierThisFrame(MULTIPLIERS.ParkedVehicleDensity.temp_value or MULTIPLIERS.ParkedVehicleDensity.value)
        end
        if MULTIPLIERS.RandomVehicleDensity.enable then
            sleep = 0
            SetRandomVehicleDensityMultiplierThisFrame(MULTIPLIERS.RandomVehicleDensity.temp_value or MULTIPLIERS.RandomVehicleDensity.value)
        end
        if MULTIPLIERS.ScenarioAnimalDensity.enable then
            sleep = 0
            SetScenarioAnimalDensityMultiplierThisFrame(MULTIPLIERS.ScenarioAnimalDensity.temp_value or MULTIPLIERS.ScenarioAnimalDensity.value)
        end
        if MULTIPLIERS.ScenarioHumanDensity.enable then
            sleep = 0
            SetScenarioHumanDensityMultiplierThisFrame(MULTIPLIERS.ScenarioHumanDensity.temp_value or MULTIPLIERS.ScenarioHumanDensity.value)
        end
        if MULTIPLIERS.ScenarioPedDensity.enable then
            sleep = 0
            SetScenarioPedDensityMultiplierThisFrame(MULTIPLIERS.ScenarioPedDensity.temp_value or MULTIPLIERS.ScenarioPedDensity.value)
        end
        Wait(sleep)
    end
end)

CreateThread(function()
    repeat Wait(2000) until LocalPlayer.state.IsInSession

    while true do
        local sleep = 1000
        if MULTIPLIERS.AnimalDensity.enable then
            sleep = 0
            SetAmbientAnimalDensityMultiplierThisFrame(MULTIPLIERS.AnimalDensity.temp_value or MULTIPLIERS.AnimalDensity.value)
        end

        if MULTIPLIERS.HumanDensity.enable then
            sleep = 0
            SetAmbientHumanDensityMultiplierThisFrame(MULTIPLIERS.HumanDensity.temp_value or MULTIPLIERS.HumanDensity.value)
        end

        if MULTIPLIERS.PedDensity.enable then
            sleep = 0
            SetAmbientPedDensityMultiplierThisFrame(MULTIPLIERS.PedDensity.temp_value or MULTIPLIERS.PedDensity.value)
        end
        if MULTIPLIERS.VehicleDensity.enable then
            sleep = 0
            SetVehicleDensityMultiplierThisFrame(MULTIPLIERS.VehicleDensity.temp_value or MULTIPLIERS.VehicleDensity.value)
        end
        Wait(sleep)
    end
end)


exports('GetDensityMultipliers', function(name)
    if not name then return MULTIPLIERS end
    if not MULTIPLIERS[name] then return error(("^1[ERROR] ^3%s^0 is not a valid density multiplier"):format(name)) end
    return MULTIPLIERS[name]
end)

-- FROM SERVER SIDE
RegisterNetEvent('vorp_lib:Client:SetDefaultDensityMultiplier', function(name, value, enable)
    if not MULTIPLIERS[name] then return error(("^1[ERROR] ^3%s^0 is not a valid density multiplier"):format(name)) end
    if enable then
        MULTIPLIERS[name].enable = enable
        MULTIPLIERS[name].value = value
    end
end)

RegisterNetEvent('vorp_lib:Client:SetTemporaryDensityMultiplier', function(name, value, enable)
    if not MULTIPLIERS[name] then return error(("^1[ERROR] ^3%s^0 is not a valid density multiplier"):format(name)) end
    if enable then
        MULTIPLIERS[name].enable = enable
        MULTIPLIERS[name].temp_value = value
    end
end)

RegisterNetEvent('vorp_lib:Client:RemoveTemporaryDensityMultiplier', function(name)
    if not MULTIPLIERS[name] then return error(("^1[ERROR] ^3%s^0 is not a valid density multiplier"):format(name)) end
    MULTIPLIERS[name].enable = false
    MULTIPLIERS[name].temp_value = nil
end)
