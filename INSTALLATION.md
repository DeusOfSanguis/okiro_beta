# Руководство по установке Okiro Beta

## 📋 Требования

### Минимальные требования сервера
- **RAM**: 4GB (рекомендуется 8GB+)
- **CPU**: 2 ядра (рекомендуется 4+)
- **Диск**: 10GB свободного места
- **OS**: Linux (Ubuntu 20.04+) или Windows Server

### Программное обеспечение
- Garry's Mod Dedicated Server
- MySQL 5.7+ или MariaDB 10.3+
- Git (для клонирования)

## 🚀 Установка

### Шаг 1: Подготовка сервера

```bash
# Создайте директорию для сервера
mkdir -p ~/gmod-server
cd ~/gmod-server

# Установите SteamCMD (Linux)
wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
tar -xvzf steamcmd_linux.tar.gz

# Установите Garry's Mod сервер
./steamcmd.sh +login anonymous +force_install_dir ./gmod +app_update 4020 validate +quit
```

### Шаг 2: Клонирование репозитория

```bash
# Перейдите в папку аддонов
cd ~/gmod-server/gmod/garrysmod/addons

# Клонируйте репозиторий
git clone https://github.com/DeusOfSanguis/okiro_beta.git
```

### Шаг 3: Настройка MySQL

```sql
-- Создайте базу данных
CREATE DATABASE okiro_beta CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Создайте пользователя
CREATE USER 'okiro_user'@'localhost' IDENTIFIED BY 'your_secure_password';

-- Выдайте права
GRANT ALL PRIVILEGES ON okiro_beta.* TO 'okiro_user'@'localhost';
FLUSH PRIVILEGES;
```

### Шаг 4: Конфигурация

#### 4.1 Настройка MySQL подключения

Создайте файл `garrysmod/data/okiro_mysql.txt`:

```json
{
    "host": "localhost",
    "port": 3306,
    "database": "okiro_beta",
    "username": "okiro_user",
    "password": "your_secure_password"
}
```

#### 4.2 Настройка сервера

Отредактируйте `garrysmod/cfg/server.cfg`:

```cfg
// Основные настройки
hostname "Okiro Beta - Solo Leveling RP"
sv_password ""
sv_region 3
sv_lan 0

// Слоты
maxplayers 32

// Загрузка
sv_loadingurl "https://your-loading-screen.com"

// Workshop Collection
host_workshop_collection "YOUR_COLLECTION_ID"

// Gamemode
gamemode "darkrp"

// Логирование
log on
sv_logbans 1
sv_logecho 1
sv_logfile 1
sv_log_onefile 0
```

### Шаг 5: Права администратора

Добавьте себя в супер-админы SAM:

1. Запустите сервер первый раз
2. Зайдите на сервер
3. В консоли сервера выполните:

```
sam adduser "STEAM_0:X:XXXXXXXX" superadmin
```

### Шаг 6: Запуск сервера

```bash
# Linux
cd ~/gmod-server/gmod
./srcds_run -game garrysmod +gamemode darkrp +map rp_downtown_v4c_v2 +maxplayers 32 -port 27015

# Windows
srcds.exe -console -game garrysmod +gamemode darkrp +map rp_downtown_v4c_v2 +maxplayers 32 -port 27015
```

## 🔧 Настройка модулей

### Okiro Main System

Файл: `okiro_beta/_okiro_main_system/lua/autorun/server/okiro_config.lua`

```lua
OKIRO = OKIRO or {}
OKIRO.Config = {
    -- Основные настройки
    StartLevel = 1,
    MaxLevel = 100,
    ExpMultiplier = 1.0,
    
    -- База данных
    UseMySQL = true,
    MySQLConfig = "okiro_mysql.txt",
    
    -- Экономика
    StartMoney = 5000,
    MoneyPerLevel = 1000,
}
```

### Система квестов

Файл: `okiro_beta/mc_quests/lua/autorun/server/mc_quests_config.lua`

### Whitelist

Файл: `okiro_beta/whitelist/lua/autorun/server/whitelist_config.lua`

## 📦 Workshop Collection

1. Создайте коллекцию в Steam Workshop
2. Добавьте все необходимые модели и материалы
3. Скопируйте ID коллекции
4. Добавьте в `server.cfg`:

```cfg
host_workshop_collection "YOUR_COLLECTION_ID"
```

## 🔍 Проверка установки

### Проверьте консоль на ошибки:

```
[Okiro] Main System loaded successfully
[Okiro] Level System initialized
[Okiro] Mob System loaded
[SAM] Database connected
[MC Quests] Loaded X quests
```

### Тестовые команды:

```
// Проверка Okiro
okiro_version
okiro_debug

// Проверка SAM
sam version
sam users

// Проверка MySQL
sql_test
```

## ⚠️ Частые проблемы

### Проблема: MySQL не подключается

**Решение**:
1. Проверьте данные в `okiro_mysql.txt`
2. Убедитесь, что MySQL сервер запущен
3. Проверьте права пользователя

### Проблема: Белый экран при входе

**Решение**:
1. Проверьте загрузку Workshop контента
2. Убедитесь что URL загрузочного экрана работает
3. Проверьте консоль клиента на ошибки

### Проблема: Игроки не получают опыт

**Решение**:
1. Проверьте работу `_okiro_main_level`
2. Проверьте логи сервера
3. Проверьте права в базе данных

## 🔄 Обновление

```bash
cd ~/gmod-server/gmod/garrysmod/addons/okiro_beta
git pull origin main

# Перезапустите сервер
```

## 📞 Поддержка

При проблемах создайте Issue на GitHub с:
- Описанием проблемы
- Логами консоли
- Версией сервера
- Списком установленных аддонов
