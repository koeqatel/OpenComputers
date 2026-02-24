local component = require('component')
local sides = require('sides')
local geolyzer = component.geolyzer
local robot = require("robot")
local event = require("event")
local config = require("config")
local Print = require("functions.Print")

local args = { ... }
local targetGrowth
local targetGain
local targetResistance
local targetSpecies

local function runConfig()
    if args[1] == nil then
        -- Read config
        if config == nil then
            Print("config is empty")
            return
        end

        targetGrowth = config.targetGrowth
        targetGain = config.targetGain
        targetResistance = config.targetResistance
        targetSpecies = config.targetSpecies
    else
        targetGrowth = args[1]
        targetGain = args[2]
        targetResistance = args[3]
        targetSpecies = args[4]

        -- Check current
        if tonumber(targetGrowth) > 23 then
            Print("Target Growth may not be higher than 23")
            return
        elseif tonumber(targetGrowth) < 0 then
            Print("Target Growth may not be lower than 0")
            return
        elseif tonumber(targetGain) > 31 then
            Print("Target Gain may not be higher than 31")
            return
        elseif tonumber(targetGain) < 0 then
            Print("Target Gain may not be lower than 0")
            return
        elseif tonumber(targetResistance) > 31 then
            Print("Target Resistance may not be higher than 31")
            return
        elseif tonumber(targetResistance) < 0 then
            Print("Target Resistance may not be lower than 0")
            return
        end

        -- Clear config
        local resetFile = io.open("config.lua", "w")
        resetFile:write("")
        resetFile:close()

        -- Write config
        local file = io.open("config.lua", "a")
        file:write("local config =\n{")
        file:write("\n    targetGrowth = ")
        file:write(targetGrowth)
        file:write(",\n    targetGain = ")
        file:write(targetGain)
        file:write(",\n    targetResistance = ")
        file:write(targetResistance)
        file:write(",\n    targetSpecies = ")
        file:write(targetSpecies or "nil")
        file:write("\n}")
        file:write("\nreturn config")
        file:close()
    end
end

local function weedKiller(crop)
    if crop["crop:name"] == "weed" then
        robot.useDown()
        robot.placeDown()
    end
end

local function walk()
    robot.forward()
    local crop = geolyzer.analyze(sides.down)
    weedKiller(crop)

    robot.forward()
    local crop = geolyzer.analyze(sides.down)
    weedKiller(crop)

    robot.forward()
    local crop = geolyzer.analyze(sides.down)
    weedKiller(crop)

    robot.back()
    robot.back()
    robot.back()
end

local function run()
    Print("plants.lua running. Press crtl + C to abort...")
    Print("run plants.lua <growth> <gain> <resistance> <species> to store to config")
    Print("")

    runConfig()

    while true do
        walk()

        -- Wait for key press with a timeout (in seconds)
        local eventType, address, char, code = event.pull(5, "key_down")

        -- If a key was pressed before timeout, exit
        if eventType == "key_down" then
            if char == 3 then
                Print("Stopping...")
                return
            end
        end

        -- If timeout occurred, continue the loop
    end
end

local ok, runtimeErr = pcall(run)
if not ok then
    io.stderr:write(runtimeErr .. "\n")
end
