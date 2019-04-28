Blocks = require 'src.entities.blocks'
PlayerBlock = require 'src.entities.playerblock'

local Grid = {
	tileWidth = Constants.tileWidth*Constants.windowScaleFactor,
	tileHeight = Constants.tileHeight*Constants.windowScaleFactor,
	grid = {},
	playerBlock = nil,

	startTime = love.timer.getTime(),
	currentTime = love.timer.getTime(),
	timerThreshold = 1, -- in seconds

}

function Grid:initGrid()
	for row=1, Constants.gridHeight do
		self.grid[row] = {}
		for col=1, Constants.gridWidth do
			self.grid[row][col] = {occupied = false,BlockType = Blocks.None}
		end
	end

	self:newPlayerBlock()

end

function Grid:update(dt)
self.currentTime = love.timer.getTime()
	if self.currentTime - self.startTime >= self.timerThreshold then
		self:tick()
		self.startTime = self.currentTime
	end
end

function Grid:tick()
	if self.playerBlock then 
		didMove = self:movePlayerBlockDown() 
	end
	if didMove == false then
		print('collision - place block here and spawn new block')
	end
end

function Grid:draw()
	-- for col=1, Constants.gridWidth do
	-- 	love.graphics.line(self.tileWidth*col, 0, self.tileWidth*col, self.tileHeight*Constants.gridHeight)
	-- end

	-- for row=1, Constants.gridHeight do
	-- 	love.graphics.line(0, self.tileHeight*row, self.tileWidth*Constants.gridWidth, self.tileHeight*row)
	-- end

	for j=1 , Constants.gridHeight do
		for i=1, Constants.gridWidth do
			if self.grid[j][i].occupied then
				love.graphics.rectangle("fill",i*Constants.tileWidth,j*Constants.tileHeight,Constants.tileWidth,Constants.tileHeight)
			end
		end
	end
end

function Grid:newPlayerBlock() 
	self.playerBlock = PlayerBlock(Vector(1,1),Blocks.LRight)
	for k,v in pairs(self.playerBlock.blockType) do
		blockPos = v + self.playerBlock.origin
		self.grid[blockPos.y][blockPos.x] = {occupied = true, BlockType = self.playerBlock.blockType, isPlayerBlock = true, newlyPlaced = false}
	end
end

function Grid:movePlayerBlockDown()
	origin = self.playerBlock.origin
	placesToCheck = {}
	for k,v in pairs(self.playerBlock.blockType) do
		table.insert(placesToCheck,origin + v + Vector(0,1)) -- origin + where our blocks are taken from blocks.lua
	end

	for k,v in pairs(placesToCheck) do
		if self.grid[v.y][v.x].occupied == true and self.grid[v.y][v.x].isPlayerBlock == false then return false end
	end

	for k,v in pairs(self.playerBlock.blockType) do
		blockPos = origin + v 
		--toBeOccupied = self.grid[blockPos.y][blockPos.x].isPlayerBlock
		--Issue: the blocks on the bottom are setting their old positions to not be occupied, but a block from above may be trying to occupy it
		if self.grid[blockPos.y][blockPos.x].newlyPlaced == false then
			self.grid[blockPos.y][blockPos.x] = {occupied=false,BlockType = Blocks.None,isPlayerBlock = false,newlyPlaced = false}
		end
		self.grid[blockPos.y+1][blockPos.x] = {occupied=true,self.playerBlock.blockType, isPlayerBlock = true, newlyPlaced = true}
	end

	self.playerBlock.origin = self.playerBlock.origin + Vector(0,1)

	for k,v in pairs(self.playerBlock.blockType) do
		blockPos = origin + v
		self.grid[blockPos.y][blockPos.x].newlyPlaced = false
		if blockPos.x > 1 then self.grid[blockPos.y][blockPos.x-1].occupied = false end
	end

end

return Grid