AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

-- Définition des équipes à ignorer
local TEAM_TABLE = {
    ["Culte"] = true,
}

-- Initialisation de l'entité
function ENT:Initialize()
    self:SetModel("models/hunter/blocks/cube2x2x2.mdl") -- Modèle serveur (invisible)
    self:SetModelScale(1, 0) -- Agrandir le cube si nécessaire
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetHealth(self.MaxHealth)

    self.Origin = self:GetPos() -- Point d'origine pour la patrouille
    self.NextSpeAttack = CurTime() + self.cooldown_atkspe

    self:SetNWInt("CurrentHealth", self:Health())
    self:SetNWInt("maxHealth", self:Health())

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
        phys:SetMass(100) -- Augmenter la masse pour plus de stabilité
        phys:EnableMotion(true)
        phys:EnableGravity(true)
        phys:EnableDrag(false)
        phys:SetAngleVelocity(Vector(0, 0, 0)) -- Empêcher la rotation initiale
    end

    -- self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)

    -- Rendre le modèle serveur invisible
    self:SetNoDraw(true)

    -- Définir la variable réseau pour AttackRange
    self:SetNWInt("AttackRange", self.AttackRange)
    self:SetNWInt("SpeAtk", false)

    self.CurrentTarget = nil
    self.Patrolling = true
    self.IsMoving = false
    self.Death = false
    self.NoMove = false

    timer.Create("NPC_Patrol_" .. self:EntIndex(), 2, 0, function()
        if not IsValid(self) then return end

        local targetAngle = self:GetAngles()
        targetAngle.p = 0 -- Empêche de viser vers le haut ou le bas
        self:SetAngles(targetAngle)

        if self.Patrolling == false then return end
        if not self.IsMoving then
            timer.Simple(1.8, function()
                self.IsMoving = true
            end)
            timer.Simple(2, function()
                if IsValid(self) and self.Patrolling then
                    self:MoveToRandomPoint()
                    timer.Simple(0.5, function()
                        self.IsMoving = false
                    end)
                end
            end)
        end
    end)
end

-- Fonction de détection des entités de la même classe poursuivant le même joueur
function ENT:HandleEntityProximity()
    if not IsValid(self.CurrentTarget) then return end

    local entities = ents.FindInSphere(self:GetPos(), 100) -- Rayon de proximité pour éviter le "packing"
    for _, ent in ipairs(entities) do
        if ent ~= self and ent:GetClass() == self:GetClass() and ent.CurrentTarget == self.CurrentTarget then
            -- Une autre entité de la même classe poursuit déjà ce joueur
            local direction = (self:GetPos() - ent:GetPos()):GetNormalized()
            local newPos = self:GetPos() + direction * 100 -- Se déplacer dans la direction opposée

            self:MoveTo(newPos)
            break
        end
    end
end

-- Fonction de démarrage de la patrouille
function ENT:StartPatrol()
    self:MoveToRandomPoint()
end

-- Fonction pour déplacer le NPC vers un point aléatoire dans le rayon de patrouille
function ENT:MoveToRandomPoint()
    if not IsValid(self) then return end

    if self.Death == true then return end

    local angle = math.random(0, 360)
    local distance = math.random(100, self.PatrolRadius)
    local targetPos = self.Origin + Vector(math.cos(math.rad(angle)) * distance, math.sin(math.rad(angle)) * distance, 0)

    self:MoveTo(targetPos)

    local targetAngle = (targetPos - self:GetPos()):Angle()
    targetAngle.p = 0 -- Empêche de viser vers le haut ou le bas
    self:SetAngles(targetAngle)
end

