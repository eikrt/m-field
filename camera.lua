local utils = require "utils"

local Camera = {x = 0, y = 0}
Camera.__index = Camera 
function Camera.new(player, x, y)
  local self = setmetatable({}, Camera)
  self.x = x
  self.y = y
  return self
end

function Camera:update(dt, player)
  width, height = love.graphics.getDimensions()
  self.x = utils.lerp(self.x, player.x - width / 2 / 16, 0.04)
  self.y = utils.lerp(self.y, player.y - height / 2 / 16, 0.04)
end

function Camera:keypressed(key)
end

return Camera
