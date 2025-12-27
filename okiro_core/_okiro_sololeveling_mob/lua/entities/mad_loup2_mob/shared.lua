ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Loup Tranchant"
ENT.Category = "Okiro Npc's"
ENT.Author = "Okiro"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.type = "mob"

if SERVER then
    -- Paramètres de l'entité
    ENT.MaxHealth = 4850
    ENT.PatrolRadius = 500 -- Rayon de patrouille en unités
    ENT.AttackRange = 120 -- Distance à partir de laquelle le NPC attaque
    ENT.Damage = 55
    ENT.Speed = 650 -- Vitesse du NPC
    ENT.money = 100000 -- Argent à drop (partager entre les personnes qui on attaqué)
    ENT.xp = 1012 -- XP partagé entre tout les joueurs
    ENT.chancedropskill = 0.1 -- chance de drop un skill en tuant le mob
    ENT.crystaldrop = "crystal" -- soit "crystal" = blanc, "crystal2" = bleu, "crystal3" = rouge, "crystal4" = violet

    ENT.cooldown_atknormal = 4

    -- Ajout d'un identifiant réseau pour la synchronisation des états
    util.AddNetworkString("NPC_State_Update")
end

ENT.HUDScale = 1.0  -- Taille par défaut
ENT.HUDHeight = 15  -- Hauteur par défaut
