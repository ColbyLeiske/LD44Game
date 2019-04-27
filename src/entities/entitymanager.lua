Object = require 'lib.classic.classic'

local em = Object:extend()

function em:new()
    self.entityList = {}
end

function em:draw() 
    for k,v in ipairs(self.entityList) do 
        v:draw()
    end
end

function em:update(dt)
    for k,v in ipairs(self.entityList) do 
        v:update(dt)
    end
end

function em:addEntity(entity) 
	entity.entityManager = self
    table.insert(self.entityList, entity)
end

return em