---- // SCRIPT BY INJ3
---- // https://steamcommunity.com/id/Inj3/

if not (Admin_System_Global.Action_On) then 
     return 
end

local ipr_CTable = {}
ipr_CTable.SysPressed = false
ipr_CTable.Key = MOUSE_LEFT
ipr_CTable.DistancePlayer = 200000
ipr_CTable.DistanceVehicle = 400000
ipr_CTable.BtOld = ""
ipr_CTable.Font = "Admin_Sys_Font_T1"

local function ipr_ButPos(nm, cx, sx, cy, sy, sw, bw, bh, cp)
    ipr_CTable[nm] = {cx = cx, sx = math.Round(sx), cy = cy, sy = math.Round(sy), sw = sw, bw = bw, bh = bh, cp = cp}
    local ipr_sw = not (ipr_CTable[nm].cp) and -ipr_CTable[nm].sw or ipr_CTable[nm].sw

    if ipr_CTable[nm].cx > (ipr_CTable[nm].sx + ipr_sw) and ipr_CTable[nm].cx < (ipr_CTable[nm].sx + ipr_sw) + ipr_CTable[nm].bw and ipr_CTable[nm].cy > ipr_CTable[nm].sy and ipr_CTable[nm].cy < ipr_CTable[nm].sy + ipr_CTable[nm].bh then
        return true
    end
    return false
end

local function ipr_ButPressed(nm, px, py)
     if input.IsMouseDown(ipr_CTable.Key) then
         if not (nm) or (ipr_CTable.BtOld ~= nm) then
             ipr_CTable.BtOld = nm
         end
         draw.RoundedBox(6, px, py, 95, 25 - 2, Color(192, 57, 43))
         if (ipr_CTable.BtOld == nm) then
             if (ipr_CTable.SysPressed) then
                 return false
             end
             ipr_CTable.SysPressed = true
             return true, surface.PlaySound( "buttons/button15.wav" )
         end
     end
     ipr_CTable.SysPressed = false
     return false
end

local ipr_LTarget = {}
local ipr_Pos = {
    ["gauche"] = {
        w = 130,
        a = false,
    },
    ["droite"] = {
        w = 30,
        a = true,
    }
}
local function ipr_LockTarget(ent, bool)
    local ipr_EyePos = not bool and ent:EyePos() or ent:EyePos() + ent:OBBCenter() + Vector(0,0,5)
    ipr_EyePos = ipr_EyePos:ToScreen()
    local ipr_PosX, ipr_PosY = ipr_EyePos.x, ipr_EyePos.y
    if not ipr_LTarget[ent] then
        ipr_LTarget[ent] = {}
    end
    if ipr_LTarget[ent].t then
        if not ipr_LTarget[ent].p then
            ipr_LTarget[ent].x = ipr_PosX
            ipr_LTarget[ent].y = ipr_PosY
            ipr_LTarget[ent].p = true
        end
    else
        ipr_LTarget[ent].x = ipr_PosX
        ipr_LTarget[ent].y = ipr_PosY
        ipr_LTarget[ent].p = false
    end
    return ipr_LTarget[ent].x, ipr_LTarget[ent].y
end

