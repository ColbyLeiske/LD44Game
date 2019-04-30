
Colors = require 'src.util.colors'
PlayerInputManager = require 'src.entities.playerinputmanager'
AudioManager = require 'src.entities.audiomanager'
Sprite = require 'src.util.spriteloader'

local menu = {}

function menu:init()
  AudioManager:init()
  AudioManager:playtheme()
  

  self.credits = require 'src.states.credits'
  self.keybinds = require 'src.states.keybinds'
  self.game = require 'src.states.game'
  self.leaderboard = require 'src.states.leaderboard'

  self.font = love.graphics.newFont("res/fonts/goodbyeDespair.ttf", 8) -- the number denotes the font size
	self.font:setFilter('nearest','nearest',1)
	love.graphics.setFont(self.font)
end

function menu:update(dt)
  local mousex, mousey = love.mouse.getPosition()

  if PlayerInputManager.input:pressed('left_click') then
    if mousex > 602 and mousex < 662 and mousey > 546 and mousey < 605 then
      AudioManager:clickedVolumeIcon()  
    end
    if mousex > 264 and mousex < 441 then

      if mousey > 364 and mousey < 411 then
          Gamestate.switch(self.game)
      end
      if mousey > 421 and mousey < 468 then
        Gamestate.switch(self.leaderboard)
      end
      if mousey > 476 and mousey < 526 then
        Gamestate.switch(self.keybinds)
      end
      if mousey > 533 and mousey < 580 then
        love.event.quit(0)
      end
    end
  end
end


function menu:draw()
  love.graphics.scale(4,4)
  love.graphics.draw(Sprite.menubackground, 0 , 0, 0)

  love.graphics.print("Play",78.5,93.5)
  love.graphics.print("Leaders",71.25,14+93.5)
  love.graphics.print("Key Binds",68.5,28+93.5)
  love.graphics.print("Exit",80,42+93.5)

  love.graphics.draw(sprites.volumeicon,153.4,140.5)

  if AudioManager.volume >= .3 then
      love.graphics.draw(sprites.volumewave1,158.4,140.5)
  end
  if AudioManager.volume >= .6 then
      love.graphics.draw(sprites.volumewave2,161.4,140.5)
  end
  if AudioManager.volume >= 1 then
      love.graphics.draw(sprites.volumewave3,164.3,140.5)
  end

end

return menu
