SQUAD = SQUAD or {}

SQUAD.Config = SQUAD.Config or {}

--Custom check function
SQUAD.Config.CustomCheck = function(ply)
    --if ply:GetUserGroup() == "user" then
    --  return true
    --end
    return true
end
SQUAD.Config.FailCheck = "Sorry, you are not a banana"

--Max members, i recommend using 4 in 4 amounts, and less than 12, 4 is perfect, but it's up to you to use it
SQUAD.Config.MaxMembers = 15
--Max tag size, example FIRED or LMAOX
SQUAD.Config.TagMaxSize = 5
--Max team name size, it speaks for itself
SQUAD.Config.NameMaxSize = 15
--Teams can deal damage between themselves? True enable damage
SQUAD.Config.DamageBetweenTeam = false
--Can you give weapons via C menu?
SQUAD.Config.CanShareWeapons = false
--Can you send money via C menu?
SQUAD.Config.CanShareMoney = false
--Can you share your view via C menu?
SQUAD.Config.CanViewPlayerScreens = false
--Can only bosses from squads use view function
SQUAD.Config.OnlyBossCanSee = false

--HUD size, i recommend values higher than 0.5
SQUAD.Config.HUDScale = 0.85
--HUD elements opacity, 255 is full opaque, 0 is invisible
SQUAD.Config.HUDOpacity = 100

--Key that brings minimap
SQUAD.Config.MinimapKey = KEY_G

--You can open squad menu in C menu?
SQUAD.Config.UseCMenu = true

--You can open squad menu in C menu?
SQUAD.Config.KeyBringSquadMenu = KEY_F6 --Keep -1 to disable it

--Prefix to use squad chat, example !party hey guys!
SQUAD.Config.ChatPrefix = "party"
--Which key is used to talk with your squad, you must hold voice chat too
SQUAD.Config.VoiceKey = -1
--This is the key displayed in tips
SQUAD.Config.VoiceKeyString = "Left ALT"
--Which groups can see admin panel info inside C menu
SQUAD.Config.AdminPanelView = {"superadmin", "admin", "trialmod"}

--Language options
SQUAD.Language = {}

SQUAD.Language.Join = "%s veut vous inviter !"
SQUAD.Language.CreateOne = "Creer"
SQUAD.Language.AcceptInvitations = "Invitations"
SQUAD.Language.ShareView = "Partager la vue"
SQUAD.Language.DrawOutlines = "Contours"
SQUAD.Language.Drawtips = "Astuces"
SQUAD.Language.NotInSquad = "Aucune escouade"
SQUAD.Language.InvitePlayers = "Inviter des joueurs"
SQUAD.Language.Create = "Créer"
SQUAD.Language.Filter = "Inviter - Filtrer :"
SQUAD.Language.InvitationButtons = {"ENVOYÉ", "SÉLECTIONNER"}
SQUAD.Language.LeavedSquad = "a quitté l'escouade"
SQUAD.Language.Sent = "vous a envoyé"

SQUAD.Language.ExitMessage = "Êtes-vous sûr de vouloir quitter l'escouade ?"
SQUAD.Language.ExitConfirm = "Confirmation d'abandon"
SQUAD.Language.Yeah = "Ouais"
SQUAD.Language.RemoveLeave = {"Retirer", "Quitter", "De l'escouade"}

SQUAD.Language.D_Title = "ESCOUADE - CRÉER"
SQUAD.Language.Chars = "lettres"
SQUAD.Language.D_Created = "ESCOUADE CRÉÉE"
SQUAD.Language.D_Exists = "L'ESCOUADE EXISTE DÉJÀ"
SQUAD.Language.D_ExistsB = "UTILISEZ UN NOM DIFFÉRENT"
SQUAD.Language.D_Error = "UNE ERREUR S'EST PRODUITE"

SQUAD.Language.Message = "Envoyer un message"
SQUAD.Language.MessageWarning = "Attendez au moins 5 secondes entre l'envoi de messages"
SQUAD.Language.Money = "Envoyer de l'argent"
SQUAD.Language.MoneySubtitle = "Insérez le montant d'argent que vous souhaitez donner"
SQUAD.Language.GiveGun = "Donner une arme"
SQUAD.Language.ScreenView = "Voir l'écran du joueur"

SQUAD.Language.MaxMembers = "Cette escouade a déjà le maximum de membres."

SQUAD.Language.Accept = "Pour accepter"
SQUAD.Language.Refuse = "Pour refuser"

-- Astuces
SQUAD.Tips = { "Maintenez C et appuyez sur le widget ESCOUADE pour créer la vôtre",
    "Vous voulez empêcher les gens de vous inviter ? Ouvrez le menu C et désactivez-le dans ESCOUADE",
    "Vous pouvez voir votre ESCOUADE à travers les murs en l'activant dans les options ESCOUADE (Menu C)",
    "Vous pouvez envoyer de l'argent via le menu ESCOUADE",
    "Vous voulez envoyer un message à votre ESCOUADE ? Tapez (! ou /)" .. SQUAD.Config.ChatPrefix .. " <message>",
    "Vous pouvez parler radio avec votre ESCOUADE en maintenant la touche vocale et " .. SQUAD.Config.VoiceKeyString,
    "Vous pouvez désactiver ces astuces dans le menu ESCOUADE"
}