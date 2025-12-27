include("okiro_scoreboard/sh_config.lua")

if SERVER then 
    AddCSLuaFile("okiro_scoreboard/sh_config.lua")
    AddCSLuaFile("okiro_scoreboard/client/cl_elements.lua")
else     
    include("okiro_scoreboard/client/cl_elements.lua")
end

if SERVER then
  
elseif CLIENT then
end 