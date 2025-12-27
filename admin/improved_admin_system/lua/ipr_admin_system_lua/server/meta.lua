---- // SCRIPT BY INJ3
---- // https://steamcommunity.com/id/Inj3/

local ipr_Sync = {}
ipr_Sync.Meta = FindMetaTable("Player")
ipr_Sync.Net = "admin_sys:syncvalue"
ipr_Sync.Mat = "Models/effects/vol_light001"
ipr_Sync.Bits = 3

local function ipr_SyncValue(player, bool, int)
     net.Start(ipr_Sync.Net)
     net.WriteUInt(int, ipr_Sync.Bits)
     net.WriteBool(bool)
     net.Send(player)
end

function ipr_Sync.Meta:SysGlobalEnabled()
     self:SysCloakEnabled(true)
     self:SysGodEnabled(true)
     self:SysNoClipEnabled(true)

     ipr_SyncValue(self, true, 4)
end

function ipr_Sync.Meta:SysGlobalDisabled()
     self:SysGodDisabled(true)
     self:SysCloakDisabled(true)
     self:SysNoClipDisabled(true)

     ipr_SyncValue(self, false, 4)
end

function ipr_Sync.Meta:SysCloakEnabled(sync)
     local ipr_WeapClass = self:GetWeapons()
     for _, v in ipairs(ipr_WeapClass) do
         v:SetNoDraw(true)
         v:DrawShadow(false)
     end
 
     local ipr_PhysClass = ents.FindByClass("physgun_beam")
     for _, v in ipairs(ipr_PhysClass) do
         local ipr_Gparent = v:GetParent()
         if (ipr_Gparent ~= self) then
             continue
         end
 
         v:SetNoDraw(true)
         v:DrawShadow(false)
     end
 
     self:SetNoDraw(true)
     self:SetColor(color_black)
     self:SetMaterial(ipr_Sync.Mat)
     self:DrawShadow(false)
     self:SetRenderMode(RENDERMODE_TRANSALPHA)

     if not sync then
     ipr_SyncValue(self, true, 1)
     end
end

function ipr_Sync.Meta:SysCloakDisabled(sync)
     local ipr_WeapClass = self:GetWeapons()
     for _, v in ipairs(ipr_WeapClass) do
         v:SetNoDraw(false)
         v:DrawShadow(true)
     end
 
     local ipr_PhysClass = ents.FindByClass("physgun_beam")
     for _, v in ipairs(ipr_PhysClass) do
         local ipr_Gparent = v:GetParent()
         if (ipr_Gparent ~= self) then
             continue
         end
 
         v:SetNoDraw(false)
         v:DrawShadow(true)
     end
 
     self:SetNoDraw(false)
     self:SetColor(color_white)
     self:SetMaterial("")
     self:DrawShadow(true)
     self:SetRenderMode(RENDERMODE_NORMAL)
 
     if not sync then
     ipr_SyncValue(self, false, 1)
     end
end

function ipr_Sync.Meta:SysGodEnabled(sync)
     self:AddFlags(FL_GODMODE)
     self:AddFlags(FL_NOTARGET)

     self:SetCollisionGroup(1)
     self.SysGodMode = true

     if not sync then
     ipr_SyncValue(self, true, 2)
     end
end

function ipr_Sync.Meta:SysGodDisabled(sync)
     self:RemoveFlags(FL_GODMODE)
     self:RemoveFlags(FL_NOTARGET)

     self:SetCollisionGroup(5)
     self.SysGodMode = false

     if not sync then
     ipr_SyncValue(self, false, 2)
     end
end

function ipr_Sync.Meta:SysNoClipEnabled()
     self:SetMoveType(MOVETYPE_NOCLIP)
end
 
function ipr_Sync.Meta:SysNoClipDisabled()
     self:SetMoveType(MOVETYPE_WALK)
end

function ipr_Sync.Meta:SysStreamerModEnabled()
     self.SysStreamerMod = true

     ipr_SyncValue(self, true, 3)
end
 
function ipr_Sync.Meta:SysStreamerModDisabled()
     self.SysStreamerMod = false

     ipr_SyncValue(self, false, 3)
end