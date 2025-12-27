util.PrecacheModel( "models/mad_models/mad_sl_male_armor7.mdl" )
util.PrecacheModel( "models/mad_models/mad_sl_male_armor21.mdl" )
util.PrecacheModel( "models/mad_models/mad_sl_male_armor22.mdl" )
util.PrecacheModel( "models/mad_models/mad_sl_male_armor6.mdl" )
util.PrecacheModel( "models/mad_models/mad_sl_male_armor2.mdl" )
util.PrecacheModel( "models/mad_models/mad_sl_male_armor4.mdl" )
util.PrecacheModel( "models/mad_models/mad_sl_male_armor14.mdl" )
util.PrecacheModel( "models/mad_models/mad_sl_male_armor25.mdl" )

CLASSES_SL = {
    ["porteur"] = {
        name = "Носильщик",
        swep = "",
        mdl = "models/mad_models/mad_sl_male_armor7.mdl",
        rarete = "commun",
        img = "mad_sololeveling/menu/new/classe2/commun.png",
        boost_hp = 0,
        boost_vitesse = 25,
    },
    ["epeiste"] = {
        name = "Мечник",
        swep = "",
        mdl = "models/mad_models/mad_sl_male_armor21.mdl",
        rarete = "commun",
        img = "mad_sololeveling/menu/new/classe2/commun.png",
        boost_hp = 125,
        boost_vitesse = 25,
    },
    ["healer"] = {
        name = "Целитель",
        swep = "",
        mdl = "models/mad_models/mad_sl_male_armor25.mdl",
        rarete = "commun",
        img = "mad_sololeveling/menu/new/classe2/commun.png",
        boost_hp = 200,
        boost_vitesse = 0,
    },
    ["assassin"] = {
        name = "Ассасин",
        swep = "",
        mdl = "models/mad_models/mad_sl_male_armor6.mdl",
        rarete = "epique",
        img = "mad_sololeveling/menu/new/classe2/epic.png",
        boost_hp = 0,
        boost_vitesse = 175,
    },
    ["bestial"] = {
        name = "Зверь",
        swep = "",
        mdl = "models/mad_models/mad_sl_male_transfo2.mdl",
        rarete = "unique",
        img = "mad_sololeveling/menu/new/classe2/unique.png",
        boost_hp = 400,
        boost_vitesse = 250,
    },
    ["tank"] = {
        name = "Танк",
        swep = "",
        mdl = "models/mad_models/mad_sl_male_armor2.mdl",
        rarete = "rare",
        img = "mad_sololeveling/menu/new/classe2/rare.png",
        boost_hp = 600,
        boost_vitesse = -50,
    },
    ["mage"] = {
        name = "Маг",
        swep = "",
        mdl = "models/mad_models/mad_sl_male_armor4.mdl",
        rarete = "legendaire",
        img = "mad_sololeveling/menu/new/classe2/legendaire.png",
        boost_hp = 25,
        boost_vitesse = 0,
    },
    ["invocateur"] = {
        name = "Призыватель",
        swep = "",
        mdl = "models/mad_models/mad_sl_male_armor14.mdl",
        rarete = "mythique",
        img = "mad_sololeveling/menu/new/classe2/mythique.png",
        boost_hp = 0,
        boost_vitesse = 125,
    },
    ["archer"] = {
        name = "Лучник",
        swep = "",
        mdl = "models/mad_models/mad_sl_male_armor14.mdl",
        rarete = "rare",
        img = "mad_sololeveling/menu/new/classe2/mythique.png",
        boost_hp = 0,
        boost_vitesse = 100,
    },
}