Outputting = false

local textObject = nil

local drawPosX = GameWidth / 2 - 48
local drawPosY = GameHeight / 2 - 48

function OutputsLoad()
	textObject = love.graphics.newText(AsepriteFont, "output")
end

local function finishOutput()
	Outputting = false
	MoveY(-11)
	SetVelocity(Vector.new(0, -2))
end

function OutputKeypressed(key, scancode, isrepeat)
	if not Outputting then
		return
	end
	if key == "return" then
		finishOutput()
	end
end

function Notify(_text)
	Outputting = true
	print("notifies")
	textObject:set(_text)
end

function OutputUpdate(dt) end

function OutputDraw()
	if Outputting then
		love.graphics.draw(Textures.outputbg, drawPosX - 16, drawPosY - 16)
		love.graphics.draw(textObject, drawPosX, drawPosY)
	end
end
