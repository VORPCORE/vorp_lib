
---@class STREAMING
local Streaming = {}

print("^3WARNING: ^7module STREAMING is a work in progress use it at your own risk")


---@param model string | integer Model name or hash
---@param timeout integer? Timeout in milliseconds to SetModelAsNoLongerNeeded and remove it from memory
function Streaming.LoadModel(model, timeout)
    if not IsModelValid(model) then
        error(("Model is invalid: %s"):format(model), 2)
    end

    if not HasModelLoaded(model) then
        RequestModel(model, false)

        local startTime <const> = GetGameTimer()
        repeat Wait(0) until HasModelLoaded(model) or (GetGameTimer() - startTime) > 5000

        if (GetGameTimer() - startTime) > 5000 then
            error(("Failed to load model: %s"):format(model), 2)
        end
    end

    if not timeout then
        return
    end

    SetTimeout(timeout, function()
        SetModelAsNoLongerNeeded(model)
    end)
end

--- load texture dictionary
---@param dict string
---@param timeout integer | nil?
function Streaming.LoadTextureDict(dict, timeout)
    if not DoesStreamedTextureDictExist(dict) then
        error(("Texture dictionary does not exist: %s"):format(dict), 2)
    end

    if not HasStreamedTextureDictLoaded(dict) then
        RequestStreamedTextureDict(dict, false)

        local startTime <const> = GetGameTimer()
        repeat Wait(0) until HasStreamedTextureDictLoaded(dict) or (GetGameTimer() - startTime) > 5000

        if (GetGameTimer() - startTime) > 5000 then
            error(("Failed to load texture dictionary: %s"):format(dict), 2)
        end
    end

    if not timeout then
        return
    end

    SetTimeout(timeout, function()
        SetStreamedTextureDictAsNoLongerNeeded(dict)
    end)
end

--- load particle fx
---@param dict string
---@param timeout integer?
function Streaming.LoadParticleFx(dict, timeout)
    if not HasNamedPtfxAssetLoaded(dict) then
        RequestNamedPtfxAsset(dict)

        local startTime <const> = GetGameTimer()
        repeat Wait(0) until HasNamedPtfxAssetLoaded(dict) or (GetGameTimer() - startTime) > 5000

        if (GetGameTimer() - startTime) > 5000 then
            error(("Failed to load particle fx: %s"):format(dict), 2)
        end
    end

    if not timeout then
        return
    end

    SetTimeout(timeout, function()
        RemoveNamedPtfxAsset(dict)
    end)
end

--- load animation dictionary
---@param dict string
---@param timeout integer?
function Streaming.LoadAnimDict(dict, timeout)
    if not DoesAnimDictExist(dict) then
        error('Animation dictionary does not exist: ' .. (dict or "no dictionary provided"), 2)
    end
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)

        local startTime <const> = GetGameTimer()
        repeat Wait(0) until HasAnimDictLoaded(dict) or (GetGameTimer() - startTime) > 5000

        if (GetGameTimer() - startTime) > 5000 then
            error(('Failed to load animation dictionary: %s'):format(dict), 1)
        end
    end

    if not timeout then
        return
    end

    SetTimeout(timeout, function()
        RemoveAnimDict(dict)
    end)
end

--- load weapon asset
---@param weapon string | integer
---@param p1 integer unknown
---@param p2 boolean
---@param timeout number?
function Streaming.LoadWeaponAsset(weapon, p1, p2, timeout)
    if not IsWeaponValid(weapon) then
        error(('Invalid weapon name or hash: %s') .. tostring(weapon), 2)
    end

    if not HasWeaponAssetLoaded(weapon) then
        RequestWeaponAsset(weapon, p1, p2)

        local startTime <const> = GetGameTimer()
        repeat Wait(0) until HasWeaponAssetLoaded(weapon) or (GetGameTimer() - startTime) > 5000

        if (GetGameTimer() - startTime) > 5000 then
            error('Failed to load weapon asset: ' .. weapon, 1)
        end
    end

    if not timeout then
        return
    end

    SetTimeout(timeout, function()
        RemoveWeaponAsset(weapon)
    end)
