local promise = {}
local isActive = false -- only one at the time

RegisterNUICallback('endProgressBar', function(result, cb)
    promise:resolve(result)
    isActive = false
    cb('ok')
end)

exports('progressSync', function(data)
    if isActive then return print('progress bar already active must wait to finish to start another one') end
    isActive = true

    promise = promise.new()
    SendNUIMessage({
        type = data.type or 'progress_linear',
        data = data,
    })

    local result = Citizen.Await(promise)
    return result
end)

exports('progressAsync', function(data, onComplete)
    if isActive then return print('progress bar already active') end
    if not onComplete then return error('onComplete function is required') end

    isActive = true
    CreateThread(function()
        promise = promise.new()
        SendNUIMessage({
            type = data.type or 'progress_linear',
            data = data,
        })

        local result = Citizen.Await(promise)
        if onComplete then
            onComplete(result)
        end
    end)
end)

exports('progressCancel', function()
    if not isActive then return print('no progress bar active') end
    SendNUIMessage({
        type = 'cancel_progress',
    })
end)

--[[ local data = {
    text = 'Loading...',
    colors = {
        startColor = 'white',
        endColor = 'black'
    },
    duration = 1000,
    type = 'linear',                    -- or circular
    position = { top = 90, left = 50 }, -- in %
} ]]

--[[ local result = exports.vorp_lib:progressSync(data)
if not result then
    print('cancelled')
end ]]


--[[ exports.vorp_lib:progressAsync(data, function(result)
    if result then
        print('Progress bar completed')
    else
        print('Progress bar cancelled')
    end
end) ]]
