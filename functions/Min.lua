local function min(numbers)
    local minIndex, minValue

    for i, value in ipairs(numbers) do
        if not minValue or value < minValue then
            minValue = value
            minIndex = i
        end
    end

    return minIndex
end

return min