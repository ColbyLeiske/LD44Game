GameObject = require 'src.entities.gameobject'
Constants = require('src.util.gameconstants')
Vector = require 'lib.hump.vector'
entityManager = require 'src.entities.entitymanager'
Grid = require 'src.entities.grid'

local game = {}

function game:enter()
    logger:log("Starting Game Intialization")
    logger:log("Game Initialized")

    Grid:initGrid()
    --local grid = Grid()
    --self.eM:addEntity(grid)

    --position = Vector(0, 0)
    --local block = LBlockRight(position, grid)
    --self.eM = entityManager()
    --self.eM:addEntity(block)

end

function game:update(dt)
	--self.eM:update(dt)
	Grid:update(dt)
end

function game:draw()
	--self.eM:draw()
	Grid:draw()
end

function game:keypressed(key) 
   if key == 'q' then
    love.event.quit()
   end

end

return game