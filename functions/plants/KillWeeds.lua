local component = require('component')
local sides = require('sides')
local geolyzer = component.geolyzer
local robot = require("robot")

local Equip = require("functions.Equip")

local function KillWeeds()
    local crop = geolyzer.analyze(sides.down)

    if crop["crop:name"] == "weed" then
        Equip("berriespp:itemSpade");
        robot.useDown()
        Equip("IC2:blockCrop");
        robot.useDown();
        Equip("berriespp:itemSpade");
        robot.suckUp(1);
    end
end

return KillWeeds
