if SERVER then
	if not ref then
		ref = {}
		local files = file.Find("particles/*.pcf", "GAME")

		for _, kr in pairs(files) do
			if not ref[kr] then
				game.AddParticles("particles/" .. kr)
			end
			ref[kr] = true
		end

		print('Loaded total ', #files, ' particle systems')
	end

print("cac")

	util.AddNetworkString("ghhtrez")
	util.AddNetworkString("dfeza")

	function fdetz(name)
		PrecacheParticleSystem(name)
		print("Precaching effect: " .. name)
		net.Start("ghhtrez")
		net.WriteString(name)
		net.Broadcast()
	end

	local za = {}

	net.Receive("dfeza", function(len, pl)
		local name = net.ReadString()
		if table.HasValue(ref, name) then return end

		local plza = za[pl]
		if plza then
			if #plza < 50 then 
				plza[#plza+1] = name
			end
		else
			plza = {name}
			za[pl] = plza
			local function processza()
				if #plza == 0 then
					za[pl] = nil
				else
					timer.Simple(0.5, processza)
					fdetz(table.remove(plza, 1))
				end
			end
			processza()
		end
	end)
end

if CLIENT then
	net.Receive("ghhtrez", function()
		local name = net.ReadString()
		print("Effect precached: " .. name)
	end)

	function Requestfdetz(name)
		net.Start("dfeza")
		net.WriteString(name)
		net.SendToServer()
	end
end
