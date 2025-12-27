-- LOTM Configuration
-- Общие настройки системы

LOTM = LOTM or {}
LOTM.Config = LOTM.Config or {}

-- Настройки хитбоксов
LOTM.Config.Hitbox = {
    -- Размеры хитбоксов для разных частей тела
    HeadRadius = 8,
    ChestRadius = 12,
    LimbRadius = 6,
    
    -- Множители урона
    HeadDamageMultiplier = 2.0,
    ChestDamageMultiplier = 1.0,
    LimbDamageMultiplier = 0.7,
    
    -- Визуализация (для отладки)
    DebugMode = false,
    DebugColor = Color(255, 0, 0, 100)
}

-- Настройки способностей
LOTM.Config.Abilities = {
    MaxAbilities = 5,
    CooldownColor = Color(200, 200, 200, 150),
    ReadyColor = Color(100, 255, 100, 200),
    
    -- Дефолтные кулдауны
    DefaultCooldown = 5,
    DefaultManaCost = 10
}

-- Настройки кейбиндов
LOTM.Config.Keybinds = {
    MenuKey = KEY_F4,
    
    -- Дефолтные бинды
    Defaults = {
        Ability1 = KEY_1,
        Ability2 = KEY_2,
        Ability3 = KEY_3,
        Ability4 = KEY_4,
        Ability5 = KEY_5,
        ThirdPerson = KEY_V,
        Aura = KEY_B,
        Artifacts = KEY_N
    }
}