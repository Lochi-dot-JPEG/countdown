Prompting = false

local textObject = nil

local lastRenderedText = "this hasnt been rendered yet"
local typedText = ""
local drawPosX = GameWidth / 2 - 10
local drawPosY = GameHeight / 2 - 64
local promptDrawPosX = GameWidth / 2 - 32
local promptDrawPosY = GameHeight / 2 - 16 - 60

function Prompt(type)
	Prompting = true
	PlayerPos = (GetTileIndex(CurrentRoom, PlayerPos) + CurrentRoom.position) * tileSize
	PlayerPos.x = PlayerPos.x + tileSize / 2
	PlayerPos.y = PlayerPos.y + 10
	typedText = ""
	Unlocks["base_open"] = true
end

function PromptDraw()
	if textObject == nil then
		print(love.graphics.newText(AsepriteFont, "hi"))
		textObject = love.graphics.newText(AsepriteFont, "hi")
	end
	if lastRenderedText ~= typedText then
		textObject:set("> " .. typedText)
		lastRenderedText = typedText
	end
	love.graphics.draw(Textures.prompt, promptDrawPosX, promptDrawPosY)
	love.graphics.draw(textObject, drawPosX, drawPosY)
end

function love.keypressed(key, scancode, isrepeat)
	if not Prompting then
		return
	end
	if key == "backspace" then
		if string.len(typedText) > 0 then
			typedText = string.sub(typedText, 0, string.len(typedText) - 1)
		end
	end
end

function love.textinput(t)
	if not Prompting then
		return
	end
	if string.len(typedText) < 4 then
		typedText = typedText .. t
	end
end

function FinishPrompt()
	Prompting = false
	MoveY(-16)
	SetVelocity(Vector.new(0, -5))
end

function PromptUpdate(dt)
	print(Unlocks.base_open)
	if input_pressed(Inputs.continue) then
		FinishPrompt()
	end
end
