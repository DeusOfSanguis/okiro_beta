DEFINE_BASECLASS("weapon_base") -- Наследуемся от стандартного оружия (weapon_base)

-- Основные параметры оружия
SWEP.Category = "FAR CRY" -- Категория в спавн-меню
SWEP.PrintName = "Recurve Bow" -- Отображаемое название
SWEP.Author = "" -- Автор оружия (не указан)
SWEP.Contact = "" -- Контактная информация (не указана)
SWEP.Purpose = "" -- Описание назначения (не указано)
SWEP.Instructions = "" -- Инструкция по использованию (не указана)

-- Модели оружия
SWEP.ViewModelFOV = 54 -- Поле зрения (FOV) для модели от первого лица
SWEP.ViewModelFlip = false -- Не переворачивать модель
SWEP.ViewModel = "" -- Модель лука от первого лица (пустая строка = стандартное поведение)
SWEP.WorldModel = Model("models/weapons/w_farcrybow.mdl") -- Модель лука в мире

SWEP.Spawnable = true -- Разрешает спавн оружия через меню
SWEP.AdminOnly = false -- Не ограничивает использование только для админов

-- Основные параметры стрельбы
SWEP.Primary.ClipSize = -1 -- Нет магазина (лук не использует обоймы)
SWEP.Primary.DefaultClip = 60 -- Количество стрел при спавне
SWEP.Primary.Automatic = true -- Лук можно использовать при зажатой ЛКМ
SWEP.Primary.Ammo = "farcrybow_arrows" -- Тип боеприпасов (настраивается ниже)

SWEP.Secondary.ClipSize = -1 -- Вторичная атака без магазина
SWEP.Secondary.DefaultClip = -1 -- Вторичная атака не имеет патронов
SWEP.Secondary.Automatic = true -- Вторичная атака тоже автоматическая
SWEP.Secondary.Ammo = "none" -- Вторичная атака не использует боеприпасы

SWEP.m_WeaponDeploySpeed = 1 -- Скорость доставания оружия (1 = стандартная)

-- Состояния лука
SWEP.STATE_NONE = 0 -- Лук опущен
SWEP.STATE_NOCKED = 1 -- Стрела вложена, но тетива не натянута
SWEP.STATE_PULLED = 2 -- Тетива натянута, лук готов к выстрелу
SWEP.STATE_RELEASE = 3 -- Стрела выпущена


-- Таблица звуков для анимаций
SWEP.ActivitySound = {}
SWEP.ActivitySound[ACT_VM_PULLBACK] = "Weapon_FarCryBow.Pull" -- Звук натяжения тетивы
SWEP.ActivitySound[ACT_VM_PRIMARYATTACK] = "Weapon_FarCryBow.Single" -- Звук выстрела
SWEP.ActivitySound[ACT_VM_LOWERED_TO_IDLE] = "Weapon_FarCryBow.Nock" -- Звук вложения стрелы
SWEP.ActivitySound[ACT_VM_DRAW] = "Weapon_FarCryBow.Draw" -- Звук поднятия лука
SWEP.ActivitySound[ACT_VM_RELEASE] = "Weapon_FarCryBow.Release" -- Звук отпускания тетивы

-- Таблица длительности анимаций
SWEP.ActivityLength = {}
SWEP.ActivityLength[ACT_VM_PULLBACK] = 0.2 -- Натяжение тетивы занимает 0.2 сек
SWEP.ActivityLength[ACT_VM_PRIMARYATTACK] = 0 -- Выстрел мгновенный
SWEP.ActivityLength[ACT_VM_DRAW] = 1.2 -- Поднятие лука занимает 1.2 сек
SWEP.ActivityLength[ACT_VM_RELEASE] = 0.5 -- Отпускание тетивы 0.5 сек
SWEP.ActivityLength[ACT_VM_LOWERED_TO_IDLE] = 0 -- Вложение стрелы мгновенное
SWEP.ActivityLength[ACT_VM_IDLE_TO_LOWERED] = 1.25 -- Опускание лука занимает 1.25 сек

-- Привязка состояний оружия к HoldType (анимации игрока)
SWEP.HoldTypeTranslate = {}
SWEP.HoldTypeTranslate[SWEP.STATE_NONE] = "normal" -- Лук опущен (обычное положение)
SWEP.HoldTypeTranslate[SWEP.STATE_NOCKED] = "pistol" -- Лук заряжен (анимация держания как у пистолета)
SWEP.HoldTypeTranslate[SWEP.STATE_PULLED] = "pistol" -- Лук натянут (анимация пистолета)
SWEP.HoldTypeTranslate[SWEP.STATE_RELEASE] = "grenade" -- Лук выпускает стрелу (анимация броска гранаты)

