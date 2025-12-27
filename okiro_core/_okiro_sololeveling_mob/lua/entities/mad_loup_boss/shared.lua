ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Loup Tranchant Neigeux"
ENT.Category = "Okiro Npc's"
ENT.Author = "Okiro"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.type = "boss"

if SERVER then
    -- Paramètres de l'entité
    ENT.MaxHealth = 5300
    ENT.PatrolRadius = 500 -- Rayon de patrouille en unités
    ENT.AttackRange = 120 -- Distance à partir de laquelle le NPC attaque
    ENT.Damage = 85
    ENT.SpecialDamage = 125
    ENT.Speed = 650 -- Vitesse du NPC
    ENT.money = 100000 -- Argent à drop (partager entre les personnes qui on attaqué)
    ENT.xp = 1518 -- XP partagé entre tout les joueurs
    ENT.chancedropskill = 0.1 -- chance de drop un skill en tuant le mob
    ENT.crystaldrop = "crystal4" -- soit "crystal" = blanc, "crystal2" = bleu, "crystal3" = rouge, "crystal4" = violet

    ENT.cooldown_atknormal = 4
    ENT.zone_atkspe = 250
    ENT.cooldown_atkspe = 10

    -- Ajout d'un identifiant réseau pour la synchronisation des états
    util.AddNetworkString("NPC_State_Update")
end

ENT.HUDScale = 3.0  -- Taille par défaut
ENT.HUDHeight = 25  -- Hauteur par défaut
