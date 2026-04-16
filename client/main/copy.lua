exports('copyToClipBoard', function(text)
    if not text or type(text) ~= "string" then
        return
    end
    SendNUIMessage({
        data = {
            type = 'copy',
            text = text
        }
    })
end)
