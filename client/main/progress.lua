local promises = {}
local isActive = false
local progressQueue = {}

local function executeProgress(data, callback)
    isActive = true
    TriggerEvent("vorp_lib:progressbar:start")

    promises = promise.new()
    SendNUIMessage({
        data = data,
        duration = data.duration or 1000,
    })

    local function processQueue()
        if #progressQueue > 0 and not isActive then
            local nextProgress = table.remove(progressQueue, 1)
            executeProgress(nextProgress.data, nextProgress.callback)
        end
    end

    CreateThread(function()
        local result = Citizen.Await(promises)
        TriggerEvent("vorp_lib:progressbar:end")
        isActive = false

        if callback then
            callback(result)
        end

        processQueue()
    end)
end

RegisterNUICallback('endProgressBar', function(result, cb)
    -- if you want to listen to the end of the progress bar
    TriggerEvent("vorp_lib:progressbar:end")
    promises:resolve(result)
    cb('ok')
end)

exports('progressStart', function(data, onComplete)
    if not onComplete then
        if isActive then
            local queuePromise = promise.new()
            table.insert(progressQueue, {
                data = data,
                callback = function(result)
                    queuePromise:resolve(result)
                end
            })
            return Citizen.Await(queuePromise)
        else
            promises = promise.new()
            executeProgress(data, nil)
            return Citizen.Await(promises)
        end
    else
        if isActive then
            table.insert(progressQueue, {
                data = data,
                callback = onComplete
            })
        else
            executeProgress(data, onComplete)
        end
    end
end)

exports('progressCancel', function()
    if not isActive then return print('no progress bar active') end
    TriggerEvent("vorp_lib:progressbar:end")
    SendNUIMessage({
        data = {
            type = 'cancel_progress',
        },
    })
end)

--[[
Red: 0deg
Orange: 30deg
Yellow: 60deg
Green: 120deg
Blue: 240deg
Purple: 270deg
Pink: 300deg

RegisterCommand('select', function()
    local data = {
        text = 'Some text here',
        colors = {
            -- for text
            startColor = 'white',
            endColor = 'black',
            -- these colors are filters they dont really represent the color that well but its an option if you want to change it
            -- for background
            -- https://colorpicker.dev/#21d70d use this website choose hwb and its the first number just add deg to it like this 330deg
            backgroundColor = '0deg', -- Changes grey bar to blue-ish
            -- for fill
            fillColor = '120deg',     -- Changes white bar to green-ish
        },
        duration = 5000,
        type = 'linear',                    -- or circular
        position = { top = 90, left = 50 }, -- in %
        image = 'score_timer_extralong',    -- only png this is optional
    }

    local result = exports.vorp_lib:progressSync(data)
    if not result then
        print('cancelled')
    else
        print('completed')
    end


      exports.vorp_lib:progressAsync(data, function(result)
        if result then
            print('Progress bar completed')
        else
            print('Progress bar cancelled')
        end
    end)
end, false)
--cancel
RegisterCommand('cancel', function()
    exports.vorp_lib:progressCancel()
end, false)
]]
