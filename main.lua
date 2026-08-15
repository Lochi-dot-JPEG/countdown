local base_countdown_length = 20
local countdown_length = base_countdown_length
local battery_capacity = 1
local time = countdown_length
local window_flags = { vsync = 1, resizable = true }

GameWidth = 320
GameHeight = 180
GameAspect = 320 / 180
DefaultOffsetX = GameWidth / 2
DefaultOffsetY = GameHeight / 2
TileSize = 16

love = require("love")

require("input")
require("door")
require("vectors")
require("paper")
require("battery")
require("map")
require("player")
require("prompt")
require("output")

CurrentRoom = nil
Textures = {}

Unlocks = {}
LogUnlocks = {}
Unlocks.base_open = false

local textTimerObject

AsepriteFont = love.graphics.newFont("textures/aseprite.otf/aseprite.otf", 7)

AsepriteFont:setLineHeight(1.2)
local low_res_canvas

function AddBattery()
	battery_capacity = battery_capacity + 1
	countdown_length = base_countdown_length + battery_capacity * 10
end

local function drawUi()
	local newstatus = "Battery: " ..
	    math.ceil(time) .. "\nHull integrity: " .. math.floor(PlayerHp / PLAYER_MAX_HP * 100) .. "%"
	textTimerObject:set(newstatus)
	love.graphics.draw(textTimerObject, 8, 8)
end

function love.draw()
	love.graphics.setCanvas(low_res_canvas)
	love.graphics.clear(2 / 255, 24 / 255, 15 / 255)

	Room.DrawBg(CurrentRoom)
	Player_Draw()
	Room.Draw(CurrentRoom)

	if Outputting then
		OutputDraw(dt)
	elseif Prompting then
		PromptDraw()
	end
	drawUi()

	love.graphics.setCanvas()
	love.graphics.clear(0, 0, 0)
	local win_width, win_height = love.graphics.getDimensions()
	if win_height > win_width / GameAspect then
		win_height = win_width / GameAspect
	else
		win_width = win_height * GameAspect
	end
	love.graphics.draw(low_res_canvas, 0, 0, 0, win_width / GameWidth, win_height / GameHeight)
end

function love.load()
	textTimerObject = love.graphics.newText(AsepriteFont, "hi")
	love.window.setMode(GameWidth * 3, GameHeight * 3, window_flags)
	love.graphics.setDefaultFilter("nearest", "nearest", 0)
	Textures.tile_a = love.graphics.newImage("textures/cookies.png")
	Textures.player = love.graphics.newImage("textures/player.png")
	Textures.base = love.graphics.newImage("textures/base.png")
	Textures.base_back = love.graphics.newImage("textures/baseback.png")
	Textures.prompt = love.graphics.newImage("textures/prompt.png")
	Textures.outputbg = love.graphics.newImage("textures/outputbg.png")
	Textures.paper = love.graphics.newImage("textures/paper.png")
	Textures.battery = love.graphics.newImage("textures/battery.png")

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
	if Outputting then
		OutputKeypressed(key, scancode, isrepeat)
	elseif Prompting then
		PromptKeypressed(key, scancode, isrepeat)
	end
end

function BatteryDead()
	PlayerPos = Vector.new(64, 64)
	PlayerHp = PLAYER_MAX_HP
	SetVelocity(Vector.new(0, 0))

	for _, object in pairs(HoldingObjects) do
		table.insert(object.room.objects, object)
		object:Reset()
	end
	HoldingObjects = {}
end

function love.update(dt)
	if CurrentRoom == Rooms.base then
		time = countdown_length
	end
	time = time - dt
	if time < 0 then
		batteryDead()
	end
	if Outputting then
		OutputUpdate(dt)
	elseif Prompting then
		PromptUpdate(dt)
	else
		PlayerUpdate(dt)
	end
end
