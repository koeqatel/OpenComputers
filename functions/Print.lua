package.loaded["functions.Log"] = nil
local Log = require("functions.Log")

local function Print(input, indent)
    if type(input) == "table" then
        indent = indent or 4
        local indentStr = string.rep(" ", indent)

        for key, value in pairs(input) do
            if type(value) == "table" then
                Print(indentStr .. key .. " (table):")
                Print(value, indent + 1)
            else
                Print(indentStr .. key .. ": " .. tostring(value) .. " (" .. type(value) .. ")")
            end
        end
    else
        Log(input)
        print(input);
    end
end

return Print