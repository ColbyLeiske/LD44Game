entityManager = require 'src.entities.entitymanager'
GameObject = require 'src.entities.gameobject'

local game = {}

function game:enter()
    logger:log("Starting Game Intialization")
    logger:log("Game Initialized")

    local testGameObject = GameObject(50,50,{})
    entityManager:addEntity(testGameObject)
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