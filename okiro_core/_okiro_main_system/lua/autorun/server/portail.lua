hook.Add("InitPostEntity", "SL:Portail:Spawn", function()
    print("Portail:Init ✅")
    
    timer.Create("Portail_Timer", MADSL_TIMER_PORTAIL, 0, function()
        print("Portail Spawn")

        local adminPresent = false
        for _, v in ipairs(player.GetAll()) do
            if v:IsAdmin() or v:IsSuperAdmin() then
                adminPresent = true
                break
            end
        end

        local portalSpawned = false
        for _, v in ipairs(player.GetAll()) do
            if v:HasWeapon("mad_asso_detecteur") then
                portalSpawned = true
                break
            end
        end

        if not adminPresent then
            local portail_rang = ents.Create("portail_sl")
            portail_rang:SetPos(Vector(PORTAIL_SL_POS[math.random(#PORTAIL_SL_POS)]))
            portail_rang.rdmportail = tirerAuSortPortail()
            portail_rang:Spawn()

            if portalSpawned == true then
                portail_rang.ouvert = true
            else
                portail_rang.ouvert = false
            end
        end
    end)
end)

function tirerAuSortPortail()
    local nomsPortails = {}
    for nom, _ in pairs(PORTAIL_SL) do
        table.insert(nomsPortails, nom)
    end

    local indiceAleatoire = math.random(1, #nomsPortails)
    local portailSelectionne = nomsPortails[indiceAleatoire]

    return portailSelectionne
end

concommand.Add("spawnportail", function(ply)
    if not ply:IsAdmin() then return end
    local portail_rang = ents.Create("portail_sl")
    portail_rang:SetPos(Vector( PORTAIL_SL_POS[math.random(#PORTAIL_SL_POS)] )) 
    portail_rang:Spawn()
    portail_rang.ouvert = false
end)