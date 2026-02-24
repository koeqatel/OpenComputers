local component = require('component')
local sides = require('sides')
local geolyzer = component.geolyzer
local robot = require("robot")

local Equip = require("functions.Equip")
local Print = require("functions.Print")

local function KillDangerSeeds()
    local crop = geolyzer.analyze(sides.down)

    if crop["crop:name"] ~= nil and crop["crop:growth"] >= 24 then
        Print("Breaking: " .. crop["crop:name"] .. " (24+)")
        Equip("berriespp:itemSpade");
        robot.useDown()
        Equip("IC2:blockCrop");
        robot.useDown();
        Equip("berriespp:itemSpade");
        robot.suckUp(1);
    end
end

return KillDangerSeeds
