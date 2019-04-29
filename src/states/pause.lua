Constants = require('src.util.gameconstants')
Vector = require 'lib.hump.vector'
Grid = require 'src.entities.grid'
sprites = require 'src.util.spriteloader'
PlayerInputManager = require 'src.entities.playerinputmanager'
GameState = require 'lib.hump.gamestate'
local pause = {}

function pause:enter(from)
    love.graphics.setDefaultFilter('nearest','nearest',1)
    self.from = from
    self.font2 = love.graphics.newFont("res/fonts/goodbyeDespair.ttf", 8) -- the number denotes the font size
	self.font2:setFilter('nearest','nearest',1)
	love.graphics.setFont(self.font2)
end

function pause:update(dt)
    if PlayerInputManager.input:pressed('pause') then
        GameState.pop()
    end
end

function pause:draw()
    self.from:draw()

    love.graphics.setColor(0,0,0, 200/255)
    love.graphics.rectangle('fill', 0,0, love.graphics.getWidth(),love.graphics.getHeight())    
    love.graphics.setColor(1,1,1)

    love.graphics.draw(sprites.pausemenu)

    love.graphics.print("Paused",73.5,16.5)
end

return pause
