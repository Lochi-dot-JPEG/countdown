Outputting = false

local textObject = nil

local drawPosX = GameWidth / 2 - 48
local drawPosY = GameHeight / 2 - 48

local messageQueue = {}

function OutputsLoad()
	textObject = love.graphics.newText(AsepriteFont, "output")
end

local function updateOutput()
	if #messageQueue == 0 then
		Outputting = false
		Release()
	else
		if textObject ~= nil then
			textObject:set(table.remove(messageQueue, #messageQueue))
		end
	end
end

function OutputKeypressed(key, _, _)
	if not Outputting then
		return
	end
	if key == "return" then
		updateOutput()
	end
end

function Notify(_text)
	Outputting = true
	print("notifies")
	table.insert(messageQueue, _text)

	updateOutput()
end

function OutputUpdate(dt) end

function OutputDraw()
	if Outputting then
		love.graphics.draw(Textures.outputbg, drawPosX - 16, drawPosY - 16)
		love.graphics.draw(textObject, drawPosX, drawPosY)
	end
end
