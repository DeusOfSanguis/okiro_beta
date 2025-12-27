ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Dragon"
ENT.Category = "Okiro Npc's"
ENT.Author = "Okiro"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.type = "boss"

if SERVER then
    -- Paramètres de l'entité
    ENT.MaxHealth = 20000
    ENT.PatrolRadius = 1000 -- Rayon de patrouille en unités
    ENT.AttackRange = 500 -- Distance à partir de laquelle le NPC attaque
    ENT.Damage = 1500
    ENT.SpecialDamage = 2500
    ENT.Speed = 200 -- Vitesse du NPC
    ENT.money = 550000 -- Argent à drop (partager entre les personnes qui on attaqué)
    ENT.xp = 50000 -- XP partagé entre tout les joueurs
    ENT.chancedropskill = 0.8 -- chance de drop un skill en tuant le mob
    ENT.crystaldrop = "crystal4" -- soit "crystal" = blanc, "crystal2" = bleu, "crystal3" = rouge, "crystal4" = violet

    ENT.cooldown_atknormal = 4
    ENT.zone_atkspe = 1200
    ENT.cooldown_atkspe = 10

    -- Ajout d'un identifiant réseau pour la synchronisation des états
    util.AddNetworkString("NPC_State_Update")
end

ENT.HUDScale = 10.0  -- Taille par défaut
ENT.HUDHeight = 25  -- Hauteur par défaut
