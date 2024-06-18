local old; old = hookmetamethod(game, "__namecall", function(self, ...)
	local method = string.lower(getnamecallmethod())
	
	if method == "fireserver" then
		for i = 2, 4 do
			local source, name = debug.info(i, "sn")

			if source and source:match("Actions") and name == "Fire" then
				local firstArg = ...

				if select("#", ...) <= 0 then
					game.GetService(game, "StarterGui").SetCore(game.GetService(game, "StarterGui"), "DevConsoleVisible", true)

					warn("1 BAN INCOMMING 0 ARGS", debug.traceback())

					return
				elseif firstArg == game.GetService(game, "Players").LocalPlayer.UserId then
					game.GetService(game, "StarterGui").SetCore(game.GetService(game, "StarterGui"), "DevConsoleVisible", true)

					warn("1 BAN INCOMMING 0 ARGS USERID", debug.traceback())

					return
				end
			end
		end
	end

	return old(self, ...)
end)