end

--- this does only loads the collision of the terrain
function Streaming.RequestCollisionAtCoord(coords)
    if not HasCollisionLoadedAtCoord(coords.x, coords.y, coords.z) then
        RequestCollisionAtCoord(coords.x, coords.y, coords.z)

        local startTime <const> = GetGameTimer()
        repeat Wait(0) until HasCollisionLoadedAtCoord(coords.x, coords.y, coords.z) or (GetGameTimer() - startTime) > 5000

        if (GetGameTimer() - startTime) > 5000 then
            error(('Failed to load collision at coords: %s'):format(tostring(coords)), 2)
        end
    end
end

function Streaming.RequestCollisionForModel(model)
    if not IsModelValid(model) then
        error(('Invalid model: %s'):format(tostring(model)), 2)
    end

    if not HasCollisionForModelLoaded(model) then
        RequestCollisionForModel(model)

        local startTime <const> = GetGameTimer()
        repeat Wait(0) until HasCollisionForModelLoaded(model) or (GetGameTimer() - startTime) > 5000

        if (GetGameTimer() - startTime) > 5000 then
            error(('Failed to load collision for model: %s'):format(tostring(model)), 2)
        end
    end
end

function Streaming.RequestIpl(ipl)
    if not IsIplActiveHash(ipl) then
        RequestIplHash(ipl)

        local startTime <const> = GetGameTimer()
        repeat Wait(0) until IsIplActiveHash(ipl) or (GetGameTimer() - startTime) > 5000

        if (GetGameTimer() - startTime) > 5000 then
            error(('Failed to load Ipl: %s'):format(tostring(ipl)), 2)
        end
    else
        print(('You are requesting an IPL that have been already requested: %s'):format(tostring(ipl)))
    end
end

function Streaming.LoadMoveNetworkDef(netDef, timeout)
    if HasMoveNetworkDefLoaded(netDef) == 0 then
        RequestMoveNetworkDef(netDef)

        local startTime <const> = GetGameTimer()
        repeat Wait(0) until HasMoveNetworkDefLoaded(netDef) == 1 or (GetGameTimer() - startTime) > 5000
        if (GetGameTimer() - startTime) > 5000 then
            error(('Failed to load move network def: %s'):format(netDef), 1)
        end
    end

    if not timeout then
        return
    end
    SetTimeout(timeout, function()
        RemoveMoveNetworkDef(netDef)
    end)
end

function Streaming.LoadClipSet(clipSet, timeout)
    if HasClipSetLoaded(clipSet) == 0 then
        RequestClipSet(clipSet)

        local startTime <const> = GetGameTimer()
        repeat Wait(0) until HasClipSetLoaded(clipSet) == 1 or (GetGameTimer() - startTime) > 5000
        if (GetGameTimer() - startTime) > 5000 then
            error(('Failed to load clip set: %s'):format(clipSet), 1)
        end
    end

    if not timeout then
        return
    end
    SetTimeout(timeout, function()
        RemoveClipSet(clipSet)
    end)
end

-- loads the world around entity, but can cause crash if too many MLOS around ?
function Streaming.LoadScene(pos, offset, radius, p7)
    if not IsLoadSceneActive() and not IsLoadSceneLoaded() then
        -- load the area, returns a boolean, will always be true unless `IS_PLAYER_SWITCH_IN_PROGRESS` is true
        if not LoadSceneStart(pos.x, pos.y, pos.z, offset.x, offset.y, offset.z, radius, p7) then
            return
        end

        local startTime <const> = GetGameTimer()
        repeat Wait(0) until IsLoadSceneLoaded() or (GetGameTimer() - startTime) > 5000
        if (GetGameTimer() - startTime) > 5000 then
            error(('Failed to load scene at pos: %s'):format(tostring(pos)), 1)
        end
    end

    LoadSceneStop()
end

return {
    Streaming = Streaming
}
