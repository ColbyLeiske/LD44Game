Constants = require('src.util.gameconstants')
Vector = require 'lib.hump.vector'
Grid = require 'src.entities.grid'
sprites = require 'src.util.spriteloader'
PlayerInputManager = require 'src.entities.playerinputmanager'
GameState = require 'lib.hump.gamestate'
menu = require 'src.states.menu'
keybinding = require 'src.states.keybinds'
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

    local mousex,mousey = love.mouse.getPosition()
    if PlayerInputManager.input:pressed('left_click') then 
        if mousex > 65*4 and mousex < (64+48) * 4 then
            if mousey > 52*4 and mousey < (52+12)*4 then
                GameState.pop()
            end
            if mousey > 52*4 + 17.5*4 and mousey < (52+12)*4 + 17.5*4 then
                GameState.push(keybinding,self.from)
            end
            if mousey > 52*4 + 44*4 and mousey < (52+12)*4 + 44*4 then
                GameState.switch(menu)
            end
        end
    end

end

function pause:draw()
    self.from:draw()

    love.graphics.setColor(0,0,0, 200/255)
    love.graphics.rectangle('fill', 0,0, love.graphics.getWidth(),love.graphics.getHeight())    
    love.graphics.setColor(1,1,1)

    love.graphics.draw(sprites.pausemenu)

    love.graphics.print("Paused",73.5,16.5)

    love.graphics.draw(sprites.pausebutton,65,52)
    love.graphics.print("Resume",74,54.5)

    love.graphics.draw(sprites.pausebutton,65,52+17.5)
    love.graphics.print("Keybinding",66.7,52+17.5 + 2.5)

    love.graphics.draw(sprites.pausebutton,65,52+44)
    love.graphics.print("Exit",81,52+44 + 2.5)

end

return pause
