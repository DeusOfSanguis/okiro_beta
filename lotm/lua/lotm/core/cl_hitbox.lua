-- LOTM Hitbox System - Client
-- Визуализация хитбоксов (debug)

LOTM.Hitboxes = LOTM.Hitboxes or {}
LOTM.ClientHitboxes = LOTM.ClientHitboxes or {}

-- Получение урона для эффектов
net.Receive("LOTM_HitboxDamage", function()
    local attacker = net.ReadEntity()
    local victim = net.ReadEntity()
    local pos = net.ReadVector()
    
    -- Эффект попадания
    local effectdata = EffectData()
    effectdata:SetOrigin(pos)
    effectdata:SetEntity(victim)
    util.Effect("BloodImpact", effectdata)
    
    -- Звук
    sound.Play("physics/flesh/flesh_impact_hard" .. math.random(1, 5) .. ".wav", pos, 75, 100)
end)

-- Debug визуализация
hook.Add("PostDrawTranslucentRenderables", "LOTM_DebugHitboxes", function()
    if not LOTM.Config.Hitbox.DebugMode then return end
    
    -- Здесь будет отрисовка debug сфер для хитбоксов
    -- Требует синхронизации с сервера
end)