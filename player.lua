PlayerPos = Vector.new(32 - 320, 32)

PlayerSpeed = 20
PickupDistance = 8 * 8

local velocity = Vector.new(0, 0)
local gravity = 2.5
local drag = 1.5
local holding_objects = {}
local object_offset = Vector.new(TileSize / 2, TileSize / 2)

function Player_Draw()
	local draw_x = GameWidth / 2 - 16
	local draw_y = GameHeight / 2 - 16
	love.graphics.draw(Textures.player, draw_x, draw_y)
	for key, value in pairs(holding_objects) do
		value:Draw()
	end
end

local function accel_x(amount)
	velocity.x = velocity.x + amount
end

local function accel_y(amount)
	velocity.y = velocity.y + amount
end

local function get_collider()
	local tile_collision = GetTile(CurrentRoom, PlayerPos)
	return tile_collision
	--	if tile_collision ~= nil and tile_collision ~= 0 then
	--		return 1
	--	end
	--	return 0
end

function MoveX(amount)
	local last_position = PlayerPos.x
	PlayerPos.x = PlayerPos.x + amount
	local collider = get_collider()
	if collider == 1 then
		PlayerPos.x = last_position
	elseif type(collider) == "string" then
		Prompt(collider)
	end
end

function SetVelocity(_velocity)
	velocity = _velocity
end

function MoveY(amount)
	local last_position = PlayerPos.y
	PlayerPos.y = PlayerPos.y + amount
	local collider = get_collider()
	if collider == 1 then
		PlayerPos.y = last_position
	elseif type(collider) == "string" then
		-- TODO check for papers here
		Prompt(collider)
	end
end

-- This is so ugly
local function GetRoom()
	local tile = PlayerPos / 320
	tile.x = math.floor(tile.x)
	tile.y = math.floor(tile.y)
	if tile.y == 0 then
		if tile.x == 0 then
			return Rooms.base
		elseif tile.x == -1 then
			return Rooms.first_room
		elseif tile.x == -2 then
			return Rooms.second_room
		end
	elseif tile.y == -1 then
		if tile.x == -2 then
			print("left center")
			return Rooms.left_center
		elseif tile.x == -1 then
			print("center_center")
			return Rooms.center_center
		elseif tile.x == 0 then
			print("right_center")
			return Rooms.right_center
		end
	elseif tile.y == -2 then
		if tile.x == 0 then
			print("right_top")
			return Rooms.right_top
		elseif tile.x == -1 then
			print("center_top")
			return Rooms.center_top
		elseif tile.x == -2 then
			print("left_top")
			return Rooms.left_top
		end
	end
	print("couldnt find")
	return Rooms.base
end

function PlayerUpdate(dt)
	if input_pressed(Inputs.down) then
		accel_y(dt * PlayerSpeed)
	end
	if input_pressed(Inputs.up) then
		accel_y(-dt * PlayerSpeed)
	else
		velocity.y = velocity.y + dt * gravity
	end
	if input_pressed(Inputs.left) then
		accel_x(-dt * PlayerSpeed)
	end
	if input_pressed(Inputs.right) then
		accel_x(dt * PlayerSpeed)
	end
	velocity.x = velocity.x * (1 - drag * dt)
	velocity.y = velocity.y * (1 - drag * dt)
	MoveX(velocity.x * dt * 20)
	MoveY(velocity.y * dt * 20)
	CurrentRoom = GetRoom()
	for key, object in pairs(CurrentRoom.objects) do
		if object.position ~= nil then
			local dist = Vector.distance_squared_to(object.position + object_offset, PlayerPos)
			print("dist " .. dist)
			if dist < PickupDistance then
				table.remove(CurrentRoom.objects, key)
				table.insert(holding_objects, object)
			end
		end
	end
	for key, object in pairs(holding_objects) do
		if object.position ~= nil then
			object.position = Vector.lerp(object.position, PlayerPos - object_offset, dt * 3 * (1 + key))
		end
	end
end
