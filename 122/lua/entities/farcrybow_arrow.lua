AddCSLuaFile() -- Отправляет этот файл на клиент, если он используется в режиме сервера

ENT.Type = "anim" -- Тип сущности: "anim" означает, что это анимируемый объект
ENT.Spawnable = false -- Отключает возможность спауна сущности через меню (она создаётся скриптом)

ENT.Model = "models/fc3bowa.mdl" -- Устанавливаем модель стрелы

-- Определяем границы хитбокса стрелы (небольшая область вокруг неё)
local ARROW_MINS = Vector(-0.25, -0.25, 0.25)
local ARROW_MAXS = Vector(0.25, 0.25, 0.25)

function ENT:Initialize()
    if SERVER then -- Убедимся, что выполняется только на сервере

        -- Создаём эффект "хвоста" за стрелой (белый след)
        util.SpriteTrail(self, 0, Color(255,255,255,200), false, 0, 0.7, 0.8, 0/(0.7+0)*0.5, "models/effects/vol_light001.vmt")

        self:SetModel(self.Model) -- Устанавливаем модель стрелы

        self:PhysicsInit(SOLID_VPHYSICS) -- Включаем физику
        self:SetMoveType(MOVETYPE_FLYGRAVITY) -- Стрела будет лететь с гравитацией
        self:SetSolid(SOLID_BBOX) -- Используем небольшую коллизионную область (бокс)
        self:DrawShadow(true) -- Включаем тени

        -- Устанавливаем границы коллизии стрелы
        self:SetCollisionBounds(ARROW_MINS, ARROW_MAXS)
        self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE) -- Позволяет стрелке сталкиваться с объектами

        -- Получаем физический объект стрелы
        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            phys:Wake() -- "Пробуждаем" физику, чтобы стрела начала движение
        end
    end
end

function ENT:Think()
    if SERVER then
        -- Если стрела всё ещё летит, корректируем её угол наклона
        if self:GetMoveType() == MOVETYPE_FLYGRAVITY then
            self:SetAngles(self:GetVelocity():Angle()) -- Угол зависит от скорости, делает полёт реалистичным
        end
    end
end

function ENT:Use(activator, caller)
    return false -- Запрещаем использование стрелы (например, поднятие)
end

function ENT:OnRemove()
    return false -- Ничего не делаем при удалении стрелы
end

-- Звуки попаданий в разные поверхности
local StickSound = {
    "weapons/farcrybow/impact_arrow_stick_1.wav",
    "weapons/farcrybow/impact_arrow_stick_2.wav",
    "weapons/farcrybow/impact_arrow_stick_3.wav"
}

local FleshSound = {
    "weapons/farcrybow/impact_arrow_flesh_1.wav",
    "weapons/farcrybow/impact_arrow_flesh_2.wav",
    "weapons/farcrybow/impact_arrow_flesh_3.wav",
    "weapons/farcrybow/impact_arrow_flesh_4.wav"
}

