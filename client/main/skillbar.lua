local promises = nil
local isActive = false

local KEY_SPACE <const> = 0xD9D0E1C0

-- duration is the time in ms the needle takes to cross the bar, width is the size of the zone in %
local DIFFICULTY <const> = {
    easy    = { duration = 2300, width = 5.6 },
    normal  = { duration = 2100, width = 7 },
    medium  = { duration = 1700, width = 8.4 },
    hard    = { duration = 1300, width = 9.8 },
    ultra   = { duration = 1200, width = 10.5 },
    extreme = { duration = 1000, width = 14 },
}

local function getDifficulty(difficulty)
    if type(difficulty) == "table" then
        return difficulty
    end

    return DIFFICULTY[difficulty] or DIFFICULTY.easy
end

-- nui has no focus so the key is read here
local function listenForKey(key)
    CreateThread(function()
        while isActive do
            Wait(0)
            if IsControlJustPressed(0, key) or IsDisabledControlJustPressed(0, key) then
                SendNUIMessage({
                    data = {
                        type = 'skillbar_check',
                    },
                })
            end
        end
    end)
end

local function executeSkillbar(data, callback)
    isActive = true
    TriggerEvent("vorp_lib:skillbar:start")

    local difficulty <const> = getDifficulty(data.difficulty)

    promises = promise.new()
    SendNUIMessage({
        data = {
            type = 'skillbar',
            text = data.text,
            amount = data.amount or 1,
            duration = difficulty.duration or 2300,
            width = difficulty.width or 6,
            colors = data.colors,
            position = data.position,
            image = data.image,
        },
    })

    PlaySoundFrontend("enter", "RDRO_Winners_Screen_Sounds", true, 0)
    listenForKey(data.key or KEY_SPACE)

    local p <const> = promises
    if not callback then
        return Citizen.Await(p)
    end

    CreateThread(function()
        local result = Citizen.Await(p)
        callback(result)
    end)
end

RegisterNUICallback('endSkillbar', function(result, cb)
    -- if you want to listen to the end of the skill bar
    TriggerEvent("vorp_lib:skillbar:end", result)
    isActive = false
    if promises then
        promises:resolve(result)
        promises = nil
    end
    cb('ok')
end)

---@param data table text, difficulty, amount, key, colors, position, image
---@param onComplete? fun(result: boolean) optional callback
exports('skillbarStart', function(data, onComplete)
    if isActive then
        print('skill bar already active')
        if onComplete then
            return onComplete(false)
        end
        return false
    end

    return executeSkillbar(data or {}, onComplete)
end)

exports('skillbarCancel', function()
    if not isActive then return print('no skill bar active') end
    SendNUIMessage({
        data = {
            type = 'cancel_skillbar',
        },
    })
end)

--[[
difficulty: easy, normal, medium, hard, ultra, extreme
or your own: difficulty = { duration = 1500, width = 9 }

RegisterCommand('skill', function()
    local data = {
        text = 'Press SPACE',               -- optional
        difficulty = 'medium',
        amount = 3,                         -- how many hits in a row are needed
        key = 0xD9D0E1C0,                   -- optional, default is space
        colors = {
            textColor = 'white',
            -- same filters as the progress bar, add deg to the number
            backgroundColor = '0deg',
            zoneColor = '120deg',
            needleColor = '#b3261e',
        },
        position = { top = 90, left = 50 }, -- in %
        image = 'score_timer_extralong',    -- only png this is optional
    }

    local result = exports.vorp_lib:skillbarStart(data)
    if not result then
        print('failed')
    else
        print('success')
    end

    exports.vorp_lib:skillbarStart(data, function(result)
        if result then
            print('Skill bar success')
        else
            print('Skill bar failed')
        end
    end)
end, false)
--cancel
RegisterCommand('cancelskill', function()
    exports.vorp_lib:skillbarCancel()
end, false)
]]
