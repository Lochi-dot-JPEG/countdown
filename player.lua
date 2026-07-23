Position = Vector.new(0, 0)


PlayerSpeed = 200

function player_update(dt)
	if input_pressed(Inputs.down) then
		Position.y = Position.y + dt * PlayerSpeed
	end
	if input_pressed(Inputs.up) then
		Position.y = Position.y - dt * PlayerSpeed
	end
	if input_pressed(Inputs.left) then
		Position.x = Position.x - dt * PlayerSpeed
	end
	if input_pressed(Inputs.right) then
		Position.x = Position.x + dt * PlayerSpeed
	end
	print("Position is " .. Position.x .. ", " .. Position.y)
end
