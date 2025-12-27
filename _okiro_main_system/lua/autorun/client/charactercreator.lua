net.Receive("SL:Mad - Character:SendClient_1", function(ply) data_1 = net.ReadTable() end)
net.Receive("SL:Mad - Character:SendClient_2", function(ply) data_2 = net.ReadTable() end)
net.Receive("SL:Mad - Character:SendClient_3", function(ply) data_3 = net.ReadTable() end)

local sSoundHover = "mad_sfx_sololeveling/voice/notification.wav"
local sSoundClick = "mad_sfx_sololeveling/voice/ouverture.wav"

net.Receive("SL:OpenCharacterCreatorMenu", function(len, ply)
  net.Start("SL:Mad - Character:Reload")
  net.SendToServer()
  if data_1 == "nil" then
    LocalPlayer():SetNWInt("Perso1", "no")
  elseif data_2 == "nil" then
    LocalPlayer():SetNWInt("Perso2", "no")
  elseif data_3 == "nil" then
    LocalPlayer():SetNWInt("Perso3", "no")
  end

  local ply = LocalPlayer()
  local ply_class_id = ply:GetNWInt("Classe")
  local classe = CLASSES_SL[ply_class_id].name
  local rang = "Ранг " .. ply:GetNWInt("Rang")
  local CharacterCreator = vgui.Create("DFrame")
  CharacterCreator:gSetPos(0, 0)
  CharacterCreator:gSetSize(1920, 1080)
  CharacterCreator:SetTitle("")
  CharacterCreator:MakePopup()
  CharacterCreator:SetDraggable(false)
  CharacterCreator:ShowCloseButton(false)
  CharacterCreator:SetAlpha(0)
  CharacterCreator:AlphaTo(255, 1, 0)
  CharacterCreator.Paint = function(s, self, w, h)

    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(Material("okiro/character/frame.png", "smooth", "clamps"))
    surface.DrawTexturedRect(gRespX(0), gRespY(0), gRespX(1920), gRespY(1080))
   
    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(Material("okiro/character/rectangle_droite.png", "smooth", "clamps"))
    surface.DrawTexturedRect(gRespX(1702), gRespY(43), gRespX(177), gRespY(51))
   
    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(Material("okiro/character/rectangle_milieu.png", "smooth", "clamps"))
    surface.DrawTexturedRect(gRespX(349), gRespY(43), gRespX(1330), gRespY(51))
   
    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(Material("okiro/character/rectangle_gauche.png", "smooth", "clamps"))
    surface.DrawTexturedRect(gRespX(41), gRespY(43), gRespX(288), gRespY(51))
  end

  local QuitButton = vgui.Create("DButton", CharacterCreator)
  QuitButton:gSetPos(1702, 43)
  QuitButton:gSetSize(177, 51)
  QuitButton:SetText("")
  QuitButton:SetZPos(100)
  QuitButton.Paint = function(s, w, h) end
  QuitButton.DoClick = function() RunConsoleCommand("disconnect") end
  if LocalPlayer():GetNWInt("Perso1") == "no" then
    local CharacterOne = vgui.Create("DImage", CharacterCreator)
    CharacterOne:gSetPos(708, 148)
    CharacterOne:gSetSize(504, 855)
    CharacterOne:SetImage("okiro/character/Slots.png", "smooth", "clamps")
    local CharacterOne_Button = vgui.Create("DButton", CharacterCreator)
    CharacterOne_Button:SetText("")
    CharacterOne_Button:gSetPos(708, 148)
    CharacterOne_Button:gSetSize(504, 855)
    CharacterOne_Button.Paint = function(s, self, w, h)
      CharacterOne_Button.DoClick = function()
        if IsValid(CharacterCreator) then CharacterCreator:Remove() end
        CharacterIdentity(1)
      end
    end
  else
    local CharacterOne = vgui.Create("DImage", CharacterCreator)
    CharacterOne:gSetPos(708, 148)
    CharacterOne:gSetSize(504, 855)
    CharacterOne:SetImage("okiro/character/jouer.png", "smooth", "clamps")
    CharacterOne_Icon = vgui.Create("DModelPanel", CharacterCreator)
    CharacterOne_Icon:gSetSize(520, 860)
    CharacterOne_Icon:gSetPos(700, 130)
    CharacterOne_Icon:SetFOV(50)
    CharacterOne_Icon:SetModel(data_1.sl_model)
    local headpos = CharacterOne_Icon.Entity:GetBonePosition(CharacterOne_Icon.Entity:LookupBone("ValveBiped.Bip01_Pelvis"))
    CharacterOne_Icon:SetLookAt(headpos)
    CharacterOne_Icon:SetCamPos(headpos - Vector(-70, 0, 0))
    function CharacterOne_Icon:LayoutEntity(Entity)
      return
    end

    if data_1.sl_genre == "male" then
      CharacterOne_Icon.Entity:SetBodygroup(3, data_1.sl_cheveux)
    else
      CharacterOne_Icon.Entity:SetBodygroup(2, data_1.sl_cheveux)
    end

    CharacterOne_Icon.Entity:SetSkin(data_1.sl_yeux)
    function CharacterOne_Icon.Entity:GetPlayerColor()
      return LocalPlayer():GetPlayerColor()
    end

    local CharacterOne_Button = vgui.Create("DButton", CharacterCreator)
    CharacterOne_Button:SetText("")
    CharacterOne_Button:gSetPos(708, 148)
    CharacterOne_Button:gSetSize(504, 855)
    CharacterOne_Button.Paint = function(s, self, w, h)
      CharacterOne_Button.DoClick = function()
        if IsValid(CharacterCreator) then CharacterCreator:Remove() end
        net.Start("SL:Mad - Character:Load")
        net.WriteFloat(1)
        net.SendToServer()
      end

      local CharacterOne_Name = vgui.Create("DLabel", CharacterCreator)
      CharacterOne_Name:gSetPos(705, 217)
      CharacterOne_Name:gSetSize(500, 50)
      CharacterOne_Name:SetFont("LexendRegular")
      CharacterOne_Name:SetText(data_1.sl_nom .. " " .. data_1.sl_prenom or "Nom Inconnu")
      CharacterOne_Name:SetTextColor(Color(219, 227, 255, 255))
      CharacterOne_Name:SetContentAlignment(5)
    end
  end

  if LocalPlayer():GetUserGroup() == "vip" or LocalPlayer():GetUserGroup() == "admin" or LocalPlayer():GetUserGroup() == "superadmin" then
    if LocalPlayer():GetNWInt("Perso2") == "no" then
      local CharacterTwo = vgui.Create("DImage", CharacterCreator)
      CharacterTwo:gSetPos(184, 148)
      CharacterTwo:gSetSize(504, 855)
      CharacterTwo:SetImage("okiro/character/Slots.png", "smooth", "clamps")
      local CharacterTwo_Button = vgui.Create("DButton", CharacterCreator)
      CharacterTwo_Button:SetText("")
      CharacterTwo_Button:gSetPos(184, 148)
      CharacterTwo_Button:gSetSize(504, 855)
      CharacterTwo_Button.Paint = function(s, self, w, h)
        CharacterTwo_Button.DoClick = function()
          if IsValid(CharacterCreator) then CharacterCreator:Remove() end
          CharacterIdentity(2)
        end
      end
    else
      local CharacterTwo = vgui.Create("DImage", CharacterCreator)
      CharacterTwo:gSetPos(184, 148)
      CharacterTwo:gSetSize(504, 855)
      CharacterTwo:SetImage("okiro/character/jouer.png", "smooth", "clamps")
      CharacterTwo_Icon = vgui.Create("DModelPanel", CharacterCreator)
      CharacterTwo_Icon:gSetSize(520, 860)
      CharacterTwo_Icon:gSetPos(170, 130)
      CharacterTwo_Icon:SetFOV(50)
      CharacterTwo_Icon:SetModel(data_2.sl_model)
      local headpos = CharacterTwo_Icon.Entity:GetBonePosition(CharacterTwo_Icon.Entity:LookupBone("ValveBiped.Bip01_Pelvis"))
      CharacterTwo_Icon:SetLookAt(headpos)
      CharacterTwo_Icon:SetCamPos(headpos - Vector(-70, 0, 0))
      function CharacterTwo_Icon:LayoutEntity(Entity)
        return
      end

      if data_2.sl_genre == "male" then
        CharacterTwo_Icon.Entity:SetBodygroup(3, data_2.sl_cheveux)
      else
        CharacterTwo_Icon.Entity:SetBodygroup(2, data_2.sl_cheveux)
      end

      CharacterTwo_Icon.Entity:SetSkin(data_2.sl_yeux)
      function CharacterTwo_Icon.Entity:GetPlayerColor()
        return LocalPlayer():GetPlayerColor()
      end

      local CharacterTwo_Button = vgui.Create("DButton", CharacterCreator)
      CharacterTwo_Button:SetText("")
      CharacterTwo_Button:gSetPos(184, 148)
      CharacterTwo_Button:gSetSize(504, 855)
      CharacterTwo_Button.Paint = function(s, self, w, h)
        CharacterTwo_Button.DoClick = function()
          if IsValid(CharacterCreator) then CharacterCreator:Remove() end
          net.Start("SL:Mad - Character:Load")
          net.WriteFloat(2)
          net.SendToServer()
        end

        local CharacterTwo_Name = vgui.Create("DLabel", CharacterCreator)
        CharacterTwo_Name:gSetPos(180, 217)
        CharacterTwo_Name:gSetSize(500, 50)
        CharacterTwo_Name:SetFont("LexendRegular")
        CharacterTwo_Name:SetText(data_2.sl_nom .. " " .. data_2.sl_prenom or "Nom Inconnu")
        CharacterTwo_Name:SetTextColor(Color(219, 227, 255, 255))
        CharacterTwo_Name:SetContentAlignment(5)
      end
    end

    if LocalPlayer():GetNWInt("Perso3") == "no" then
      local CharacterThree = vgui.Create("DImage", CharacterCreator)
      CharacterThree:gSetPos(1232, 148)
      CharacterThree:gSetSize(504, 855)
      CharacterThree:SetImage("okiro/character/Slots.png", "smooth", "clamps")
      local CharacterThree_Button = vgui.Create("DButton", CharacterCreator)
      CharacterThree_Button:SetText("")
      CharacterThree_Button:gSetPos(1232, 148)
      CharacterThree_Button:gSetSize(504, 855)
      CharacterThree_Button.Paint = function(s, self, w, h)
        CharacterThree_Button.DoClick = function()
          if IsValid(CharacterCreator) then CharacterCreator:Remove() end
          CharacterIdentity(3)
        end
      end
    else
      local CharacterThree = vgui.Create("DImage", CharacterCreator)
      CharacterThree:gSetPos(1232, 148)
      CharacterThree:gSetSize(504, 855)
      CharacterThree:SetImage("okiro/character/jouer.png", "smooth", "clamps")
      CharacterThree_Icon = vgui.Create("DModelPanel", CharacterCreator)
      CharacterThree_Icon:gSetSize(520, 860)
      CharacterThree_Icon:gSetPos(1240, 130)
      CharacterThree_Icon:SetFOV(50)
      CharacterThree_Icon:SetModel(data_3.sl_model)
      local headpos = CharacterThree_Icon.Entity:GetBonePosition(CharacterThree_Icon.Entity:LookupBone("ValveBiped.Bip01_Pelvis"))
      CharacterThree_Icon:SetLookAt(headpos)
      CharacterThree_Icon:SetCamPos(headpos - Vector(-70, 0, 0))
      function CharacterThree_Icon:LayoutEntity(Entity)
        return
      end

      if data_3.sl_genre == "male" then
        CharacterThree_Icon.Entity:SetBodygroup(3, data_3.sl_cheveux)
      else
        CharacterThree_Icon.Entity:SetBodygroup(2, data_3.sl_cheveux)
      end

      CharacterThree_Icon.Entity:SetSkin(data_3.sl_yeux)
      function CharacterThree_Icon.Entity:GetPlayerColor()
        return LocalPlayer():GetPlayerColor()
      end

      local CharacterThree_Button = vgui.Create("DButton", CharacterCreator)
      CharacterThree_Button:SetText("")
      CharacterThree_Button:gSetPos(1232, 148)
      CharacterThree_Button:gSetSize(504, 855)
      CharacterThree_Button.Paint = function(s, self, w, h)
        CharacterThree_Button.DoClick = function()
          if IsValid(CharacterCreator) then CharacterCreator:Remove() end
          net.Start("SL:Mad - Character:Load")
          net.WriteFloat(3)
          net.SendToServer()
        end

        local CharacterThree_Name = vgui.Create("DLabel", CharacterCreator)
        CharacterThree_Name:gSetPos(1240, 217)
        CharacterThree_Name:gSetSize(500, 50)
        CharacterThree_Name:SetFont("LexendRegular")
        CharacterThree_Name:SetText(data_3.sl_nom .. " " .. data_3.sl_prenom or "Nom Inconnu")
        CharacterThree_Name:SetTextColor(Color(219, 227, 255, 255))
        CharacterThree_Name:SetContentAlignment(5)
      end
    end
  end
end)

