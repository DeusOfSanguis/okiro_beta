EFFECT.Mat = Material("effects/spark")

function EFFECT:Init(data)
    local pos = data:GetOrigin()
    
    -- Create emitter
    local emitter = ParticleEmitter(pos)
    
    -- Create sparks
    for i = 1, 30 do
        local particle = emitter:Add("effects/spark", pos)
        
        if particle then
            -- Randomize particle velocity
            local vel = VectorRand() * 200
            vel.z = vel.z + 50
            
            particle:SetVelocity(vel)
            particle:SetDieTime(0.5)
            particle:SetStartAlpha(255)
            particle:SetEndAlpha(0)
            particle:SetStartSize(5)
            particle:SetEndSize(0)
            particle:SetRoll(math.Rand(0, 360))
            particle:SetRollDelta(math.Rand(-10, 10))
            particle:SetColor(255, 255, 255)
            particle:SetGravity(Vector(0, 0, -600))
            particle:SetCollide(true)
            particle:SetBounce(0.3)
        end
    end
    
    emitter:Finish()
    
    -- Add light effect
    local light = DynamicLight(0)
    if light then
        light.Pos = pos
        light.r = 255
        light.g = 200
        light.b = 100
        light.Brightness = 3
        light.Size = 100
        light.Decay = 1000
        light.DieTime = CurTime() + 0.1
    end
end

function EFFECT:Think()
    return false
end

function EFFECT:Render()
end

effects.Register("parry_sparks", "ParrySparks")