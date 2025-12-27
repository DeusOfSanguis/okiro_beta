---- // SCRIPT BY INJ3
---- // https://steamcommunity.com/id/Inj3/

--- > [HUD Affichage Info]
Admin_System_Global.Mode_HUD = true --- Activer l'affichage des informations sur les véhicules/joueurs en mode Admin.

---- // Indiquer les groupes qui peuvent contourner l'affichage des informations sur les véhicules/joueurs en mode Admin, ils seront invisibles aux autres admins.
Admin_System_Global.Mode_Bypass = {
    ["superadmin"] = true,
}
--- <

--- > [HUD Support]
Admin_System_Global.Mode_Vcmod = false ---  true = Si le VCmod est présent sur votre serveur.
--- <

--- > [HUD Visiblite info]
Admin_System_Global.Mode_Bypass_Veh = false --- Les admins ne voient pas les infos des véhicules appartenant au groupe ci-dessus "Admin_System_Global.Mode_Bypass".
Admin_System_Global.Mode_Bypass_Player = false --- Les admins ne voient pas les infos des joueurs appartenant au groupe ci-dessus "Admin_System_Global.Mode_Bypass".
--- <

--- > [HUD Position]
Admin_System_Global.Mode_Bool = true --- Activer l'affichage des états (cloak, godmod, noclip) sur votre HUD en mode Admin.
Admin_System_Global.Mode_Height = "haut" --- Positionement vertical - "haut", "milieu", "bas".
Admin_System_Global.Mode_Wide = "milieu" --- Positionement horizontal - "gauche", "milieu", "droite".
--- <