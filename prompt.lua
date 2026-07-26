Prompting = false

local textObject = nil

local lastRenderedText = "this hasnt been rendered yet"
local typedText = ""
local promptType = ""

local drawPosX = DefaultOffsetX - 10
local drawPosY = DefaultOffsetY - 64
local promptDrawPosX = DefaultOffsetX - 32
local promptDrawPosY = DefaultOffsetY - 16 - 60

local outputs = {}

local function listClues()
	return "Clues: \n1. idk"
end
function PromptLoad()
	outputs.bdoorshut = function()
		Unlocks.base_open = true
		Notify("Opening!")
	end
	outputs.complist = function() Notify(listClues()) end
	outputs.comphelp = function() Notify("Did you need a CLUE?") end
	outputs.compclue = function() Notify("The door is broken.\nMaybe SHUTting it might\ndo something.") end
	textObject = love.graphics.newText(AsepriteFont, "hi")
end

function Prompt(pType)
	promptType = pType
	Prompting = true
	PlayerPos = (GetTileIndex(CurrentRoom, PlayerPos) + CurrentRoom.position) * TileSize
	PlayerPos.x = PlayerPos.x - TileSize / 2
	PlayerPos.y = PlayerPos.y - 6
	typedText = ""
	Unlocks["base_open"] = true
end

function PromptDraw()
	if lastRenderedText ~= typedText then
		textObject:set("> " .. typedText)
		lastRenderedText = typedText
	end
	love.graphics.draw(Textures.prompt, promptDrawPosX, promptDrawPosY)
	love.graphics.draw(textObject, drawPosX, drawPosY)
end

function love.textinput(t)
	if not Prompting then
		return
	end
	if string.len(typedText) < 4 then
		typedText = typedText .. t
		typedText = string.lower(typedText)
	end
end

local function Release()
	Prompting = false
	MoveY(-11)
	SetVelocity(Vector.new(0, -1))
end

local function SubmitCode()
	local attempt = string.lower(promptType .. typedText)
	print("Attempted " .. attempt)
	local attemptResult = outputs[attempt]
	if attemptResult == nil then
		Release()
		return
	end
	attemptResult()
	if not Outputting then
		Release()
	end
	Prompting = false
end


function PromptUpdate(dt) end

function PromptKeypressed(key, scancode, isrepeat)
	if not Prompting then
		return
	end
	if key == "return" then
		SubmitCode()
	end
	if key == "backspace" then
		if string.len(typedText) > 0 then
			typedText = string.sub(typedText, 0, string.len(typedText) - 1)
		end
	end
end
