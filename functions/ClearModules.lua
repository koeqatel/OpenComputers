local function ClearModules()
    local myModules = {
        "functions.plants.AnalizeSeed",
        "functions.plants.BuildCropsticks",
        "functions.plants.DetectSeed",
        "functions.plants.GetSeedScore",
        "functions.plants.KillDangerSeeds",
        "functions.plants.KillWeeds",
        "functions.Equip",
        "functions.Log",
        "functions.Max",
        "functions.Min",
        "functions.Print",
        "functions.Select",
        "functions.TableContains",
    }

    for _, name in ipairs(myModules) do
        package.loaded[name] = nil
    end
end

return ClearModules
