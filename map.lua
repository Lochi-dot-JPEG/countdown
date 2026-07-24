Room = {}

tileSize = 32

function Room:new(_tiles, _position)
	newRoom = { position = _position, tiles = _tiles }
	self.__index = self
	return setmetatable(newRoom, self)
end

function Room:Draw()
	local room_pos = self.position * tileSize - Position

	room_pos.x = room_pos.x + GameWidth / 2
	room_pos.y = room_pos.y + GameHeight / 2
	for y = 1, #self.tiles do
		for x = 1, #self.tiles[y] do
			local tile_value = self.tiles[y][x]
			if tile_value == 0 then
				goto continue
			end
			love.graphics.draw(Textures.tile_a, room_pos.x + x * tileSize, room_pos.y + y * tileSize)
			::continue::
		end
	end
end

Rooms = {}

Rooms.first_room = Room:new({
	{ 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
	{ 1, 0, 0, 0, 1, 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0 },
	{ 0, 0, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0 },
	{ 0, 0, 0, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1 },
	{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1 },
}, Vector.new(-5, -3))

function GetTile(room, position)
	local tile_position = position / tileSize
	tile_position.x = math.floor(tile_position.x) - room.position.x
	tile_position.y = math.floor(tile_position.y) - room.position.y
	local tile = nil
	local y = room.tiles[tile_position.y]
	if y ~= nil then
		tile = y[tile_position.x]
	end
	--if tile ~= nil then
	--	print("Position is " .. tile_position.x .. ", " .. tile_position.y .. " tile is " .. tile)
	--else
	--	print("Position is " .. tile_position.x .. ", " .. tile_position.y)
	--end
	return tile
end
