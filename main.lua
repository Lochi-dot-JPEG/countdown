local countdown_length = 30
local time = countdown_length
GameWidth = 320
GameHeight = 180
local window_flags = { vsync = 1, resizable = true }

require("input")
require("vectors")
require("map")
require("player")

Textures = {}

local low_res_canvas

function love.draw()
	love.graphics.setCanvas(low_res_canvas)
	love.graphics.clear(0, 0, 0)

	love.graphics.print("Hello World!", 400, 300)
	love.graphics.print("You have " .. math.floor(time) .. " seconds left!", 400, 350)

	Room.Draw(Rooms.first_room)
	Player_Draw()

	love.graphics.setCanvas()
	love.graphics.clear(0, 0, 0)
	local win_width, win_height = love.graphics.getDimensions()
	love.graphics.draw(low_res_canvas, 0, 0, 0, win_width / GameWidth, win_height / GameHeight)
	--love.graphics.draw(low_res_canvas, 0, 0, 0)
end

function love.load()
	love.window.setMode(GameWidth * 3, GameHeight * 3, window_flags)
	love.graphics.setDefaultFilter("nearest", "nearest", 0)
	Textures.tile_a = love.graphics.newImage("textures/cookies.png")
	Textures.player = love.graphics.newImage("textures/player.png")
	low_res_canvas = love.graphics.newCanvas(GameWidth, GameHeight)
end

function love.update(dt)
	time = time - dt
	player_update(dt)
end
