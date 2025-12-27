--[[
    Addon : EliteWeaponSelector
    By : Esteb
	Support : !Esteb.#6666
	Version : 2.0
--]]


local config = {} 

config.baseFont = "Poppins" -- Quelle police devrions-nous utiliser? (C:\Program Files (x86)\Steam\steamapps\common\GarrysMod\garrysmod\resource\fonts)

config.baseSizeFont = 7 -- Taile du texte 

config.lingerDuration = 2 -- Combien de temps doit-il rester sur l'écran? (secondes) 

config.originY = 20 -- À quelle distance du haut de l'écran? (pixels)

config.bgH = 30 -- Quelle est la hauteur des cases ? (pixels)

config.bgSelectedColor = Color( 9, 57, 128, 255) -- Couleur de fond arme sélectionnée

config.bgNonSelectedColor = Color(0, 0, 0, 50) -- Couleur de fond arme non sélectionnée

config.bgSelectedOutline = Color( 5, 38, 87) -- Couleur de contour de l'arme sélectionnée

config.textSelectedColor = Color(219, 227, 255, 255) -- Couleur du texte de l'arme sélectionnée

config.textNonSelectedColor = Color(219, 227, 255, 255) -- Couleur du texte de l'arme non sélectionnée

config.slotChangeSound = "ambient/water/rain_drip4.wav" -- Son produit lorsque vous sélectionnez une arme

config.weaponSelectedSound = "ambient/water/drip4.wav" -- Son produit lorsque vous utilisez une arme

config.emptySlotText = "Vide" -- Texte affiché quand il n'y a plus d'arme dans la catégorie

-- Transforme eliteswephud_config utilisé dans le code par config pour une meilleure qualité" de la config
eliteswephud_config = config

