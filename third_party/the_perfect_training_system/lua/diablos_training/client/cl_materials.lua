/*---------------------------------------------------------------------------
    Generate the treadmill materials to have a "speed simulation"
	They go from 0 to 50 with a step of 5, this could be changed though.
---------------------------------------------------------------------------*/

function Diablos.TS:GenerateTreadmillMaterials()
	Diablos.TS.Materials["TreadmillMat"] = "Diablos:TS:Materials:Treadmill"

	for speed = 0, 50, 5 do
		speed = tostring(speed)

		CreateMaterial(Diablos.TS.Materials["TreadmillMat"] .. ":" .. speed, "VertexLitGeneric", {
				["$basetexture"] = "models/tptsa/treadmill/floor",
				["Proxies"] = {
					["AnimatedTexture"] =  {
						["animatedTextureVar"] = "$basetexture",
						["animatedTextureFrameNumVar"] = "$frame",
						["animatedTextureFrameRate"] = speed,
					}
				},
			}
		)
	end
end



/*---------------------------------------------------------------------------
	Returns if the logo should be taken online
	WARNING: this function returns false if the config file doesn't specify a logo at all,
	it doesn't mean the logo isn't online, as there is just no logo at all
---------------------------------------------------------------------------*/

function Diablos.TS:IsLogoOnline()
	return string.StartWith(Diablos.TS.IconLogo, "http")
end


/*---------------------------------------------------------------------------
    Call the functions to create the logo materials
	from local or online depending on the result of Diablos.TS:IsLogoOnline()
---------------------------------------------------------------------------*/

function Diablos.TS:GenerateLogoMaterials()
	if Diablos.TS.IconLogo != "" then
		if Diablos.TS:IsLogoOnline() then
			Diablos.TS:GenerateLogoOnline()
			Diablos.TS:DebugConsoleMsg(2, "Retrieving the logo via online...")
		else
			Diablos.TS:GenerateLogoLocal()
			Diablos.TS:DebugConsoleMsg(2, "Retrieving the logo via local...")
		end
	end
end

/*---------------------------------------------------------------------------
    Generate the logo material from the material "mat"
	The material mat is a material already created, from which we recover its name to create the materials we want to have:
	- Diablos.TS.Materials["PunchingLogo"]:
		* material to apply on the punching ball model, whose name is Diablos.TS.Materials["PunchingLogoName"]
	- Diablos.TS.Materials["GUILogo"]:
		* material to apply on the punching ball model, whose name is Diablos.TS.Materials["GUILogoName"]
---------------------------------------------------------------------------*/

function Diablos.TS:GenerateLogoMaterial(mat)

	if mat then

		Diablos.TS:DebugConsoleMsg(2, "Generating the logo " .. mat:GetName() .. "...")

		Diablos.TS.Materials["PunchingLogoName"] = "Diablos:TS:Materials:Punching:Icon"
		Diablos.TS.Materials["GUILogoName"] = "Diablos:TS:Materials:GUI:Icon"

		-- Logo for the punching ball (VertexLitGeneric)
		Diablos.TS.Materials["PunchingLogo"] = CreateMaterial(Diablos.TS.Materials["PunchingLogoName"], "VertexLitGeneric", {
				["$basetexture"] = mat:GetName(),
				["$translucent"] = 1,
				["$smooth"] = 1,
				["$model"] = 1,
			}
		)

		-- Logo for the GUI (UnlitGeneric)
		Diablos.TS.Materials["GUILogo"] = CreateMaterial(Diablos.TS.Materials["GUILogoName"], "UnlitGeneric", {
			["$basetexture"] = mat:GetName(),
			["$translucent"] = 1,
			["$smooth"] = 1,
		}
	)

	end
end


/*---------------------------------------------------------------------------
    Create the punching icon material local:
		- Use the basic Material() function (as the image is put in the server in local)
		- Call the Diablos.TS:GenerateLogoMaterial(mat) method
---------------------------------------------------------------------------*/

function Diablos.TS:GenerateLogoLocal()

	local punchingIcon = Material(Diablos.TS.IconLogo, "smooth")

	Diablos.TS:GenerateLogoMaterial(punchingIcon)

end

/*---------------------------------------------------------------------------
    Create the punching icon material online:
		- Creates a DHTML panel with a custom body to put the icon logo in background
			* Made to work for all image resolutions automatically (with background-size: contain)
		- Get the HTML material of that page by using a custom timer (because there could be some time for the DHTML to be prepared)
		- Call the Diablos.TS:GenerateLogoMaterial(mat) method
---------------------------------------------------------------------------*/

function Diablos.TS:GenerateLogoOnline()

	local htmlPanel = vgui.Create("DHTML")

	local htmlCode = [[
        <html>
            <head>
                <style>
                    body {
						background-image: url("]] .. Diablos.TS.IconLogo .. [[");
						background-position: center;
						background-size: contain;
						background-repeat: no-repeat;
                        background-attachment: fixed;
						overflow: hidden;
					}
                </style>
            </head>
            <body>
			</body>
        </html>
	]]

	htmlPanel:SetHTML(htmlCode)

	-- Hide the panel and the console messages

	htmlPanel:SetAlpha(0)
	htmlPanel:SetMouseInputEnabled(false)

	function htmlPanel:ConsoleMessage(msg) end

	local html_mat = htmlPanel:GetHTMLMaterial()

	local timerName = "TPTSA:GenerateMaterial:Icon:" .. LocalPlayer():SteamID64()

	-- We launch this until the html material is generated - if it's not generated after delay * repetitions then we forget about the generation
	timer.Create(timerName, 0.5, 10, function()
		if IsValid(htmlPanel) then
			html_mat = htmlPanel:GetHTMLMaterial()
			if html_mat then
				Diablos.TS:GenerateLogoMaterial(html_mat)

				timer.Remove(timerName)
			end
		else
			timer.Remove(timerName)
		end
	end)
end

/*---------------------------------------------------------------------------
    Generate materials on startup when a client is coming.
	This will generate:
		- Treadmill materials to have a "speed simulation"
		- Logo materials (if the setting is used by the server)
---------------------------------------------------------------------------*/

function Diablos.TS:GenerateMaterialsOnStartup()
	Diablos.TS:GenerateTreadmillMaterials() -- generate treadmill materials
	Diablos.TS:GenerateLogoMaterials() -- generate logo material
end