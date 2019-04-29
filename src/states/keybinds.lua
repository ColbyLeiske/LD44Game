local menu
local keybinds = {}
local buttons = {}
local backButtonHolder = {}

local font

local window_width = love.graphics.getWidth()
local window_height = love.graphics.getHeight()

local button_height = 50
local button_width = (window_width/5)
local buttonStartY = 15 -- we will change this
local buttonStartX = (window_width/3) + (button_width) + 50
local backButtonStartX = 90
local backButton_width = 475
local backButtonStartY = 15
local buttonMargin = 35
local bindNextKeyPress = {check=false, inputAction=''}

local buttonExists = false
local originalKey
local waitingForBind = '...'
local stillWaiting = false
local backButton = 'Back'


local keyActionAssociations = {
  ['left'] = 'a',
  ['right'] = 'd',
  ['soft'] = 's',
  ['hard'] = 'w',
  ['clockwise'] = 'c',
  ['counter'] = 'v',
  ['back'] = 'back'
}

local keyBindChange = {
  "Move left", "Move right", "Soft drop", "Hard drop", "Rotate clockwise", "Rotate counterclockwise"
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
  font = love.graphics.newFont("res/fonts/goodbyeDespair.ttf", 32) -- the number denotes the font size
  love.graphics.setFont(font)
  buttons[1] = newButton("Drag left", function() self:setupNewKeybind(keyActionAssociations['left'],'left') end, 'left')
  buttons[2] = newButton("Drag right", function() self:setupNewKeybind(keyActionAssociations['right'],'right') end,'right')
  buttons[3] = newButton("Soft drop", function()self:setupNewKeybind(keyActionAssociations['soft'],'soft') end,'soft')
  buttons[4] = newButton("Hard drop", function() self:setupNewKeybind(keyActionAssociations['hard'],'hard') end,'hard')
  buttons[5] = newButton("Rotate clockwise", function() self:setupNewKeybind(keyActionAssociations['clockwise'],'clockwise') end, 'clockwise')
  buttons[6] = newButton("Rotate counterclockwise", function() self:setupNewKeybind(keyActionAssociations['counter'],'counter') end,'counter')
  backButtonHolder[1] = newBackButton("Back", function() Gamestate.switch(menu) end)
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

    button.active = mousex > buttonStartX and mousex < buttonStartX + button_width and mousey > (buttony+82) and mousey < buttony + 82 + button_height
    backButtonHolder.active = mousex > backButtonStartX and mousex < backButtonStartX + backButton_width and mousey > backButtonStartY and mousey < backButtonStartY + button_height

    if self.input:pressed('left_click') and button.active and stillWaiting == false then
      button.fn()
end

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


    love.graphics.setColor(unpack(color))
    --back button
    love.graphics.rectangle("fill", backButtonStartX, backButtonStartY, backButton_width, button_height)
    --rest of the buttons
    love.graphics.rectangle("fill", buttonStartX, buttony + 82, button_width, button_height)
    --text on the buttons
    love.graphics.setColor(0,0,0,1)
    local textW = font:getWidth(button.text)
    local textH = font:getHeight(button.text)
--    love.graphics.print(backButton)
    love.graphics.print(printValue, font, (window_width * 0.5) + 133 , buttony + (textH * 0.2) + 85) --warning for this)
    love.graphics.print(backButton, font, love.graphics.getWidth()/2 - 60, 25)
    love.graphics.setColor(1,1,1,1)
  end

  for i, keyText in ipairs(keyBindChange) do
    local keyTextH = font:getHeight(keyText)
    local keyTexty = (buttonStartY + (i-1) * buttonMargin + (i-1) * button_height)
    --(window_width * 0.98)
    love.graphics.printf(keyText, font, window_width - (window_width *.98) , keyTexty + (keyTextH * 0.2) + 80, window_width/2, "center")
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

function newBackButton(text, fn)
  return {
    text = text,
    fn = fn,
    active = false
  }
end

return keybinds
