Object = require('lib.classic.classic')
Roomlist = require('src.rooms.roomlist')
Room = require('src.rooms.room')
sti = require ('lib.sti.sti')
Constants = require('src.util.gameconstants')
Logger = require('src.util.logger')
Signal = require 'lib.hump.signal'
Transition = require 'src.rooms.transition'

local roommanager = Object:extend()

function roommanager:new(mapWidth,mapHeight)
    self.timer = Timer()

    self.mapWidth = mapWidth
    self.mapHeight = mapHeight

    self.mapLayout = {} --will hold our values in a 2d array. These will point to actual maps

    for i = 1, self.mapHeight do
        self.mapLayout[i] = {}
        for j = 1, self.mapWidth do
            self.mapLayout[i][j] = false --default no room here :)
        end
    end

    self.currentMap = {x=1,y=1} -- TEMMMMPPPP

    self.wallsMap = sti(Roomlist.walls, {"bump"}) 
    self.world = bump.newWorld(16)
    self.wallsMap:bump_init(self.world,"walls")

    self.mapLayout[self.currentMap.y][self.currentMap.x] = Room(2,self.world) -- spawn
    self.mapLayout[self.currentMap.y + 1][self.currentMap.x] = Room(2,self.world) -- testing room 2
    self.mapLayout[self.currentMap.y][self.currentMap.x +1] = Room(2,self.world) -- testing room 2
    self:getCurrentMap():enter()    
end

function roommanager:update(dt)
    if self.timer then self.timer:update(dt) end
    Transition:update(dt)
    self.wallsMap:update(dt)
    self:getCurrentMap():update(dt)
end

function roommanager:draw()
    
    --draw current map
    self:getCurrentMap():drawMap()
    -- draw base walls and potential doors
    self.wallsMap:drawTileLayer("base_walls",Constants.windowScaleFactor,Constants.windowScaleFactor)
    self.wallsMap:drawTileLayer("shadows",Constants.windowScaleFactor,Constants.windowScaleFactor)

    --self.wallsMap:bump_draw(self.world,0,0,1,1)
    --BumpDebug:draw(self.world)

    checkWallsRt= self:checkWalls(self.currentMap.y,self.currentMap.x)
    if checkWallsRt[1] == false then
        self.wallsMap:drawTileLayer("door_up",Constants.windowScaleFactor,Constants.windowScaleFactor)
    end
    if checkWallsRt[2] == false then
        self.wallsMap:drawTileLayer("door_down",Constants.windowScaleFactor,Constants.windowScaleFactor)
    end
    if checkWallsRt[3] == false then
        self.wallsMap:drawTileLayer("door_left",Constants.windowScaleFactor,Constants.windowScaleFactor)
    end
    if checkWallsRt[4] == false then
        self.wallsMap:drawTileLayer("door_right",Constants.windowScaleFactor,Constants.windowScaleFactor)
    end

    self:getCurrentMap():drawEntity()
    Transition:draw()
end

--returns a table of 4 values...
-- 1 up
-- 2 down
-- 3 left
-- 4 right
function roommanager:checkWalls(roomI,roomJ) 
    wallsTable = {}
    
    --up
    if roomI - 1 > 0 then
        wallsTable[1] = self.mapLayout[roomI-1][roomJ]
    else
        wallsTable[1] = false -- hit the boundaries so can't go over there 
    end
    
    --down
    if roomI + 1 <= self.mapHeight then
        wallsTable[2] = self.mapLayout[roomI+1][roomJ]
    else
        wallsTable[2] = false -- hit the boundaries so can't go over there 
    end

    --left
    if roomJ - 1 > 0 then
        wallsTable[3] = self.mapLayout[roomI][roomJ-1]
    else
        wallsTable[3] = false -- hit the boundaries so can't go over there 
    end

    --right
    if roomJ + 1 <= self.mapWidth then
        wallsTable[4] = self.mapLayout[roomI][roomJ+1]
    else
        wallsTable[4] = false -- hit the boundaries so can't go over there 
    end

    return wallsTable
end

function roommanager:changeRoom(newRoomI,newRoomJ)
    self:getCurrentMap():exit()
    Transition:start()
    self.currentMap.x = self.currentMap.x + newRoomI
    self.currentMap.y = self.currentMap.y + newRoomJ
    self:getCurrentMap():enter()
end

function roommanager:addEntity(entity)
    print("adding entity to ("..entity.position.x .. "," .. entity.position.y .. ").")
    entity.roommanager = self
    self.world:add(entity,entity.position.x,entity.position.y,15,15) --hardcoded width and height. change to size of sprite later
    self:getCurrentMap().world:add(entity,entity.position.x,entity.position.y,15,15) --hardcoded width and height. change to size of sprite later
    self:getCurrentMap():addEntity(entity)
end

function roommanager:moveEntity(entity,targetPosition)
    local actualXWalls, actualYWalls, colsWalls, lenWalls =  self.world:move(entity,targetPosition.x,targetPosition.y)
    if lenWalls > 0 then
        return actualXWalls,actualYWalls, colsWalls, lenWalls
    end
    return self:getCurrentMap().world:move(entity,targetPosition.x,targetPosition.y)
end

function roommanager:getCurrentMap() 
    return self.mapLayout[self.currentMap.y][self.currentMap.x]
end

return roommanager