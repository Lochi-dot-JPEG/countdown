Position = Vector.new(0, 0)

PlayerSpeed = 20

local velocity = Vector.new(0, 0)
local gravity = 8
local drag = 5

function Player_Draw()
	local draw_x = love.graphics.getWidth() / 2 - 16
	local draw_y = love.graphics.getHeight() / 2 - 16
	print("drawx " .. draw_x .. " " .. draw_y)
	love.graphics.draw(Textures.player, draw_x, draw_y)
end

local function accel_x(amount)
	velocity.x = velocity.x + amount
end

local function accel_y(amount)
	velocity.y = velocity.y + amount
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
	velocity.y = velocity.y + dt * gravity
	if input_pressed(Inputs.down) then
		accel_y(dt * PlayerSpeed)
	end
	if input_pressed(Inputs.up) then
		accel_y(-dt * PlayerSpeed)
	end
	if input_pressed(Inputs.left) then
		accel_x(-dt * PlayerSpeed)
	end
	if input_pressed(Inputs.right) then
		accel_x(dt * PlayerSpeed)
	end
	velocity.x = velocity.x * (1 - drag * dt)
	velocity.y = velocity.y * (1 - drag * dt)
	move_x(velocity.x)
	move_y(velocity.y)
end
