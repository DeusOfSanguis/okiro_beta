local scrW, scrH = ScrW(), ScrH()
local round, min = math.Round, math.min
local scalePerf = min(scrW, scrH) / 1080

function scale(y)
    return round( y * scalePerf )
end

surface.CreateFont( 'mr.font1', {
	font = 'Lexend Medium';
	size = scale(32);
	antialias = true;
	extended = true;
	weight = 350;
} )

surface.CreateFont( 'mr.font1_s', {
	font = 'Lexend Medium';
	size = scale(32);
	antialias = true;
	extended = true;
	weight = 350;
    blursize = 10;
} )

surface.CreateFont( 'mr.font2', {
	font = 'Albert Sans SemiBold';
	size = scale(20);
	antialias = true;
	extended = true;
	weight = 350;
} )

surface.CreateFont( 'mr.font3', {
	font = 'Albert Sans Black';
	size = scale(24);
	antialias = true;
	extended = true;
	weight = 350;
} )

surface.CreateFont( 'mr.font4', {
	font = 'Lexend Medium';
	size = scale(32);
	antialias = true;
	extended = true;
	weight = 350;
} )

local cachedMaterials = {}
local function GetMaterial(path)
    if not cachedMaterials[path] then
        cachedMaterials[path] = Material( path, 'smooth mips' ) --
    end
    return cachedMaterials[path]
end

MagieReroll.UI.GetMaterial = GetMaterial

function MagieReroll.UI.ItemsAreEqual(item1, item2)
    if not item1 or not item2 then return false end
    return item1.name == item2.name and item1.rarity == item2.rarity
end

function MagieReroll.UI.GetPreviewItems()
    local preview = {}
    
    for _, item in ipairs(MagieReroll.Config.Items) do
        table.insert(preview, {
            name = item.name,
            rarity = item.rarity,
            icon = item.icon
        })
    end
    
    for i = #preview, 2, -1 do
        local j = math.random(i)
        preview[i], preview[j] = preview[j], preview[i]
    end
    
    local extendedPreview = {}
    for i = 1, 3 do
        for _, item in ipairs(preview) do
            table.insert(extendedPreview, table.Copy(item))
        end
    end
    
    return extendedPreview
end

function MagieReroll.UI.Image( x, y, w, h, mats, color )
    surface.SetDrawColor( color )
    surface.SetMaterial( mats )
    surface.DrawTexturedRect( x, y, w, h )
end

local shadow_color = Color( 70, 166, 197, 100 )
function MagieReroll.UI.Text( text, font, x, y, color, alignx, aligny )
    draw.SimpleText( text, font.. '_s', x + 1, y + 1, shadow_color, alignx, aligny )
    draw.SimpleText( text, font.. '_s', x - 1, y - 1, shadow_color, alignx, aligny )
    draw.SimpleText( text, font, x, y, color, alignx, aligny )
end

function MagieReroll.UI.Outline( x, y, w, h, color, th )
    surface.SetDrawColor( color )
    surface.DrawOutlinedRect( x, y, w, h, th )
end

function MagieReroll.UI.Box( x, y, w, h, color )
    surface.SetDrawColor( color )
    surface.DrawRect( x, y, w, h )
end

local currencySymbol = '₩'
local thousandSeparator = '.'
function MagieReroll.UI.FormatMoney(amount)
    if not isnumber(amount) then
        return '0' .. currencySymbol
    end
    
    local formatted = math.floor(amount)
    
    local str = tostring(formatted)
    
    local result = ''
    local count = 0
    
    for i = #str, 1, -1 do
        count = count + 1
        result = string.sub(str, i, i) .. result
        
        if count % 3 == 0 and i > 1 then
            result = thousandSeparator .. result
        end
    end
    
    return result .. ' ' .. currencySymbol
end


function MagieReroll.UI.TextBox(padding, x, y, text, font, textColor, bgColor, xAlign, yAlign)
    xAlign = xAlign or TEXT_ALIGN_LEFT
    yAlign = yAlign or TEXT_ALIGN_TOP
    
    surface.SetFont(font)
    
    local textWidth, textHeight = surface.GetTextSize(text)
    
    local bgWidth = textWidth + padding * 2
    local bgHeight = textHeight + padding * 2
    
    local bgX, bgY = x, y
    local textX, textY = x + padding, y + padding
    
    if xAlign == TEXT_ALIGN_CENTER then
        bgX = x - bgWidth / 2
        textX = bgX + padding
    elseif xAlign == TEXT_ALIGN_RIGHT then
        bgX = x - bgWidth
        textX = bgX + padding
    end
    
    if yAlign == TEXT_ALIGN_CENTER then
        bgY = y - bgHeight / 2
        textY = bgY + padding
    elseif yAlign == TEXT_ALIGN_BOTTOM then
        bgY = y - bgHeight
        textY = bgY + padding
    end
    
    MagieReroll.UI.Box( bgX, bgY, bgWidth, bgHeight, bgColor )
    
    draw.SimpleText( text, font, textX, textY, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    return bgWidth
end

function LerpColor(t, from, to)
	return Color(
		(1 - t) * from.r + t * to.r,
		(1 - t) * from.g + t * to.g,
		(1 - t) * from.b + t * to.b,
		(1 - t) * from.a + t * to.a
	)
end