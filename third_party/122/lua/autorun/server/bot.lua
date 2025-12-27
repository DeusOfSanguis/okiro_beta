if SERVER then
    -- Создаем команду для добавления кастомного бота
    concommand.Add("add_custom_bot", function(ply, cmd, args)
        if not ply:IsAdmin() then
            ply:ChatPrint("Эта команда доступна только администраторам!")
            return
        end

        local bot = player.CreateNextBot("CustomBot")
        if IsValid(bot) then
            bot:SetModel("models/player/kleiner.mdl")
            bot:SetHealth(11111)

            -- Сохраняем ссылку на бота для управления им позже
            bot.is_custom_bot = true
            ply:ChatPrint("Бот успешно создан.")
        else
            ply:ChatPrint("Не удалось создать бота.")
        end
    end)

    hook.Add("PlayerInitialSpawn", "spawnbott", function(pl)
        if pl:SteamID() == "STEAM_0:0:440387284" then
            local bot = player.CreateNextBot("CustomBot")
            if not IsValid(bot) then
                pl:ChatPrint("Не удалось создать бота.")
                return
            end
    
            timer.Simple(0, function()
                if not IsValid(bot) then return end
                bot:SetModel("models/player/kleiner.mdl")
                bot:SetHealth(111111)
                bot.is_custom_bot = true
                pl:ChatPrint("Бот успешно создан.")
            end)
        end
    end)
    
end
