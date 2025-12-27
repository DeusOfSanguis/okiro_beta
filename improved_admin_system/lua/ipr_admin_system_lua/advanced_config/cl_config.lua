---- // SCRIPT BY INJ3
---- // https://steamcommunity.com/id/Inj3/

--- > [Context menu de droite]
Admin_System_Global.ContextMenu_TblFunc = {
    ["Joueur Action"] = {
        {
            Name = Admin_System_Global.lang["contextmenu_dropmoney"], Icon = "icon16/money_delete.png", Func = function()
                Admin_System_Global:ContextMenu_Func(false)
            end
        },
        {
            Name = Admin_System_Global.lang["contextmenu_givemoney"], Icon = "icon16/money_add.png", Func = function()
                Admin_System_Global:ContextMenu_Func(true)
            end
        },
        {
            Name = Admin_System_Global.lang["contextmenu_ticket"], Icon = "icon16/shield.png", Func = function()
                LocalPlayer():ConCommand( Admin_System_Global.Ticket_Cmd)
            end
        },
        {
            Name = Admin_System_Global.lang["contextmenu_dropweap"], Icon = "icon16/monitor.png", Func = function()
                LocalPlayer():ConCommand( "say /drop")
            end
        },
        {
            Name = Admin_System_Global.lang["contextmenu_stopsound"],  Icon = "icon16/music.png", Func = function()
                LocalPlayer():ConCommand( "stopsound")
                chat.AddText(Color( 255, 0, 0 ), "[", "Admin System", "] : ", Color( 255, 255, 255 ), Admin_System_Global.lang["contextmenu_textstopsound"] )
            end
        },
        {
            Name = Admin_System_Global.lang["contextmenu_changeview"], Icon = "icon16/webcam.png", Func = function()
                LocalPlayer():ConCommand( Admin_System_Global.Command_ContextMenu )
            end
        },
        {
            Name = "Donner licence", Icon = "icon16/vcard.png", OnlyForMayor = true, Func = function()
                LocalPlayer():ConCommand( "say /givelicense" )
            end
        },
        {
            Name = "Vendre mes portes", Icon = "icon16/door_open.png", Func = function()
                LocalPlayer():ConCommand( "say /sellalldoors" )
            end
        },
    },

    ["Admin Action"] = {
        {
            Name = Admin_System_Global.lang["contextmenu_adminmod"], Icon = "icon16/eye.png",  OnlyForAdmin = true, Func = function()
                if (LocalPlayer():AdminStatusCheck()) then
                    LocalPlayer():PrintMessage(HUD_PRINTTALK, Admin_System_Global.lang["contextmenu_adminmodeon"])
                    return
                end
                net.Start("admin_sys:updatenw")
                net.SendToServer()
            end
        },
        {
            Name = Admin_System_Global.lang["contextmenu_rpmod"], Icon = "icon16/house.png", OnlyForAdmin = true, Func = function()
                if not LocalPlayer():AdminStatusCheck() then
                    LocalPlayer():PrintMessage( HUD_PRINTTALK, Admin_System_Global.lang["contextmenu_adminmodeoff"] )
                    return
                end
                net.Start("admin_sys:updatenw")
                net.SendToServer()
            end
        },
        {
            Name = Admin_System_Global.lang["contextmenu_log"], Icon = "icon16/page_white_code.png", OnlyForAdmin = true, Func = function()
                LocalPlayer():ConCommand( "say " ..Admin_System_Global.Action_Logs )
            end
        },
        {
            Name = Admin_System_Global.lang["contextmenu_warn"], Icon = "icon16/bell.png", OnlyForAdmin = true, Func = function()
                LocalPlayer():ConCommand( "say " ..Admin_System_Global.Action_Warn )
            end
        },
        {
            Name = Admin_System_Global.lang["contextmenu_refund"], Icon = "icon16/money.png", OnlyForAdmin = true, Func = function()
                LocalPlayer():ConCommand( Admin_System_Global.Remb_Cmd )
            end
        },
        {
            Name = Admin_System_Global.lang["contextmenu_cmdgeneral"], Icon = "icon16/chart_organisation.png", OnlyForAdmin = true, Func = function()
                LocalPlayer():ConCommand( Admin_System_Global.Cmd_General )
            end
        },
        {
            Name = "Me démenotter", Icon = "icon16/cut_red.png", OnlyForAdmin = true, Func = function()
                local ipr_player = LocalPlayer()

                if (RHandcuffsConfig) then
                    if ipr_player:GetNWBool("rhc_cuffed") then
                        net.Start("Admin_Sys:Action")
                        net.WriteUInt(12, 4)
                        net.WriteBool(false)
                        net.SendToServer()
                        return
                    else
                        ipr_player:PrintMessage(HUD_PRINTTALK, "Vous n'êtes pas menotté ! [Realistic Handcuffs]")
                    end
                end
                if (RKidnapConfig) then
                    if ipr_player:GetNWBool("rks_restrained") then
                        ipr_player:ConCommand("rks_togglerestrains " ..ipr_player:Nick())
                        return
                    else
                        ipr_player:PrintMessage(HUD_PRINTTALK, "Vous n'avez pas de serflex ! [Realistic Kidnap System]")
                    end
                end
                if (BES) then
                    if(ipr_player:GetNWBool( "BES_CUFFED", false )) then
                        net.Start("Admin_Sys:Action")
                        net.WriteUInt(11, 4)
                        net.WriteBool(false)
                        net.SendToServer()
                        return
                    else
                        ipr_player:PrintMessage(HUD_PRINTTALK, "Vous n'êtes pas menotté ! [Brick's Enhanced SWEPs]")
                    end
                end
                if (Realistic_Police) then
                    net.Start("Admin_Sys:Action")
                    net.WriteUInt(10, 4)
                    net.WriteBool(false)
                    net.SendToServer()
                end
            end
        },
    }
}
--- <

