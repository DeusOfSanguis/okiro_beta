-- Okiro Global Module Loader
-- Автоматическое обнаружение и загрузка всех модулей

local OkiroLoader = {}
OkiroLoader.Modules = {}
OkiroLoader.LoadOrder = {
    "okiro_core",      -- Ядро системы (первыми)
    "okiro_ui",        -- UI компоненты
    "admin",           -- Админ системы
    "third_party",     -- Сторонние аддоны
    "okiro_gameplay",  -- Игровые механики
    "workshop"         -- Workshop аддоны (последними)
}

-- Сканирование папок и поиск модулей
function OkiroLoader:ScanModules()
    local basePath = "okiro_beta/"
    
    for _, category in ipairs(self.LoadOrder) do
        self.Modules[category] = {}
        
        -- Получаем список папок в категории
        local folders = file.Find(basePath .. category .. "/*", "LUA")
        
        for _, folder in ipairs(folders) do
            if file.IsDir(basePath .. category .. "/" .. folder, "LUA") then
                table.insert(self.Modules[category], folder)
            end
        end
    end
end

-- Загрузка модуля
function OkiroLoader:LoadModule(category, moduleName)
    local basePath = "okiro_beta/" .. category .. "/" .. moduleName .. "/"
    
    -- Проверяем наличие загрузчика модуля
    local loaderPath = basePath .. "lua/autorun/" .. moduleName .. "_load.lua"
    
    if file.Exists(loaderPath, "LUA") then
        if SERVER then
            AddCSLuaFile(loaderPath)
            include(loaderPath)
        else
            include(loaderPath)
        end
        
        print(string.format("[Okiro Loader] ✓ %s/%s загружен", category, moduleName))
        return true
    else
        -- Если нет отдельного загрузчика, ищем все lua файлы
        self:LoadModuleFiles(basePath .. "lua/", moduleName)
        return true
    end
end

-- Загрузка всех Lua файлов в папке
function OkiroLoader:LoadModuleFiles(path, moduleName)
    local files = file.Find(path .. "*.lua", "LUA")
    
    for _, luaFile in ipairs(files) do
        if SERVER then
            AddCSLuaFile(path .. luaFile)
        end
        include(path .. luaFile)
    end
    
    -- Рекурсивно загружаем подпапки
    local folders = file.Find(path .. "*", "LUA")
    for _, folder in ipairs(folders) do
        if file.IsDir(path .. folder, "LUA") then
            self:LoadModuleFiles(path .. folder .. "/", moduleName)
        end
    end
end

-- Основная функция загрузки
function OkiroLoader:Initialize()
    print("\n[Okiro Loader] ======================================")
    print("[Okiro Loader] Начинаю загрузку модулей...")
    print("[Okiro Loader] ======================================\n")
    
    self:ScanModules()
    
    local totalLoaded = 0
    
    for _, category in ipairs(self.LoadOrder) do
        print(string.format("[Okiro Loader] Загрузка категории: %s", category))
        
        for _, moduleName in ipairs(self.Modules[category] or {}) do
            local success = self:LoadModule(category, moduleName)
            if success then
                totalLoaded = totalLoaded + 1
            else
                print(string.format("[Okiro Loader] ✗ Ошибка загрузки %s/%s", category, moduleName))
            end
        end
        
        print("")
    end
    
    print(string.format("[Okiro Loader] ======================================"))
    print(string.format("[Okiro Loader] Загружено модулей: %d", totalLoaded))
    print(string.format("[Okiro Loader] ======================================\n"))
end

-- Запуск загрузки
hook.Add("Initialize", "Okiro_Global_Loader", function()
    OkiroLoader:Initialize()
end)