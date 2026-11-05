-- CEF now requires a real NUI click before execCommand('copy') works
local copyBusy = false
local copyCallback = nil

---@param text string|number text to copy
---@param cb? fun(copied: boolean) optional callback, called with true if copied or false if cancelled
exports('copyToClipBoard', function(text, cb)
    if text == nil or copyBusy then
        return
    end

    text = tostring(text)
    if text == "" then
        return
    end

    copyBusy = true
    copyCallback = cb
    SetNuiFocus(true, true)
    SendNUIMessage({
        data = {
            type = 'copy',
            text = text
        }
    })
end)

RegisterNUICallback('copyResult', function(data, cb)
    SetNuiFocus(false, false)
    copyBusy = false

    local callback = copyCallback
    copyCallback = nil

    if callback then
        local ok = data and data.ok == true
        pcall(callback, ok)
    end

    cb('ok')
end)
