Position = Vector.new(0, 0)

PlayerSpeed = 200
local last_position

function Player_Draw()
	local draw_x = love.graphics.getWidth() / 2 - 16
	local draw_y = love.graphics.getHeight() / 2 - 16
	print("drawx " .. draw_x .. " " .. draw_y)
	love.graphics.draw(Textures.player, draw_x, draw_y)
end

local function move_x(amount)
	local last_position = Position.x
	Position.x = Position.x + amount
	if is_colliding() then
		Position.x = last_position
	end
end

local function move_y(amount)
	local last_position = Position.y
	Position.y = Position.y + amount
	if is_colliding() then
		Position.y = last_position
	end
end

function is_colliding()
	local tile_collision = GetTile(Rooms.first_room, Position)
	if tile_collision ~= nil and tile_collision ~= 0 then
		return true
	end
	return false
end

function player_update(dt)
	if input_pressed(Inputs.down) then
		move_y(dt * PlayerSpeed)
	end
	if input_pressed(Inputs.up) then
		move_y(-dt * PlayerSpeed)
	end
	if input_pressed(Inputs.left) then
		move_x(-dt * PlayerSpeed)
	end
	if input_pressed(Inputs.right) then
		move_x(dt * PlayerSpeed)
	end
end
