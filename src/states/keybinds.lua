PlayerInputManager = require 'src.entities.playerinputmanager'

local menu
local keybinds = {}

local font = love.graphics.newFont(32)

local window_width = love.graphics.getWidth()
local window_height = love.graphics.getHeight()

local button_height = 50
local button_width = (window_width * 0.5) + 20
local buttonStartY = 60-- we will change this
local buttonStartX = (window_width * 0.5) - (button_width * 0.5)
local buttonMargin = 25
local bindNextKeyPress = {check=false, inputAction=''}

function keybinds:init()
  menu = require 'src.states.menu'
  self.buttons = {}
  self.buttons[1] = self:newButton("Back" , function() 
    if self.doubleFrom ~= nil then
      Gamestate.pop()
    else
      Gamestate.switch(self.from) 
    end
  end,'back')
  self.buttons[3] = self:newButton("Drag left", function() self:setupNewKeybind(PlayerInputManager.keyActionAssociations['left'],'left') end, 'left')
  self.buttons[5] = self:newButton("Drag right", function() self:setupNewKeybind(PlayerInputManager.keyActionAssociations['right'],'right') end,'right')
  self.buttons[4] = self:newButton("Soft drop", function()self:setupNewKeybind(PlayerInputManager.keyActionAssociations['soft'],'soft') end,'soft')
  self.buttons[2] = self:newButton("Hard drop", function() self:setupNewKeybind(PlayerInputManager.keyActionAssociations['hard'],'hard') end,'hard')
  self.buttons[6] = self:newButton("Rotate clockwise", function() self:setupNewKeybind(PlayerInputManager.keyActionAssociations['clockwise'],'clockwise') end, 'clockwise')
  self.buttons[7] = self:newButton("Rotate counterclockwise", function() self:setupNewKeybind(PlayerInputManager.keyActionAssociations['counter'],'counter') end,'counter')
  print(#self.buttons)
end

function keybinds:enter(from,doubleFrom)
  self.doubleFrom = doubleFrom or nil
  self.from = from
end

function keybinds:setupNewKeybind(prevKey,inputAction)
  PlayerInputManager.input:unbind(prevKey)
  bindNextKeyPress = {check = true, inputAction = inputAction }
end

function keybinds:update()
  for k, button in ipairs(self.buttons) do
    local buttony = buttonStartY + ((k-1) * buttonMargin + (k-1) * button_height)
    local mousex, mousey = love.mouse.getPosition()
    button.active = mousex > buttonStartX and mousex < buttonStartX + button_width and mousey > buttony and mousey < buttony + button_height
    if PlayerInputManager.input:pressed('left_click') and button.active then
      button.fn()
    end
  end
end

function keybinds:draw()
  for k, button in ipairs(self.buttons) do

    local printValue = (PlayerInputManager.keyActionAssociations[button.inputAction])
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
    love.graphics.print(printValue, font, (window_width * 0.5) - textW * 0.5, buttony + (textH * 0.2)) --warning for this)
    love.graphics.setColor(1,1,1,1)
  end
end

function keybinds:keyreleased(key)
  if bindNextKeyPress.check then
    PlayerInputManager.input:bind(key, bindNextKeyPress.inputAction)
    PlayerInputManager.keyActionAssociations[bindNextKeyPress.inputAction] = key
    bindNextKeyPress.check = false
  end
end

function keybinds:newButton(text, fn, inputAction)
    return {
      text = text,
      fn = fn,
      active = false,
      inputAction = inputAction,
    }
end

return keybinds
