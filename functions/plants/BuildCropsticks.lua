local component = require('component')
local sides = require('sides')
local geolyzer = component.geolyzer
local robot = require("robot")

package.loaded["functions.Equip"] = nil
local Equip = require("functions.Equip")

local function BuildCropsticks()
    local crop = geolyzer.analyze(sides.down)

    if crop.name == "minecraft:air" then
        Equip("IC2:blockCrop");
        robot.placeDown();
        Equip("IC2:blockCrop");
        robot.useDown();
        Equip("berriespp:itemSpade");
        robot.suckUp(2);
    end
end

return BuildCropsticks
