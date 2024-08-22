local Player = {}
Player.__index = Player

function Player.new(x, y)
  local self = setmetatable({}, Player)
  self.x = x
  self.y = y
  self.char = "@"
  return self
end

function Player:update(dt, dungeon)
  -- Future updates can go here (e.g., animations, stats)

end

function Player:keypressed(key, dungeon)
  local newX, newY = self.x, self.y
  if key == "w" then
    newY = self.y - 1
  elseif key == "s" then
    newY = self.y + 1
  elseif key == "a" then
    newX = self.x - 1
  elseif key == "d" then
    newX = self.x + 1
  end

  if dungeon:isPassable(newX, newY) then
    self.x = newX
    self.y = newY
  end
end

function Player:draw(camera)

  love.graphics.setColor(1,1,1)
  love.graphics.print(self.char, (self.x - camera.x) * 16  , (self.y - camera.y ) * 16)
end

return Player
