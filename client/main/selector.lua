local isInSelection = false
local playerSelected = 0

---@param options {allow_self: boolean, amount_of_players: number, distance: number, allow_in_vehicle: boolean, allow_on_horse: boolean}
---@return number | false
local function selector(options)
    if isInSelection then return false end
    isInSelection = true
    playerSelected = 0

    local playerPed <const> = PlayerPedId()
    local isInVehicle <const> = IsPedInAnyVehicle(playerPed, false) -- perhaps add option to allow this

    if isInVehicle and not options.allow_in_vehicle then
        print("cant do this while in vehicle or mounted on horse?")
        return false
    end

    local isInHorse <const> = IsPedOnMount(playerPed)
    if isInHorse and not options.allow_on_horse then
        print("cant do this while mounted on horse?")
        return false
    end

    local activePlayers <const> = GetActivePlayers()

    local function getDistanceBetweenCoords(playerPos, targetPos)
        local dx <const> = targetPos.x - playerPos.x
        local dy <const> = targetPos.y - playerPos.y
        local dz <const> = targetPos.z - playerPos.z
        return math.sqrt(dx * dx + dy * dy + dz * dz)
    end

    local playersNeeded <const> = {}
    local amount_of_players <const> = options.amount_of_players or 4 -- fallback to default value

    local interior2 <const> = GetInteriorFromEntity(playerPed)
    for _, player in ipairs(activePlayers) do
        if #playersNeeded < amount_of_players then
            local playerPos <const> = GetEntityCoords(playerPed)
            local targetPed <const> = GetPlayerPed(player)
            local targetPos <const> = GetEntityCoords(targetPed)
            local interior <const> = GetInteriorFromEntity(targetPed)
            if interior == interior2 then
                local isInLineOfSight <const> = HasEntityClearLosToEntityInFront(playerPed, targetPed, 3167)
                if isInLineOfSight then
                    local dist <const> = #(playerPos - targetPos)
                    if dist <= (options.distance or 8.0) then -- option for distance?
                        if options.allow_self and player == PlayerId() then
                            playersNeeded[#playersNeeded] = player
                        else
                            if player ~= PlayerId() then
                                playersNeeded[#playersNeeded] = player
                            end
                        end
                    end
                end
            end
        else
            break
        end
    end

    if #playersNeeded == 0 then
        return false
    end

    local set = false
    SetNuiFocus(true, true)
    repeat
        local players <const> = {}
        for _, player in ipairs(playersNeeded) do
            local targetPed <const> = GetPlayerPed(player)
            local targetPos <const> = GetEntityCoords(targetPed)
            local playerPos <const> = GetEntityCoords(playerPed) -- who used item
            local interior <const> = GetInteriorFromEntity(targetPed)
            if interior == interior2 then
                local coords <const> = GetWorldPositionOfEntityBone(targetPed, GetPedBoneIndex(targetPed, 21030))
                local onScreen <const>, _x <const>, _y <const> = GetScreenCoordFromWorldCoord(coords.x, coords.y,
                coords.z + .3)
                if onScreen then
                    players[#players] = {
                        id = GetPlayerServerId(player),
                        x = _x,
                        y = _y,
                        distance = getDistanceBetweenCoords(playerPos, targetPos)
                    }
                end
            end
        end

        if IsPlayerDead(PlayerId()) then
            playerSelected = -1
        end

        if playerSelected == -1 then
            break
        end

        if not set then
            set = true
            SendNUIMessage({ data = { type = "select", players = players } })
        end

        SendNUIMessage({ data = { type = "update", players = players } }) -- update postion if they move?

        Wait(0)
    until playerSelected > 0

    table.wipe(playersNeeded)

    SetNuiFocus(false, false)
    print(playerSelected)
    isInSelection = false

    -- was cancelled pressed ESC
    if playerSelected == -1 then
        return false
    end

    return playerSelected
end

RegisterNUICallback("selector", function(data, cb)
    playerSelected = data.id
    cb("ok")
end)

RegisterNUICallback("selectorSound", function(_, cb)
    PlaySoundFrontend("SELECT", "HUD_SHOP_SOUNDSET", true, 0)
    cb("ok")
end)


exports("Select", selector)

--[[
 local result <const> = exports.vorp_lib:Select({
        allow_self = true, -- option to allow self selection
        amount_of_players = 4,
        distance = 8.0,
        allow_in_vehicle = true, -- option to allow selection in vehicle
        allow_on_horse = true -- option to allow selection on horse
    })
]]
