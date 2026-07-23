Position = Vector.new(0, 0)

PlayerSpeed = 200
local last_position


function player_draw()
	local draw_x = love.graphics.getWidth() / 2 - 16
	local draw_y = love.graphics.getHeight() / 2 - 16
	print("drawx " .. draw_x .. " " .. draw_y)
	love.graphics.draw(Textures.player, draw_x, draw_y)
end

function player_update(dt)
	last_position = Vector.new(Position.x, Position.y)
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
	local tile_collision = GetTile(Rooms.first_room, Position)
	if tile_collision ~= nil and tile_collision ~= 0 then
		Position = last_position
	end
end
