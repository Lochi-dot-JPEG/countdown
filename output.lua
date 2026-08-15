Outputting = false

local textObject = nil

local drawPosX = GameWidth / 2 - 48
local drawPosY = GameHeight / 2 - 48

local messageQueue = {}

function OutputsLoad()
	textObject = love.graphics.newText(AsepriteFont, "output")
end

local function wrap(message, max_len)
	local new_message = ""
	local char_count = 0
	message = string.gsub(message, "\n", "")
	for word in string.gmatch(message, "%a+") do
		char_count = char_count + string.len(word) + 1
		if char_count > max_len then
			new_message = new_message .. "\n"
			char_count = 0
		end
		new_message = new_message .. " " .. word
	end
	return new_message
end

local function nextOutput()
	if #messageQueue == 0 then
		Outputting = false
		Release()
		return
	end

	if textObject ~= nil then
		Outputting = true
		print("next messages")
		local new_message = table.remove(messageQueue, #messageQueue)
		new_message = wrap(new_message, 24)
		textObject:set(new_message)
	end
end

local function updateOutput()
	if #messageQueue == 0 then
		Outputting = false
		Release()
	end
	if not Outputting then
		nextOutput()
	end
end

function OutputKeypressed(key, _, _)
	if not Outputting then
		return
	end
	if key == "return" then
		nextOutput()
	end
end

function Notify(_text)
	--Outputting = true
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
