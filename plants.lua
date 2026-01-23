local component = require('component')
local sides = require('sides')
local geolyzer = component.geolyzer
local robot = require("robot")

local function printTableRecursive(tbl, indent)
    indent = indent or 0
    local indentStr = string.rep("  ", indent)
    
    for key, value in pairs(tbl) do
        if type(value) == "table" then
            print(indentStr .. key .. " (table):")
            printTableRecursive(value, indent + 1)
        else
            print(indentStr .. key .. ": " .. tostring(value) .. " (" .. type(value) .. ")")
        end
    end
end

local function breakWeeds(crop)
    if crop["crop:name"] == "weed" then
        print("weed")
        robot.use()
        robot.dropDown()
    end
end

local function scan()
    local crop = geolyzer.analyze(sides.front)
    breakWeeds(crop)

    printTableRecursive(crop, 4)
end


scan()