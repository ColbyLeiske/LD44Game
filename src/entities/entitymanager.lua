local em = {
    entityList = {}
}

function em:draw() 
    for k,v in ipairs(self.entityList) do 
        if k.draw then k.draw() end
    end
end

function em:update(dt)
    for k,v in ipairs(self.entityList) do 
        if k.update then k.update(dt) end
    end
end

function em:addEntity(entity) 
    table.insert(self.entityList, entity)
end

return em