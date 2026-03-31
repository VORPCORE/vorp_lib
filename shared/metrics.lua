-- module for adding metrics to the server
-- example: where the buying and selling of items is happening etc

--TODO:
local LIB <const> = Import 'class'

-- JUST FOR TESTING THIS IS JUTS A PROTOTYPE
local PROVIDERS <const> = {
    FIVEMANAGER = "fivenmanager",
    GRAFANA = "grafana",
    PROMETHEUS = "prometheus",
}

local metrics <const> = LIB.Class:Create({

    constructor = function(self)
        self.provider = nil
    end,

    set = {
        -- can support multiple providers
        Provider = function(self, provider)
            if not PROVIDERS[provider] then
                error("Invalid provider: " .. provider)
            end
            self.provider = PROVIDERS[provider]
        end,

        AddItem = function(self, data)
            -- reason for this item to have been added to player inventory
            -- name
            -- amount
            -- price
            -- reason (bought , sold, pickup, given)
            -- from who (shop,farming, hunting)
        end,

        AddMoney = function(self, data)
            -- reason for this money to have been added to player inventory
            -- amount
            -- reason (bought , sold, pickup, given)
            -- from who (shop,farming, hunting)
        end,
    }
}, "METRICS")


return {
    Metrics = metrics
}
