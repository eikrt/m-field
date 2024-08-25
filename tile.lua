local Tile = {}
Tile.__index = Tile

function Tile.new(type)
  local self = setmetatable({}, Tile)
  self.type = type
  self.drawed = false
  self.bg_color = {0,0,0}
  if type == "wall" then
    self.char = " "
  elseif type == "floor" then
    self.char = "."
  elseif type == "stair_up" then
    self.char = ">"
  elseif type == "stair_down" then
    self.char = "<"
  end
  return self
end

function Tile:draw(x, y)
  if self.drawed then
    love.graphics.setColor(self.bg_color)
    love.graphics.rectangle("fill", x * 16, y * 16, 16, 16)
    love.graphics.setColor(1,1,1)
    love.graphics.print(self.char, x * 16, y * 16)
  end
end

return Tile