-- Добавляем новый тип боеприпасов "farcrybow_arrows"
game.AddAmmoType {
	name = "farcrybow_arrows",
	tracer = TRACER_NONE -- У стрел нет светящегося следа
}

-- Перевод названия патронов в интерфейсе
if CLIENT then
	language.Add("farcrybow_arrows_ammo", "Arrows") -- В HUD будет написано "Arrows"
end

-- Добавление кастомных звуков
sound.Add {
	channel = CHAN_AUTO,
	volume = 1,
	level = 60,
	name = "Weapon_FarCryBow.Draw",
	sound = { "weapons/farcrybow/nock_1.wav" }
}

sound.Add {
	channel = CHAN_AUTO,
	volume = 1,
	level = 10,
	name = "Weapon_FarCryBow.Nock",
	sound = { "weapons/farcrybow/nock_1.wav" }
}

sound.Add {
	channel = CHAN_AUTO,
	volume = 1,
	level = 50,
	name = "Weapon_FarCryBow.Pull",
	sound = { "weapons/farcrybow/fcbow_pull1.wav", "weapons/farcrybow/fcbow_pull2.wav", "weapons/farcrybow/fcbow_pull3.wav" }
}

sound.Add {
	channel = CHAN_AUTO,
	volume = 1,
	level = 50,
	name = "Weapon_FarCryBow.Release",
	sound = { "weapons/farcrybow/fcbow_release.wav" }
}

sound.Add {
	channel = CHAN_AUTO,
	volume = 1,
	level = 60,
	name = "Weapon_FarCryBow.Single",
	sound = { "weapons/farcrybow/fcbow_shoot1.wav", "weapons/farcrybow/fcbow_shoot2.wav", "weapons/farcrybow/fcbow_shoot3.wav" }
}

sound.Add {
	channel = CHAN_AUTO,
	volume = 1,
	level = 60,
	name = "Weapon_FarCryBow.ZoomIn",
	sound = "weapons/farcrybow/fcbow_zoomin.wav"
}

sound.Add {
	channel = CHAN_AUTO,
	volume = 1,
	level = 60,
	name = "Weapon_FarCryBow.ZoomOut",
	sound = "weapons/farcrybow/fcbow_zoomout.wav"
}

-- Функция настройки сетевых переменных (например, WepState)
	function SWEP:SetupDataTables()
		self:NetworkVar("Int", 0, "WepState") -- Создаём переменную `WepState`, которую можно передавать между клиентом и сервером
	end

-- Блокируем стандартную атаку
function SWEP:PrimaryAttack()
	return
end

-- Блокируем перезарядку
function SWEP:Reload()
	return
end

-- Воспроизведение звуков с предсказанием (чтобы не дублировались)
function SWEP:EmitSoundX(...)
	if (game.SinglePlayer() and SERVER) or (CLIENT and IsFirstTimePredicted()) then
		return self:EmitSound(...)
	end
end

-- Запуск анимации с привязанным звуком и задержкой
function SWEP:PlayActivity(act)
	self:SendWeaponAnim(act) -- Запускаем анимацию

	local snd = self.ActivitySound[act] -- Получаем звук для анимации
	if snd then
		self:EmitSoundX(snd) -- Воспроизводим звук
	end

	local t = self.ActivityLength[act] -- Получаем длительность анимации
	if t then
		self:SetNextPrimaryFire(CurTime() + t) -- Блокируем стрельбу на это время
	end
end

-- Получение количества патронов у игрока
function SWEP:Ammo1()
	return self.Owner:GetAmmoCount(self:GetPrimaryAmmoType())
end

local sin, cos = math.sin, math.cos -- Оптимизируем доступ к тригонометрическим функциям (ускоряет код)

