include("shared.lua")

local ModelPath = "models/mad_lezardmob.mdl"

-- Initialisation côté client
function ENT:Initialize()
    self.ClientModel = ClientsideModel(ModelPath, RENDERGROUP_TRANSLUCENT)
    if IsValid(self.ClientModel) then
        self.ClientModel:SetParent(self)
        -- self.ClientModel:SetLocalPos(Vector(0, 0, 0))
        -- self.ClientModel:SetLocalAngles(Angle(0, 0, 0))

        -- Randomisation des bodygroups
        local bodygroupCount = self.ClientModel:GetNumBodyGroups() -- Nombre total de bodygroups pour le modèle
        for i = 0, bodygroupCount - 1 do
            local choices = self.ClientModel:GetBodygroupCount(i) -- Nombre d'options pour ce bodygroup
            if choices > 1 then
                self.ClientModel:SetBodygroup(i, math.random(0, choices - 1)) -- Choisir un bodygroup aléatoire
            end
        end
    else
        print("Erreur : Impossible de créer le modèle client pour le NPC.")
    end

    self.CurrentAnimation = ""
    self.onCustomSequence = false
    self.Attacking = false
    self.LastState = ""

    -- Taille dynamique de l'écriture en fonction de l'échelle de l'HUD
    local fontSize = 10 * self.HUDScale
    local outlineSize = math.max(1, math.floor(self.HUDScale)) -- L'épaisseur des bordures suit également l'échelle

    -- Création d'une police personnalisée avec la taille dynamique
    surface.CreateFont("DynamicFont", {
        font = "DermaDefaultBold",
        size = fontSize,
        weight = 500,
        antialias = true,
    })
end

function ENT:PlayLoopingAnimation(anim)
    if IsValid(self.ClientModel) then
        local sequence = self.ClientModel:LookupSequence(anim)
        if sequence and sequence >= 0 then
            self.ClientModel:ResetSequence(sequence)
            self.ClientModel:SetCycle(0) -- Commence à zéro
            self.ClientModel:SetPlaybackRate(1) -- Définit la vitesse de lecture

            -- Utiliser Think pour forcer le cycle
            self.NextAnimationFrame = 0
            self.AnimationSequence = sequence

            self:ThinkAnimation() -- Commence le processus
        else
            print("Sequence not found: " .. anim)
        end
    end
end

function ENT:ThinkAnimation()
    if not IsValid(self.ClientModel) then return end

    local curTime = CurTime()
    if self.NextAnimationFrame <= curTime then
        self.ClientModel:FrameAdvance(curTime - (self.LastFrameTime or curTime))
        self.LastFrameTime = curTime
        self.NextAnimationFrame = curTime + 0.01 -- Avance à chaque frame
    end

    timer.Simple(0.01, function()
        if IsValid(self) then
            self:ThinkAnimation()
        end
    end)
end

-- Définit une séquence personnalisée
function ENT:SetCustomSequence(sequence)
    if not IsValid(self.ClientModel) then return end
    local seq = self.ClientModel:LookupSequence(sequence)
    if seq == -1 then
        print("NPC Mad: Séquence '" .. sequence .. "' introuvable.")
        return
    end
    self.ClientModel:ResetSequence(seq)
    self.ClientModel:SetCycle(0)
    self.ClientModel:SetPlaybackRate(1)
    self.CurrentAnimation = sequence
end

-- Joue une animation une seule fois avec retour à un état précédent
function ENT:PlaySequenceOnce(sequence, callback)
    if not IsValid(self.ClientModel) then return end
    local sequenceId = self.ClientModel:LookupSequence(sequence)
    if sequenceId == -1 then
        print("NPC Mad: Séquence '" .. sequence .. "' introuvable.")
        return
    end

    local duration = self.ClientModel:SequenceDuration(sequenceId)
    self:PlayLoopingAnimation(sequence)

    timer.Create(self:EntIndex() .. "_PlaySequenceOnce", duration, 1, function()
        if IsValid(self) then
            if callback then callback() end
            self.Attacking = false
            self.onCustomSequence = false
            self:CheckAndPlayAnimation() -- Retour à l'état approprié
        end
    end)

    self.onCustomSequence = true
end

-- Table des animations d'attaque avec leurs poids
local AttackAnimations = {
    { Sequence = "attack1", Weight = 1 },
    { Sequence = "attack2", Weight = 1 },
}

-- Fonction pour sélectionner une animation d'attaque aléatoire
local function GetRandomAttackAnimation()
    local totalWeight = 0

    -- Calcul du poids total
    for _, anim in ipairs(AttackAnimations) do
        totalWeight = totalWeight + anim.Weight
    end

    local randomWeight = math.random() * totalWeight
    local currentWeight = 0

    -- Sélection d'une animation en fonction du poids
    for _, anim in ipairs(AttackAnimations) do
        currentWeight = currentWeight + anim.Weight
        if randomWeight <= currentWeight then
            return anim.Sequence
        end
    end

    -- Par défaut, retourne la première animation si rien n'est trouvé
    return AttackAnimations[1].Sequence
