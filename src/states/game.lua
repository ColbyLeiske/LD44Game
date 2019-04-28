Constants = require('src.util.gameconstants')
Vector = require 'lib.hump.vector'
Grid = require 'src.entities.grid'

local game = {}

function game:enter()
    logger:log("Starting Game Intialization")
    logger:log("Game Initialized")
    Grid:initGrid()
end

function game:update(dt)
	Grid:update(dt)
end

function game:draw()
	Grid:draw()
end

function game:keypressed(key) 
   if key == 'q' then
    love.event.quit()
   end
end

return game