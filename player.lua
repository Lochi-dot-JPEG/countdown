--PlayerPos = Vector.new(32 - 320, 32)
PlayerPos = Vector.new(32, 32)

PlayerSpeed = 20
PickupDistance = 12 * 12 -- Uses distance squared because square roots are bad

local velocity = Vector.new(0, 0)
local gravity = 2.5
local drag = 1.5
HoldingObjects = {}
local object_offset = Vector.new(TileSize / 2, TileSize / 2)
local flipped = 1

function Player_Draw()
	local draw_x = GameWidth / 2
	local draw_y = GameHeight / 2
	if velocity.x ~= 0 then
		flipped = (math.abs(velocity.x) == velocity.x) and -1 or 1
	end
	love.graphics.draw(Textures.player, draw_x, draw_y, 0, flipped, 1, 16, 16)
	for key, value in pairs(HoldingObjects) do
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
	if tile_collision == 0 then
		for key, object in pairs(CurrentRoom.objects) do
			if object.width ~= nil then
				if object:ContainsPoint(PlayerPos) then
					return 1
				end
			end
		end
	end
	return tile_collision
	--	if tile_collision ~= nil and tile_collision ~= 0 then
	--		return 1
	--	end
	--	return 0
end

local function StoreItems()
	for key, object in pairs(HoldingObjects) do
		if object.id ~= nil and type(object.id) == "string" then
			LogUnlocks[object.id] = true
			print("Adds to log " .. object.id)
		end
		if object.is_battery ~= nil then
			AddBattery()
		end
	end
	HoldingObjects = {}
end

function MoveX(amount)
	local last_position = PlayerPos.x
	PlayerPos.x = PlayerPos.x + amount
	local collider = get_collider()
	if collider == 1 then
		velocity.x = 0
		PlayerPos.x = last_position
	elseif type(collider) == "string" then
		if collider == "comp" then
			StoreItems()
		end
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
		velocity.y = 0
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
			return Rooms.left_center
		elseif tile.x == -1 then
			return Rooms.center_center
		elseif tile.x == 0 then
			return Rooms.right_center
		end
	elseif tile.y == -2 then
		if tile.x == 0 then
			return Rooms.right_top
		elseif tile.x == -1 then
			return Rooms.center_top
		elseif tile.x == -2 then
			return Rooms.left_top
		end
	end
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
	CurrentRoom = GetRoom()
	MoveY(velocity.y * dt * 20)
	CurrentRoom = GetRoom()
	for key, object in pairs(CurrentRoom.objects) do
		if object.position ~= nil then
			local dist = Vector.distance_squared_to(object.position + object_offset, PlayerPos)
			if dist < PickupDistance then
				table.remove(CurrentRoom.objects, key)
				table.insert(HoldingObjects, object)
			end
		end
		if object.width ~= nil then
			if Unlocks[object.unlock] == true then
				table.remove(CurrentRoom.objects, key)
			end
		end
	end
	for key, object in pairs(HoldingObjects) do
		if object.position ~= nil then
			object.position = Vector.lerp(object.position, PlayerPos - object_offset, dt * 3 * (1 + key))
		end
	end
end
