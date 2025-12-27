# LOTM System - Lord of the Mysteries

## Описание
Полнофункциональная система способностей и боя для Garry's Mod с продвинутыми хитбоксами и удобной системой кейбиндов.

## Структура

```
lotm/
├── lua/
│   ├── autorun/
│   │   └── lotm_init.lua          # Автозагрузка системы
│   └── lotm/
│       ├── core/
│       │   ├── sh_config.lua      # Конфигурация
│       │   ├── sv_hitbox.lua      # Серверная часть хитбоксов
│       │   ├── cl_hitbox.lua      # Клиентская часть хитбоксов
│       │   ├── sv_abilities.lua   # Серверная часть способностей
│       │   ├── cl_abilities.lua   # Клиентская часть способностей
│       │   ├── sv_keybinds.lua    # Серверная часть кейбиндов
│       │   └── cl_keybinds.lua    # Клиентская часть кейбиндов
│       └── ui/
│           └── cl_keybind_menu.lua # UI меню кейбиндов (F4)
└── README.md
```

## Функционал

### 1. Система хитбоксов
- Регистрация динамических хитбоксов
- Привязка к костям модели или мировым координатам
- Автоматическая проверка столкновений
- Множители урона
- Callback функции при попадании
- Debug визуализация

### 2. Система способностей
- Регистрация до 5 способностей на игрока
- Система кулдаунов
- Интеграция с хитбоксами для атак
- Простой API для создания новых способностей

### 3. Система кейбиндов
- Красивое UI меню (F4)
- Настройка клавиш для:
  - 5 слотов способностей
  - Переключения вида от третьего лица
  - Переключения ауры
  - Открытия меню артефактов
- Сохранение настроек в PData
- Сброс к дефолтным значениям

## API

### Регистрация хитбокса

```lua
local hitboxID = LOTM.Hitboxes:Register(ply, {
    id = "fireball_hitbox",
    bone = "ValveBiped.Bip01_R_Hand",
    offset = Vector(10, 0, 0),
    radius = 15,
    damage = 50,
    damageType = DMG_BURN,
    duration = 2,
    callback = function(attacker, victim, hitbox)
        print(attacker:Nick() .. " hit " .. victim:Nick())
    end
})
```

### Регистрация способности

```lua
LOTM.Abilities:Register({
    id = "fireball",
    name = "Fireball",
    description = "Launch a devastating fireball",
    icon = "materials/lotm/abilities/fireball.png",
    cooldown = 8,
    manaCost = 30,
    onUse = function(ply, ability, slot)
        -- Создаем хитбокс для атаки
        local hitboxID = LOTM.Hitboxes:Register(ply, {
            id = "fireball_" .. CurTime(),
            bone = "ValveBiped.Bip01_R_Hand",
            radius = 20,
            damage = 75,
            damageType = DMG_BURN,
            duration = 1.5
        })
        
        -- Визуальные эффекты
        ply:EmitSound("weapons/physcannon/energy_sing_explosion2.wav")
    end
})
```

### Выдача способности игроку

```lua
LOTM.Abilities:GiveToPlayer(ply, "fireball", 1) -- Слот 1
```

## Установка

1. Скопируйте папку `lotm` в `garrysmod/addons/`
2. Перезапустите сервер
3. Система загрузится автоматически
4. Нажмите F4 для настройки кейбиндов

## Кастомизация

Все настройки находятся в `lotm/lua/lotm/core/sh_config.lua`:
- Размеры хитбоксов
- Множители урона
- Дефолтные кейбинды
- Параметры UI
- Debug режим

## Примеры способностей

Смотрите примеры в документации для создания:
- Дальних атак (projectile)
- Ближних атак (melee)
- AOE способностей
- Buff/debuff систем

## Поддержка

Для вопросов и багрепортов создавайте Issues на GitHub.