function SWEP:Think()
	local CT = CurTime() -- Получаем текущее игровое время
	local nextFire = self:GetNextPrimaryFire() -- Время, когда можно снова стрелять
	local holdType = self.HoldTypeTranslate[self.dt.WepState] -- Получаем нужный HoldType
	if holdType ~= self:GetHoldType() then
		self:SetHoldType(holdType) -- Устанавливаем новый HoldType, если он изменился
	end

	if nextFire >= CT then -- Если ещё не пришло время следующего выстрела
		return -- Прерываем выполнение функции
	end


	local noClip = self.Owner:GetMoveType() == MOVETYPE_NOCLIP -- Проверяем, в режиме ли noclip
	local onGround = self.Owner:IsOnGround() -- Проверяем, стоит ли игрок на земле


	if self.dt.WepState == self.STATE_PULLED then -- Если игрок держит натянутый лук
		if self.Owner:KeyDown(IN_RELOAD) or self.Owner:KeyDown(IN_SPEED) or self:Ammo1() <= 0 then
			self.dt.WepState = self.STATE_NOCKED -- Сбрасываем натяжение (стрела остаётся заряженной)
			self:PlayActivity(ACT_VM_RELEASE) -- Запускаем анимацию отпускания тетивы
		elseif not self.Owner:KeyDown(IN_ATTACK) then -- Если игрок отпустил ЛКМ
			self.dt.WepState = self.STATE_RELEASE -- Стреляем
			self:PlayActivity(ACT_VM_PRIMARYATTACK) -- Анимация выстрела


			if SERVER then
				local ang = self.Owner:GetAimVector():Angle() -- Угол взгляда игрока

				-- Определяем точку появления стрелы
				local pos = self.Owner:EyePos() + ang:Up() * -7 + ang:Forward() * 30

				-- Вычисляем силу выстрела (чем дольше натянута тетива, тем быстрее стрела)
				local charge = self:GetNextSecondaryFire()
				charge = math.Clamp(CT - charge, 0, 1) -- Ограничиваем от 0 до 1

				-- Создаём стрелу
				local arrow = ents.Create("farcrybow_arrow")
				arrow:SetOwner(self.Owner) -- Назначаем владельца стрелы
				arrow:SetPos(pos) -- Устанавливаем позицию
				arrow:SetAngles(ang) -- Направление полёта
				arrow:Spawn()
				arrow:Activate()
				arrow:SetVelocity(ang:Forward() * 3000 * charge) -- Устанавливаем скорость полёта
				arrow.Weapon = self
			end

		end
	elseif self.dt.WepState == self.STATE_RELEASE then
		if self.Owner:KeyDown(IN_ATTACK) and self:Ammo1() > 0 then
			self.dt.WepState = self.STATE_NOCKED -- Заряжаем новую стрелу
			self:PlayActivity(ACT_VM_LOWERED_TO_IDLE)
		else
			self.dt.WepState = self.STATE_NONE -- Лук опускается
			self:PlayActivity(ACT_VM_IDLE_TO_LOWERED)
		end

	elseif self.dt.WepState == self.STATE_NOCKED then -- Если стрела вложена, но тетива не натянута
		if self.Owner:KeyDown(IN_ATTACK) -- Игрок нажал ЛКМ
		   and not (not onGround and not noClip) -- Проверяем, что он не летит в воздухе (без noclip)
		   and not self.Owner:KeyDown(IN_RELOAD) -- Не нажата перезарядка (чтобы не сбросить натяжение)
		   and not self.Owner:KeyDown(IN_SPEED) then -- Не нажата клавиша бега
		   
			self.dt.WepState = self.STATE_PULLED -- Переключаемся в состояние натяжения
			self:PlayActivity(ACT_VM_PULLBACK) -- Запускаем анимацию натягивания тетивы
			self:SetNextSecondaryFire(CT) -- Запоминаем время начала натяжения
		end

	elseif self.dt.WepState == self.STATE_NONE then -- Если оружие опущено
		if (self.Owner:KeyDown(IN_RELOAD) or self.Owner:KeyPressed(IN_ATTACK)) -- Игрок нажал R (перезарядка) или ЛКМ
		   and self:Ammo1() > 0 then -- У игрока есть стрелы
		   
			self.dt.WepState = self.STATE_NOCKED -- Переход в режим заряженной стрелы
			self:PlayActivity(ACT_VM_LOWERED_TO_IDLE) -- Анимация поднятия лука
		end

	elseif self.dt.WepState == BOW_HOLSTER then -- Оружие убирается
		if SERVER then -- Только на сервере
			if IsValid(self.nextWeapon) then -- Проверяем, есть ли следующее оружие
				self.Owner:SelectWeapon(self.nextWeapon:GetClass()) -- Меняем оружие
				self.nextWeapon = nil -- Сбрасываем переменную
			end
		end
	end
end

function SWEP:Deploy()
	if CLIENT then
		self.AimMult = 0 -- Убираем эффект прицеливания
		self.AimMult2 = 0
	end

	self.dt.WepState = self.STATE_NONE -- Лук в опущенном состоянии
	self.nextWeapon = nil -- Сбрасываем переменную для смены оружия

	self:PlayActivity(ACT_VM_DRAW) -- Запускаем анимацию поднятия лука
	return true
end

