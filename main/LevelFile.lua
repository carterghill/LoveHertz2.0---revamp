require("main/Level")
require("main/Debug")

LevelFile = {}

function LevelFile:load(location)

  lvl = {}

  if location:match("^.+(%..+)$") == ".lvl" then

    success = love.filesystem.mount(location, "CustomLevel")
    print(tostring(success))

    imgtypes = {".png", ".gif", ".jpg", ".jpe", ".jpeg", ".bmp"}
    for k, v in pairs(imgtypes) do
      if love.filesystem.exists("CustomLevel/icon"..v) then
        lvl.icon = love.graphics.newImage("CustomLevel/icon"..v)
        print("icon found")
      end
    end

    --lvl.map = Tserial.unpack(love.filesystem.read("level/default.txt"))
    if love.filesystem.exists("CustomLevel/default.txt") then
        print("Exists")
    else
        print("Does not exist")
    end

    inGame = true
    Placeables:loadCustom()
    lvl.location = location

  end



  --function lvl:load()

    --l:load("CustomLevel/default.txt")

  --end

  return lvl

end
