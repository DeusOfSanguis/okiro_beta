RANG_SL = {
    
    ["E"] = {
        name = "Ранг E",
        pourcent = 0.5,
        color = Color(99,252,146),
        coef_bonus_vie = 1,
        coef_bonus_vitesse = 1,
        coef_bonus_degat = 0,
    },

    ["D"] = {
        name = "Ранг D",
        pourcent = 0.3,
        color = Color(99,247,252),
        coef_bonus_vie = 1.15,
        coef_bonus_vitesse = 1.15,
        coef_bonus_degat = 0.15,
    },

    ["C"] = {
        name = "Ранг C",
        pourcent = 0.15,
        color = Color(99,103,252),
        coef_bonus_vie = 1.35,
        coef_bonus_vitesse = 1.35,
        coef_bonus_degat = 0.25,
    },

    ["B"] = {
        name = "Ранг B",
        pourcent = 0.04,
        color = Color(252,250,99),
        coef_bonus_vie = 1.5,
        coef_bonus_vitesse = 1.6,
        coef_bonus_degat = 0.4,
    },

    ["A"] = {
        name = "Ранг A",
        pourcent = 0.009,
        color = Color(252,99,99),
        coef_bonus_vie = 1.8,
        coef_bonus_vitesse = 1.8,
        coef_bonus_degat = 0.2,
    },

    ["S"] = {
        name = "Ранг S",
        pourcent = 0.0001,
        color = Color(0,0,0),
        coef_bonus_vie = 2.2,
        coef_bonus_vitesse = 2.2,
        coef_bonus_degat = 0.7,
    },

}


concommand.Add( "asdwqasd", function( ply, cmd, args )
    local ply_class_id = ply:GetNWInt("Classe")
        print(ply_class_id)
    --local ply_class_name = CLASSES_SL[ply_class_id].name
    --print("Игрок имеет класс: " .. ply_class_name)
end )