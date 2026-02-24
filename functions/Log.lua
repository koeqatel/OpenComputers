local function Log(input, indent)
    if type(input) == "table" then
        indent = indent or 4
        local indentStr = string.rep(" ", indent)

        for key, value in pairs(input) do
            if type(value) == "table" then
                Log(indentStr .. key .. " (table):")
                Log(value, indent + 1)
            else
                Log(indentStr .. key .. ": " .. tostring(value) .. " (" .. type(value) .. ")")
            end
        end
    else
        local process = require("process")

        local fileName = process.info().path
        local logName = string.gsub("logs/" .. fileName, ".lua", ".log")

        local file, err = io.open(logName, "a")

        if not file then
            print("FAILED TO OPEN: ", logName)
            print("ERROR: ", err)
            return
        end

        file:write(input)
        file:write("\n")
        file:close()
    end
end

return Log
