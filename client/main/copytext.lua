exports('copyText', function(text)
    if not text or type(text) ~= "string" then
        return false, "invalid text"
    end

    SendNUIMessage({
        data = {
            type = 'copyText',
            text = text
        }
    })

    return true
end)
