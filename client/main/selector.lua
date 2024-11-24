--* player selector module to allow selecting players with a ui where is more intuitive than using a command or input
local isInSelection = false
local playerSelected = 0

---@param allow_self boolean allows self selection
---@param amount_of_players number max amount of closest players than can be selected
---@return number | false
local function selector(allow_self, amount_of_players)
    if isInSelection then return false end
    isInSelection = true
    playerSelected = 0

    local playerPed <const> = PlayerPedId()
    local isInVehicle <const> = IsPedInAnyVehicle(playerPed, false)
    local isInHorse <const> = GetMount(playerPed) > 0
    if isInVehicle or isInHorse then
        print("cant do this while in vehicle or mounted on horse")
        return false
    end

    local activePlayers <const> = GetActivePlayers()
    if allow_self and #activePlayers > 1 then
        if #activePlayers == 1 then
            if activePlayers[1] == PlayerId() then
                local selfId <const> = GetPlayerServerId(PlayerId())
                isInSelection = false
                return selfId
            end
        end
    end

    local function getDistanceBetweenCoords(playerPos, targetPos)
        local dx = targetPos.x - playerPos.x
        local dy = targetPos.y - playerPos.y
        local dz = targetPos.z - playerPos.z
        return math.sqrt(dx * dx + dy * dy + dz * dz)
    end


    SetNuiFocus(true, true)

    local playersNeeded = {}
    amount_of_players = amount_of_players or 4 -- fallback to default value

    for _, player in ipairs(activePlayers) do
        if #playersNeeded < amount_of_players then
            local playerPos <const> = GetEntityCoords(playerPed)
            local targetPed <const> = GetPlayerPed(player)
            local targetPos <const> = GetEntityCoords(targetPed)
            local dist <const> = #(playerPos - targetPos)
            if dist < 8.0 then
                if player == PlayerId() then
                    if allow_self then
                        table.insert(playersNeeded, player)
                    end
                else
                    table.insert(playersNeeded, player)
                end
            end
        else
            break
        end
    end

    local set = false

    repeat
        -- track players coords in case they are moving around
        local players = {}
        for _, player in ipairs(playersNeeded) do
            local targetPed <const> = GetPlayerPed(player)
            local targetPos <const> = GetEntityCoords(targetPed)
            local playerPos <const> = GetEntityCoords(playerPed) -- who used item
            local coords <const> = GetWorldPositionOfEntityBone(targetPed, GetPedBoneIndex(targetPed, 21030))
            local onScreen <const>, _x <const>, _y <const> = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z + .5)
            if onScreen then
                table.insert(players, {
                    id = GetPlayerServerId(player),
                    x = _x,
                    y = _y,
                    distance = getDistanceBetweenCoords(playerPos, targetPos)
                })
            end
        end

        if not set then
            set = true
            SendNUIMessage({ action = "select", players = players })
        end

        SendNUIMessage({ action = "update", players = players })

        Wait(0)
    until playerSelected > 0

    playersNeeded = {}

    SetNuiFocus(false, false)
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


exports("Select", selector)
