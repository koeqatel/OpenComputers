local function TableContains(haystack, needle)
    for key, value in pairs(haystack) do
        if value == needle then
            return true
        end
    end

    return false
end

return TableContains