end
function ENT:CheckAndPlayAnimation()
    if not IsValid(self) then return end

    -- Si le NPC est mort, joue l'animation de mort et arrête les autres animations
    if self.Death then
        if self.LastState ~= "die" then
            self.LastState = "die"
            self:PlaySequenceOnce("die", function()
                -- print("Animation de mort jouée.")
            end)
        end
        return -- Sort de la fonction pour arrêter toute autre animation
    end

    local state = "idle" -- Animation par défaut

    -- Vérifie si une attaque spéciale est en cours
    if self:GetNWBool("SpeAtk", false) then
        state = "skill2"
    elseif self:GetNWBool("Attacking", false) then
        state = GetRandomAttackAnimation() -- Animation d'attaque normale
    elseif self:GetNWBool("IsMoving", false) then
        state = "run" -- Animation de course si le NPC est en mouvement
    end

    -- Si aucun état n'est défini, retourne à "idle"
    if state == "" then
        state = "idle"
    end

    -- Si l'état d'animation a changé ou qu'aucune animation n'est en cours
    if state ~= self.LastState and not self.onCustomSequence then
        self.LastState = state

        -- Joue l'animation correspondante
        if state == "skill2" or state == GetRandomAttackAnimation() then
            self:PlaySequenceOnce(state, function()
                -- print("Animation terminée :", state)
            end)
        else
            self:PlayLoopingAnimation(state)
        end
    end
end

-- Pense et ajuste les animations
function ENT:Think()
    if not IsValid(self) then return end

    if IsValid(self.ClientModel) then
        self.ClientModel:SetPos(self:GetPos() + Vector(0,0,-25))
        self.ClientModel:SetAngles(self:GetAngles())
    end

    self:CheckAndPlayAnimation()

    self:NextThink(CurTime())
    return true
end

-- Nettoyage lors de la suppression
function ENT:OnRemove()
    if IsValid(self.ClientModel) then
        self.ClientModel:Remove()
    end
    timer.Remove(self:EntIndex() .. "_PlaySequenceOnce")
end

-- Réception des états du serveur
net.Receive("NPC_State_Update", function()
    local ent = net.ReadEntity()
    if not IsValid(ent) then return end

    ent.Patrolling = net.ReadBool()
    local hasTarget = net.ReadBool()
    if hasTarget then
        ent.CurrentTarget = net.ReadEntity()
    else
        ent.CurrentTarget = nil
    end
    ent.Death = net.ReadBool()

    -- print("NPC Mad State Updated: Patrolling =", ent.Patrolling, "Has Target =", hasTarget)
end)

-- Fonction pour interpoler les couleurs entre vert et rouge
local function GetHealthColor(healthFraction)
    local r = math.Clamp(255 * (1 - healthFraction), 0, 255) -- Rouge augmente à mesure que la vie diminue
    local g = math.Clamp(255 * healthFraction, 0, 255)     -- Vert diminue à mesure que la vie diminue
    return Color(r, g, 0, 255) -- Bleu est à 0, alpha à 255
end

-- Fonction pour dessiner la barre de vie
local function DrawHealthBar(ent)
    if not IsValid(ent.ClientModel) then return end

    -- Récupère la position du bone "mixamorig:Head"
    local boneId = ent.ClientModel:LookupBone("Bip001_Head")
    if not boneId then return end -- Si le bone n'existe pas, on quitte
    local bonePos, _ = ent.ClientModel:GetBonePosition(boneId)
    if not bonePos then return end -- Vérifie que la position est valide

    -- Données pour la barre de vie
    local health = ent:GetNWInt("CurrentHealth", 0)
    local maxHealth = ent:GetNWInt("MaxHealth", 1) -- Assure qu'il y ait une valeur par défaut
    local healthFraction = math.Clamp(health / maxHealth, 0, 1)
    local healthColor = GetHealthColor(healthFraction)

    -- Calcul des positions 3D et mise à l'échelle
    local barWidth = 150 * ent.HUDScale
    local barHeight = 15 * ent.HUDScale
    local barPos = bonePos + Vector(0, 0, 10 * ent.HUDScale)

    -- Angle de la caméra pour toujours être face au joueur
    local ang = Angle(0, LocalPlayer():EyeAngles().y - 90, 90)

    -- Dessin de la barre de vie en 3D2D
    cam.Start3D2D(barPos, ang, 0.1)
        draw.RoundedBox(6, -barWidth / 2, 0, barWidth, barHeight, Color(0, 0, 0, 200)) -- Fond de la barre
        draw.RoundedBox(6, -barWidth / 2 + 2, 2, (barWidth - 4) * healthFraction, barHeight - 4, healthColor) -- Remplissage
        draw.SimpleTextOutlined(
            math.floor(healthFraction * 100) .. "%",
            "DynamicFont",
            0,
            barHeight / 2,
            Color(255, 255, 255),
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER,
            1,
            Color(0, 0, 0)
        )
    cam.End3D2D()
end

-- Hook pour dessiner les barres de vie de tous les NPCs
hook.Add("PostDrawOpaqueRenderables", "DrawSoloLevelingNPCHealthBarLezard", function()
    for _, ent in ipairs(ents.FindByClass("mad_lezard_mob")) do
        if IsValid(ent) then
            DrawHealthBar(ent)
        end
    end
end)
