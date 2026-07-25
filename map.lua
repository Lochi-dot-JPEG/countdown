Room = {}

tileSize = 16

function Room:new(_tiles, _position, foreground_texture, background_texture)
	newRoom = { position = _position, tiles = _tiles, fg = foreground_texture, bg = background_texture }
	self.__index = self
	return setmetatable(newRoom, self)
end

local function get_draw_pos(room)
	local room_pos = room.position * tileSize - Position

	room_pos.x = room_pos.x + GameWidth / 2 + 16
	room_pos.y = room_pos.y + GameHeight / 2 + 16
	return room_pos
end

function Room:DrawBg()
	local room_pos = get_draw_pos(self)
	love.graphics.draw(self.bg, room_pos.x, room_pos.y)
end

function Room:Draw()
	local room_pos = get_draw_pos(self)
	love.graphics.draw(self.fg, room_pos.x, room_pos.y)
end

Rooms = {}

function LoadRooms()
	Rooms.base = Room:new({
		{ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
		{ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1 },
		{ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "bcomp", 0, 1 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1 },
		{ 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 },
		{ 1, 0, "bdoor", 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
		{ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
	}, Vector.new(-4, -4), Textures.base, Textures.base_back)

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
end

function GetTile(room, position)
	if room == nil then
		return
	end
	local tile_position = position / tileSize
	tile_position.x = math.floor(tile_position.x) - room.position.x
	tile_position.y = math.floor(tile_position.y) - room.position.y
	local tile = nil
	local y = room.tiles[tile_position.y]
	if y ~= nil then
		tile = y[tile_position.x]
	end
	return tile
end
