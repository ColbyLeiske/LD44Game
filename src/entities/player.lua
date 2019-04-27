GameObject = require('src.entities.GameObject')
Timer = require('lib.chrono.Timer')
Input = require('lib.boipushy.Input')
Projectile = require('src.entities.projectile')
Vector = require 'lib.hump.vector'
Lume = require 'lib.lume.lume'

local player = GameObject:extend()

function player:new(position, opts)
	player.super.new(self, position, opts)

	self.name = Lume.uuid()

	self.input = Input()
	self.input:bind('w', 'up')
	self.input:bind('d', 'right')
	self.input:bind('s', 'down')
	self.input:bind('a', 'left')
	self.input:bind('mouse1', 'fire')

	self.speed = 10
end

function player:update(dt)
	player.super.update(self,dt)
	
	--mouseX, mouseY = love.mouse.getPosition()
	--angle = math.getAngle(self.position.x+(self.width/2),self.position.y+(self.height/2) , mouseX, mouseY)
	
	movementAxis = self:getMovementAxis()
	if movementAxis ~= Vector(0,0) then
		targetPosition = (movementAxis*dt*300) + self.position
		local actualX, actualY, cols, len = self.roommanager:moveEntity(self,targetPosition)
		if len > 0 then
			print("collision")
		else
			print("no collision")
		end
		print("X: "..actualX .. " Y: " .. actualY)
		self.position = Vector(actualX,actualY)
	end

	if self.input:pressed('fire') then 
		--local projectile = Projectile(self.position, 10, .1, norm, {})
		--self.entityManager:addEntity(projectile)
	end

end

function player:draw()
	player.super.draw(self)

	love.graphics.push()
	--love.graphics.translate(self.position.x+self.width, self.position.y+self.height)
	--love.graphics.rotate(-angle)
	love.graphics.setColor(1,0,0,1)
	love.graphics.rectangle("fill", self.position.x, self.position.y, 15, 15);
	love.graphics.setColor(1,1,1,1)

	love.graphics.pop()

end

function math.getAngle(x1,y1, x2,y2) 
	return math.atan2(x2-x1, y2-y1) 
end

function player:getMovementAxis() 
	movementAxis = Vector(0,0)
	if self.input:down('up') then movementAxis.y = -1 end
	if self.input:down('right') then movementAxis.x = 1 end
	if self.input:down('down') then movementAxis.y = 1 end
	if self.input:down('left') then movementAxis.x = -1 end
	return movementAxis
end

return player