function ENT:Touch(ent) -- Функция вызывается, когда стрела касается объекта
    if not ent:IsTrigger() then
        ply = self:GetOwner()
        local speed = self:GetVelocity():Length() -- Получаем скорость стрелы
        local pos = ply:GetShootPos()
        local aim = ply:GetAimVector()
        local vector = 175
        local radius = 15
        local hitEntities = {}
        
        local angleOffset = 18
                
        for i = -angleOffset, angleOffset, 5 do
            local rotatedAim = aim:Angle()
            rotatedAim:RotateAroundAxis(rotatedAim:Up(), i)
            local direction = rotatedAim:Forward()
            
            local slash = {
                start = pos,
                endpos = pos + (direction * vector),
                filter = function(ent)
                    if ent:GetClass() == "mad_crystal" or ent == ply then
                        return false
                    end
                    return true
                end,
                mins = Vector(-radius, -radius, 0),
                maxs = Vector(radius, radius, 0)
            }
            
        end
        local tr = util.TraceHull(slash)

        local entityClass = tr.Entity:GetClass()
        local isNPC = string.StartWith(entityClass, "mad_")
        -- Если стрела попала в игрока или NPC
        if (tr.Entity:IsPlayer() or isNPC or tr.Entity:IsNextBot()) then
            if speed >= 150 then -- Проверяем, достаточно ли скорости для нанесения урона
                local baseDamage = 20 -- Базовый урон
                local additionalDamage = speed * 0.1 -- Дополнительный урон от скорости
                local damage = baseDamage + additionalDamage -- Общий урон
                
                -- Поиск ближайшего хитбокса (например, голова, грудь)
                local closestHitbox = 0
                local closestDistance = 9999999

                for i = 0, ent:GetHitBoxGroupCount() - 1 do
                    for j = 0, ent:GetHitBoxCount(i) - 1 do
                        local bone = ent:GetHitBoxBone(j, i) -- Получаем индекс кости
                        local hitboxPos, hitboxAng = ent:GetBonePosition(bone) -- Получаем позицию хитбокса

                        local hitboxDistance = self:GetPos():Distance(hitboxPos) -- Считаем расстояние до него

                        if hitboxDistance < closestDistance then
                            closestDistance = hitboxDistance
                            closestHitbox = bone -- Запоминаем ближайший хитбокс
                        end
                    end
                end

                -- Создаём "пулю", которая наносит урон игроку в точку попадания
                local bullet = {}
                bullet.Attacker = self.Owner
                bullet.Damage = damage
                bullet.Src = self:GetPos() -- Исходная позиция: где стрела находится сейчас
                bullet.Dir = (ent:GetBonePosition(closestHitbox) - self:GetPos()):GetNormalized() -- Направление к хитбоксу
                bullet.Spread = Vector(0, 0, 0)
                bullet.Num = 1
                bullet.Force = 1
                bullet.Tracer = 0
                bullet.TracerName = ""
                print(damage)
                self:FireBullets(bullet) -- Выпускаем "пулю"

                -- Проигрываем звук попадания в тело
                ent:EmitSound("weapons/farcrybow/impact_arrow_flesh_" .. math.random(1, 4) .. ".wav")

                self:Remove() -- Удаляем стрелу после попадания
            end
            return false
        end

        -- Если стрела попала в мир (стену, землю и т. д.)
        if ent:IsWorld() then
            self.notstuck = false
            self:SetMoveType(MOVETYPE_NONE) -- Останавливаем стрелу
            self:PhysicsInit(SOLID_NONE) -- Отключаем физику
            self:EmitSound("weapons/farcrybow/impact_arrow_stick_" .. math.random(1, 3) .. ".wav") -- Звук удара

            self:SetPos(self:GetPos() + self:GetForward() * 0) -- Зафиксировать стрелу в месте удара
        else
            if ent:IsValid() then -- Если попали в объект (ящик, дверь и т. д.)
                self.notstuck = false
                self:SetMoveType(MOVETYPE_NONE) -- Останавливаем стрелу
                self:PhysicsInit(SOLID_NONE) -- Отключаем физику
                self:SetParent(ent) -- "Прикрепляем" стрелу к объекту

                local damageprop = speed * 0.013 -- Наносимый урон пропорционален скорости

                -- Создаём "пулю", чтобы нанести урон объекту
                local bullet = {}
                bullet.Attacker = self.Owner
                bullet.Damage = damageprop
                bullet.Src = self:GetPos()
                bullet.Dir = self:GetForward()
                bullet.Spread = Vector(0, 0, 0)
                bullet.Num = 1
                bullet.Force = 5
                bullet.Tracer = 0
                bullet.TracerName = ""

                self:FireBullets(bullet) -- Выпускаем "пулю"

                self.removearrow = CurTime() + 22 -- Удаляем стрелу через 22 секунды
                self:EmitSound("Weapon_Arrow.ImpactConcrete") -- Звук попадания в объект
                self:SetPos(self:GetPos() + self:GetForward() * 2) -- Немного корректируем позицию стрелы
            end
        end
    end
end
