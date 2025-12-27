---- // SCRIPT BY INJ3
---- // https://steamcommunity.com/id/Inj3/

local ipr_GCMD = {}
ipr_GCMD.GCmd = false
ipr_GCMD.GuiP = false

local function Admin_Sys_General_Cmd()
    if IsValid(ipr_GCMD.GuiP) then
        return
    end
    if not (ipr_GCMD.GCmd) then
        ipr_GCMD.GCmd = Admin_System_Global:AddCmdBut(nil, nil, nil, nil, true) or {}
    end
    local Admin_Sys_CountTable, Admin_Sys_TableMax = #ipr_GCMD.GCmd, 3
    local Admin_Sys_Math, Admin_Sys_Count_Math = math.ceil(Admin_Sys_CountTable / Admin_Sys_TableMax), 0
    local Admin_Sys_Count_MT = Admin_Sys_Math - Admin_Sys_Math
    local Admin_Sys_Gradient, Admin_Sys_Col, Admin_SysCountAnim = surface.GetTextureID("gui/gradient"), Color(52,73,94), 0

    ipr_GCMD.GuiP = vgui.Create("DFrame")
    local Admin_Sys_Frame_Dimage = vgui.Create("DImageButton", ipr_GCMD.GuiP)

    ipr_GCMD.GuiP:SetTitle("")
    ipr_GCMD.GuiP:SetSize(Admin_System_Global:Size_Auto(430, "w"), Admin_Sys_Math * Admin_System_Global:Size_Auto(47, "h") + Admin_System_Global:Size_Auto(80, "h"))
    ipr_GCMD.GuiP:ShowCloseButton(false)
    ipr_GCMD.GuiP:Center()
    ipr_GCMD.GuiP:MakePopup()
    ipr_GCMD.GuiP:AlphaTo(5, 0, 0)
    ipr_GCMD.GuiP:AlphaTo(255, 1.5, 0)

    local function Admin_Sys_AnimQuad(AddSys_Delta, AddSys_PosA, AddSys_PosB)
        return AddSys_PosB * (AddSys_Delta % 2) + AddSys_PosA
    end
    local Admin_Sys_Frame_Anim = Derma_Anim("Admin_SysAnimLoad", ipr_GCMD.GuiP, function(pnl, anim, delta, data)
        pnl:SetPos(Admin_Sys_AnimQuad(delta, 0, ScrW() / 2 - Admin_System_Global:Size_Auto(225, "w")), ScrH() / 2 - Admin_System_Global:Size_Auto(125, "h"))
    end)
    Admin_Sys_Frame_Anim:Start(1)

    local Admin_SysCurAnim = CurTime() + 1
    ipr_GCMD.GuiP.AnimationThink = function()
        if Admin_Sys_Frame_Anim:Active() then
            Admin_Sys_Frame_Anim:Run()
            
            local ipr_Cur = CurTime()
            if (ipr_Cur > Admin_SysCurAnim) then
                ipr_GCMD.GuiP:SetAnimationEnabled(false)
            end
        end
    end
    ipr_GCMD.GuiP.Paint = function(self, w, h)
        local Admin_Sys_Abs = math.abs(math.sin(CurTime() * 1.5) * 170)
        Admin_System_Global:Gui_Blur(self, 1, Color( 0, 0, 0, 170 ), 8)
        draw.RoundedBox(6, 0, 0, w, Admin_System_Global:Size_Auto(26, "h"), Admin_System_Global.CmdGeneralColor)
        draw.DrawText(Admin_System_Global.lang["general_cmd"], "Admin_Sys_Font_T1", w/2, Admin_System_Global:Size_Auto(5, "h"), Admin_System_Global.CmdGeneralColorTitle, TEXT_ALIGN_CENTER)
        draw.DrawText("v" ..Admin_System_Global.Version.. " by Inj3", "Admin_Sys_Font_T1", w-Admin_System_Global:Size_Auto(5, "w"),h - Admin_System_Global:Size_Auto(18, "h"), Color(Admin_Sys_Abs, Admin_Sys_Abs, Admin_Sys_Abs, Admin_Sys_Abs), TEXT_ALIGN_RIGHT)
    end

    local ipr_Local = LocalPlayer()
    for Admin_Sys_Count = 1 , Admin_Sys_CountTable do
        local Admin_Sys_Frame_BT, Admin_Sys_Lerp, Admin_Sys_Lerp_An = vgui.Create("DButton", ipr_GCMD.GuiP), 0, 0.05
        Admin_Sys_Frame_BT:SetSize(Admin_System_Global:Size_Auto(130, "w"), Admin_System_Global:Size_Auto(25, "h"))
        Admin_Sys_Frame_BT:SetText("")
        Admin_Sys_Frame_BT:SetIcon(ipr_GCMD.GCmd[Admin_Sys_Count].Icon)
        Admin_Sys_Frame_BT:Center()
        local Admin_Sys_Count_Math_, Admin_Sys_Count_MT_ = Admin_Sys_Count_Math, Admin_Sys_Count_MT
        local Admin_Sys_Frame_Anim = Derma_Anim("Admin_SysAnimLoad" ..ipr_GCMD.GCmd[Admin_Sys_Count].Name, Admin_Sys_Frame_BT, function(pnl, anim, delta, data)
            pnl:SetPos(Admin_Sys_AnimQuad(delta, 0, Admin_Sys_Count_Math_ * Admin_System_Global:Size_Auto(140, "w") + Admin_System_Global:Size_Auto(10, "w")), Admin_Sys_AnimQuad(delta, 0, Admin_Sys_Count_MT_ * Admin_System_Global:Size_Auto(53, "h") + Admin_System_Global:Size_Auto(45, "h")))
        end)
        Admin_Sys_Frame_Anim:Start(Admin_SysCountAnim + 1)
        Admin_Sys_Frame_BT.Think = function(self)
            if Admin_Sys_Frame_Anim:Active() then
                Admin_Sys_Frame_Anim:Run()
            end
        end
        Admin_Sys_Frame_BT.Paint = function(self, w, h)
            surface.SetDrawColor(Admin_Sys_Col)
            surface.SetTexture(Admin_Sys_Gradient)
            surface.DrawTexturedRect(0, 0, w + 50 , h)

            local ipr_Hover = self:IsHovered()
            Admin_Sys_Lerp = (ipr_Hover) and Lerp(Admin_Sys_Lerp_An, Admin_Sys_Lerp, w - Admin_System_Global:Size_Auto(3, "w")) or 0
            draw.RoundedBox(6, 2, 0, Admin_Sys_Lerp, 1, Color(192, 57, 43, 230))

            if (ipr_GCMD.GCmd[Admin_Sys_Count].Commands == "say " ..Admin_System_Global.Mode_Cmd) then
                draw.DrawText(ipr_Local:AdminStatusCheck() and "Admin Mode ✘" or "Admin Mode ✔", "Admin_Sys_Font_T3", w/2 + Admin_System_Global:Size_Auto(8, "w"), Admin_System_Global:Size_Auto(5, "h"), ipr_Local:AdminStatusCheck() and Color(192, 57, 43) or Color(39, 174, 96), TEXT_ALIGN_CENTER )
                return
            end
            draw.DrawText(ipr_GCMD.GCmd[Admin_Sys_Count].Name or "nil", "Admin_Sys_Font_T3", w/2 + Admin_System_Global:Size_Auto(8, "w"), Admin_System_Global:Size_Auto(5, "h"), Admin_System_Global.CmdGeneralColorButText, TEXT_ALIGN_CENTER )
        end
        Admin_Sys_Frame_BT.DoClick = function()
            if (ipr_GCMD.GCmd[Admin_Sys_Count].Commands == "wip") then
                ipr_Local:PrintMessage( HUD_PRINTTALK, Admin_System_Global.lang["general_cmd_available"])
                return
            end
            if (ipr_GCMD.GCmd[Admin_Sys_Count].Commands == "none") then
                ipr_Local:PrintMessage( HUD_PRINTTALK, "Le script n'est pas détecté, veuillez l'installer !")
                return
            end
            if not (Admin_System_Global.TicketLoad) and (ipr_GCMD.GCmd[Admin_Sys_Count].Commands == Admin_System_Global.Ticket_Cmd) then
                ipr_Local:PrintMessage( HUD_PRINTTALK, "This feature is disabled by owner.")
                return
            end
            ipr_Local:ConCommand(ipr_GCMD.GCmd[Admin_Sys_Count].Commands)

            if (timer.Exists("Admin_Sys_Frame_Anim")) then
                timer.Remove("Admin_Sys_Frame_Anim")
            end
            ipr_GCMD.GuiP:Remove()
        end
        Admin_Sys_Count_Math = Admin_Sys_Count_Math + 1
        if (Admin_Sys_Count_Math >= Admin_Sys_TableMax) then
            Admin_Sys_Count_Math = 0
            Admin_Sys_Count_MT = Admin_Sys_Count_MT + 1
        end
    end

    Admin_Sys_Frame_Dimage:SetPos(ipr_GCMD.GuiP:GetWide() - Admin_System_Global:Size_Auto(20, "w"), Admin_System_Global:Size_Auto(5, "h"))
    Admin_Sys_Frame_Dimage:SetSize(Admin_System_Global:Size_Auto(17, "w"),Admin_System_Global:Size_Auto(17, "h"))
    Admin_Sys_Frame_Dimage:SetImage("icon16/cross.png")
    function Admin_Sys_Frame_Dimage:Paint(w,h) end
    Admin_Sys_Frame_Dimage.DoClick = function()
        if (timer.Exists("Admin_Sys_Frame_Anim")) then
            timer.Remove("Admin_Sys_Frame_Anim")
        end
        ipr_GCMD.GuiP:Remove()
    end
end
Admin_System_Global:AddGui(1, Admin_Sys_General_Cmd)