Constants = require('src.util.gameconstants')
Vector = require 'lib.hump.vector'
Grid = require 'src.entities.grid'
PlayerInputManager = require 'src.entities.playerinputmanager'
GameState = require 'lib.hump.gamestate'
pause = require 'src.states.pause'

local game = {}

function game:enter()

    love.graphics.setDefaultFilter('nearest','nearest',1)
    Grid:initGrid()

end

function game:update(dt)
    Grid:update(dt)
    if PlayerInputManager.input:pressed('pause') then
        GameState.push(pause)
    end
end

function game:draw()
	Grid:draw()
end

function game:resume()
    Grid:resume()
end

return game
