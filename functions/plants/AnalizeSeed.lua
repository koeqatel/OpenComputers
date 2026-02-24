local component = require('component')
local sides = require('sides')
local geolyzer = component.geolyzer

local function AnalizeSeed()
    local crop = geolyzer.analyze(sides.down)
    local seed = {
        name = crop["crop:name"],
        growth = crop["crop:growth"],
        gain = crop["crop:gain"],
        resistance = crop["crop:resistance"],
        score = crop["crop:resistance"],
    }
    return seed
end

return AnalizeSeed
