
Colors = require 'src.util.colors'
PlayerInputManager = require 'src.entities.playerinputmanager'
AudioManager = require 'src.entities.audiomanager'

local keybinds
local credits

local menu = {}
local buttons = {}

local font = nil


local window_width = love.graphics.getWidth()
local window_height = love.graphics.getHeight()

local button_height = 50
local button_width = window_width * (1/3)
local buttonStartY = 280 -- we will change this
local buttonStartX = (window_width * 0.5) - (button_width * 0.5)
local buttonMargin = 25


function menu:init()
  credits = require 'src.states.credits'
  keybinds = require 'src.states.keybinds'
  game = require 'src.states.game'

  AudioManager:init()
  AudioManager:playtheme()
  
end

function menu:enter()
  font = love.graphics.newFont(32)
  buttons[1] = newButton("Start Game" , function() Gamestate.switch(game) end)
  buttons[2] = newButton("Keybinds" , function() Gamestate.switch(keybinds) end)
  buttons[3] = newButton("Credits" , function() Gamestate.switch(credits) end)
  buttons[4] = newButton("Exit" ,function() love.event.quit(0) end)
end

function menu:update(dt)
  for k, button in ipairs(buttons) do
    local buttony = buttonStartY + ((k-1) * buttonMargin + (k-1) * button_height)
    local mousex, mousey = love.mouse.getPosition()
    button.active = mousex > buttonStartX and mousex < buttonStartX + button_width and mousey > buttony and mousey < buttony + button_height
    if PlayerInputManager.input:pressed('left_click') and button.active then
      button.fn()
    end
  end
end

local titleColor = {
  type = "gradient",
  color1 = {1, 0, 0.4},
  color2 = {1,0,0,0.2},
  direction = "up"
}

function menu:draw()
  love.graphics.setColor(Colors.darkGreen)
  love.graphics.rectangle("fill", 0, 0, window_width,window_height)

  love.graphics.setColor(Colors.darkGreen)
  love.graphics.rectangle("fill", 0, 0, window_width,window_height)

  love.graphics.setColor(1,1,1)

  local title = love.graphics.newImage("res/raw_sprites/png/tetrisTempoFinal.png")
  love.graphics.draw(title, 120 , 0, 0, 2.5, 2.5)

  for k, button in ipairs(buttons) do
    local buttony = buttonStartY + ((k-1) * buttonMargin + (k-1) * button_height)
    --color that displays when the cursor is over the button
    if button.active then
        color = {0.8, 0.8, 0.8, 1.0}
    else
        color = {0.4, 0.4, 0.5, 1.0}
    end
    --constructing of the buttons
    love.graphics.setColor(unpack(color))
    love.graphics.rectangle("fill", buttonStartX, buttony, button_width, button_height)

    --text on the buttons
    love.graphics.setColor(0,0,0,1)
    local textW = font:getWidth(button.text)
    local textH = font:getHeight(button.text)
    love.graphics.print(button.text, font, (window_width * 0.5) - textW * 0.5, buttony + (textH * 0.2)) --warning for this)
    love.graphics.setColor(1,1,1,1)
  end
end

function newButton(text, fn)
    return {
      text = text,
      fn = fn,
      active = false,
    }
end


return menu
