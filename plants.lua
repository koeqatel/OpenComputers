local component = require('component')
local sides = require('sides')
local geolyzer = component.geolyzer
local robot = require("robot")
local event = require("event")
local config = require("config")

local args = { ... }
local targetGrowth
local targetGain
local targetResistance
local targetSpecies

local function printT(tbl, indent)
    indent = indent or 4
    local indentStr = string.rep(" ", indent)

    for key, value in pairs(tbl) do
        if type(value) == "table" then
            print(indentStr .. key .. " (table):")
            printT(value, indent + 1)
        else
            print(indentStr .. key .. ": " .. tostring(value) .. " (" .. type(value) .. ")")
        end
    end
end

local function weedKiller(crop)
    if crop["crop:name"] == "weed" then
        print("weed")
        robot.use()
        robot.dropDown()
    end
end

local function scan()
    local crop = geolyzer.analyze(sides.front)
    weedKiller(crop)

    printT(crop)
end

local function runConfig()
    if args[1] == nil then
        -- Read config
        if config == nil then
            print("config is empty")
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
            print("Target Growth may not be higher than 23")
            return
        elseif tonumber(targetGrowth) < 0 then
            print("Target Growth may not be lower than 0")
            return
        elseif tonumber(targetGain) > 31 then
            print("Target Gain may not be higher than 31")
            return
        elseif tonumber(targetGain) < 0 then
            print("Target Gain may not be lower than 0")
            return
        elseif tonumber(targetResistance) > 31 then
            print("Target Resistance may not be higher than 31")
            return
        elseif tonumber(targetResistance) < 0 then
            print("Target Resistance may not be lower than 0")
            return
        end

        -- Clear config
        local resetFile = io.open("config.lua", "w")
        resetFile:write("")
        resetFile:close()

        -- Write config
        local file = io.open("config.lua", "a")
        file:write("local config =\n{")
        file:write("\ntargetGrowth = ")
        file:write(targetGrowth)
        file:write(",\ntargetGain = ")
        file:write(targetGain)
        file:write(",\ntargetResistance = ")
        file:write(targetResistance)
        file:write(",\ntargetSpecies = ")
        file:write(targetSpecies or "nil")
        file:write("\n}")
        file:write("\nreturn config")
        file:close()
    end
end

local function run()
    print("plants.lua running. Press any key to abort...")
    print("run plants.lua <growth> <gain> <resistance> <species> to store to config")
    print("")

    runConfig()
    while true do
        scan()

        -- Wait for key press with a timeout (in seconds)
        local eventType, address, char, code = event.pull(5, "key_down")

        -- If a key was pressed before timeout, exit
        if eventType == "key_down" then
            print("Stopping...")
            return
        end

        -- If timeout occurred, continue the loop
    end
end

local ok, runtimeErr = pcall(run)
if not ok then
    io.stderr:write(runtimeErr .. "\n")
end
