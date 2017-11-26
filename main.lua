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
require("entities/Items")
require "gooi"
lol = ""
paused = false

-- This one is called right at the start
function love.load()

  love.filesystem.setIdentity( "beatboy" )
  globalScale = love.graphics.getWidth()/1280
  en = Enemies:new()
  slowdowns = 0
  Placeables:load()
  Cameras:new()
  P = Player:create("images/traveler")
  l = Level:new(Tiles, P)
  items = Items:new()
  b = Background:new("images/backgrounds/city")
  if love.filesystem.exists("Levels/default.txt") ~= nil then
    l:load()
  end
  UI:load()
  debug = ""
  Cameras:setPosition(l.players.x, l.players.y)
  --love.keyboard.setKeyRepeat(true)
end
tileNum = ""

-- This function is being called repeatedly and draws things to the screen
function love.draw()

  if not paused then
    b:draw()
    Placeables:draw()
    Decorative:draw()
    if l ~= nil then
      Tiles:draw()
      l.players:draw()
    end
    items:draw()
    en:draw()
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
      love.graphics.print("Player: ("..l.players.x..", "..l.players.y..")\n"..
      "("..Cameras:current().x..", "..Cameras:current().y..")\n"..love.system.getOS().."\n"..lol, 0, 30)
    end

    EditModeUI:draw()
    UI:draw()
  else
    love.graphics.setColor(155, 155, 155, 155)
    love.graphics.draw(pauseImg)
    love.graphics.setColor(255, 255, 255, 255)
  end
  gooi.draw()

end

-- This one is also being called repeatedly, handles game logic
function love.update(dt)

  gooi.update(dt)

  if not paused then
    items:update(dt)
    Cameras:update(dt)
    UI:update(dt)
    if EditModeUI.display then
      if love.mouse.isDown(1) and not EditModeUI.delete then
        if not UI:mouseOn() then
          Tiles:place()
        end
      end
      if love.mouse.isDown(2) or (love.mouse.isDown(1) and EditModeUI.delete) then
        if not UI:mouseOn() then
          Tiles:remove()
        end
      end
    else
      if l ~=nil then
        l.players:update(dt)
        en:update(dt)
      end
    end
  end
end

function love.touchpressed( id, x, y, dx, dy, pressure )
  gooi.pressed(id, x, y)
end

function love.touchreleased( id, x, y, dx, dy, pressure )
  gooi.released(id, x, y)
end

function love.touchmoved( id, x, y, dx, dy, pressure )
  if not EditModeUI.display then
    PlayerUI:touchmoved(id, x, y, dx, dy)
  else
    if zoomSlider:overIt(x, y) and zoomSlider:overIt(dx, dy) then
      gooi.released(id, x-dx, y-dy)
      gooi.pressed(id, x, y)
    end
  end
end

function love.mousepressed(x, y, button, istouch)
  UI:onClick(x, y)
  if love.system.getOS() ~= "Android" then
    gooi.pressed()
  end
  Placeables:onClick(x,y,button)
end

function love.mousereleased(x, y, button, istouch)
  if love.system.getOS() ~= "Android" then
    gooi.released()
  end
  if not jumpButton:overIt(love.mouse.getPosition())
  and not shootButton:overIt(love.mouse.getPosition()) then
    Cameras:current().xSpeed = 0
    Cameras:current().ySpeed = 0
    l.players.left = false
    l.players.right = false
  end
end

function love.textinput(text)
  if gooi.input then
    gooi.input = false
  end
  gooi.textinput(text)
end

function pauseGame()

  if paused then
    paused = false
    if PlayerUI.display then
      gooi.setGroupEnabled("player", true)
    elseif EditModeUI.display then
      gooi.setGroupEnabled("edit_mode", true)
    end
  else
    paused = true
    gooi.setGroupEnabled("edit_mode", false)
    gooi.setGroupEnabled("player", false)
    local screenshot = love.graphics.newScreenshot();
    screenshot:encode('png', 'pause.png');
    pauseImg = love.graphics.newImage('pause.png')
    gooi.alert({
        text = "Game is Paused",
        ok = function()
            pauseGame()
        end
    })
  end

end
