local event = require("event")

package.loaded["functions.ClearModules"] = nil
local ClearModules = require("functions.ClearModules")
ClearModules()

local Print = require("functions.Print")

local M = {}
local running = true

local function onKey(_, _, char)
    if char == 3 then
        Print("Stopping...")
        if not event.ignore("key_down", onKey) then
            Print("Failed to unregister keydown event")
        end
        running = false
    end
end

event.listen("key_down", onKey)

function M.run(userFunction, usage, interval)
    usage = usage or "No usage povided"
    interval = interval or 5

    local process = require("process")
    local fileName = process.info().path

    local function main()
        Print(fileName .. " running. Press Ctrl + C to abort...")
        Print("Usage: " .. usage)
        Print("")

        while running do
            -- Run the user’s code
            userFunction()
            
            os.sleep(interval)
        end
    end

    local ok, runtimeErr = pcall(main)
    if not ok then
        io.stderr:write(runtimeErr .. "\n")
    end
end

return M
