local Player = require "player"
local Dungeon = require "dungeon"
local Camera = require "camera"
local pinited = false
function love.load()
  -- Load player and dungeon
  player = Player.new(2, 2)
  dungeon = Dungeon.new(128, 128)  -- 40x30 grid
  camera = Camera.new(0,0)
  fullscreen = false 
  co = coroutine.create(function()
      dungeon:gen()
  end)
  coroutine.resume(co)
end

function love.update(dt)
  player:update(dt, dungeon)
  camera:update(dt, player)
  if coroutine.status(co) == "suspended" then
    coroutine.resume(co)
  elseif coroutine.status(co) == "dead" then
    if not pinited then
      player.x = dungeon.rooms[2][2].x + 2
      player.y = dungeon.rooms[2][2].y + 2
      pinited = true
    end
  end
end

function love.draw()
  dungeon:draw(camera, player)
  player:draw(camera)
end

function love.keypressed(key)
  if key == "f" then

    fullscreen = not fullscreen 
		love.window.setFullscreen(fullscreen, "exclusive")
	end
  camera:keypressed(key)
  player:keypressed(key, dungeon)
end
