GameObject = require 'src.entities.gameobject'
Player = require 'src.entities.player'
Vector = require 'lib.hump.vector'
RoomManager = require 'src.rooms.roommanager'

local game = {}

local rM = RoomManager(4,4)

function game:enter()
    logger:log("Starting Game Intialization")
    logger:log("Game Initialized")

   	local player = Player(Vector(200,200))
    rM:addEntity(player)
end

function game:update(dt)
   rM:update(dt)
end

function game:draw()
    rM:draw()
end

function game:keypressed(key) 
   if key == 'q' then
    love.event.quit()
   end

   if key == 'down' then
    rM:changeRoom(0,1)
   end
   if key == 'up' then
    rM:changeRoom(0,1)
   end
end

return game