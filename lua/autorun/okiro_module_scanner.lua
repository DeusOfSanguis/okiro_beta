-- Сканер модулей (запускать через консоль: okitro_scan_modules)
concommand.Add("okiro_scan_modules", function()
    print("\n=== Сканирование модулей Okiro Beta ===\n")
    
    local categories = {
        "okiro_core",
        "okiro_ui", 
        "admin",
        "third_party",
        "okiro_gameplay",
        "workshop"
    }
    
    local totalModules = 0
    
    for _, category in ipairs(categories) do
        print("[" .. category .. "]")
        local folders = file.Find("okiro_beta/" .. category .. "/*", "LUA")
        
        for _, folder in ipairs(folders) do
            if file.IsDir("okiro_beta/" .. category .. "/" .. folder, "LUA") then
                print("  - " .. folder)
                totalModules = totalModules + 1
            end
        end
        
        print("")
    end
    
    print("Всего модулей найдено: " .. totalModules)
end)