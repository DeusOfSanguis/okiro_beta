local BASE_WIDTH = 1920
local BASE_HEIGHT = 1080
local scaleX, scaleY

function UpdateScaleFactors()
	scaleX = ScrW() / BASE_WIDTH
	scaleY = ScrH() / BASE_HEIGHT
end

function UpdateScaleFonts()
	gCreateRespFont("DeathScreen:Font24:Lexend", "Lexend", 24)
	gCreateRespFont("DeathScreen:Font18:Lexend", "Lexend", 18)
	gCreateRespFont("DeathScreen:Font16:Lexend", "Lexend", 16)
	gCreateRespFont("Revive:Font24:Lexend", "Lexend", 24)
	gCreateRespFont("Character:TextEntry", "Lexend", 25)
	gCreateRespFont("Character:TextFinish", "Lexend", 30)
	gCreateRespFont("Presentation:Text", "Lexend", 25)
	gCreateRespFont("Presentation:TextBtn", "Lexend", 20)
	gCreateRespFont("Presentation:TextBtn2", "Lexend", 15)
	gCreateRespFont( "M_Font1", "Lexend", 25, 100)
	gCreateRespFont( "M_Font2", "Lexend", 45, 100)
	gCreateRespFont( "M_Font3", "Lexend", 25, 100)
	gCreateRespFont( "M_Font4", "Lexend", 55, 100)
	gCreateRespFont( "M_Font5", "Lexend", 20, 125)
	gCreateRespFont( "MNew_Font1", "Lexend Medium", 33, 100)
	gCreateRespFont( "MNew_Font2", "Lexend", 45, 100)
	gCreateRespFont( "MNew_Font3", "Lexend", 25, 100)
	gCreateRespFont( "MNew_Font4", "Lexend", 55, 100)
	gCreateRespFont( "MNew_Font5", "Lexend", 20, 125)
	gCreateRespFont( "MNew_Font6", "Lexend", 29, 100 )
	gCreateRespFont("LexendRegular", "Lexend", 30, 500, true, false, false, true)
	gCreateRespFont("LexendMedium", "Lexend Medium", 20, 500, true, false, false, true)

end

function gRespX(value)
	return math.Round(value * scaleX)
end

function gRespY(value)
	return math.Round(value * scaleY)
end

function gRespFont(size)
	return math.Round(size * math.min(scaleX, scaleY))
end

function gCreateRespFont(name, fontFamily, baseSize, weight, antialias, shadow, outline)
	local fontData = {
		font = fontFamily,
		size = gRespFont(baseSize),
		weight = weight or 500,
		antialias = antialias or true,
		shadow = shadow or false,
		outline = outline or false
	}
	surface.CreateFont(name, fontData)
end

local function Initialize()
	UpdateScaleFactors()
	UpdateScaleFonts()
end

hook.Add("Initialize", "InitializeResponsiveSystem", Initialize)

hook.Add("OnScreenSizeChanged", "UpdateResponsiveFactors", function()
	Initialize()
end)

Initialize()