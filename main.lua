local countdown_length = 30
local time = countdown_length

require('input')
require('vectors')
require('map')
require('player')

Textures = {}

function love.draw()
	love.graphics.print("Hello World!", 400, 300)
	love.graphics.print("You have " .. math.floor(time) .. " seconds left!", 400, 350)
	Room.Draw(Rooms.first_room)
	player_draw()
end

function love.load()
	Textures.tile_a = love.graphics.newImage("textures/cookies.png")
	Textures.player = love.graphics.newImage("textures/player.png")
end

function love.update(dt)
	time = time - dt
	player_update(dt)
end
