/*---------------------------------------------------------------------------
	Get the bind name from:
        - inEnum: the IN enumeration
---------------------------------------------------------------------------*/

function Diablos.TS:GetBindReference(inEnum)
    local bindResult
    if inEnum == IN_ATTACK then
        bindResult = "attack"
    elseif inEnum == IN_JUMP then
        bindResult = "jump"
    elseif inEnum == IN_DUCK then
        bindResult = "duck"
    elseif inEnum == IN_FORWARD then
        bindResult = "forward"
    elseif inEnum == IN_BACK then
        bindResult = "back"
    elseif inEnum == IN_USE then
        bindResult = "use"
    elseif inEnum == IN_CANCEL then
        bindResult = ""
    elseif inEnum == IN_LEFT then
        bindResult = "left"
    elseif inEnum == IN_RIGHT then
        bindResult = "right"
    elseif inEnum == IN_MOVELEFT then
        bindResult = "moveleft"
    elseif inEnum == IN_MOVERIGHT then
        bindResult = "moveright"
    elseif inEnum == IN_ATTACK2 then
        bindResult = "attack2"
    elseif inEnum == IN_RUN then
        bindResult = "speed"
    elseif inEnum == IN_RELOAD then
        bindResult = "reload"
    elseif inEnum == IN_ALT1 then
        bindResult = "alt1"
    elseif inEnum == IN_ALT2 then
        bindResult = "alt2"
    elseif inEnum == IN_SCORE then
        bindResult = "showscores"
    elseif inEnum == IN_SPEED then
        bindResult = "speed"
    elseif inEnum == IN_WALK then
        bindResult = "walk"
    elseif inEnum == IN_ZOOM then
        bindResult = "zoom"
    elseif inEnum == IN_WEAPON1 then
        bindResult = ""
    elseif inEnum == IN_WEAPON2 then
        bindResult = ""
    elseif inEnum == IN_BULLRUSH then
        bindResult = ""
    elseif inEnum == IN_GRENADE1 then
        bindResult = "grenade1"
    elseif inEnum == IN_GRENADE2 then
        bindResult = "grenade2"
    end

    return bindResult
end

/*---------------------------------------------------------------------------
    Get the key name from:
        - inEnum: the IN enumeration

    This will check the bind reference from inEnum, then get the first key found with that binding for the client
    
    | Example usage:Diablos.TS:GetKeyNameReference(IN_USE)
        | Calls Diablos.TS:GetBindReference(IN_USE) and returns "use"
        | Calls input.LookupBinding("use") and returns "e"
        | Returns "e"
---------------------------------------------------------------------------*/

function Diablos.TS:GetKeyNameReference(inEnum)
    local keyNameResult = input.LookupBinding(Diablos.TS:GetBindReference(inEnum))
    return keyNameResult
end


/*---------------------------------------------------------------------------
    Get the KEY_ enumeration from a keyname

	| Example usage: Diablos.TS:GetKeyReference(Diablos.TS:GetKeyNameReference(IN_RELOAD))
		| Calls Diablos.TS:GetKeyNameReference(IN_RELOAD) and returns "reload"
		| Calls input.LookupBinding("reload") and returns "r"
		| Calls Diablos.TS:GetKeyReference("r")
		| In the keyRef table, r has a value of KEY_R
		| Returns KEY_R
---------------------------------------------------------------------------*/

local keyRef = {
	["0"] = KEY_0,
	["1"] = KEY_1,
	["2"] = KEY_2,
	["3"] = KEY_3,
	["4"] = KEY_4,
	["5"] = KEY_5,
	["6"] = KEY_6,
	["7"] = KEY_7,
	["8"] = KEY_8,
	["9"] = KEY_9,
	["a"] = KEY_A,
	["b"] = KEY_B,
	["c"] = KEY_C,
	["d"] = KEY_D,
	["e"] = KEY_E,
	["f"] = KEY_F,
	["g"] = KEY_G,
	["h"] = KEY_H,
	["i"] = KEY_I,
	["j"] = KEY_J,
	["k"] = KEY_K,
	["l"] = KEY_L,
	["m"] = KEY_M,
	["n"] = KEY_N,
	["o"] = KEY_O,
	["p"] = KEY_P,
	["q"] = KEY_Q,
	["r"] = KEY_R,
	["s"] = KEY_S,
	["t"] = KEY_T,
	["u"] = KEY_U,
	["v"] = KEY_V,
	["w"] = KEY_W,
	["x"] = KEY_X,
	["y"] = KEY_Y,
	["z"] = KEY_Z,
}

function Diablos.TS:GetKeyReference(keyName)
	keyName = string.lower(keyName)
	return keyRef[keyName]
end