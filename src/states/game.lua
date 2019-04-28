entityManager = require 'src.entities.entitymanager'
GameObject = require 'src.entities.gameobject'
Enemy = require 'src.entities.enemy'
Vector = require 'lib.hump.vector'
RoomManager = require 'src.rooms.roommanager'

local game = {}

local rM = RoomManager(4,4)

function game:enter()
    logger:log("Starting Game Intialization")
    logger:log("Game Initialized")

   	local enemy = Enemy(Vector(50,50),{})
    entityManager:addEntity(enemy)
end

function game:update(dt)
   entityManager:update(dt)
   rM:update(dt)
end

function game:draw()
    entityManager:draw()
    rM:draw()
end

function game:keypressed(key)
   if key == 'q' then
    love.event.quit()
   end
   if key == 's' then
    rM:changeRoom(0,1)
   end
   if key == 'w' then
    rM:changeRoom(0,-1)
   end
   if key == 'd' then
    rM:changeRoom(1,0)
   end
   if key == 'a' then
    rM:changeRoom(-1,0)
   end
end

return game
