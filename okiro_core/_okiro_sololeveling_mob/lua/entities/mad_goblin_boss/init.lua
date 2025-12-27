AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

-- Définition des équipes à ignorer
local TEAM_TABLE = {
    ["Culte"] = true,
}

local hitjoueur = {
	"mad_sfx_sololeveling/punch/se_Punch_FaceHit.ogg",
	"mad_sfx_sololeveling/punch/se_Punch_Hit01.ogg",
	"mad_sfx_sololeveling/punch/se_Punch_Hit02.ogg"
}

local swing_attack = {
	"mad_sfx_sololeveling/punch/chopper_Punch01.ogg",
	"mad_sfx_sololeveling/punch/chopper_Punch02.ogg",
	"mad_sfx_sololeveling/punch/chopper_Punch03.ogg"
}

-- Initialisation de l'entité
function ENT:Initialize()
    self:SetModel("models/hunter/blocks/cube1x1x1.mdl") -- Modèle serveur (invisible)
    self:SetModelScale(1, 0) -- Agrandir le cube si nécessaire
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetHealth(self.MaxHealth)

    self:SetNWInt("CurrentHealth", self:Health())
    self:SetNWInt("maxHealth", self:Health())

    self.Origin = self:GetPos() -- Point d'origine pour la patrouille

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

    self.CurrentTarget = nil
    self.Patrolling = true
    self.IsMoving = false
    self.Death = false

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
        self:Attack(nearestPlayer)
        
        -- Calcul de l'angle vers le joueur
        local targetAngle = (nearestPlayer:GetPos() - self:GetPos()):Angle()
        targetAngle.p = 0 -- Empêche de viser vers le haut ou le bas
        self:SetAngles(targetAngle)
    
        self.IsMoving = false
    elseif nearestPlayer then
        self.Patrolling = false
        self.CurrentTarget = nearestPlayer
        self:Chase(nearestPlayer)
        
        -- Calcul de l'angle vers le joueur
        local targetAngle = (nearestPlayer:GetPos() - self:GetPos()):Angle()
        targetAngle.p = 0 -- Empêche de viser vers le haut ou le bas
        self:SetAngles(targetAngle)
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
    end
    
    if self.Patrolling and self:GetPos():Distance(self.Origin) <= 50 then
        if self:Health() < self.MaxHealth then
            self:SetHealth(self.MaxHealth)
        end
    end

    self:SendState()

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

-- Fonction d'attaque
function ENT:Attack(target)
    if not IsValid(target) or TEAM_TABLE[target:Team()] then return end

    if self.Death == true then return end

    if self.NextAttack and self.NextAttack > CurTime() then return end

    local swingSound = string.format("mad_sfx_sololeveling/punch/chopper_Punch0%d.ogg", math.random(1, 3))
    self:EmitSound(swingSound)

    -- Activation de l'attaque de feu
    self:FireAttack(target)

    self.NextAttack = CurTime() + 8
    self.IsMoving = false
end

-- Ajout de la fonction FireAttack pour gérer l'attaque de feu
function ENT:FireAttack(enemy)
    if not IsValid(enemy) then return end
    if not IsValid(self) then return end
    self.cdAttack = self.cdAttack or 0
    if self.cdAttack < CurTime() then
        self.cdAttack = CurTime() + 1
        if self:Health() < 1 then return end
        self:EmitSound(swing_attack[math.random(1, 3)], 75, math.random(70, 130), 0.8, CHAN_AUTO)

        -- Créer le projectile de feu
        timer.Simple(0.7, function()
            if self:Health() < 1 then return end
            if IsValid(self) and IsValid(enemy) then
                if IsValid(self) and IsValid(enemy) and enemy:GetPos():Distance(self:GetPos()) < 700 then
                    self.shot = ents.Create("ent_config_launch")
                    --------------------------------------------------------------------------
                    self.shot.Damage = self.Damage
                    self.shot.Burn = true
                    self.shot.BurnTime = 1
                    --------------------------------------------------------------------------
                    self.shot.Freeze = false
                    self.shot.FreezeTimer = 0
                    self.shot.HaveFreezeEffect = false
                    self.shot.FreezeEffect = ""
                    --------------------------------------------------------------------------
                    self.shot.HaveHitSound = true
                    self.shot.HitSound = hitjoueur[math.random(1, 3)]
                    self.shot.MinSound = 70
                    self.shot.MaxSound = 130
                    self.shot.HaveRepeat = false
                    self.shot.RepeatTime = 0
                    --------------------------------------------------------------------------
                    self.shot:SetPos(self:GetPos() + Vector(0, 0, 50) + self:GetForward() * 75)
                    self.shot:SetOwner(self)
                    self.shot:SetAngles(self:GetAngles())
                    self.shot:Spawn()
                    self.shot:GetPhysicsObject():EnableMotion(true)
                    self.shot:SetRenderMode(RENDERMODE_TRANSCOLOR)
                    self.shot:SetColor(Color(0, 0, 0, 0))
                    self.shot:SetModel("models/hunter/misc/sphere175x175.mdl")

                    timer.Simple(0.001, function()
                        ParticleEffectAttach("[1]_fire_goblinmage_projectile", 4, self.shot, 0)
                    end)

                    local phys = self.shot:GetPhysicsObject()
                    phys:EnableGravity(false)
                    phys:SetVelocity(self.shot:GetForward() * 750)
                end
            end
        end)
    end
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
