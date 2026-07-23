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
	print("Draws at " .. self.position.x .. ", " .. self.position.y)
	for y = 1, #self.tiles do
		for x = 1, #self.tiles[y] do
			local tile_value = self.tiles[y][x]
			if tile_value == 0 then
				goto continue
			end
			love.graphics.draw(test_texture, x * tileSize, y * tileSize)
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
	{ x = 10, y = 12 }
)
