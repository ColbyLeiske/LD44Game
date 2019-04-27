Object = require('lib.classic.classic')
Timer = require('lib.chrono.Timer')
Lume = require ('lib.lume.lume')
Roomlist = require('src.rooms.roomlist')
sti = require ('lib.sti.sti')
bump = require ('lib.bump.bump')
Constants = require('src.util.gameconstants')
EntityManager = require 'src.entities.entitymanager'

--Kinda nasty to replicate the exact entity logic but Id like to have these seperated explicitly for the sake of everyone

local Room = Object:extend()

function Room:new(mapChoice)
    self.mapChoice = mapChoice
    self.mapPath = Roomlist[self.mapChoice]
    self.map = sti(self.mapPath,{"bump"})
    self.world = bump.newWorld(16)
    self.map:bump_init(self.world)

    self.timer = Timer()

    self.entityManager = EntityManager()
end

function Room:enter()
    --self.map:bump_init(self.world)
end

function Room:exit() 
    for k,v in ipairs(self.map.bump_collidables) do
       -- self.world:remove(item)
    end
end

function Room:update(dt)
    if self.timer then self.timer:update(dt) end
    if self.map then self.map:update(dt) end
    if self.entityManager then self.entityManager:update(dt) end
end

function Room:drawMap()
    if self.map then self.map:draw(0,0,Constants.windowScaleFactor,Constants.windowScaleFactor) end
end

function Room:drawEntity()
    if self.entityManager then self.entityManager:draw() end
end

function Room:addEntity(entity) 
    self.entityManager:addEntity(entity)  
end

return Room