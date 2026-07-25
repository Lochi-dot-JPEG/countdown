Prompting = false

local textObject = nil

local lastRenderedText = ""
local typedText = ""

function Prompt(type)
	Prompting = true
	Unlocks["base_open"] = true
end

function PromptDraw()
	if textObject == nil then
		print(love.graphics.newText(AsepriteFont, "hi"))
		textObject = love.graphics.newText(AsepriteFont, "hi")
	end
	if lastRenderedText ~= typedText then
		textObject:set(typedText)
		lastRenderedText = typedText
	end
	love.graphics.draw(textObject, 0, 0)
end

function love.textinput(t)
	if Prompting then
		if string.len(typedText) >= 4 then
			typedText = ""
		end
		typedText = typedText .. t
	end
end

function PromptUpdate(dt)
	print(Unlocks.base_open)
	if input_pressed(Inputs.continue) then
		Prompting = false
		MoveY(-16)
		SetVelocity(Vector.new(0, -5))
	end
end
