esc = esc or {}
local buttonReprendre = Material("okiro/echap/reprendre.png")
local buttonBoutique = Material("okiro/echap/boutique.png")
local buttonParametres = Material("okiro/echap/parametres.png")
local buttonDiscord = Material("okiro/echap/discord.png")
local buttonCollection = Material("okiro/echap/collection.png")
local buttonSedeconnecter = Material("okiro/echap/sedeconnecter.png")

esc.buttons = {
    {name = "Retour au jeu", action = "return", mat = buttonReprendre, otst = 77},
    {name = "Boutique?", action = "https://okirosl.tebex.io/", mat = buttonBoutique, otst = 77},
    {name = "Paramètres", action = "game:openoptionsdialog", mat = buttonParametres, otst = 77},
    {name = "Discord", action = "https://discord.gg/okiro", mat = buttonDiscord, otst = 77},
    {name = "Collection", action = "https://steamcommunity.com/sharedfiles/filedetails/?id=3388989039", mat = buttonCollection, otst = 77},
    {name = "Sortie", action = "disconnect", mat = buttonSedeconnecter, otst = 82},
}

esc.color = Color(0, 170, 255)
esc.font = "Lexend-Regular"
esc.text1 = "ARC 1:"
esc.text2 = "LE DEBUT DE LA FIN"
esc.textNev = "NOUVEAUTÉS"
esc.textNev0 = "V1.0.0"
esc.textNev1 = "• Ajout de nouveaux mobs : Dragon, Chef des Elfs, etc..."
esc.textNev2 = "• Modification des cooldowns des attaques"
esc.textNev3 = "• Changement complet de la direction artistique"
esc.textNev4 = "• Ajout de nouveaux items et armes"

if CLIENT then
    for i = 1, 70 do
        surface.CreateFont("Regular." .. i, {
            font = "Lexend",
            size = i,
            weight = 200,
            extended = false,
            antialias = true,
            outline = false,
        })
    end
    for i = 1, 70 do
        surface.CreateFont("Medium." .. i, {
            font = "Lexend Medium",
            size = i,
            weight = 200,
            extended = false,
            antialias = true,
            outline = false,
        })
    end
end

if SERVER then
    resource.AddFile("resource/fonts/Lexend-Regular.ttf")
end
