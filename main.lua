local countdown_length = 30
local time = countdown_length

require('map')

function love.draw()
	love.graphics.print("Hello World!", 400, 300)
	love.graphics.print("You have " .. math.floor(time) .. " seconds left!", 400, 350)
	Room.Draw(Rooms.first_room)
end

function love.update(dt)
	time = time - dt
end