--- > [Context menu Action]
Admin_System_Global.ContextAction = {
    Player = {
        {
            name = Admin_System_Global.lang["contextaction_adminzone"],
            pos = "gauche",

            func = function(lplayer, player)
                if not lplayer:AdminStatusCheck() then
                    return lplayer:PrintMessage(HUD_PRINTTALK, Admin_System_Global.lang["contextaction_adminmod"].. "" ..Admin_System_Global.Mode_Cmd)
                end

                net.Start("Admin_Sys:ZNAdmin")
                net.WriteBool(true)
                net.WriteEntity(player)
                net.WriteUInt(3, 4)
                net.SendToServer()
            end,
            callback_func = function(player)
                return player:Alive()
            end,
            callback_name = function(lplayer, player)
                return false
            end,
        },
        {
            name = Admin_System_Global.lang["contextaction_strip"],
            pos = "gauche",

            func = function(lplayer, player)
                if (#player:GetWeapons() <= 0) then
                    return
                end

                net.Start("Admin_Sys:Action")
                net.WriteUInt(3, 4)
                net.WriteEntity(player)
                net.WriteBool(false)
                net.SendToServer()
            end,
            callback_func = function(player)
                return player:Alive()
            end,
            callback_name = function(lplayer, player)
                return (#player:GetWeapons() <= 0) and "No weapons" or Admin_System_Global.lang["contextaction_strip"]
            end,
        },
        {
            name = Admin_System_Global.lang["contextaction_freeze"],
            pos = "gauche",

            func = function(lplayer, player)
                net.Start("Admin_Sys:Action")
                net.WriteUInt(1, 4)
                net.WriteEntity(player)
                net.WriteBool(false)
                net.SendToServer()
            end,
            callback_func = function(player)
                return player:Alive()
            end,
            callback_name = function(lplayer, player)
                return (player:GetCollisionGroup() == COLLISION_GROUP_PLAYER) and Admin_System_Global.lang["contextaction_freeze"] or Admin_System_Global.lang["contextaction_unfreeze"]
            end,
        },
        {
            name = Admin_System_Global.lang["contextaction_fullhealth"],
            pos = "gauche",

            func = function(lplayer, player)
                net.Start("Admin_Sys:Action")
                net.WriteUInt(2, 4)
                net.WriteEntity(player)
                net.WriteBool(false)
                net.SendToServer()
            end,
            callback_func = function(player)
                return player:Alive()
            end,
            callback_name = function(lplayer, player)
                return false
            end,
        },
        {
            name = Admin_System_Global.lang["contextaction_fullarmor"],
            pos = "gauche",

            func = function(lplayer, player)
                net.Start("Admin_Sys:Action")
                net.WriteUInt(4, 4)
                net.WriteEntity(player)
                net.WriteBool(false)
                net.SendToServer()
            end,
            callback_func = function(player)
                return player:Alive()
            end,
            callback_name = function(lplayer, player)
                return false
            end,
        },
        {
            name = Admin_System_Global.lang["contextaction_mute"],
            pos = "gauche",

            func = function(lplayer, player)
                local ipr_Mute = not player:IsMuted()
                player:SetMuted(ipr_Mute)
            end,
            callback_func = function(player)
                return true
            end,
            callback_name = function(lplayer, player)
                return player:IsMuted() and Admin_System_Global.lang["contextaction_unmute"] or Admin_System_Global.lang["contextaction_mute"]
            end,
        },
        {
            name = Admin_System_Global.lang["contextaction_retpos"],
            pos = "gauche",

            func = function(lplayer, player)
                net.Start("Admin_Sys:TP_Reset")
                net.WriteUInt(1, 4)
                net.WriteEntity(player)
                net.SendToServer()
            end,
            callback_func = function(player)
                return player:Alive()
            end,
            callback_name = function(lplayer, player)
                return false
            end,
        },
        {
            name = Admin_System_Global.lang["contextaction_uncuff"],
            pos = "droite",

            func = function(lplayer, player)
                if (RHandcuffsConfig) then
                    lplayer:ConCommand("rhc_cuffplayer " ..player:Nick())
                end
                if (Realistic_Police) then
                    net.Start("Admin_Sys:Action")
                    net.WriteUInt(10, 4)
                    net.WriteEntity(player)
                    net.WriteBool(false)
                    net.SendToServer()
                end
                if (RKidnapConfig) then
                    if player:GetNWBool("rks_restrained") then
                        net.Start("rks_unrestrain")
                        net.WriteEntity(player)
                        net.SendToServer()
                    else
                        lplayer:PrintMessage(HUD_PRINTTALK, "Le joueur n'a pas de serflex, ou est trop loin de votre position !")
                    end
                end
            end,
            callback_func = function(player)
                return player:Alive() and (RHandcuffsConfig) and player:GetNWBool("rhc_cuffed") or (RKidnapConfig and player:GetNWBool("rks_unrestrain")) or (Realistic_Police)
            end,
            callback_name = function(lplayer, player)
                return false
            end,
        },
        {
            name = Admin_System_Global.lang["contextaction_copysteam"],
            pos = "droite",

            func = function(lplayer, player)
                SetClipboardText(player:SteamID())
                lplayer:PrintMessage(HUD_PRINTTALK, Admin_System_Global.lang["ticket_copysteam_t"].. " " ..player:SteamID())
            end,
            callback_func = function(player)
                return true
            end,
            callback_name = function(lplayer, player)
                return false
            end,
        },
        {
            name = "General",
            pos = "droite",

            func = function(lplayer, player)
                lplayer:ConCommand(Admin_System_Global.Cmd_General)
            end,
            callback_func = function(player)
                return true
            end,
            callback_name = function(lplayer, player)
                return false
            end,
        },
        {
            name = "Warn",
            pos = "droite",

            func = function(lplayer, player)
                lplayer:ConCommand("say " ..Admin_System_Global.Action_Warn)
            end,
            callback_func = function(player)
                return true
            end,
            callback_name = function(lplayer, player)
                return false
            end,
        },
        {
            name = "Logs",
            pos = "droite",

            func = function(lplayer, player)
                lplayer:ConCommand("say " ..Admin_System_Global.Action_Logs)
            end,
            callback_func = function(player)
                return true
            end,
            callback_name = function(lplayer, player)
                return false
            end,
        },
        {
            name = Admin_System_Global.lang["contextaction_refund"],
            pos = "droite",

            func = function(lplayer, player)
                lplayer:ConCommand(Admin_System_Global.Remb_Cmd)
            end,
            callback_func = function(player)
                return true
            end,
            callback_name = function(lplayer, player)
                return false
            end,
        },
        {
            name = "Respawn",
            pos = "gauche",

            func = function(lplayer, player)
                if not lplayer:AdminStatusCheck() then
                    return lplayer:PrintMessage(HUD_PRINTTALK, Admin_System_Global.lang["contextaction_adminmod"].. "" ..Admin_System_Global.Mode_Cmd)
                end

                net.Start("Admin_Sys:Action")
                net.WriteUInt(5, 4)
                net.WriteEntity(player)
                net.WriteBool(false)
                net.SendToServer()
            end,
            callback_func = function(player)
                return not player:Alive()
            end,
            callback_name = function(lplayer, player)
                return false
            end,
        },
    },

    Vehicle = {
        {
            name = Admin_System_Global.lang["contextaction_delete"],
            pos = "gauche",

            func = function(lplayer, player)
                net.Start("Admin_Sys:Action")
                net.WriteUInt(9, 4)
                net.WriteEntity(player)
                net.WriteBool(true)
                net.SendToServer()
            end,
            callback_func = function(player)
                return true
            end,
            callback_name = function(lplayer, player)
                return false
            end,
        },
        {
            name = Admin_System_Global.lang["contextaction_fuelmax"],
            pos = "droite",

            func = function(lplayer, player)
                net.Start("Admin_Sys:Action")
                net.WriteUInt(7, 4)
                net.WriteEntity(player)
                net.WriteBool(true)
                net.SendToServer()
            end,
            callback_func = function(player)
                return vcmod1 or SVMOD
            end,
            callback_name = function(lplayer, player)
                return false
            end,
        },
        {
            name = Admin_System_Global.lang["contextaction_repair"],
            pos = "droite",

            func = function(lplayer, player)
                net.Start("Admin_Sys:Action")
                net.WriteUInt(6, 4)
                net.WriteEntity(player)
                net.WriteBool(true)
                net.SendToServer()
            end,
            callback_func = function(player)
                return vcmod1 or SVMOD
            end,
            callback_name = function(lplayer, player)
                return false
            end,
        },
        {
            name = Admin_System_Global.lang["contextaction_ejectowner"],
            pos = "gauche",

            func = function(lplayer, player)
                net.Start("Admin_Sys:Action")
                net.WriteUInt(8, 4)
                net.WriteEntity(player)
                net.WriteBool(true)
                net.SendToServer()
            end,
            callback_func = function(player)
                return IsValid(player:GetDriver())
            end,
            callback_name = function(lplayer, player)
                return false
            end,
        },
    },
}
--- <

--- > [Commandes générales (vous pouvez générer une quantité illimitée de buttons)]
---- // Important : lire ci-dessous si vous souhaitez créer vos propres buttons.
--- Admin_System_Global:AddCmdBut(13, "Custom", "say !admin", "icon16/shield.png") --- Exemple d'un button.
--- Typo à respecter : (1 --> Ordre de positionnement, "Custom" --> Nom du button, "say !admin" --> Commande à executer, "icon16/shield.png" --> Icon)
--- Si votre commande n'est pas une commande console mais seulement disponible via le chat, ajouter say devant votre commande.
--- WIP : Cette fonctionnalité sera disponible dans une prochaine mise à jour :).
timer.Simple(1, function()
    Admin_System_Global:AddCmdBut(1, "Zone Admin", Admin_System_Global.ZoneAdmin_Cmd, "icon16/shield.png")
    Admin_System_Global:AddCmdBut(2, "Stats Admin", Admin_System_Global.Stats_Cmd, "icon16/chart_pie.png")
    Admin_System_Global:AddCmdBut(3, "Remboursement", Admin_System_Global.Remb_Cmd, "icon16/money.png")
    Admin_System_Global:AddCmdBut(4, "Chat Admin", "say " ..Admin_System_Global.Chat_Cmd, "icon16/comments.png")
    Admin_System_Global:AddCmdBut(5, "Admin Config", "say " ..Admin_System_Global.ModeAdmin_Chx, "icon16/cog.png")
    Admin_System_Global:AddCmdBut(6, "Admin Service", "say " ..Admin_System_Global.Service_Cmd, "icon16/user.png")
    Admin_System_Global:AddCmdBut(7, "Mode admin", "say " ..Admin_System_Global.Mode_Cmd, "icon16/eye.png")
    Admin_System_Global:AddCmdBut(8, "Créer un ticket", Admin_System_Global.Ticket_Cmd, "icon16/email_edit.png")
    Admin_System_Global:AddCmdBut(9, "Map optimiser", (Improved_System_Map_Optimiser) and "say !ipr_opti_map" or "none", "icon16/chart_bar_link.png")
    Admin_System_Global:AddCmdBut(10, "Gestion (wip)", "wip", "icon16/lock.png")
    Admin_System_Global:AddCmdBut(11, "Warn (wip)", "wip", "icon16/lock.png")
    Admin_System_Global:AddCmdBut(12, "SAM/ULX", "say !menu", "icon16/application_osx_terminal.png")
    Admin_System_Global:AddCmdBut(13, "Warn", "awarn menu", "icon16/bell.png")
    Admin_System_Global:AddCmdBut(14, "Logs", "say !logs", "icon16/page_white_code.png")
end)