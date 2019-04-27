entityManager = require 'src.entities.entitymanager'
GameObject = require 'src.entities.gameobject'
player = require 'src.entities.player'

local game = {}

function game:enter()
    logger:log("Starting Game Intialization")
    logger:log("Game Initialized")

   	local player = player(100,100,30,30,.5,{})
    entityManager:addEntity(player)
end

function game:update(dt)
   entityManager:update(dt)
end

function game:draw()
    entityManager:draw()
end

function game:keypressed(key) 
   if key == 'q' then
    love.event.quit()
   end
end

return game