ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Goblin Mage"
ENT.Category = "Okiro Npc's"
ENT.Author = "Okiro"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.type = "boss"

if SERVER then
    -- Paramètres de l'entité
    ENT.MaxHealth = 5000
    ENT.PatrolRadius = 750 -- Rayon de patrouille en unités
    ENT.AttackRange = 400 -- Distance à partir de laquelle le NPC attaque
    ENT.Damage = 50
    ENT.Speed = 650 -- Vitesse du NPC
    ENT.money = 100000 -- Argent à drop (partager entre les personnes qui on attaqué)
    ENT.xp = 450 -- XP partagé entre tout les joueurs
    ENT.chancedropskill = 0.1 -- chance de drop un skill en tuant le mob
    ENT.crystaldrop = "crystal" -- soit "crystal" = blanc, "crystal2" = bleu, "crystal3" = rouge, "crystal4" = violet

    -- Ajout d'un identifiant réseau pour la synchronisation des états
    util.AddNetworkString("NPC_State_Update")
end

ENT.HUDScale = 2.0  -- Taille par défaut
ENT.HUDHeight = 15  -- Hauteur par défaut
