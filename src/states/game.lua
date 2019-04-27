entityManager = require 'src.entities.entitymanager'
GameObject = require 'src.entities.gameobject'
Player = require 'src.entities.player'

RoomManager = require 'src.rooms.roommanager'


local game = {}

local rM = RoomManager(4,4)

function game:enter()
    logger:log("Starting Game Intialization")
    logger:log("Game Initialized")

   	local player = Player(100,100,30,30,.5,{})
    entityManager:addEntity(player)
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
end

return game