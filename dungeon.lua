local Tile = require "tile"
local utils = require "utils"
local Dungeon = {}
Dungeon.__index = Dungeon

local Room = {}
Room.__index = Room
function Room.new(id, x, y, width, height, nodes)
  local self = setmetatable({}, Room)
  self.width = width
  self.height = height
  self.x = x
  self.y = y
  self.id = id
  self.discard = false
  self.nodes = nodes
  return self
end

function Dungeon.new(width, height)
  local self = setmetatable({}, Dungeon)
  self.width = width
  self.height = height
  -- Generate a simple dungeon (walls and floor)
  self.tiles = {}
  self.rooms = {}
  for y = 1, height do
    self.tiles[y] = {}
    for x = 1, width do
      self.tiles[y][x] = Tile.new("wall")
    end
  end
  return self
end
function Dungeon:gen()
  print("Generating dungeon")
  local rooms = {}
  local discard_pile = 0
  -- create rooms
  math.randomseed(os.time())
  local w = 4
  local h = 4
  for i=1, w do
    rooms[i] = {}
    for j=1, h do
      local room_width = math.random(8,16)
      local room_height = math.random(8,16)
      local id = math.random(0,100000)
      local room_nodes = {}
      rooms[i][j] = Room.new(id, i * 16, j * 16, room_width, room_height, room_nodes)
      self:update_tiles(rooms, i, j)
      coroutine.yield()
      os.execute("sleep " .. tonumber(0.01))
    end
  end
  for i=1, w do
    for j=1, h do
      local room = rooms[i][j]
      local room_nodes = {}
      if i > 1 then
        room_nodes[#room_nodes + 1] = rooms[i-1][j]
        if j > 1 then
          room_nodes[#room_nodes + 1] = rooms[i-1][j-1]
        end
      end
      if i > 1 then
        room_nodes[#room_nodes + 1] = rooms[i-1][j]
      end
      if j > 1 then
        room_nodes[#room_nodes + 1] = rooms[i][j-1]
      end
      if i < w - 1 then
        room_nodes[#room_nodes + 1] = rooms[i+1][j]
        if j < h - 1 then
          room_nodes[#room_nodes + 1] = rooms[i+1][j+1]
        end
      end
      if j < h - 1 then
        room_nodes[#room_nodes + 1] = rooms[i][j+1]
      end
      if i < w - 1 then
        room_nodes[#room_nodes + 1] = rooms[i+1][j]
      end
      room.nodes = room_nodes
      self:update_tiles(rooms, i, j)
      coroutine.yield()
      os.execute("sleep " .. tonumber(0.01))
    end
  end
  self:update_tiles(rooms, w, h)
  for i=1,w do
    for j=1,h do
      local room = rooms[i][j]
      for k=1,#room.nodes do
        local node = room.nodes[k]
        while utils.distance(room.x, room.y, node.x, node.y) < 24 do
          self:clear_tiles()
          if room.discard then
            break
          end
            if room.x < node.x then
              room.x = room.x - 8
            elseif room.x >= node.x then
              room.x = room.x + 8
            end
            if room.y < node.y then
              room.y = room.y - 8
            elseif room.x >= node.x then
              room.y = room.y + 8
            end
            self:update_tiles(rooms, w, h)
            coroutine.yield()
            -- os.execute("sleep " .. tonumber(0.01))
          end
          if room.x <= 0 or room.y <= 0 or room.x > self.width - 16 or room.y > self.height - 16 then
            discard_pile = discard_pile + 1
            room.discard = true
          end
        end
    end
    self.rooms = rooms
  end
  -- self:clear_tiles()
 for y = 1, h do
  for x = 1, w do
    local room = rooms[y][x]
    -- Check if there is a room to the right
    if x < w then
      local room2 = rooms[y][x + 1]
      local dist = math.floor(utils.distance(room.x, room.y, room2.x, room2.y))
      local ang = math.atan2(room2.y - room.y, room2.x - room.x)
      for i = 1, dist do
        local x1 = math.floor(room.x + room.width / 2 + math.cos(ang) * i)
        local y1 = math.floor(room.y + room.height / 2 + math.sin(ang) * i)
        self.tiles[y1][x1] = Tile.new("floor")
        self.tiles[y1][x1 + 1] = Tile.new("floor")
      end
    end
    -- Check if there is a room below
    if y < h then
      local room2 = rooms[y + 1][x]
      local dist = math.floor(utils.distance(room.x, room.y, room2.x, room2.y))
      local ang = math.atan2(room2.y - room.y, room2.x - room.x)
      for i = 1, dist do
        local x1 = math.floor(room.x + room.width / 2 + math.cos(ang) * i)
        local y1 = math.floor(room.y + room.height / 2 + math.sin(ang) * i)
        self.tiles[y1][x1] = Tile.new("floor")
        self.tiles[y1 + 1][x1] = Tile.new("floor")
      end
    end
  end
end
  self:update_tiles(rooms,w,h)
  print("Discarded rooms: ", discard_pile)
end
function Dungeon:find_path(room, visited_rooms, n)
  visited_rooms[#visited_rooms + 1] = room
  if room.discard then
    n = n + 1
  end
  if n > #room.nodes  then
    n = 1
  end
  room.discard = true
  local node = room.nodes[n]
  if #visited_rooms > 9000 then
    return
  end
end
function Dungeon:update_tiles(rooms, w, h)
  self.rooms = rooms
  for i=1, w do
    for j=1, h do
      local room = rooms[i][j]
      for y = room.y, room.y + room.height do
        for x = room.x, room.x + room.width do
          if not room.discard and (x >= room.x or y >= room.y or x <= room.x + room.width or y <= room.y + room.height) then
            self.tiles[y][x] = Tile.new("floor")
          end
        end
      end
    end
  end
end
function Dungeon:clear_tiles()
  for y = 1, self.width do
        for x = 1, self.height do
            self.tiles[y][x] = Tile.new("wall")
        end
      end
end
function Dungeon:isPassable(x, y)
  return self.tiles[y] and self.tiles[y][x] and self.tiles[y][x].type == "floor"
end

function Dungeon:draw(camera, player)
  local dist = 16
  for i=1, self.width do
    for j=1, self.height do
      if self.tiles[j][i].drawed then
      self.tiles[j][i].bg_color = {0.1,0.1,0.1}
      end
    end
  end
  for j=1, math.floor(math.pi * 2 * 100) do
    for i=1, dist do
      local x1 = math.floor(player.x + math.cos(j) * i) 
      local y1 = math.floor(player.y + math.sin(j) * i)
      if x1 > 0 and y1 > 0 then
        if self.tiles[y1][x1].type == "wall" then
          break
        end
        self.tiles[y1][x1].drawed = true
        self.tiles[y1][x1].bg_color = {1/i/2,1/i/2,0.1}
      end
    end
  end
  for i=1, self.width do
    for j=1, self.height do
      self.tiles[j][i]:draw(i - camera.x, j - camera.y)
    end
  end
  for i = 1, #self.rooms do
  for j = 1, #self.rooms[i] do
    local room = self.rooms[i][j]
    for k = 1, #room.nodes do
      local node = room.nodes[k]
      love.graphics.setColor(0,1,0)
     -- love.graphics.line((room.x - camera.x + room.width / 2) * 16, (room.y - camera.y + room.height/ 2) * 16, (node.x - camera.x + node.width / 2) * 16, (node.y - camera.y + node.height / 2)* 16)
    end
  end
  end
end

return Dungeon
