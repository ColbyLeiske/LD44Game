Constants = require('src.util.gameconstants')
Vector = require 'lib.hump.vector'
Grid = require 'src.entities.grid'
sprites = require 'src.util.spriteloader'
PlayerInputManager = require 'src.entities.playerinputmanager'
ScoreManager = require 'src.entities.scoremanager'
GameState = require 'lib.hump.gamestate'
menu = require 'src.states.menu'
keybinding = require 'src.states.keybinds'
Dreamlo = require 'lib.dreamlo.dreamlo'
Secrets = require 'src.util.secrets'

local gameover = {}

function gameover:enter(from)
    love.graphics.setDefaultFilter('nearest','nearest',1)
    self.from = from
    self.font2 = love.graphics.newFont("res/fonts/goodbyeDespair.ttf", 8) -- the number denotes the font size
	self.font2:setFilter('nearest','nearest',1)
    love.graphics.setFont(self.font2)
    self.name = ''
    love.keyboard.setKeyRepeat( true )
    self.hasPressedSubmit = false
end

function gameover:update(dt)
    local mousex,mousey = love.mouse.getPosition()
    if PlayerInputManager.input:pressed('left_click') then 
        if mousex > 54*4 and mousex < (54+32) * 4 and mousey > 95*4 and mousey < (95+12)*4  and self.hasPressedSubmit == false then
            self.hasPressedSubmit = true
            if self.name ~= '' or self.name ~= " " then 
                Dreamlo.setSecretCode(Secrets.dreamlo_secret)
                Dreamlo.setPublicCode(Secrets.dreamlo_public)
                Dreamlo.add(self.name, ScoreManager.score)
            end
            GameState.switch(menu)
        end
        if mousex > (65+23+2)*4 and mousex < (65+23+2+32) * 4 and mousey > 95*4 and mousey < (95+12)*4 then
            GameState.switch(menu)
        end
    end

end

function gameover:draw()
    self.from:draw()

    love.graphics.setColor(0,0,0, 200/255)
    love.graphics.rectangle('fill', 0,0, love.graphics.getWidth(),love.graphics.getHeight())    
    love.graphics.setColor(1,1,1)

    love.graphics.draw(sprites.gameoverbackground)
    local fWidth = self.font2:getWidth("Game over!")
    love.graphics.print("Game over!",(love.graphics.getWidth()/2 - 2*(fWidth))/4,14)
    local fWidth = self.font2:getWidth("Score: " .. ScoreManager.score)
    love.graphics.print("Score: " .. ScoreManager.score , (love.graphics.getWidth()/2 - 2*(fWidth))/4,23)

    love.graphics.draw(sprites.gameoverbutton,54,95)
    love.graphics.print("Submit",54+1.5,97.5)

    love.graphics.draw(sprites.gameoverbutton,65+23+2,95)
    love.graphics.print("Exit",68+23+6.75,97.5)
    local fWidth = self.font2:getWidth("Name: ")

    love.graphics.print("Name: ",(love.graphics.getWidth()/2 - 2*(fWidth))/4,52.5)
    love.graphics.print(self.name,65,70)

end

function gameover:keypressed(key) 
    if key == 'rshift' or key == 'lshift' or key == 'capslock' or key == 'lctrl' or key == 'lalt' or key == 'rctrl' or key =='ralt' or key == 'lgui' or key == 'rgui' or key =='return' then
        return
    end

    if key ~= 'backspace' and string.len( self.name ) < 9 then 
        self.name = self.name .. key
    end
    if key == 'backspace' and string.len(self.name) > 0 then
        self.name = self.name:sub(1,-2)
    end
end

return gameover
