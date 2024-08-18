local TargetHitbox = function(Hitbox, func)
	if Hitbox then
		local Halve = Hitbox.Size / 2

		local Offsets = {
			Vector3.new(0, 0, 0); -- Center
			--[
			Vector3.new(-1, 1, -1); -- Back top left
			Vector3.new(-1, 1, 1); -- Back top right
			--Vector3.new(-1, -1, -1); -- Back bottom left
			--Vector3.new(1, -1, -1); -- Front bottom left
			Vector3.new(1, 1, -1); -- Front top left
			Vector3.new(1, 1, 1); -- Front top right
			--Vector3.new(-1, -1, 1); -- Back bottom right
			--Vector3.new(1, -1, 1); -- Front bottom right
			--]]
			--[
			-- Vector3.new(-1, 0, -1); -- Back Center left
			-- Vector3.new(1, 0, -1); -- Front Center left
			-- Vector3.new(1, 0, 1); -- Front Center right
			-- Vector3.new(-1, 0, 1); -- Back Center right
			Vector3.new(0, 1, 0); -- Top center
			-- Vector3.new(0, -1, 0); -- Bottom center
			-- Vector3.new(-1, 0, 0); -- Back
			-- Vector3.new(1, 0, 0); -- Front
			-- Vector3.new(0, 0, 1); -- Right
			-- Vector3.new(0, 0, -1); -- Left
			Vector3.new(0, 1, 1); -- Top right
			Vector3.new(0, 1, -1); -- Top left
			-- Vector3.new(0, -1, 1); -- Bottom right
			-- Vector3.new(0, -1, -1); -- Bottom left
			-- Vector3.new(-1, 0, 0); -- Back
			-- Vector3.new(1, 0, 0); -- Front
			Vector3.new(-1, 1, 0); -- Back top
			Vector3.new(1, 1, 0); -- Front top
			-- Vector3.new(-1, -1, 0); -- Back bottom
			-- Vector3.new(1, -1, 0); -- Front bottom
			--]]
		}

		local Corners = {}

		for i = 1, #Offsets do
			local Offset = Vector3.new(
				Halve.X * (Offsets[i].X * 0.9),
				Halve.Y * (Offsets[i].Y * 0.9),
				Halve.Z * (Offsets[i].Z * 0.9)
			)

			Corners[i] = Hitbox.CFrame:PointToWorldSpace(Offset)
		end

		for i2, pos in pairs(Corners) do
			func(i2, pos)
		end
	end
end