-- Fonction pour déplacer le NPC vers une position spécifique en utilisant SetVelocity
function ENT:MoveTo(pos)
    if not IsValid(self) then return end

    if self.Death == true then return end

    -- Calcul de la direction et de la vitesse horizontale
    local direction = (pos - self:GetPos())
    direction.z = 0 -- Garder le mouvement horizontal
    direction = direction:GetNormalized()

    local velocity = direction * self.Speed

    -- Détection du sol (rayon vers le bas pour déterminer la position du sol)
    local trace = util.TraceLine({
        start = self:GetPos(),
        endpos = self:GetPos() - Vector(0, 0, 100),  -- Augmenter la distance pour capter le sol même s'il y a une pente
        filter = self
    })

    -- Si le sol est détecté
    if trace.Hit then
        -- Récupérer l'angle de la surface du sol (normal du sol)
        local groundNormal = trace.HitNormal
        local angle = math.deg(groundNormal:Angle().pitch)

        -- Calcul de la nouvelle position en fonction de la pente
        local newPos = self:GetPos()

        -- Ajustement de la hauteur en fonction de la pente, mais éviter une descente continue
        if angle > 5 or angle < -5 then
            -- Si la pente est importante, on ajuste la position pour suivre la pente
            newPos.z = trace.HitPos.z + 10 -- Offset léger pour suivre la pente
        elseif angle >= -5 and angle <= 5 then
            -- Si terrain plat ou légèrement incliné, on ajuste doucement la position
            newPos.z = trace.HitPos.z
        end

        -- Appliquer la position ajustée pour éviter de flotter
        if newPos.z > self:GetPos().z then
            self:SetPos(newPos)
        end
    else
        -- Si aucun sol n'est détecté et l'entité flotte, on applique une légère correction pour la faire tomber doucement
        local newPos = self:GetPos()
        if newPos.z > self.Origin.z then
            -- Appliquer une chute douce pour éviter le flottement
            newPos.z = newPos.z - 5  -- Appliquer une chute douce
            self:SetPos(newPos)
        end
    end

    -- Vérification sous l'entité pour éviter de traverser le sol ou les displacements
    local traceUnder = util.TraceLine({
        start = self:GetPos() + Vector(0, 0, 5),  -- Un peu au-dessus du sol pour détecter les obstacles
        endpos = self:GetPos() - Vector(0, 0, 20),  -- Trajectoire vers le bas
        filter = self
    })

    if traceUnder.Hit then
        -- Si un obstacle est détecté sous l'entité, on empêche de descendre sous le sol
        local newPos = self:GetPos()
        newPos.z = traceUnder.HitPos.z + 10  -- Ajuster la position pour ne pas passer sous le sol
        self:SetPos(newPos)
    end

    -- Appliquer la vélocité horizontale pour déplacer l'entité
    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:SetVelocity(velocity)
        phys:SetAngleVelocity(Vector(0, 0, 0)) -- Empêcher toute rotation
    end

    timer.Simple(0.5, function()
        self.IsMoving = false
    end)
end

function ENT:IsPlayerAlreadyTargeted(player)
    local entities = ents.FindByClass(self:GetClass())
    for _, ent in ipairs(entities) do
        if ent ~= self and IsValid(ent.CurrentTarget) and ent.CurrentTarget == player then
            return true, ent
        end
    end
    return false, nil
end

