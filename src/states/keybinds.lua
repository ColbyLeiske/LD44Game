local menu
local keybinds = {}
local buttons = {}

local font = love.graphics.newFont(32)


local window_width = love.graphics.getWidth()
local window_height = love.graphics.getHeight()

local button_height = 50
local button_width = (window_width * 0.5) + 20
local buttonStartY = 60-- we will change this
local buttonStartX = (window_width * 0.5) - (button_width * 0.5)
local buttonMargin = 25
local bindNextKeyPress = {check=false, inputAction=''}
local buttonExists = false
local originalKey
local waitingForBind = '...'
local stillWaiting = false


local keyActionAssociations = {
  ['left'] = 'a',
  ['right'] = 'd',
  ['soft'] = 's',
  ['hard'] = 'w',
  ['clockwise'] = 'c',
  ['counter'] = 'v',
  ['back'] = 'back'
}

function keybinds:init()
  menu = require 'src.states.menu'
    self.input = Input()
    self.input:bind('mouse1', 'left_click')
  for k,v in pairs(keyActionAssociations) do
    self.input:bind(v,k)
  end
end

function keybinds:enter()
  love.keyboard.setKeyRepeat(true)
  buttons[1] = newButton("Back" , function() Gamestate.switch(menu) end,'back')

  buttons[2] = newButton("Drag left", function() self:setupNewKeybind(keyActionAssociations['left'],'left') end, 'left')
  buttons[3] = newButton("Drag right", function() self:setupNewKeybind(keyActionAssociations['right'],'right') end,'right')
  buttons[4] = newButton("Soft drop", function()self:setupNewKeybind(keyActionAssociations['soft'],'soft') end,'soft')
  buttons[5] = newButton("Hard drop", function() self:setupNewKeybind(keyActionAssociations['hard'],'hard') end,'hard')
  buttons[6] = newButton("Rotate clockwise", function() self:setupNewKeybind(keyActionAssociations['clockwise'],'clockwise') end, 'clockwise')
  buttons[7] = newButton("Rotate counterclockwise", function() self:setupNewKeybind(keyActionAssociations['counter'],'counter') end,'counter')
end

function keybinds:setupNewKeybind(prevKey,inputAction)
  originalKey = prevKey
  self.input:unbind(prevKey)
  stillWaiting = true
  bindNextKeyPress = {check = true, inputAction = inputAction }
  print('Preparing for new keybind with PREV: '.. prevKey .. ' with ACTION: '.. inputAction)
end

function keybinds:update()
  for k, button in ipairs(buttons) do
    local buttony = buttonStartY + ((k-1) * buttonMargin + (k-1) * button_height)
    local mousex, mousey = love.mouse.getPosition()
    button.active = mousex > buttonStartX and mousex < buttonStartX + button_width and mousey > buttony and mousey < buttony + button_height
    if self.input:pressed('left_click') and button.active and stillWaiting == false then
      button.fn()
    end
  end

--testing
    if self.input:pressed('right') then
      print("right")
    elseif self.input:pressed('left') then
      print("left")
    end

end

function keybinds:draw()
  for k, button in ipairs(buttons) do

    if stillWaiting and keyActionAssociations[button.inputAction] == originalKey then
      keyActionAssociations[button.inputAction] = waitingForBind
    end

    local printValue = (keyActionAssociations[button.inputAction])
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

    love.graphics.print(printValue, font, (window_width * 0.5), buttony + (textH * 0.2)) --warning for this)
    love.graphics.setColor(1,1,1,1)
  end
end

function keybinds:keyreleased(key)
  for k,v in pairs(keyActionAssociations) do
    if (key == v) and (key ~= originalKey) then
      buttonExists = true
      break
    else
      buttonExists = false
    end
  end

  if bindNextKeyPress.check and (buttonExists == false) then
    stillWaiting = false
    self.input:bind(key, bindNextKeyPress.inputAction)
    keyActionAssociations[bindNextKeyPress.inputAction] = key
    bindNextKeyPress.check = false
  end
end


function newButton(text, fn, inputAction)
    return {
      text = text,
      fn = fn,
      active = false,
      inputAction = inputAction,
    }
end

return keybinds
