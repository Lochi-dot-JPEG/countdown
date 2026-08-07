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
	local output = "Entries:"

	for key, value in pairs(LogUnlocks) do
		output = output .. "\n- " .. string.upper(key)
	end
	return output
end

local logs = {
	loga =
	"I left all of my thoughts\ndown on notes like this one\n. If anyone finds them, use\nthem to navigate this place.",
	logb = "I coded that door wrong.\nInstead of opening it have to \nSHUT it :(",

	logc =
	"I built some murder drones\nto chase down any other murder\n drones that come in. \nI hope they don't \nTURN against me.",

	logd =
	"Up above me, I create\na really strong password on the\nwall to keep my colleagues out\nof getting into the top lab.",

	loge =
	"This little shortcut opens when I input\nopen SESAme.",
}

local function showClue(name)
	if LogUnlocks[name] ~= nil then
		Notify(logs[name])
	end
end

function PromptLoad()
	-- Tutorial
	outputs.complist = function() Notify(listClues()) end
	outputs.comphelp = function() Notify("Did you need a CLUE?") end
	outputs.compclue = function() Notify("The door is broken.\nMaybe SHUTting it might\ndo something.") end
	outputs.compman = function() Notify("this isn't a real terminal") end
	outputs.compls = function() Notify(listClues()) end
	outputs.bdoorshut = function()
		Unlocks.base_open = true
		Notify("Opening!")
	end
	outputs.shortcutsesa = function()
		Unlocks.shortcut = true
		Notify("Open sesame!")
	end

	-- Fun
	outputs.comphiya = function() Notify("Hiiii!") end
	outputs.compturn = function() Notify("Turn what?") end

	-- Logs
	outputs.comploga = function() showClue("loga") end
	outputs.complogb = function() showClue("logb") end
	outputs.complogc = function() showClue("logc") end
	outputs.complogd = function() showClue("logd") end
	outputs.comploge = function() showClue("loge") end

	-- Level Computers

	textObject = love.graphics.newText(AsepriteFont, "hi")
end

function Prompt(pType)
	promptType = pType
	Prompting = true
	PlayerPos = (GetTileIndex(CurrentRoom, PlayerPos) + CurrentRoom.position) * TileSize
	PlayerPos.x = PlayerPos.x - TileSize / 2
	PlayerPos.y = PlayerPos.y - 6
	typedText = ""
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
	SetVelocity(Vector.new(0, -2))
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
