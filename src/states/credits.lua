local menu
local credits = {}
local buttons = {}

local font = nil


local window_width = love.graphics.getWidth()
local window_height = love.graphics.getHeight()

local button_height = 50
local button_width = window_width * (1/3)
local buttonStartY = 150 -- we will change this
local buttonStartX = (window_width * 0.5) - (button_width * 0.5)
local buttonMargin = 25

function credits:init()
  menu = require 'src.states.menu'
end


function credits:enter()
  self.input = Input()
  self.input:bind('mouse1', 'left_click')
  font = love.graphics.newFont(32)

  buttons[1] = newButton("Back" , function() Gamestate.switch(menu) end)
end

function credits:update()
  for k, button in ipairs(buttons) do
    local buttony = buttonStartY + ((k-1) * buttonMargin + (k-1) * button_height)
    local mousex, mousey = love.mouse.getPosition()
    button.active = mousex > buttonStartX and mousex < buttonStartX + button_width and mousey > buttony and mousey < buttony + button_height
    if self.input:pressed('left_click') and button.active then
      button.fn()
    end
  end
end

function credits:draw()
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


return credits