local function Admin_Sys_Context_Action()
    local ipr_Player, ipr_PosPlayer, ipr_LPlayer, ipr_CurTime = ents.FindByClass("player"), {}, LocalPlayer(), CurTime()
    for _, v in ipairs(ipr_Player) do
        if (ipr_LPlayer == v) or v:InVehicle() then
           continue
        end
        local ipr_TargetL = (ipr_LTarget[v] and ipr_LTarget[v].p)
        if not ipr_TargetL and (v:GetPos():DistToSqr(ipr_LPlayer:GetPos()) > ipr_CTable.DistancePlayer) then
            continue
        end
        
        local ipr_PosX, ipr_PosY = ipr_LockTarget(v)
        local ipr_CursorX, ipr_CursorY = input.GetCursorPos()
        for c, h in ipairs(Admin_System_Global.ContextAction.Player) do
            if h.callback_func(v) then
                if not ipr_PosPlayer[v] then
                    ipr_PosPlayer[v] = {}
                end
                if not ipr_PosPlayer[v][h.pos] then
                    ipr_PosPlayer[v][h.pos] = 0
                end
                if ipr_ButPos(h.name, ipr_CursorX, ipr_PosX, ipr_CursorY, ipr_PosY + ipr_PosPlayer[v][h.pos], ipr_Pos[h.pos].w, 95, 25, ipr_Pos[h.pos].a) then
                    draw.RoundedBox(6, ipr_Pos[h.pos].a and ipr_PosX + 30 or ipr_PosX - 130, ipr_PosY + ipr_PosPlayer[v][h.pos], 95, 25, Admin_System_Global.ButContextActionHover)
                    draw.RoundedBox(6, ipr_Pos[h.pos].a and ipr_PosX + 30 or ipr_PosX - 130, ipr_PosY + ipr_PosPlayer[v][h.pos], 95, 25 - 2, Admin_System_Global.ButContextAction)
                    ipr_LTarget[v].t, ipr_LTarget[v].c = true, CurTime() + 1

                    if ipr_ButPressed(h.name, ipr_Pos[h.pos].a and ipr_PosX + 30 or ipr_PosX - 130, ipr_PosY + ipr_PosPlayer[v][h.pos]) then
                        h.func(ipr_LPlayer, v)
                        ipr_CTable.BtOld = h.name
                    end
                else
                    if ipr_LTarget[v].c and (ipr_LTarget[v].c < ipr_CurTime) then
                        ipr_LTarget[v].t = false
                    end
                    draw.RoundedBox(6, ipr_Pos[h.pos].a and ipr_PosX + 30 or ipr_PosX - 130, ipr_PosY + ipr_PosPlayer[v][h.pos], 95, 23, Admin_System_Global.ButContextAction)
                end
                draw.DrawText((h.callback_name) and h.callback_name(ipr_LPlayer, v) or h.name, ipr_CTable.Font, ipr_Pos[h.pos].a and ipr_PosX + 80 or ipr_PosX - 80, ipr_PosY + ipr_PosPlayer[v][h.pos] + 2, Admin_System_Global.ButTextContextAction, TEXT_ALIGN_CENTER)
                ipr_PosPlayer[v][h.pos] = ipr_PosPlayer[v][h.pos] + 28
            end
        end
        draw.SimpleTextOutlined(v:Nick(), ipr_CTable.Font, ipr_PosX, ipr_PosY - 20, Admin_System_Global.ButTextContextAction, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Admin_System_Global.ButContextAction)
        draw.SimpleTextOutlined(ipr_LTarget[v] and ipr_LTarget[v].p and "[Locked]" or "", ipr_CTable.Font, ipr_PosX, ipr_PosY - 40, Admin_System_Global.ButTextContextAction, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Admin_System_Global.ButContextActionHover)
    end
    local ipr_Vehicle, ipr_PosVehicle = ents.FindByClass("prop_vehicle_jeep"), {}
    for _, v in ipairs(ipr_Vehicle) do
        if not v:IsVehicle() then
           continue
        end
        local ipr_TargetL = (ipr_LTarget[v] and ipr_LTarget[v].p)
        if (not ipr_TargetL and v:GetPos():DistToSqr(ipr_LPlayer:GetPos()) > ipr_CTable.DistanceVehicle) then
            continue
        end

        local ipr_PosX, ipr_PosY = ipr_LockTarget(v, true)
        local ipr_CursorX, ipr_CursorY = input.GetCursorPos()
        for c, h in ipairs(Admin_System_Global.ContextAction.Vehicle) do
            if h.callback_func(v) then
                if not ipr_PosVehicle[v] then
                    ipr_PosVehicle[v] = {}
                end
                if not ipr_PosVehicle[v][h.pos] then
                    ipr_PosVehicle[v][h.pos] = 0
                end
                if ipr_ButPos(h.name, ipr_CursorX, ipr_PosX, ipr_CursorY, ipr_PosY + ipr_PosVehicle[v][h.pos], ipr_Pos[h.pos].w, 95, 25, ipr_Pos[h.pos].a) then
                    draw.RoundedBox(6, ipr_Pos[h.pos].a and ipr_PosX + 30 or ipr_PosX - 130, ipr_PosY + ipr_PosVehicle[v][h.pos], 95, 25, Admin_System_Global.ButContextActionHover)
                    draw.RoundedBox(6, ipr_Pos[h.pos].a and ipr_PosX + 30 or ipr_PosX - 130, ipr_PosY + ipr_PosVehicle[v][h.pos], 95, 25 - 2, Admin_System_Global.ButContextAction)
                    ipr_LTarget[v].t, ipr_LTarget[v].c = true, CurTime() + 1

                    if ipr_ButPressed(h.name, ipr_Pos[h.pos].a and ipr_PosX + 30 or ipr_PosX - 130, ipr_PosY + ipr_PosVehicle[v][h.pos]) then
                        h.func(ipr_LPlayer, v)
                        ipr_CTable.BtOld = h.name
                    end
                else
                    if ipr_LTarget[v].c and (ipr_LTarget[v].c < ipr_CurTime) then
                        ipr_LTarget[v].t = false
                    end
                    draw.RoundedBox(6, ipr_Pos[h.pos].a and ipr_PosX + 30 or ipr_PosX - 130, ipr_PosY + ipr_PosVehicle[v][h.pos], 95, 23, Admin_System_Global.ButContextAction)
                end
                draw.DrawText((h.callback_name) and h.callback_name(ipr_LPlayer, v) or h.name, ipr_CTable.Font, ipr_Pos[h.pos].a and ipr_PosX + 80 or ipr_PosX - 80, ipr_PosY + ipr_PosVehicle[v][h.pos] + 2, Admin_System_Global.ButTextContextAction, TEXT_ALIGN_CENTER)             
                ipr_PosVehicle[v][h.pos] = ipr_PosVehicle[v][h.pos] + 28
            end
        end
        draw.SimpleTextOutlined(v, ipr_CTable.Font, ipr_PosX, ipr_PosY - 20, Admin_System_Global.ButTextContextAction, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Admin_System_Global.ButContextAction)
        draw.SimpleTextOutlined(ipr_LTarget[v] and ipr_LTarget[v].p and "[Locked]" or "", ipr_CTable.Font, ipr_PosX, ipr_PosY - 35, Admin_System_Global.ButTextContextAction, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Admin_System_Global.ButContextActionHover)
    end
end

hook.Add("OnContextMenuOpen", "Admin_System_ContextAction_OP", function()
    local ipr_LPlayer = LocalPlayer()
    local ipr_LPlayerUser = ipr_LPlayer:GetUserGroup()
    local ipr_LpGrp = Admin_System_Global.Action_Table[ipr_LPlayerUser]

    if not Admin_System_Global.Action_Perm then
        if (ipr_LpGrp) then
            hook.Add("HUDPaint", "Admin_Sys_Context_Action", Admin_Sys_Context_Action)
        end
    else
        if (ipr_LpGrp) and ipr_LPlayer:AdminStatusCheck() then
            hook.Add("HUDPaint", "Admin_Sys_Context_Action", Admin_Sys_Context_Action)
        end
    end
end)
 
hook.Add("OnContextMenuClose", "Admin_System_ContextAction_CL", function()
     ipr_LTarget = {}
     hook.Remove("HUDPaint","Admin_Sys_Context_Action")
end)