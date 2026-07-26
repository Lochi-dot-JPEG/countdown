Paper = {}
function Paper:new(_position, _id)
	local newPaper = { position = _position * TileSize, id = _id }
	self.__index = self
	return setmetatable(newPaper, self)
end

function Paper:Draw()
	local paper_pos = self.position - PlayerPos
	love.graphics.draw(Textures.paper, paper_pos.x + DefaultOffsetX, paper_pos.y + DefaultOffsetY)
end
