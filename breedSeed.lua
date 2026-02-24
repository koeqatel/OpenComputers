local event = require("event")
local robot = require("robot")
local component = require('component')

package.loaded["functions.Runner"] = nil
local Runner = require("functions.Runner")

local BuildCropsticks = require("functions.plants.BuildCropsticks")
local KillWeeds = require("functions.plants.KillWeeds")
local KillDangerSeeds = require("functions.plants.KillDangerSeeds")
local GetSeedScore = require("functions.plants.GetSeedScore")
local Print = require("functions.Print")
local Log = require("functions.Log")
local Min = require("functions.Min")
local Max = require("functions.Max")
local Equip = require("functions.Equip")
local Select = require("functions.Select")

local args = { ... }

local seeds = {}

Runner.run(function()
    robot.back()
    robot.back()

    -- Step 1 - Get seeds
    Log("Step 1 - Get seeds")
    Equip("berriespp:itemSpade");

    for i = 1, 3, 1 do
        KillWeeds()
        if i == 2 then
            KillDangerSeeds()
        end
        BuildCropsticks()
        seeds[i] = GetSeedScore(args[1], args[2], args[3], args[4])
        -- DetectSeed(args)

        if i == 2 and seeds[i] ~= -1 then
            Equip("berriespp:itemSpade");
            robot.useDown();
            Equip("IC2:blockCrop");
            robot.useDown();
        end

        robot.forward()
    end

    Log(seeds)

    -- Step 2 - Upgrade breeders
    Log("Step 2 - Upgrade breeders")
    local indexedSeed = Select("IC2:itemCropSeed");

    if indexedSeed ~= nil and seeds[2] ~= -1 then
        -- If both breeder seeds have a score of 0 they are perfect and should never be replaced
        if seeds[1] ~= 0 or seeds[3] ~= 0 then
            -- Lower is better, closer to the target
            local lowestIndex = Min({ seeds[1], 10000, seeds[3] });
            local highestIndex = Max({ seeds[1], 0, seeds[3] });

            if seeds[2] ~= -1 and seeds[highestIndex] > seeds[2] then
                Log(seeds[highestIndex] .. ">" .. seeds[2] .. " = true")
                Log("HighestIndex = " .. highestIndex)
                if highestIndex == 3 then
                    robot.forward()
                    robot.forward()
                elseif highestIndex == 1 then
                    robot.back()
                    robot.back()
                end

                if indexedSeed[1] <= 16 then
                    robot.select(indexedSeed[1])
                    component.inventory_controller.equip()
                elseif indexedSeed[1] ~= 17 then
                    Print("I don't know what happened. It claims it found a seed and then lost it.")
                end

                robot.useDown();
                robot.useDown();
            end
        end
    end

    -- Step 3 - Stock up
    Log("Step 3 - Stock up")
    local indexedItem = Select("IC2:blockCrop");
    robot.forward()
    robot.forward()

    if indexedItem == nil then
        robot.suckUp(32)
        return
    elseif indexedItem[1] == 17 then
        robot.select(1)
        component.inventory_controller.equip()
    end

    if indexedItem ~= nil and indexedItem[2].size < 32 then
        robot.suckUp(1)
    end

    -- Step 4 - Store seeds
    Log("Step 4 - Store seeds")
    robot.forward()
    robot.forward()

    local indexedSeed = Select("IC2:itemCropSeed")
    local indexedWeed = Select("IC2:itemWeed")

    if indexedSeed ~= nil then
        if seeds[2] == 0 then
            -- Store perfect seeds
            robot.back()
            if indexedSeed[1] == 17 then
                robot.select(1)
                component.inventory_controller.equip()
            else
                robot.select(indexedSeed[1])
            end
            robot.dropUp()
            robot.back()
        else
            -- Store happy little accidents
            robot.back()
            robot.back()
            if indexedSeed[1] == 17 then
                robot.select(1)
                component.inventory_controller.equip()
            else
                robot.select(indexedSeed[1])
            end
            robot.dropUp()
        end
    end

    -- Step 5 - Dump weeds
    Log("Step 5 - Dump weeds")
    robot.forward()
    robot.forward()

    if indexedWeed ~= nil then
        if indexedWeed[1] == 17 then
            robot.select(1)
            component.inventory_controller.equip()
        else
            robot.select(indexedWeed[1])
        end

        robot.dropUp()
    end

    robot.back()
    robot.back()
    robot.select(1)
    Log("")
end, "breedSeed.lua 23 31 0 \"<exact seed name>\"", 10)
