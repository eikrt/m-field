local Entity = {}
Entity.__index = Entity 

function Entity.new(type,x,y)
  local self = setmetatable({}, Entity)
  self.type = type
  self.drawed = false
  self.x = x
  self.y = y
  self.dmg = 1
  self.hp = 2
  self.char = "¤"
  self.dead = false
  self.faction = "hostile"
  if type == "slime" then
    self.char = "¤"
    self.hp = 1
    self.dmg = 1
  elseif type == "roboworm" then
    self.char = "~"
    self.hp = 2
    self.dmg = 2
  elseif type == "hologram" then
    self.char = "="
    self.hp = 3
    self.dmg = 3
  end
  self.name = type 
  return self
end
function Entity:update(dt, dungeon)
  if self.hp <= 0 then
    self.char = "§"
    self.dead = true
  end
end
function Entity:move(moveset, player)
  if self.dead or self.hp <= 0 then
    return
  end
  local newX, newY = self.x, self.y
  local dir = 0
  if moveset == "random" then
    dir = math.random(0,4)
  end
  if dir == 0 then
    newY = self.y - 1
  elseif dir == 1 then
    newY = self.y + 1
  elseif dir == 2 then
    newX = self.x - 1
  elseif dir == 3 then
    newX = self.x + 1
  end
  if moveset == "target" or moveset == "pathf" then
    local ang = math.atan2(player.y - self.y, player.x - self.x)
    if math.cos(ang) > 0 then
      newX = self.x + math.ceil(math.cos(ang))
    else
      newX = self.x + math.floor(math.cos(ang))
    end
    if math.sin(ang) > 0 then
      newY = self.y + math.ceil(math.sin(ang))
    else
      newY = self.y + math.floor(math.sin(ang))
    end
    newY = self.y + math.ceil(math.sin(ang))
  end
  if moveset == "pathf" then
  end

  local entity = dungeon:get_entity(newX, newY)
  if entity ~= nil then
    dungeon:resolve_conflict("attack", self, entity)
  else
  if dungeon:isPassable(newX, newY) then
    self.x = newX
    self.y = newY
  end
  end
end
function Entity:draw(camera)
  --if self.drawed then
  love.graphics.setColor(1,1,1)
  love.graphics.print(self.char, (self.x - camera.x)* 16 , (self.y - camera.y) * 16 )
  -- end
end

return Entity 
