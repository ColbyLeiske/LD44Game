Object = require('lib.classic.classic')
Roomlist = require('src.rooms.roomlist')
Room = require('src.rooms.room')
sti = require ('lib.sti.sti')
Constants = require('src.util.gameconstants')
Logger = require('src.util.logger')

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
    self.wallsMap:bump_init(self.world)

    self.mapLayout[self.currentMap.y][self.currentMap.x] = Room(1) -- spawn
    self.mapLayout[self.currentMap.y + 1][self.currentMap.x] = Room(2) -- testing room 2
    self.mapLayout[self.currentMap.y][self.currentMap.x +1] = Room(2) -- testing room 2

end

function roommanager:update(dt)
    if self.timer then self.timer:update(dt) end
    self.wallsMap:update(dt)
end

function roommanager:draw()
    
    --draw current map
   self.mapLayout[self.currentMap.y][self.currentMap.x]:draw()
    -- draw base walls and potential doors
    self.wallsMap:drawTileLayer("base_walls",Constants.windowScaleFactor,Constants.windowScaleFactor)
    self.wallsMap:drawTileLayer("shadows",Constants.windowScaleFactor,Constants.windowScaleFactor)

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
    self.currentMap.x = self.currentMap.x + newRoomI
    self.currentMap.y = self.currentMap.y + newRoomJ
end

return roommanager