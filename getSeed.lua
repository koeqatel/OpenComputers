local component = require('component')
local sides = require('sides')
local geolyzer = component.geolyzer
local event = require("event")

package.loaded["functions.Runner"] = nil
local Runner = require("functions.Runner")

local BuildCropsticks = require("functions.plants.BuildCropsticks")
local KillWeeds = require("functions.plants.KillWeeds")
local KillDangerSeeds = require("functions.plants.KillDangerSeeds")
local DetectSeed = require("functions.plants.DetectSeed")

local args = { ... }

Runner.run(function()
    KillWeeds()
    KillDangerSeeds()
    BuildCropsticks()
    DetectSeed(args)
end, "getSeed.lua \"Stargatium\" \"Quantaria\" \"Transformium\"", 5)
