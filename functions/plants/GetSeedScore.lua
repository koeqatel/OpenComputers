local component = require('component')
local sides = require('sides')
local geolyzer = component.geolyzer

local Log = require("functions.Log")

local function GetSeedScore(targetGrowth, targetGain, targetResistance, targetSpecies)
    local crop = geolyzer.analyze(sides.down)
    Log(crop)
    Log("")
    local score = 0

    if crop["crop:name"] == nil then
        return -1
    end

    score = score + math.abs(targetGrowth - crop["crop:growth"])
    score = score + math.abs(targetGain - crop["crop:gain"])
    score = score + math.floor(math.abs(targetResistance - crop["crop:resistance"]) / 4)

    -- Always break seeds that are not the target.
    if targetSpecies ~= crop["crop:name"] then
        score = score + 1000
    end

    return score
end

return GetSeedScore
