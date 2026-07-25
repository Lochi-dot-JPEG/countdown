Position = Vector.new(0, 0)

PlayerSpeed = 20

local velocity = Vector.new(0, 0)
local gravity = 8
local drag = 5

function Player_Draw()
	local draw_x = GameWidth / 2 - 16
	local draw_y = GameHeight / 2 - 16
	print("drawx " .. draw_x .. " " .. draw_y)
	love.graphics.draw(Textures.player, draw_x, draw_y)
end

local function accel_x(amount)
	velocity.x = velocity.x + amount
end

local function accel_y(amount)
	velocity.y = velocity.y + amount
end

local function get_collider()
	local tile_collision = GetTile(CurrentRoom, Position)
	return tile_collision
	--	if tile_collision ~= nil and tile_collision ~= 0 then
	--		return 1
	--	end
	--	return 0
end

function MoveX(amount)
	local last_position = Position.x
	Position.x = Position.x + amount
	local collider = get_collider()
	if collider == 1 then
		Position.x = last_position
	elseif type(collider) == "string" then
		Prompt(collider)
	end
end

function SetVelocity(_velocity)
	velocity = _velocity
end
function MoveY(amount)
	local last_position = Position.y
	Position.y = Position.y + amount
	local collider = get_collider()
	if collider == 1 then
		Position.y = last_position
	elseif type(collider) == "string" then
		Prompt(collider)
	end
end

function PlayerUpdate(dt)
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
	MoveX(velocity.x)
	MoveY(velocity.y)
	print("velocity" .. velocity.x .. " ," .. velocity.y)
	print("position" .. Position.x .. " ," .. Position.y)
end
