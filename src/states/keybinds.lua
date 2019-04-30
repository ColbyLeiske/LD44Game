PlayerInputManager = require 'src.entities.playerinputmanager'
Sprite = require 'src.util.spriteloader'
AudioManager = require 'src.entities.audiomanager'

local keybinds = {}

local bindNextKeyPress = {check=false, inputAction='', currentKey = ''}

function keybinds:init()
  menu = require 'src.states.menu'
  
  -- self.buttons[1] = self:newButton("Back" , function() 
  --   if self.doubleFrom ~= nil then
  --     Gamestate.pop()
  --   else
  --     Gamestate.switch(self.from) 
  --   end
  -- end,'back')
  -- self.buttons[3] = self:newButton("Drag left", function() self:setupNewKeybind(PlayerInputManager.keyActionAssociations['left'],'left') end, 'left')
  -- self.buttons[5] = self:newButton("Drag right", function() self:setupNewKeybind(PlayerInputManager.keyActionAssociations['right'],'right') end,'right')
  -- self.buttons[4] = self:newButton("Soft drop", function()self:setupNewKeybind(PlayerInputManager.keyActionAssociations['soft'],'soft') end,'soft')
  -- self.buttons[2] = self:newButton("Hard drop", function() self:setupNewKeybind(PlayerInputManager.keyActionAssociations['hard'],'hard') end,'hard')
  -- self.buttons[6] = self:newButton("Rotate clockwise", function() self:setupNewKeybind(PlayerInputManager.keyActionAssociations['clockwise'],'clockwise') end, 'clockwise')
  -- self.buttons[7] = self:newButton("Rotate counterclockwise", function() self:setupNewKeybind(PlayerInputManager.keyActionAssociations['counter'],'counter') end,'counter')
  -- print(#self.buttons)

  self.font = love.graphics.newFont("res/fonts/goodbyeDespair.ttf", 8) -- the number denotes the font size
	self.font:setFilter('nearest','nearest',1)
	love.graphics.setFont(self.font)
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
  local mousex, mousey = love.mouse.getPosition()

  if PlayerInputManager.input:pressed('left_click') then
    print ("X:" .. mousex .. ' Y: ' .. mousey)
    --back button
    if isInBounds(288,512,414,558) then
      if bindNextKeyPress.check == true then
        PlayerInputManager.keyActionAssociations[bindNextKeyPress.inputAction] = bindNextKeyPress.currentKey
        bindNextKeyPress = {check=false, inputAction='', currentKey = ''}
      end
      if self.doubleFrom ~= nil then
        Gamestate.pop()
      else
        Gamestate.switch(self.from) 
      end
    end

    if isInBounds(321,297,351,326) then
      --w
      self:prepareNewBinding('hard')
    elseif isInBounds(321,152,351,183) then
      --a
      self:prepareNewBinding('left')
    elseif isInBounds(321,248,350,279) then
      --s
      self:prepareNewBinding('soft')
    elseif isInBounds(320,200,350,230) then
      --d
      self:prepareNewBinding('right')
    elseif isInBounds(321,345,349,374) then
      --c
      self:prepareNewBinding('clockwise')
    elseif isInBounds(321,392,351,424) then
      --v
      self:prepareNewBinding('counter')
    end
  end
end

function keybinds:draw()
  love.graphics.scale(4,4)
  love.graphics.draw(Sprite.keybindsbackground,0,0)

  love.graphics.print("Move Left",114/4 + 2,154/4)
  love.graphics.print(PlayerInputManager.keyActionAssociations['left'],114/4 + 53.5 , 154/4)

  love.graphics.print("Move Right",114/4 + 2,204/4)
  love.graphics.print(PlayerInputManager.keyActionAssociations['right'],114/4 + 53.5 , 204/4)

  love.graphics.print("Soft Fall",114/4 + 2,250/4)
  love.graphics.print(PlayerInputManager.keyActionAssociations['soft'],114/4 + 53.5 , 250/4)

  love.graphics.print("Hard Fall",114/4 + 2,300/4)
  love.graphics.print(PlayerInputManager.keyActionAssociations['hard'],114/4 + 53.5 , 300/4)

  love.graphics.print("Clockwise",114/4 + 2,350/4)
  love.graphics.print(PlayerInputManager.keyActionAssociations['clockwise'],114/4 + 53.5 , 350/4)

  love.graphics.print("Counter",114/4 + 2,396/4)
  love.graphics.print(PlayerInputManager.keyActionAssociations['counter'],114/4 + 53.5 , 396/4)

  love.graphics.print("Buy T",80 + 20,154/4 - 6)
  love.graphics.print("Buy I",80 + 20,204/4 - 6)
  love.graphics.print("Buy S",80 + 20,250/4 - 6)
  love.graphics.print("Buy L",80 + 20,300/4 - 6)
  love.graphics.print("Buy J",80 + 20,350/4 - 6)
  love.graphics.print("Buy O",80 + 20,396/4 - 6)
  love.graphics.print("Buy Z",80 + 20,419/4 )

  love.graphics.print("1",80 + 50,154/4 - 6)
  love.graphics.print("2",80 + 50,204/4 - 6)
  love.graphics.print("3",80 + 50,250/4 - 6)
  love.graphics.print("4",80 + 50,300/4 - 6)
  love.graphics.print("5",80 + 50,350/4 - 6)
  love.graphics.print("6",80 + 50,396/4 - 6)
  love.graphics.print("7",80 + 50,419/4 )

  love.graphics.print("Back",288/4 + 6.5,512/4 + 2.5 )


end

function keybinds:prepareNewBinding(inputAction) 
  bindNextKeyPress = {check=true,inputAction=inputAction,currentKey=PlayerInputManager.keyActionAssociations[inputAction]}
  PlayerInputManager.keyActionAssociations[inputAction] = '...'
end

function keybinds:keyreleased(key)

  if bindNextKeyPress.check then
    for k,v in pairs(PlayerInputManager.keyActionAssociations) do
      if v == key then
        print('key taken')
        return
      end
    end
    PlayerInputManager.input:unbind(bindNextKeyPress.currentKey)
    PlayerInputManager.input:bind(key, bindNextKeyPress.inputAction)
    PlayerInputManager.keyActionAssociations[bindNextKeyPress.inputAction] = key
    bindNextKeyPress.check = false
  end
end

function isInBounds(x1,y1,x2,y2)
  local mousex, mousey = love.mouse.getPosition()
  return mousex > x1 and mousex < x2 and mousey > y1 and mousey < y2
end


return keybinds
