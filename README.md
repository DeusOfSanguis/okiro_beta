# Okiro Beta - Solo Leveling GMod Server

![Garry's Mod](https://img.shields.io/badge/Garry's%20Mod-Server-blue)
![Lua](https://img.shields.io/badge/Language-Lua-blue)
![Status](https://img.shields.io/badge/Status-Beta-yellow)

## 📖 Описание

Okiro Beta - это кастомный сервер Garry's Mod, вдохновленный аниме/манхвой "Solo Leveling". Сервер включает уникальную систему прокачки, данжи с мобами, квесты и множество других механик.

## ✨ Основные возможности

### 🎮 Игровые системы
- **Система уровней** - прокачка персонажа как в Solo Leveling
- **Данжи и мобы** - PvE контент с боссами
- **Квесты** - система заданий от NPC
- **Система отрядов** - кооперативная игра
- **Тренировки** - улучшение навыков
- **Реролл система** - возможность изменить персонажа

### 🎨 Интерфейс
- Кастомный HUD в стиле Solo Leveling
- Уникальный экран смерти
- Система выбора оружия
- Таблица игроков (Scoreboard)
- ESC меню с настройками

### 🛠️ Администрирование
- SAM (Server Administration Manager)
- Система предупреждений
- Whitelist контроль
- Улучшенные админ инструменты

## 📁 Структура проекта

```
okiro_beta/
├── okiro_core/          # Ядро системы Okiro
│   ├── _okiro_main_system/
│   ├── _okiro_main_level/
│   ├── _okiro_sololeveling_mob/
│   └── ...
├── okiro_ui/            # UI модули
│   ├── _okiro_hud/
│   ├── _okiro_tab/
│   └── ...
├── okiro_gameplay/      # Игровые механики
│   ├── _okiro_weapon_selector/
│   ├── _okiro_revive/
│   └── ...
├── admin/               # Админ системы
│   ├── sam-156/
│   ├── awarn3/
│   └── ...
├── third_party/         # Сторонние аддоны
│   ├── mc_quests/
│   ├── chatbox/
│   └── ...
└── workshop/            # Workshop аддоны
    ├── zworkshop_pac3/
    └── ...
```

## 🚀 Установка

1. Клонируйте репозиторий:
```bash
git clone https://github.com/DeusOfSanguis/okiro_beta.git
```

2. Скопируйте содержимое в папку `garrysmod/addons/`

3. Перезапустите сервер

Подробная инструкция: [INSTALLATION.md](INSTALLATION.md)

## 📝 Требования

- Garry's Mod (актуальная версия)
- MySQL база данных (для некоторых систем)
- Workshop Collection (контент модели и материалы)

## 🤝 Разработка

Структура кастомных модулей:
```lua
addon_name/
├── lua/
│   ├── autorun/          # Автозагрузка
│   │   ├── server/       # Серверные скрипты
│   │   ├── client/       # Клиентские скрипты
│   │   └── shared/       # Общие скрипты
│   ├── entities/         # Энтити
│   ├── weapons/          # Оружие
│   └── effects/          # Эффекты
└── addon.json            # Манифест аддона
```

## 📄 Документация

- [STRUCTURE.md](STRUCTURE.md) - Детальное описание структуры проекта
- [INSTALLATION.md](INSTALLATION.md) - Подробная инструкция по установке

## 📄 Лицензия

Приватный проект. Все права защищены.

## 👥 Авторы

- **DeusOfSanguis** - Основной разработчик

## 📞 Контакты

Для вопросов и предложений создавайте Issues в этом репозитории.
