Timer = require'lib.chrono.timer'


local transition = {
    isTransitioning = false,
    opacity = {a=0},
    timer = Timer(),
}

function transition:update(dt)
    self.timer:update(dt)
end

function transition:draw()
    if self.isTransitioning then
        love.graphics.setColor(1,1,1,self.opacity.a)
        love.graphics.rectangle('fill',0,0,love.graphics.getWidth(),love.graphics.getHeight())
        love.graphics.setColor(1,1,1,1)
    end
end

function transition:start()
    self.isTransitioning = true
    self.timer:tween(.5, self.opacity, {a = 1}, 'in-cubic')
    self.timer:after(.5,function() self.timer:tween(.5,self.opacity,{a=0},'in-cubic') end)
    self.timer:after(1,function() self.isTransitioning = false end)
end


return transition