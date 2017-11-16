require("Placeable")
require("Tiles")
require("Cameras")
require("Players")
require("controls")
require("Level")
require("UI/Element")
require("UI/EditModeUI")
require("UI/PlayerUI")
require("UI/UI")
require("Background")
require("entities/Enemy")
require("entities/Enemies")
require("entities/Item")
require "gooi"

-- This one is called right at the start
function love.load()
  local c = function ()
    if l ~= nil then
      if l.players.x > e.x then
        e.right = true
        e.left = false
      else
        e.right = false
        e.left = true
      end
    end
  end
  --e = Enemy:new("images/enemies/Frank", 1, c, 100, -100)
  en = Enemies:new()
  --en:add(e)
  slowdowns = 0
  Placeables:load()
  Cameras:new()
  P = Player:create("images/traveler")
  --Tiles:place(0, 100)
  --Tiles:place(-50, 100)
  --Tiles:place(-70, 100)
  --Tiles:place(-150, 100)
  --Tiles:place(-200, 100)
  l = Level:new(Tiles, P)
  item = Item:new(300, -100, "images/items/healthpack.png")
  --EditModeUI:load()
  --PlayerUI:load()
  UI:load()
  b = Background:new("images/backgrounds/city")
  --box = UI:new(540, 460, 200, 200, "Text", "Click\nto lose\nhealth! ", function () l.players.health = l.players.health - 2; box.input = true end)
  --health = UI:new(36, 36, 200, 36, "Health Bar", "", function () l.players.health = l.players.health + 1 end)

  --save = Tserial.unpack(love.filesystem.read("save.txt"))
  if love.filesystem.exists("Levels/default.txt") ~= nil then
    l:load()
  end
  debug = ""
  Cameras:setPosition(l.players.x, l.players.y)
  --love.keyboard.setKeyRepeat(true)
end
tileNum = ""

-- This function is being called repeatedly and draws things to the screen
function love.draw()
  b:draw()
  Placeables:draw()
  Decorative:draw()
  if l ~= nil then
    Tiles:draw()
    l.players:draw()
  end
  item:draw()
  en:draw()
  --debug = "Level Name: "..l.name.."\n"..love.filesystem.getSaveDirectory().."\nTiles: "..#Tiles.set
  --love.graphics.print(debug.."\n"..tileNum.."FPS: "..love.timer.getFPS())
  if fps == nil then
    fps = love.timer.getFPS()
    prevfps = fps
  else
    prevfps = fps
    fps = love.timer.getFPS()
  end
  if fps < prevfps then
    slowdowns = slowdowns + 1
  end
  love.graphics.print("FPS: "..fps.."\nSlowdowns: "..slowdowns)
  if l ~= nil then
    love.graphics.print("Player: ("..l.players.x..", "..l.players.y..")", 0, 26)
  end

  --health:draw()
  --box:draw()
  --if EditModeUI.display then
    EditModeUI:draw()
  --end
  --PlayerUI:draw()
  UI:draw()

end

-- This one is also being called repeatedly, handles game logic
function love.update(dt)
  item:update(dt)
  --item.x = l.players.x + 200
  --item.y = l.players.y
  gooi.update(dt)
  if l.name ~= nil then
    --lbl1:setText("Level Name: "..l.name)
  end
  Cameras:update(dt)
  UI:update(dt)
  if EditModeUI.display then
    if love.mouse.isDown(1) then
      if not UI:mouseOn() then
        Tiles:place()
      end
    end
    if love.mouse.isDown(2) then
      Tiles:remove()
    end
  else
    if l ~=nil then
      l.players:update(dt)
      en:update(dt)
    end
  end

end

function love.mousepressed(x, y, button, istouch)
  --tileNum = tileNum.."HELLO FROM MOUSE"
  --EditModeUI:onClick(x, y)
  --PlayerUI:onClick(x, y)
  UI:onClick(x, y)
  gooi.pressed()
  Placeables:onClick(x,y,button)
end

function love.mousereleased(x, y, button)
  gooi.released()
end

function love.textinput(text)
  if gooi.input then
    gooi.input = false
  end
  gooi.textinput(text)
end
