local countdown_length = 30
local time = countdown_length
local window_flags = { vsync = 1, resizable = true }

GameWidth = 320
GameHeight = 180
DefaultOffsetX = GameWidth / 2
DefaultOffsetY = GameHeight / 2
TileSize = 16

local love = require("love")
require("input")
require("door")
require("vectors")
require("paper")
require("map")
require("player")
require("prompt")
require("output")

CurrentRoom = nil
Textures = {}

Unlocks = {}
LogUnlocks = {}
Unlocks.base_open = false


AsepriteFont = love.graphics.newFont("textures/aseprite.otf/aseprite.otf", 7)

AsepriteFont:setLineHeight(1.2)
local low_res_canvas

function love.draw()
	love.graphics.setCanvas(low_res_canvas)
	love.graphics.clear(0, 0, 0)

	love.graphics.print("Hello World!", 400, 300)
	love.graphics.print("You have " .. math.floor(time) .. " seconds left!", 400, 350)


	Room.DrawBg(CurrentRoom)
	Player_Draw()
	Room.Draw(CurrentRoom)

	if Prompting then
		PromptDraw()
	elseif Outputting then
		OutputDraw(dt)
	end

	love.graphics.setCanvas()
	love.graphics.clear(0, 0, 0)
	local win_width, win_height = love.graphics.getDimensions()
	love.graphics.draw(low_res_canvas, 0, 0, 0, win_width / GameWidth, win_height / GameHeight)
end

function love.load()
	love.window.setMode(GameWidth * 3, GameHeight * 3, window_flags)
	love.graphics.setDefaultFilter("nearest", "nearest", 0)
	Textures.tile_a = love.graphics.newImage("textures/cookies.png")
	Textures.player = love.graphics.newImage("textures/player.png")
	Textures.base = love.graphics.newImage("textures/base.png")
	Textures.base_back = love.graphics.newImage("textures/baseback.png")
	Textures.prompt = love.graphics.newImage("textures/prompt.png")
	Textures.outputbg = love.graphics.newImage("textures/outputbg.png")
	Textures.paper = love.graphics.newImage("textures/paper.png")

	local roomCount = 9
	for i = 1, roomCount do
		Textures["fg" .. i] = love.graphics.newImage("textures/fg" .. i .. ".png")
		Textures["bg" .. i] = love.graphics.newImage("textures/bg" .. i .. ".png")
	end

	low_res_canvas = love.graphics.newCanvas(GameWidth, GameHeight)
	LoadRooms()
	PromptLoad()
	OutputsLoad()
	CurrentRoom = Rooms.base
end

function love.keypressed(key, scancode, isrepeat)
	if Prompting then
		PromptKeypressed(key, scancode, isrepeat)
	elseif Outputting then
		OutputKeypressed(key, scancode, isrepeat)
	end
end

function love.update(dt)
	time = time - dt
	if Prompting then
		PromptUpdate(dt)
	elseif Outputting then
		OutputUpdate(dt)
	else
		PlayerUpdate(dt)
	end
end