-- Fonction de détection des joueurs et gestion des attaques
function ENT:Think()
    if not IsValid(self) then return end
    if self.Death == true then return end

    if self.NoMove then
        self.Patrolling = false
        self.CurrentTarget = nil
        self:SendState() -- Met à jour les clients sur l'état
        self:SetNWBool("IsMoving", false) -- Arrête le mouvement pendant une attaque spéciale
        self:NextThink(CurTime())
        return true
    end

    local entities = ents.FindInSphere(self:GetPos(), self.PatrolRadius)
    local nearestPlayer = nil
    local nearestDistance = math.huge

    for _, ent in ipairs(entities) do
        if ent:IsPlayer() and ent:Alive() and not TEAM_TABLE[team.GetName(ent:Team())] then
            local alreadyTargeted, otherEntity = self:IsPlayerAlreadyTargeted(ent)

            if not alreadyTargeted then
                local distance = self:GetPos():Distance(ent:GetPos())
                if distance < nearestDistance then
                    nearestDistance = distance
                    nearestPlayer = ent
                end
            end
        end
    end

    if nearestPlayer and nearestDistance <= self.AttackRange then
        self.Patrolling = false
        self.CurrentTarget = nearestPlayer

        if self.NextSpeAttack and self.NextSpeAttack <= CurTime() then
            self:OnSpecialAttack(nearestPlayer)
        else
            self:Attack(nearestPlayer)
        end
        
        -- Calcul de l'angle vers le joueur
        local targetAngle = (nearestPlayer:GetPos() - self:GetPos()):Angle()
        targetAngle.p = 0 -- Empêche de viser vers le haut ou le bas
        self:SetAngles(targetAngle)
    
        self.IsMoving = false
        self:SetNWBool("IsMoving", false) -- Pas de course pendant l'attaque
    elseif nearestPlayer then
        self.Patrolling = false
        self.CurrentTarget = nearestPlayer
        self:Chase(nearestPlayer)
        
        -- Calcul de l'angle vers le joueur
        local targetAngle = (nearestPlayer:GetPos() - self:GetPos()):Angle()
        targetAngle.p = 0 -- Empêche de viser vers le haut ou le bas
        self:SetAngles(targetAngle)

        self.IsMoving = true -- Le NPC est en train de se déplacer vers le joueur
        self:SetNWBool("IsMoving", true)
    else
        if not self.Patrolling then
            self.Patrolling = true
            self.CurrentTarget = nil
            self:MoveTo(self.Origin) -- Retourner à l'origine

            -- Retourner à l'origine
            local targetAngle = (self.Origin - self:GetPos()):Angle()
            targetAngle.p = 0 -- Empêche de viser vers le haut ou le bas
            self:SetAngles(targetAngle)
        end

        -- Si le NPC atteint son point d'origine
        if self:GetPos():Distance(self.Origin) <= 50 then
            if self:Health() < self.MaxHealth then
                self:SetHealth(self.MaxHealth)
            end
        end
    end

    self:SendState()

    -- Empêche la rotation non désirée
    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:SetAngleVelocity(Vector(0, 0, 0))
    end

    self:NextThink(CurTime())
    return true
end

ENT.playerDamage = {}

