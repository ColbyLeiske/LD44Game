GameObject = require('src.entities.GameObject')
Timer = require('lib.chrono.Timer')

local player = GameObject:extend()

input = Input()


function player:new(x, y, width, height, speed, opts)
	player.super.new(self, x,y,opts)
	self.width = width
	self.height = height
	self.speed = speed

	input:bind('w', 'up')
	input:bind('d', 'right')
	input:bind('s', 'down')
	input:bind('a', 'left')

end

function player:update(dt)
	player.super.update(self,dt)
	if input:down('up') then self.y = self.y-self.speed end
	if input:down('right') then self.x = self.x+self.speed end
	if input:down('down') then self.y = self.y+self.speed end
	if input:down('left') then self.x = self.x-self.speed end

	mouseX, mouseY = love.mouse.getPosition()

	angle = math.getAngle(self.x+(self.width/2),self.y+(self.height/2) , mouseX, mouseY)

end

function player:draw()
	player.super.draw(self)

	love.graphics.push()
	love.graphics.translate(self.x+self.width, self.y+self.height)
	love.graphics.rotate(-angle)

	love.graphics.rectangle("fill", -self.width/2, -self.height/2, self.width, self.height);

	love.graphics.pop()
end

function math.getAngle(x1,y1, x2,y2) 
	return math.atan2(x2-x1, y2-y1) 
end

return player