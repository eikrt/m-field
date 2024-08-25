local Player = require "player"
local Dungeon = require "dungeon"
local Camera = require "camera"
local Hud = require "hud"
local turns = 0
function love.load()
  -- Load player and dungeon
  player = Player.new(2, 2)
  dungeon = Dungeon.new(128, 128)  -- 40x30 grid
  camera = Camera.new(0,0)
  hud = Hud.new()
  fullscreen = false 
  co = coroutine.create(function()
      dungeon:gen(player)
  end)
  coroutine.resume(co)
end

function love.update(dt)
  camera:update(dt, player)
  if coroutine.status(co) == "suspended" then
    coroutine.resume(co)
  elseif coroutine.status(co) == "dead" then
  end
  if dungeon.initing then
    player.x = dungeon.rooms[2][2].x + 2
    player.y = dungeon.rooms[2][2].y + 2
    dungeon.initing = false
  end
  dungeon:update(dt)
  hud.status_message = dungeon.actions[#dungeon.actions] or ""
end

function love.draw()
  dungeon:draw(camera, player)
  hud:draw(player)
end

function love.keypressed(key)
  if key == "f" then
    fullscreen = not fullscreen
		love.window.setFullscreen(fullscreen, "exclusive")
	end
  camera:keypressed(key)
  local change_turn = player:keypressed(key, dungeon)
  if change_turn then
    turns = turns + 1
    dungeon:resolve(player)
  end
end
