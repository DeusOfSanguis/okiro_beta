/*---------------------------------------------------------------------------
	Create fonts we need for all the menus
---------------------------------------------------------------------------*/

local scrwRatio = ScrW() / 1920

local function CreateFont(sizeFont, boldValue, italicValue)
	local fontName = "Diablos:Font:TS:" .. sizeFont
	local curWeight = 400
	if boldValue then
		fontName = fontName .. ":B"
		curWeight = 900
	end
	if italicValue then
		fontName = fontName .. ":I"
	end
	surface.CreateFont(fontName, {
		font = "Roboto Condensed",
		size = sizeFont * scrwRatio,
		weight = curWeight,
		italic = italicValue,
	})
end

local fontsToCreate = {
	["regular"] = {15, 20, 25, 30, 35, 40, 45, 50, 60, 65, 80},
	["bold"] = {15, 20, 25, 30, 35, 40, 45},
	["italic"] = {15, 20, 25, 30, 35, 45},
}

for _, fontSize in pairs(fontsToCreate["regular"]) do
	CreateFont(fontSize, false, false)
end

for _, fontSize in pairs(fontsToCreate["bold"]) do
	CreateFont(fontSize, true, false)
end

for _, fontSize in pairs(fontsToCreate["italic"]) do
	CreateFont(fontSize, false, true)
end