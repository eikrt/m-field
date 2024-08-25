local Hud = {}
Hud.__index = Hud

function Hud.new()
  local self = setmetatable({}, Hud )
  self.status_message = ""
  return self
end

function Hud:draw(player)
  width, height = love.graphics.getDimensions()
  love.graphics.setColor(1,1,1)
  love.graphics.print("Health " .. player.hp .. " Damage " .. player.dmg, 0,height-16)
  love.graphics.setColor(1,1,1)
  love.graphics.print(self.status_message, 0,0)
end

return Hud 
