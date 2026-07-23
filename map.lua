Room = {}

tileSize = 32

function love.load()
	test_texture = love.graphics.newImage("textures/cookies.png")
end

function Room:new(_tiles, _position)
	newRoom = { position = _position, tiles = _tiles }
	self.__index = self
	return setmetatable(newRoom, self)
end

function Room:Draw()
	local room_pos = self.position - Position
	for y = 1, #self.tiles do
		for x = 1, #self.tiles[y] do
			local tile_value = self.tiles[y][x]
			if tile_value == 0 then
				goto continue
			end
			love.graphics.draw(test_texture, room_pos.x + x * tileSize, room_pos.y + y * tileSize)
			::continue::
		end
	end
end

Rooms = {}

Rooms.first_room = Room:new(
	{
		{ 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
		{ 1, 0, 0, 0, 1, 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
		{ 0, 0, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, },
		{ 0, 0, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, },
		{ 0, 0, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
		{ 0, 0, 0, 0, 1, 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, },
	},
	Vector.new(10, 12)
)
