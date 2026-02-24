local function max(numbers)
    local maxIndex, maxValue

    for i, value in ipairs(numbers) do
        if not maxValue or value > maxValue then
            maxValue = value
            maxIndex = i
        end
    end

    return maxIndex
end

return max