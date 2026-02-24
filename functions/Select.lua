local component = require('component')
local robot = require("robot")

local function checkItem(slot, itemName)
    local item = component.inventory_controller.getStackInInternalSlot(slot)
    if item ~= nil then
        if item.name == itemName then
            robot.select(slot)
            return item
        end
    end

    return nil
end

local function Select(itemName)
    -- Check inventory
    for i = 1, 16, 1 do
        local item = checkItem(i, itemName)
        if item ~= nil then
            return {i, item}
        end
    end

    -- If nothing found
    robot.select(16)
    component.inventory_controller.equip()
    local item = checkItem(16, itemName)
    if item ~= nil then
        return {17, item}
    end
    component.inventory_controller.equip()

    return nil
end

return Select
