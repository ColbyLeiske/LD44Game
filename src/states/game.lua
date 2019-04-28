Sprites = require 'src.util.spriteloader'

local game = {}

function game:enter()
    logger:log("Starting Game Intialization")
    logger:log("Game Initialized")

    love.graphics.setDefaultFilter('nearest','nearest',1)
    Sprites:loadSprites()
end

function game:update(dt)
   
end

function game:draw()

end

function game:keypressed(key) 
   if key == 'q' then
    love.event.quit()
   end
end

return game