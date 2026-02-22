local CLASS <const> = Import('class').Class

local function loadLangFile(resource, folder, lang)
    local path <const> = ('%s/%s.lua'):format(folder, lang)
    local raw <const> = LoadResourceFile(resource, path)
    if not raw then return nil end

    local fn, err = load(raw)
    if not fn then
        print(('[Locale] Error loading %s: %s'):format(path, err))
        return nil
    end

    return fn()
end

local Locale <const> = CLASS:Create({
    constructor = function(self, data)
        self._langs = {}
        self._currentLang = data.default or 'en'
        self._defaultLang = data.default or 'en'
        self._fallback = data.fallback ~= false
        self._folder = data.folder or 'locales'
        self._resource = data.resource or GetCurrentResourceName()

        local langs <const> = data.langs or { self._defaultLang }
        for _, lang in ipairs(langs) do
            local content = loadLangFile(self._resource, self._folder, lang)
            if content then
                self._langs[lang] = content
            end
        end

        if not self._langs[self._defaultLang] then
            local content = loadLangFile(self._resource, self._folder, self._defaultLang)
            if content then
                self._langs[self._defaultLang] = content
            end
        end
    end,

    set = {
        SetLang = function(self, lang)
            if self._langs[lang] then
                self._currentLang = lang
            else
                error(('Language "%s" not loaded'):format(lang))
            end
        end
    },

    get = {
        GetLang = function(self)
            return self._currentLang
        end,
        GetAvailableLangs = function(self)
            local langs = {}
            for lang in pairs(self._langs) do
                langs[#langs + 1] = lang
            end
            return langs
        end
    },

    T = function(self, key, vars)
        local text = nil

        if self._langs[self._currentLang] then
            text = self._langs[self._currentLang][key]
        end

        if not text and self._fallback and self._currentLang ~= self._defaultLang then
            if self._langs[self._defaultLang] then
                text = self._langs[self._defaultLang][key]
            end
        end

        if not text then
            return key
        end

        if vars and type(vars) == 'table' then
            for name, value in pairs(vars) do
                text = text:gsub('{' .. name .. '}', tostring(value))
            end
        end

        return text
    end
})

local LocaleAPI <const> = {}

function LocaleAPI:Load(options)
    return Locale:New(options or {})
end

return {
    Locale = LocaleAPI
}
