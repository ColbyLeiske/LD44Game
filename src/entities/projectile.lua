GameObject = require('src.entities.GameObject')
Timer = require('lib.chrono.Timer')

local projectile = GameObject:extend()

function projectile:new(position, size, speed, norm, opts)
	projectile.super.new(self, position ,opts)
	self.size = size
	self.speed = speed
	self.norm = norm

end

function projectile:update(dt)
	projectile.super.update(self,dt)

	self.position.x = self.position.x + (self.norm.x*self.speed * dt)
	self.position.y = self.position.y + (self.norm.y*self.speed * dt)

end

function projectile:draw()
	projectile.super.draw(self)

	love.graphics.push()
	love.graphics.translate(self.position.x, self.position.y)

	love.graphics.rectangle("fill", 0, 0, self.size, self.size);

	love.graphics.pop()
end

return projectile