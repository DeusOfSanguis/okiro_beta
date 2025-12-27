--[[
-----------------------------------------------------------
                    Informations
-----------------------------------------------------------
Ce fichier provient du site web https://aide-serveur.fr/ et a été publié et créé par Autorun__.
Toute forme de revente, de republication, d'envoi à des tiers, etc. est strictement interdite, car cet addon est payant.
Discord : Autorun__
Serveur Discord : Discord.gg/GgH8eKmFpt
-----------------------------------------------------------
--]]

TaxiTeleportConfig = {}

-- Devise
TaxiTeleportConfig.Currency = "₩" -- $ ou €, etc.

-- Configuration des destinations
TaxiTeleportConfig.Destinations = {
        --{                                         -- N'oubliez pas "{"
        --    Name = "Centre-Ville",                -- Nom de la destination
        --    Pos = Vector(-4716, -7451, 105),      -- Position de la destination (Utilisez getpos dans la console)
        --    Angle = Angle(0, 90, 0),              -- Angle (Utilisez getpos dans la console)
        --    Price = 250,                          -- Prix
        --},                                        -- N'oubliez pas "},"
        {
            Name = "L'Association des Chasseurs",
            Pos = Vector(-8016, -11594, -3009),
            Angle = Angle(0, 90, 0),
            Price = 50000,
        },
        {
            Name = "Zone Commercial",
            Pos = Vector(5510, 12700, -2976),
            Angle = Angle(0, 90, 0),
            Price = 50000,
        },
        {
            Name = "Port",
            Pos = Vector(12281, 338, -3024),
            Angle = Angle(0, 90, 0),
            Price = 50000,
        },
        {
            Name = "Hopital",
            Pos = Vector(-12696, 6783, -2565),
            Angle = Angle(0, 90, 0),
            Price = 50000,
        },
        {
            Name = "Police",
            Pos = Vector(-3990, 14819, -2574),
            Angle = Angle(0, 90, 0),
            Price = 50000,
        },
    -- Ajoutez d'autres destinations ici
}

-- Paramètres du temps, de la distance et du modèle
TaxiTeleportConfig.TimerDelay = 10 -- Temps d'attente en secondes avant la téléportation
TaxiTeleportConfig.MaxDistance = 250 -- Distance maximale, si le joueur dépasse cette distance, la course sera alors annulée
TaxiTeleportConfig.EntityModel = "models/tdmcars/crownvic_taxi.mdl" -- Modèle du taxi

-- Messages
TaxiTeleportConfig.Messages = {
    CourseTaken = "Vous avez pris une course pour la destination suivante : ", -- Le nom de la destination sera ajouté après
    TimeLeftBeforeTeleport = "Temps avant téléportation : ", -- Le temps sera ajouté après
    TeleportedTo = "Vous avez été transporté à la destination suivante : ",
    TooFarAway = "Course annulée, vous êtes trop loin du taxi.",
    NotEnoughMoney = "Vous n'avez pas assez d'argent pour cette course."
}

-- Souhaitez-vous activer une option permettant la désactivation automatique des Teleport Taxi s'il y a un chauffeur de taxi en ville ?
TaxiTeleportConfig.ActivateTeleportTaxi = true -- true = Oui // false = Non

-- Liste des jobs considérés comme chauffeurs de taxi
TaxiTeleportConfig.TaxiJobs = {
    "Chauffeur de taxi",
    -- Ajoutez d'autres jobs ici si nécessaire
}

-- Message dans le chat lorsqu'un chauffeur de taxi est en service
TaxiTeleportConfig.TaxiInServiceMessage = "Vous ne pouvez pas utiliser ce taxi, car un chauffeur de taxi est en service."

-- Configuration des couleurs
TaxiTeleportConfig.Colors = {
    Background = Color(33, 115, 152, 115),                -- Couleur de fond du panneaux
    Text = Color(255, 255, 255, 255),                     -- Couleur du texte principal
    CloseButton = Color(200, 20, 20, 255),              -- Couleur du bouton de fermeture
    XClose = Color(255, 255, 255, 255),                 -- Couleur du texte 'X' du bouton de fermeture
    ButtonBackground = Color(33, 115, 172, 255),          -- Couleur de fond des boutons
    ButtonBackgroundHover = Color(33, 115, 172, 255),    -- Couleur de fond des boutons au survol
    ButtonText = Color(255, 255, 255, 255),             -- Couleur du texte des boutons
    ButtonTextHover = Color(200, 200, 200, 255),              -- Couleur du texte des boutons au survol
    ScrollBar = Color(0, 0, 0, 100, 255),               -- Couleur de la scrollbar
    ScrollBarBtn = Color(0, 0, 0, 0),                   -- Couleur des boutons de la scrollbar
    ScrollBarGrip = Color(255, 205, 0, 255),            -- Couleur de la poignée de la scrollbar
}

-- Configuration du style des bords
TaxiTeleportConfig.BorderRadius = 5 -- 0 pour des bords carrés, augmentez la valeur pour des bords arrondis.


if SERVER then
    AddCSLuaFile()
end