local component = require('component')
local sides = require('sides')
local geolyzer = component.geolyzer
local robot = require("robot")

local Equip = require("functions.Equip")
local TableContains = require("functions.TableContains")
local Print = require("functions.Print")

local function DetectSeed(targets)
    local crop = geolyzer.analyze(sides.down)
    if not TableContains(targets, crop["crop:name"]) and crop["crop:name"] ~= nil then
        Print("Breaking: " .. crop["crop:name"] .. " (Unwanted)")
        Equip("berriespp:itemSpade");
        robot.useDown();
        Equip("IC2:blockCrop");
        robot.useDown();
        Equip("berriespp:itemSpade");
        robot.suckUp(1);
    elseif TableContains(targets, crop["crop:name"]) then
        Print("Found " .. crop["crop:name"] .. "!")
    end
end

return DetectSeed
