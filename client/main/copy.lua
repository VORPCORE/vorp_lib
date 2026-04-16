exports('copyToClipBoard', function(text)
    if not text or type(text) ~= "string" then
        return
    end
    SetNuiFocus(true, false)
    SendNUIMessage({
        data = {
            type = 'copy',
            text = text
        }
    })
    Wait(500)
end)
