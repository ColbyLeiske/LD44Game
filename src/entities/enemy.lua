GameObject = require('src.entities.gameobject')
Timer = require('lib.chrono.Timer')
Input = require('lib.boipushy.Input')

local Enemy = GameObject:extend()

function Enemy:new(x, y, opts)
    Enemy.super.new(self,x,y,opts)
    self.input = Input()

    --self.timer:tween(2, self, {x = 200, y = 100}, 'in-out-cubic')
  --  self.timer:after()
    self.currentState = {} --empty table
    self.idleState = {
      update = function(dt) print('hi') end
    }
    self.walkState = {
      update = function(dt) print('hi') end
    }
    self.currentState = self.idleState
end

function Enemy:update(dt)
    Enemy.super.update(self,dt)

    self.currentState.update(dt)
end

function Enemy:draw()
  Enemy.super.draw(self)
  love.graphics.rectangle("fill", self.x,self.y ,50,50)
end


return Enemy


--     self.movement = {
--      x = 0,
--      y = 0,
--      vx = 100,
--      vy = 10,
--    }
-- input:bind('p', 'pause')
--  self.timer:after(5, function()end)
--    if (test == true) then
--   movement.x = movement.x + (movement.vx * dt)
--    movement.y = movement.y + (movement.vy * dt)
--  end
