MEL_ScoreBoard = MEL_ScoreBoard or {}
MEL_ScoreBoard.Materials = MEL_ScoreBoard.Materials or {}
MEL_ScoreBoard.Color = MEL_ScoreBoard.Color or {}
MEL_ScoreBoard.Translate = MEL_ScoreBoard.Tranlate or {}
MEL_ScoreBoard.Config = MEL_ScoreBoard.Tranlate or {}

MEL_ScoreBoard.Config = {
    ["ClickSound"] = "sound/mel.wav",
    ["VIPGroup"] = {
        ["vip"] = true,
        ["premium"] = true,
        ["supreme"] = true,
        ["newgenien"] = true,
        ["VIP"] = true,
    },
}

MEL_ScoreBoard.Color = {
    ["Bleu1"] = Color(30, 34, 38),
    ["Bleu2"] = Color(23, 26, 29),
    ["Rouge1"] = Color(29, 23, 23),
    ["Rouge2"] = Color(38, 30, 30),
    ["Blanc"] = Color(255, 255, 255),
}

MEL_ScoreBoard.Translate = {
    ["Nom"] = "Имя",
    ["SteamID"] = "SteamID",
    ["Grade"] = "Ранг",
    ["Meurtre"] = "Убийства",
    ["Mort"] = "Смерти",
    ["Argent"] = "Деньги",
    ["Métier"] = "Профессия",
    ["Vie"] = "Здоровье",
    ["Armure"] = "Броня",
    ["Faim"] = "Голод",
    ["Bannissement"] = "ban",
    ["Expulsé"] = "kick",
    ["Téléporter"] = "bring",
    ["Goto"] = "Goto",
    ["Invincible"] = "God mod",
    ["Invisible"] = "cloak",
    ["Enlever Les Armes"] = "strip",
    ["Changer De Jobs"] = "set job(test)",
    ["Geler"] = "freeze",
}

MEL_ScoreBoard.Materials = {
    ["BackGround"] = Material("okiro/f4/base.png"),
    ["Goto"] = Material("okiro/mel_tab/gotoop.png"),
    ["Cube"] = Material("okiro/mel_tab/gotoop.png"),
    ["Freeze"] = Material("okiro/mel_tab/freezeop.png"),
    ["Helicopter"] = Material("mel_tabhelicopterop.png"),
    ["Illuminati"] = Material("okiro/mel_tab/illuminatiop.png"),
    ["Invisible"] = Material("okiro/mel_tab/invisibleop.png"),
    ["Magie"] = Material("okiro/mel_tab/magieop.png"),
    ["Marteau"] = Material("okiro/mel_tab/marteauop.png"),
    ["Fond1"] = Material("okiro/mel_tab/scoreboardmainop.png"),
    ["Fond2"] = Material("okiro/mel_tab/scoreboardsecondop.png"),
    ["SetTeam"] = Material("okiro/mel_tab/setteamop.png"),
    ["Strip"] = Material("okiro/mel_tab/stripop.png"),
    ["SuperAdmin"] = Material("okiro/mel_tab/superadminop.png"),
    ["User"] = Material("okiro/mel_tab/userop.png"),
    ["VIP"] = Material("okiro/mel_tab/vipop.png"),
    ["0a100"] = Material("okiro/mel_tab/0a100pingop.png"),
    ["100a200"] = Material("okiro/mel_tab/100a200pingop.png"),
    ["200a300"] = Material("okiro/mel_tab/200a300pingop.png"),
    ["300a400"] = Material("okiro/mel_tab/300a400pingop.png"),
    ["400a500"] = Material("okiro/mel_tab/400a500pingop.png"),
    ["500a600"] = Material("okiro/mel_tab/500a600pingop.png"),
}