local bBoys = false
local bGirls = false
local vCharEntryName
local vCharEntryName2


local function CenterTextEntry(textEntry, placeholder)
  textEntry.Paint = function(self, w, h)
      draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0)) 
      local text = self:GetText()
      
      if text == "" then
          draw.SimpleText(placeholder, self:GetFont(), w / 2, h / 2, Color(200, 200, 200, 150), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
      else
          draw.SimpleText(text, self:GetFont(), w / 2, h / 2, self:GetTextColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
      end
  end
end

function CharacterIdentity(num)
  slot_chara = num
  LocalPlayer():SetNWInt("Creation_Genre", "male")
  local CharacterCreator = vgui.Create("DFrame")
  CharacterCreator:gSetPos(0, 0)
  CharacterCreator:gSetSize(1920, 1080)
  CharacterCreator:SetTitle("")
  CharacterCreator:MakePopup()
  CharacterCreator:SetDraggable(false)
  CharacterCreator:ShowCloseButton(false)

  vCharEntryName = vgui.Create("DTextEntry", CharacterCreator)
    vCharEntryName:SetPos(gRespX(728), gRespY(414))
    vCharEntryName:SetSize(gRespX(464), gRespY(66))
    vCharEntryName:SetFont("Character:TextEntry")
    vCharEntryName:SetTextColor(Color(219, 227, 255, 255))
    vCharEntryName:SetPaintBackground(false)
    vCharEntryName:SetDrawLanguageID(false)
    CenterTextEntry(vCharEntryName, "Entrez votre prénom...")

    vCharEntryName2 = vgui.Create("DTextEntry", CharacterCreator)
    vCharEntryName2:SetPos(gRespX(728), gRespY(489))
    vCharEntryName2:SetSize(gRespX(464), gRespY(66))
    vCharEntryName2:SetFont("Character:TextEntry")
    vCharEntryName2:SetTextColor(Color(219, 227, 255, 255))
    vCharEntryName2:SetPaintBackground(false)
    vCharEntryName2:SetDrawLanguageID(false)
    CenterTextEntry(vCharEntryName2, "Entrez votre nom...")
  vCharEntryName2.OnEnter = function(self) chat.AddText(self:GetValue()) end

  function CharacterCreator:Paint(w, h)
    surface.SetMaterial(Material("okiro/character/frame.png", "noclamp smooth"))
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawTexturedRect(gRespX(0), gRespY(0), gRespX(1920), gRespY(1080))

    surface.SetMaterial(Material("okiro/character/rectangle_gauche.png", "noclamp smooth"))
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawTexturedRect(gRespX(41), gRespY(43), gRespX(288), gRespY(51))

    surface.SetMaterial(Material("okiro/character_manque/box_charcreate.png", "noclamp smooth"))
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawTexturedRect(gRespX(349), gRespY(43), gRespX(1330), gRespY(51))

    surface.SetMaterial(Material("okiro/character/rectangle 22474.png", "noclamp smooth"))
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawTexturedRect(gRespX(708), gRespY(315), gRespX(504), gRespY(341))

    surface.SetMaterial(Material("okiro/character_manque/box_identity.png", "noclamp smooth"))
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawTexturedRect(gRespX(728), gRespY(337), gRespX(464), gRespY(61))

    surface.SetMaterial(Material("okiro/character_manque/category_title.png", "noclamp smooth"))
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawTexturedRect(gRespX(728), gRespY(414), gRespX(464), gRespY(66))

    surface.SetMaterial(Material("okiro/character_manque/category_title.png", "noclamp smooth"))
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawTexturedRect(gRespX(728), gRespY(489), gRespX(464), gRespY(66))

    surface.SetMaterial(Material("okiro/character_manque/progress_identity.png", "noclamp smooth"))
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawTexturedRect(gRespX(700), gRespY(750), gRespX(512), gRespY(41))
    if bBoys == true then
      surface.SetMaterial(Material("okiro/character_manque/box_boys.png", "noclamp smooth"))
      surface.SetDrawColor(255, 255, 255, 255)
      surface.DrawTexturedRect(gRespX(728), gRespY(567), gRespX(464), gRespY(66))
    elseif bGirls == true then
      surface.SetMaterial(Material("okiro/character_manque/box_girl.png", "noclamp smooth"))
      surface.SetDrawColor(255, 255, 255, 255)
      surface.DrawTexturedRect(gRespX(728), gRespY(567), gRespX(464), gRespY(66))
    else
      surface.SetMaterial(Material("okiro/character_manque/box_boys.png", "noclamp smooth"))
      surface.SetDrawColor(255, 255, 255, 255)
      surface.DrawTexturedRect(gRespX(728), gRespY(567), gRespX(464), gRespY(66))
    end
  end

  local vCharBoysBtn = vgui.Create("DButton", CharacterCreator)
  vCharBoysBtn:SetPos(gRespX(728), gRespY(567))
  vCharBoysBtn:SetSize(gRespX(230), gRespY(66))
  vCharBoysBtn:SetText("")
  function vCharBoysBtn:Paint(w, h)
  end
  vCharBoysBtn.OnCursorEntered = function() surface.PlaySound(sSoundHover) end
  vCharBoysBtn.DoClick = function()
    surface.PlaySound(sSoundClick)
    bBoys = true
    bGirls = false
    LocalPlayer():SetNWInt("Creation_Genre", "male")
  end

  local vCharGirlsBtn = vgui.Create("DButton", CharacterCreator)
  vCharGirlsBtn:SetPos(gRespX(963), gRespY(567))
  vCharGirlsBtn:SetSize(gRespX(230), gRespY(66))
  vCharGirlsBtn:SetText("")
  function vCharGirlsBtn:Paint(w, h)
  end

  vCharGirlsBtn.OnCursorEntered = function() surface.PlaySound(sSoundHover) end
  vCharGirlsBtn.DoClick = function()
    surface.PlaySound(sSoundClick)
    bBoys = false
    bGirls = true
    LocalPlayer():SetNWInt("Creation_Genre", "female")
  end

  vCharNextBtn = vgui.Create("DButton", CharacterCreator)
  vCharNextBtn:gSetPos(708, 671)
  vCharNextBtn:gSetSize(504, 67)
  vCharNextBtn:SetText("")
  function vCharNextBtn:Paint(w, h)
    if self:IsHovered() then
      surface.SetDrawColor(255, 255, 255, 255)
      surface.SetMaterial(Material("okiro/character_manque/next.png", "noclamp smooth"))
      surface.DrawTexturedRect(0, 0, w, h)
      draw.RoundedBox(0, gRespX(1), gRespY(1), gRespX(502), gRespY(65), Color(0, 170, 255, 80))
    else
      surface.SetDrawColor(255, 255, 255, 255)
      surface.SetMaterial(Material("okiro/character_manque/next.png", "noclamp smooth"))
      surface.DrawTexturedRect(gRespX(0), gRespY(0), w, h)
    end
  end

  vCharNextBtn.OnCursorEntered = function() surface.PlaySound(sSoundHover) end
  vCharNextBtn.DoClick = function()
    surface.PlaySound(sSoundClick)

    local name = vCharEntryName:GetValue()
    local prenom = vCharEntryName2:GetValue()

    if name == "" or prenom == "" then
        chat.AddText(Color(255, 0, 0), "[Erreur] ", Color(255, 255, 255), "Vous devez entrer un nom et un prénom avant de continuer.")
        return
    end

    CharacterCreator:Remove()
    CharacterApparence(name, prenom)
end

  local vLeaveBtn = vgui.Create("DButton", CharacterCreator)
  vLeaveBtn:SetPos(gRespX(1702), gRespY(43))
  vLeaveBtn:SetSize(gRespX(177), gRespY(51))
  vLeaveBtn:SetText("")
  vLeaveBtn.OnCursorEntered = function() surface.PlaySound(sSoundHover) end
  function vLeaveBtn:Paint(w, h)
    if self:IsHovered() then
      surface.SetDrawColor(255, 255, 255, 255)
      surface.SetMaterial(Material("okiro/character/rectangle_droite.png", "noclamp smooth"))
      surface.DrawTexturedRect(0, 0, w, h)
      draw.RoundedBox(0, gRespX(1), gRespY(1), gRespX(175), gRespY(49), Color(0, 170, 255, 80))
    else
      surface.SetDrawColor(255, 255, 255, 255)
      surface.SetMaterial(Material("okiro/character/rectangle_droite.png", "noclamp smooth"))
      surface.DrawTexturedRect(0, 0, w, h)
    end
  end

  vLeaveBtn.DoClick = function()
    surface.PlaySound(sSoundClick)
    RunConsoleCommand("disconnect")
  end
end

function CharacterApparence(name, prenom)
  local vFrame = vgui.Create("DFrame")
  vFrame:SetSize(ScrW(), ScrH())
  vFrame:Center()
  vFrame:SetTitle("")
  vFrame:SetText("")
  vFrame:ShowCloseButton(false)
  vFrame:SetDraggable(false)
  vFrame:SetSizable(false)
  vFrame:MakePopup()
  function vFrame:Paint(w, h)

    surface.SetMaterial(Material("okiro/character/frame.png", "noclamp smooth"))
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawTexturedRect(gRespX(0), gRespY(0), gRespX(1920), gRespY(1080))

    surface.SetMaterial(Material("okiro/character/rectangle_gauche.png", "noclamp smooth"))
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawTexturedRect(gRespX(41), gRespY(43), gRespX(288), gRespY(51))

    surface.SetMaterial(Material("okiro/character_manque/box_charcreate.png", "noclamp smooth"))
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawTexturedRect(gRespX(349), gRespY(43), gRespX(1330), gRespY(51))

    surface.SetMaterial(Material("okiro/character/rectangle 22474.png", "noclamp smooth"))
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawTexturedRect(gRespX(492), gRespY(263), gRespX(504), gRespY(392))

    surface.SetMaterial(Material("okiro/character_manque/box_apparence.png", "noclamp smooth"))
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawTexturedRect(gRespX(512), gRespY(285), gRespX(464), gRespY(61))

    surface.SetMaterial(Material("okiro/character_manque/progress_body.png", "noclamp smooth"))
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawTexturedRect(gRespX(483), gRespY(750), gRespX(513), gRespY(39))

    surface.SetMaterial(Material("okiro/character_manque/hair_bg.png", "noclamp smooth"))
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawTexturedRect(gRespX(512), gRespY(362), gRespX(464), gRespY(128))

    surface.SetMaterial(Material("okiro/character_manque/pupils_bg.png", "noclamp smooth"))
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawTexturedRect(gRespX(512), gRespY(506), gRespX(464), gRespY(128))
  end

  local vModel = vgui.Create("DModelPanel", vFrame)
  vModel:gSetSize(gRespX(308), gRespY(848))
  vModel:gSetPos(gRespX(1114), gRespY(144))
  vModel:SetFOV(27)
  vModel:SetAnimated(true)
  function vModel:LayoutEntity(ent)
    return
  end

  if bBoys == true then
    vModel:SetModel("models/mad_models/mad_sl_male_civil1.mdl")
  elseif bGirls == true then
    vModel:SetModel("models/mad_models/mad_sl_female1.mdl")
  else
    vModel:SetModel("models/mad_models/mad_sl_male_civil1.mdl")
  end

  local mouseX, mouseY = 0, 0
  local isDragging = false
  local initialAngles
  local initialMouseX, initialMouseY
  local function IconOnMousePressed(panel, mousecode)
    if mousecode == MOUSE_LEFT then
      isDragging = true
      if IsValid(vModel) then
      end

      mouseX, mouseY = gui.MousePos()
      initialMouseX, initialMouseY = mouseX, mouseY
      if IsValid(vModel) then
        initialAngles = vModel:GetCamPos():Angle()
      end
    end
  end

  local function IconOnMouseReleased(panel, mousecode)
    if mousecode == MOUSE_LEFT then isDragging = false end
  end

  local function IconOnCursorMoved(panel, x, y)
    if isDragging then
      if initialAngles == nil then
        return
      end

      local deltaInitialX, deltaInitialY = x - initialMouseX, y - initialMouseY
      local curAngles = initialAngles + Angle(0, -deltaInitialX * 0.5, deltaInitialY * 0.5)
      if IsValid(vModel) then
        vModel:SetCamPos(curAngles:Forward() * 80)
      end

      mouseX, mouseY = x, y
    end
  end

  vModel.OnMousePressed = IconOnMousePressed
  vModel.OnMouseReleased = IconOnMouseReleased
  vModel.OnCursorMoved = IconOnCursorMoved

  local vSlideHair = vgui.Create("DNumSlider", vFrame)
  vSlideHair:gSetPos(205, 400)
  vSlideHair:gSetSize(790, 100)
  vSlideHair:SetText("")
  vSlideHair:SetMin(0)
  vSlideHair:SetMax(42)
  vSlideHair:SetDecimals(0)
  function vSlideHair:Paint(w, h)
    draw.RoundedBox(0, gRespX(335), gRespY(50), gRespX(407), gRespY(9), Color(219, 227, 255, 47))
    local vProgress = (self:GetValue() - self:GetMin()) / (self:GetMax() - self:GetMin())
    draw.RoundedBox(0, gRespX(335), gRespY(50), gRespX(407) * vProgress, gRespY(9), Color(219, 227, 255, 255))
  end
  vSlideHair.OnValueChanged = function(self, value)
    if bBoys == true then
      vModel.Entity:SetBodygroup(3, value)
    elseif bGirls == true then
      vModel.Entity:SetBodygroup(2, value)
    else
      vModel.Entity:SetBodygroup(3, value)
    end
    LocalPlayer():SetNWInt("Creation_Cheveux", value)
  end

  local vSlideEye = vgui.Create("DNumSlider", vFrame)
  vSlideEye:gSetPos(205, 550)
  vSlideEye:gSetSize(790, 100)
  vSlideEye:SetText("")
  vSlideEye:SetMin(0)
  vSlideEye:SetMax(9)
  vSlideEye:SetDecimals(0)
  function vSlideEye:Paint(w, h)
    draw.RoundedBox(0, gRespX(335), gRespY(50), gRespX(407), gRespY(9), Color(219, 227, 255, 47))
    local vProgress = (self:GetValue() - self:GetMin()) / (self:GetMax() - self:GetMin())
    draw.RoundedBox(0, gRespX(335), gRespY(50), gRespX(407) * vProgress, gRespY(9), Color(219, 227, 255, 255))
  end

  vSlideEye.OnValueChanged = function(self, value)
    vModel.Entity:SetSkin(value)
    LocalPlayer():SetNWInt("Creation_Yeux", value)
  end

  vCharNextBtn = vgui.Create("DButton", vFrame)
  vCharNextBtn:gSetPos(492, 671)
  vCharNextBtn:gSetSize(504, 67)
  vCharNextBtn:SetText("")
  function vCharNextBtn:Paint(w, h)
    if self:IsHovered() then
      surface.SetDrawColor(255, 255, 255, 255)
      surface.SetMaterial(Material("okiro/character_manque/next.png", "noclamp smooth"))
      surface.DrawTexturedRect(gRespX(0), gRespY(0), w, h)
      draw.RoundedBox(0, gRespX(1), gRespY(1), gRespX(502), gRespY(65), Color(0, 170, 255, 80))
    else
      surface.SetDrawColor(255, 255, 255, 255)
      surface.SetMaterial(Material("okiro/character_manque/next.png", "noclamp smooth"))
      surface.DrawTexturedRect(gRespX(0), gRespY(0), w, h)
    end
  end
  vCharNextBtn.OnCursorEntered = function() surface.PlaySound(sSoundHover) end
  vCharNextBtn.DoClick = function()
    surface.PlaySound(sSoundClick)
    vFrame:Remove()
    CharacterColor(name, prenom)
  end

  local vLeaveBtn = vgui.Create("DButton", vFrame)
  vLeaveBtn:SetPos(gRespX(1702), gRespY(43))
  vLeaveBtn:SetSize(gRespX(177), gRespY(51))
  vLeaveBtn:SetText("")
  vLeaveBtn.OnCursorEntered = function() surface.PlaySound(sSoundHover) end
  function vLeaveBtn:Paint(w, h)
    if self:IsHovered() then
      surface.SetDrawColor(255, 255, 255, 255)
      surface.SetMaterial(Material("okiro/character/rectangle_droite.png", "noclamp smooth"))
      surface.DrawTexturedRect(gRespX(0),gRespY(0), w, h)
      draw.RoundedBox(0, gRespX(1), gRespY(1), gRespX(175), gRespY(49), Color(0, 170, 255, 80))
    else
      surface.SetDrawColor(255, 255, 255, 255)
      surface.SetMaterial(Material("okiro/character/rectangle_droite.png", "noclamp smooth"))
      surface.DrawTexturedRect(gRespX(0), gRespY(0), w, h)
    end
  end
  vLeaveBtn.DoClick = function()
    surface.PlaySound(sSoundClick)
    RunConsoleCommand("disconnect")
  end
end

function CharacterColor(name, prenom)
  local vFrame = vgui.Create("DFrame")
  vFrame:SetSize(ScrW(), ScrH())
  vFrame:Center()
  vFrame:SetTitle("")
  vFrame:SetText("")
  vFrame:ShowCloseButton(false)
  vFrame:SetDraggable(false)
  vFrame:SetSizable(false)
  vFrame:MakePopup()
  function vFrame:Paint(w, h)
    surface.SetMaterial(Material("okiro/character/frame.png", "noclamp smooth"))
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawTexturedRect(gRespX(0), gRespY(0), gRespX(1920), gRespY(1080))

    surface.SetMaterial(Material("okiro/character/rectangle_gauche.png", "noclamp smooth"))
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawTexturedRect(gRespX(41), gRespY(43), gRespX(288), gRespY(51))

    surface.SetMaterial(Material("okiro/character_manque/box_charcreate.png", "noclamp smooth"))
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawTexturedRect(gRespX(349), gRespY(43), gRespX(1330), gRespY(51))

    surface.SetMaterial(Material("okiro/character/rectangle 22474.png", "noclamp smooth"))
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawTexturedRect(gRespX(492), gRespY(218), gRespX(504), gRespY(480))

    surface.SetMaterial(Material("okiro/character_manque/box_color.png", "noclamp smooth"))
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawTexturedRect(gRespX(512), gRespY(240), gRespX(464), gRespY(61))

    surface.SetMaterial(Material("okiro/character_manque/color_bg.png", "noclamp smooth"))
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawTexturedRect(gRespX(512), gRespY(320), gRespX(464), gRespY(357))

    surface.SetMaterial(Material("okiro/character_manque/progress_color.png", "noclamp smooth"))
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawTexturedRect(gRespX(483), gRespY(795), gRespX(513), gRespY(39))
  end

  local vModel = vgui.Create("DModelPanel", vFrame)
  vModel:gSetSize(gRespX(308), gRespY(848))
  vModel:gSetPos(gRespX(1114), gRespY(144))
  vModel:SetFOV(27)
  vModel:SetAnimated(true)
  function vModel:LayoutEntity(ent)
    return
  end

  if bBoys == true then
    vModel:SetModel("models/mad_models/mad_sl_male_civil1.mdl")
    vModel.Entity:SetBodygroup(3, LocalPlayer():GetNWInt("Creation_Cheveux"))
    vModel.Entity:SetSkin(LocalPlayer():GetNWInt("Creation_Yeux"))
  elseif bGirls == true then
    vModel:SetModel("models/mad_models/mad_sl_female1.mdl")
    vModel.Entity:SetBodygroup(2, LocalPlayer():GetNWInt("Creation_Cheveux"))
    vModel.Entity:SetSkin(LocalPlayer():GetNWInt("Creation_Yeux"))
  else
    vModel:SetModel("models/mad_models/mad_sl_male_civil1.mdl")
    vModel.Entity:SetBodygroup(3, LocalPlayer():GetNWInt("Creation_Cheveux"))
    vModel.Entity:SetSkin(LocalPlayer():GetNWInt("Creation_Yeux"))
  end

  function vModel.Entity:GetPlayerColor() return (LocalPlayer():GetPlayerColor()) end

  local mouseX, mouseY = 0, 0
  local isDragging = false
  local initialAngles
  local initialMouseX, initialMouseY
  local function IconOnMousePressed(panel, mousecode)
    if mousecode == MOUSE_LEFT then
      isDragging = true
      if IsValid(vModel) then
      end

      mouseX, mouseY = gui.MousePos()
      initialMouseX, initialMouseY = mouseX, mouseY
      if IsValid(vModel) then
        initialAngles = vModel:GetCamPos():Angle()
      end
    end
  end

  local function IconOnMouseReleased(panel, mousecode)
    if mousecode == MOUSE_LEFT then isDragging = false end
  end

  local function IconOnCursorMoved(panel, x, y)
    if isDragging then
      if initialAngles == nil then
        return
      end

      local deltaInitialX, deltaInitialY = x - initialMouseX, y - initialMouseY
      local curAngles = initialAngles + Angle(0, -deltaInitialX * 0.5, deltaInitialY * 0.5)
      if IsValid(vModel) then
        vModel:SetCamPos(curAngles:Forward() * 80)
      end

      mouseX, mouseY = x, y
    end
  end

  vModel.OnMousePressed = IconOnMousePressed
  vModel.OnMouseReleased = IconOnMouseReleased
  vModel.OnCursorMoved = IconOnCursorMoved

  local vColorPicker = vgui.Create("DColorMixer", vFrame)
  vColorPicker:gSetSize(414, 264)
  vColorPicker:gSetPos(537, 387)
  vColorPicker:SetAlphaBar(false)
  vColorPicker:SetPalette(false)
  vColorPicker:SetWangs(false)
  vColorPicker.ValueChanged = function(picker, color)
    LocalPlayer():SetPlayerColor(Vector(color.r / 255, color.g / 255, color.b / 255))
    function vModel.Entity:GetPlayerColor()
      return Vector(color.r / 255, color.g / 255, color.b / 255)
    end
  end

  vCharNextBtn = vgui.Create("DButton", vFrame)
  vCharNextBtn:gSetPos(492, 716)
  vCharNextBtn:gSetSize(504, 67)
  vCharNextBtn:SetText("")
  function vCharNextBtn:Paint(w, h)
    if self:IsHovered() then
      surface.SetDrawColor(255, 255, 255, 255)
      surface.SetMaterial(Material("okiro/character_manque/next.png", "noclamp smooth"))
      surface.DrawTexturedRect(gRespX(0), gRespY(0), w, h)
      draw.RoundedBox(0, gRespX(1), gRespY(1), gRespX(502), gRespY(65), Color(0, 170, 255, 80))
    else
      surface.SetDrawColor(255, 255, 255, 255)
      surface.SetMaterial(Material("okiro/character_manque/next.png", "noclamp smooth"))
      surface.DrawTexturedRect(gRespX(0), gRespY(0), w, h)
    end
  end
  vCharNextBtn.OnCursorEntered = function() surface.PlaySound(sSoundHover) end
  vCharNextBtn.DoClick = function()
    surface.PlaySound(sSoundClick)
    vFrame:Remove()
    CharacterConfirm(name, prenom)
  end


  local vLeaveBtn = vgui.Create("DButton", vFrame)
  vLeaveBtn:gSetPos(1702, 43)
  vLeaveBtn:gSetSize(177, 51)
  vLeaveBtn:SetText("")
  vLeaveBtn.OnCursorEntered = function() surface.PlaySound(sSoundHover) end
  function vLeaveBtn:Paint(w, h)
    if self:IsHovered() then
      surface.SetDrawColor(255, 255, 255, 255)
      surface.SetMaterial(Material("okiro/character/rectangle_droite.png", "noclamp smooth"))
      surface.DrawTexturedRect(gRespX(0), gRespY(0), w, h)
      draw.RoundedBox(0, gRespX(1), gRespY(1), gRespX(175), gRespY(49), Color(0, 170, 255, 80))
    else
      surface.SetDrawColor(255, 255, 255, 255)
      surface.SetMaterial(Material("okiro/character/rectangle_droite.png", "noclamp smooth"))
      surface.DrawTexturedRect(gRespX(0), gRespY(0), w, h)
    end
  end

  vLeaveBtn.DoClick = function()
    surface.PlaySound(sSoundClick)
    RunConsoleCommand("disconnect")
  end
end

function CharacterConfirm(name, prenom)
  local vFrame = vgui.Create("DFrame")
  vFrame:gSetSize(1920, 1080)
  vFrame:Center()
  vFrame:SetTitle("")
  vFrame:SetText("")
  vFrame:ShowCloseButton(false)
  vFrame:SetDraggable(false)
  vFrame:SetSizable(false)
  vFrame:MakePopup()
  function vFrame:Paint(w, h)

    surface.SetMaterial(Material("okiro/character/frame.png", "noclamp smooth"))
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawTexturedRect(gRespX(0), gRespY(0), gRespX(1920), gRespY(1080))

    surface.SetMaterial(Material("okiro/character/rectangle_gauche.png", "noclamp smooth"))
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawTexturedRect(gRespX(41), gRespY(43), gRespX(288), gRespY(51))

    surface.SetMaterial(Material("okiro/character_manque/box_charcreate.png", "noclamp smooth"))
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawTexturedRect(gRespX(349), gRespY(43), gRespX(1330), gRespY(51))

    surface.SetMaterial(Material("okiro/character_manque/confirm_bg.png", "noclamp smooth"))
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawTexturedRect(gRespX(492), gRespY(296), gRespX(504), gRespY(244))

    surface.SetMaterial(Material("okiro/character_manque/progress_confirm.png", "noclamp smooth"))
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawTexturedRect(gRespX(483), gRespY(636), gRespX(513), gRespY(39))
  end

  local vModel = vgui.Create("DModelPanel", vFrame)
  vModel:gSetSize(308, 848)
  vModel:gSetPos(1114, 144)
  vModel:SetFOV(27)
  vModel:SetAnimated(true)
  function vModel:LayoutEntity(ent)
    return
  end

  if bBoys == true then
    vModel:SetModel("models/mad_models/mad_sl_male_civil1.mdl")
    vModel.Entity:SetBodygroup(3, LocalPlayer():GetNWInt("Creation_Cheveux"))
    vModel.Entity:SetSkin(LocalPlayer():GetNWInt("Creation_Yeux"))
  elseif bGirls == true then
    vModel:SetModel("models/mad_models/mad_sl_female1.mdl")
    vModel.Entity:SetBodygroup(2, LocalPlayer():GetNWInt("Creation_Cheveux"))
    vModel.Entity:SetSkin(LocalPlayer():GetNWInt("Creation_Yeux"))
  else
    vModel:SetModel("models/mad_models/mad_sl_male_civil1.mdl")
    vModel.Entity:SetBodygroup(3, LocalPlayer():GetNWInt("Creation_Cheveux"))
    vModel.Entity:SetSkin(LocalPlayer():GetNWInt("Creation_Yeux"))
  end

  function vModel.Entity:GetPlayerColor() return (LocalPlayer():GetPlayerColor()) end

  local mouseX, mouseY = 0, 0
  local isDragging = false
  local initialAngles
  local initialMouseX, initialMouseY
  local function IconOnMousePressed(panel, mousecode)
    if mousecode == MOUSE_LEFT then
      isDragging = true
      if IsValid(vModel) then
      end

      mouseX, mouseY = gui.MousePos()
      initialMouseX, initialMouseY = mouseX, mouseY
      if IsValid(vModel) then
        initialAngles = vModel:GetCamPos():Angle()
      end
    end
  end

  local function IconOnMouseReleased(panel, mousecode)
    if mousecode == MOUSE_LEFT then isDragging = false end
  end

  local function IconOnCursorMoved(panel, x, y)
    if isDragging then
      if initialAngles == nil then
        return
      end

      local deltaInitialX, deltaInitialY = x - initialMouseX, y - initialMouseY
      local curAngles = initialAngles + Angle(0, -deltaInitialX * 0.5, deltaInitialY * 0.5)
      if IsValid(vModel) then
        vModel:SetCamPos(curAngles:Forward() * 80)
      end

      mouseX, mouseY = x, y
    end
  end

  vModel.OnMousePressed = IconOnMousePressed
  vModel.OnMouseReleased = IconOnMouseReleased
  vModel.OnCursorMoved = IconOnCursorMoved

  vCharConfirmBtn = vgui.Create("DButton", vFrame)
  vCharConfirmBtn:gSetPos(492, 558)
  vCharConfirmBtn:gSetSize(504, 67)
  vCharConfirmBtn:SetText("")
  function vCharConfirmBtn:Paint(w, h)
    if self:IsHovered() then
      surface.SetDrawColor(255, 255, 255, 255)
      surface.SetMaterial(Material("okiro/character_manque/box_confirm.png", "noclamp smooth"))
      surface.DrawTexturedRect(gRespX(0), gRespY(0), w, h)
      draw.RoundedBox(0, gRespX(1), gRespY(1), gRespX(502), gRespY(65), Color(0, 170, 255, 80))
    else
      surface.SetDrawColor(255, 255, 255, 255)
      surface.SetMaterial(Material("okiro/character_manque/box_confirm.png", "noclamp smooth"))
      surface.DrawTexturedRect(gRespX(0), gRespY(0), w, h)
    end
  end
  vCharConfirmBtn.OnCursorEntered = function() surface.PlaySound(sSoundHover) end
  vCharConfirmBtn.DoClick = function()
    surface.PlaySound(sSoundClick)

    net.Start("SL:Mad - Character:Create")
      net.WriteFloat(slot_chara)
      net.WriteString(LocalPlayer():GetNWInt("Creation_Genre"))
      net.WriteFloat(LocalPlayer():GetNWInt("Creation_Cheveux"))
      net.WriteFloat(LocalPlayer():GetNWInt("Creation_Yeux"))
      net.WriteString(name)
      net.WriteString(prenom)
      net.WriteVector(LocalPlayer():GetPlayerColor())
    net.SendToServer()
    vFrame:Remove()
  end

  local vLeaveBtn = vgui.Create("DButton", vFrame)
  vLeaveBtn:gSetPos(1702, 43)
  vLeaveBtn:gSetSize(177, 51)
  vLeaveBtn:SetText("")
  vLeaveBtn.OnCursorEntered = function() surface.PlaySound(sSoundHover) end
  function vLeaveBtn:Paint(w, h)
    if self:IsHovered() then
      surface.SetDrawColor(255, 255, 255, 255)
      surface.SetMaterial(Material("okiro/character/rectangle_droite.png", "noclamp smooth"))
      surface.DrawTexturedRect(gRespX(0), gRespY(0), w, h)
      draw.RoundedBox(0, gRespX(1), gRespY(1), gRespX(175), gRespY(49), Color(0, 170, 255, 80))
    else
      surface.SetDrawColor(255, 255, 255, 255)
      surface.SetMaterial(Material("okiro/character/rectangle_droite.png", "noclamp smooth"))
      surface.DrawTexturedRect(gRespX(0), gRespY(0), w, h)
    end
  end

  vLeaveBtn.DoClick = function()
    surface.PlaySound(sSoundClick)
    RunConsoleCommand("disconnect")
  end
end