-- Gestion des dégâts reçus
function ENT:OnTakeDamage(dmginfo)
    if self.Death == true then return end
    
    if dmginfo:GetAttacker():IsPlayer() and dmginfo:GetAttacker():Alive() and TEAM_TABLE[team.GetName(dmginfo:GetAttacker():Team())] then
    return 0 end

    local attacker = dmginfo:GetAttacker()

    -- Vérifier si l'attaquant est un joueur
    if (attacker:IsPlayer() and attacker:Alive()) or attacker:GetClass() == "ent_config_launch" then
        -- Si l'entité a agro un joueur (l'entité a une cible), tout le monde peut attaquer
        if self.CurrentTarget then
            -- Si l'entité a une cible, tous les joueurs peuvent infliger des dégâts
        else
            -- Si l'entité n'a pas agro, seul l'attaquant original peut infliger des dégâts
            if self.CurrentTarget ~= attacker then
                return 0
            end
        end
    end

    -- Si le joueur est valide, ajouter les dégâts à la table des dégâts pour cet NPC
    if IsValid(attacker) and attacker:IsPlayer() then
        -- Ajoutez les dégâts infligés à la table du joueur pour cet NPC
        self.playerDamage[attacker] = (self.playerDamage[attacker] or 0) + dmginfo:GetDamage()
    elseif attacker:GetClass() == "ent_config_launch" then
        self.playerDamage[attacker:GetOwner()] = (self.playerDamage[attacker:GetOwner()] or 0) + dmginfo:GetDamage()
    end

    self:SetHealth(self:Health() - dmginfo:GetDamage())

    self:SetNWInt("CurrentHealth", self:Health())

    if self:Health() <= 0 then
        self.Death = true
        self:SendState()

        self:SetNWInt("CurrentHealth", 0)

        timer.Simple(3.6, function()
            if self:IsValid() then
                self:Remove()
            end
        end)

        timer.Simple(3.5, function()

            local totalDamage = 0
            local eligiblePlayers = {} -- Tableau pour stocker les joueurs éligibles
    
            local ent = ents.Create("mad_crystal")
            ent:SetNWInt("item", self.crystaldrop)
            ent:SetPos(self:GetPos())
            ent:Spawn()
        
            -- Calculez le total des dégâts infligés pour cet NPC
            for _, damage in pairs(self.playerDamage) do
                totalDamage = totalDamage + damage
            end
        
            -- Distribuez l'argent équitablement entre les joueurs
            if totalDamage > 0 then
                for player, damage in pairs(self.playerDamage) do
                    local moneyEarned = math.floor(self.money * damage / totalDamage)
                    local xpEarned = math.floor(self.xp * damage / totalDamage)
        
                    if player:GetUserGroup() == "vip" then
                        player:addXP(xpEarned*1.2,true,true)
                        net.Start("SL:Notification")
                        net.WriteString(self.PrintName.. " vaincu : + ".. xpEarned*1.2 .." XP")
                        net.Send(player)
                        player:addMoney(moneyEarned*1.2)
                        net.Start("SL:Notification")
                        net.WriteString("Vous avez gagnez : + ".. formatMoney(moneyEarned*1.2))
                        net.Send(player)
                    else
                        player:addXP(xpEarned,true,true)
                        net.Start("SL:Notification")
                        net.WriteString(self.PrintName.. " vaincu : + "..xpEarned.." XP")
                        net.Send(player)
                        player:addMoney(moneyEarned)
                        net.Start("SL:Notification")
                        net.WriteString("Vous avez gagnez : + ".. formatMoney(moneyEarned))
                        net.Send(player)
                    end
                    
                    -- Vérifier si le joueur est éligible pour une compétence
                    local playerLevel = player:getDarkRPVar("level")
                    local playerClass = player:GetNWInt("Classe")
                    for skillName, skillData in pairs(SKILLS_SL) do
                        if skillData.classe == playerClass and playerLevel >= skillData.level then
                            table.insert(eligiblePlayers, player)
                            break
                        end
                    end
                end
            end
        
            -- Distribution des compétences avec une chance de 10 % par joueur éligible
            for _, player in ipairs(eligiblePlayers) do
                if math.random() <= self.chancedropskill then
                    local playerClass = player:GetNWInt("Classe")
                    local playerLevel = player:getDarkRPVar("level")
                    local availableSkills = {} -- Tableau pour stocker les compétences disponibles pour ce joueur
                    for skillName, skillData in pairs(SKILLS_SL) do
                        if skillData.classe == playerClass and playerLevel >= skillData.level and player:HasSkill(skillName) == false then
                            if skillData.ismagie == false then
                                table.insert(availableSkills, skillName)
                            elseif skillData.ismagie == true then
                                if player:GetNWInt("Magie") == skillData.element then
                                    table.insert(availableSkills, skillName)
                                end
                            end
                        end
                    end
        
                    -- Sélectionnez une compétence aléatoire parmi les compétences disponibles pour le joueur
                    local randomSkill = availableSkills[math.random(#availableSkills)]
                    local skillData = SKILLS_SL[randomSkill]
        
                    -- Ajouter la compétence au joueur
                    if skillData then
                        player:AddDataSkillsSL(randomSkill, skillData.level)
                        net.Start("SL:Notification")
                        net.WriteString("Vous avez obtenu le skill : "..skillData.name)
                        net.Send(player)
                    end
                end
            end
        
            -- Réinitialisez la table des dégâts pour la prochaine instance de NPC
            self.playerDamage = {}
        end)
    end
end

-- Fonction de poursuite (ajout de la gestion de la proximité)
function ENT:Chase(target)
    if not IsValid(target) then return end

    if self.Death == true then return end

    local pos = target:GetPos()
    self:HandleEntityProximity() -- Vérifie si une autre entité de la même classe poursuit le même joueur
    self:MoveTo(pos)
end

function ENT:Attack(target)
    if not IsValid(target) or TEAM_TABLE[target:Team()] then return end
    if self.Death or self.NoMove then return end -- Stop si en attaque spéciale ou si le NPC est mort

    if self.NextAttack and self.NextAttack > CurTime() then return end

    -- Notifie le client d'une attaque
    self:SetNWBool("Attacking", true)

    -- Animation d'attaque serveur
    local swingSound = string.format("mad_sfx_sololeveling/punch/chopper_Punch0%d.ogg", math.random(1, 3))
    self:EmitSound(swingSound)

    timer.Simple(0.5, function()
        if not IsValid(self) or not IsValid(target) then return end
        target:TakeDamage(self.Damage, self, self)

        local hitSound = "mad_sfx_sololeveling/punch/se_Punch_FaceHit.ogg"
        self:EmitSound(hitSound)
    end)

    -- Cooldown d'attaque
    self.NextAttack = CurTime() + self.cooldown_atknormal

    -- Réinitialisation de l'état après l'animation
    timer.Simple(1, function()
        if not IsValid(self) then return end
        self:SetNWBool("Attacking", false)
    end)
end

function ENT:OnSpecialAttack(target)
    if not IsValid(self) or not IsValid(target) then return end
    if self.Death then return end

    if self.NextSpeAttack and self.NextSpeAttack > CurTime() then return end

    -- Notifie le client d'une attaque spéciale
    self:SetNWBool("SpeAtk", true)

    -- Arrête les mouvements et commence l'attaque spéciale
    self.NoMove = true
    self.IsMoving = false

    -- Effets visuels et sonores
    self:EmitSound("mad_sfx_sololeveling/bestial/roar2.mp3", 75, math.random(70, 80), 0.8, CHAN_AUTO)
    ParticleEffect("dust_conquer_charge", self:GetPos(), self:GetAngles(), self)

    -- Création de la zone de dégâts
    local zone = ents.Create("mad_zone_radius")
    zone:SetNWInt("Radius", self.zone_atkspe * 10)
    if IsValid(zone) then
        zone:SetModel("models/effects/teleporttrail.mdl")
        zone:SetPos(self:GetPos())
        zone:SetModelScale(0.001)
        zone:Spawn()
        zone:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
        zone:SetNoDraw(false)
        zone:SetParent(self)
    end

    -- Dégâts de zone après un délai
    timer.Simple(1.4, function()
        if not IsValid(self) then return end

        if IsValid(zone) then
            zone:Remove()
        end

        local entities = ents.FindInSphere(self:GetPos(), self.zone_atkspe)
        for _, ent in ipairs(entities) do
            if (ent:IsPlayer() or ent:IsNPC()) and ent ~= self then
                ent:TakeDamage(self.SpecialDamage, self, self)
                ent:SetVelocity(self:GetForward() * 150 + ent:GetUp() * 500)
            end
        end
    end)

    -- Réinitialisation de l'état après l'animation
    timer.Simple(2, function()
        if not IsValid(self) then return end
        self.NoMove = false
        self:SetNWBool("SpeAtk", false)
    end)

    -- Cooldown de l'attaque spéciale
    self.NextSpeAttack = CurTime() + self.cooldown_atkspe
end

-- Fonction pour envoyer l'état au client
function ENT:SendState()
    if not IsValid(self) then return end

    self:SetNWBool("IsMoving", self.IsMoving)

    net.Start("NPC_State_Update")
        net.WriteEntity(self)
        net.WriteBool(self.Patrolling)
        if IsValid(self.CurrentTarget) then
            net.WriteBool(true)
            net.WriteEntity(self.CurrentTarget)
        else
            net.WriteBool(false)
        end
        net.WriteBool(self.Death)
    net.Broadcast()
end

-- Nettoyage des timers à la suppression
function ENT:OnRemove()
    timer.Remove("NPC_Patrol_" .. self:EntIndex())
end
