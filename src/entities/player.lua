GameObject = require('src.entities.GameObject')
Timer = require('lib.chrono.Timer')
Input = require('lib.boipushy.Input')
Projectile = require('src.entities.projectile')

local player = GameObject:extend()

function player:new(position, width, height, speed, opts)
	player.super.new(self, position, opts)
	self.input = Input()
	self.width = width
	self.height = height
	self.speed = speed

	self.input:bind('w', 'up')
	self.input:bind('d', 'right')
	self.input:bind('s', 'down')
	self.input:bind('a', 'left')

	self.input:bind('mouse1', 'fire')

end

function player:update(dt)
	player.super.update(self,dt)
	if self.input:down('up') then self.position.y = self.position.y-self.speed end
	if self.input:down('right') then self.position.x = self.position.x+self.speed end
	if self.input:down('down') then self.position.y = self.position.y+self.speed end
	if self.input:down('left') then self.position.x = self.position.x-self.speed end

	mouseX, mouseY = love.mouse.getPosition()

	angle = math.getAngle(self.position.x+(self.width/2),self.position.y+(self.height/2) , mouseX, mouseY)

	norm = self.position:normalized()
	
	if self.input:pressed('fire') then 

		local projectile = Projectile(self.position, 10, .1, norm, {})
		self.entityManager:addEntity(projectile)

	end

end

function player:draw()
	player.super.draw(self)

	love.graphics.push()
	love.graphics.translate(self.position.x+self.width, self.position.y+self.height)
	love.graphics.rotate(-angle)

	love.graphics.rectangle("fill", -self.width/2, -self.height/2, self.width, self.height);

	love.graphics.pop()

end

function math.getAngle(x1,y1, x2,y2) 
	return math.atan2(x2-x1, y2-y1) 
end

return player