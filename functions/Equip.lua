local component = require('component')
local robot = require("robot")

local function Equip(itemName)
    -- Check inventory
    for i = 1, 17, 1 do
        local index = i
        -- Nothing found? Check equipped
        if i == 17 then
            index = 1
            robot.select(1)
            component.inventory_controller.equip()
        end

        local item = component.inventory_controller.getStackInInternalSlot(index)
        if item ~= nil then
            if item.name == itemName then
                robot.select(index)
                component.inventory_controller.equip()
                return index
            end
        end
    end

    return -1
end

return Equip
