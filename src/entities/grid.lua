Blocks = require 'src.entities.blocks'
PlayerBlock = require 'src.entities.playerblock'
Input = require 'lib.boipushy.input'
lume = require 'lib.lume.lume'

local Grid = {
	tileWidth = Constants.tileWidth*Constants.windowScaleFactor,
	tileHeight = Constants.tileHeight*Constants.windowScaleFactor,
	grid = {},
	playerBlock = nil,

	startTime = love.timer.getTime(),
	currentTime = love.timer.getTime(),
	timerThreshold = .5, -- in seconds
}

function Grid:initGrid()
	self.input = Input()
	self.input:bind('a','left')
	self.input:bind('d','right')
	self.input:bind('s','soft')
	self.input:bind('w','hard')

	for row=1, Constants.gridHeight do
		self.grid[row] = {}
		for col=1, Constants.gridWidth do
			self.grid[row][col] = {occupied = false,BlockType = Blocks.None,isPlayerBlock = false}
		end
	end

	--for testing
	for col=2, Constants.gridWidth do
		self.grid[24][col] = {occupied = true,BlockType = Blocks.Square,isPlayerBlock = false}
	end
	for col=3, 20 do
		self.grid[23][col] = {occupied = true,BlockType = Blocks.Square,isPlayerBlock = false}
	end

	self:newPlayerBlock() -- for testing

end

function Grid:update(dt)
	if self.input:down('soft', 0.12) then self:movePlayerBlockDown() end
	if self.input:down('right', 0.12) then self:movePlayerBlockXAxis(Vector(1,0)) end
	if self.input:down('left', 0.12) then self:movePlayerBlockXAxis(Vector(-1,0)) end
	if self.input:pressed('hard') then 
		for i=1,Constants.gridHeight do
			self:movePlayerBlockDown()
		end
		self:placePlayerBlock()
	end

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
		self:placePlayerBlock()
	end

	self:checkForCompletedLines()
end

function Grid:draw()
	love.graphics.scale(Constants.windowScaleFactor,Constants.windowScaleFactor)

	for col=1, Constants.gridWidth do
		love.graphics.line(Constants.tileWidth*col, 0, Constants.tileWidth*col, love.graphics.getHeight())
	end

	for row=1, Constants.gridHeight do
		love.graphics.line(0, Constants.tileHeight*row, love.graphics.getWidth(), Constants.tileHeight*row)
	end

	for j=1 , Constants.gridHeight do
		for i=1, Constants.gridWidth do
			if self.grid[j][i].occupied then
				love.graphics.rectangle("fill",(i-1)*Constants.tileWidth,(j-1-Constants.gridHeightBuffer)*Constants.tileHeight,Constants.tileWidth,Constants.tileHeight)
			end
		end
	end
end

function Grid:newPlayerBlock() 
	self.playerBlock = PlayerBlock(Vector(Constants.gridWidth/2,1),Blocks.Straight)
	for k,v in pairs(self.playerBlock.blockType) do
		blockPos = v + self.playerBlock.origin
		self.grid[blockPos.y][blockPos.x] = {occupied = true, BlockType = self.playerBlock.blockType, isPlayerBlock = true, newlyPlaced = false}
	end
end

--refactor to take any axis into account, and go from there for left and right block movement, except if you can't move left we won't place.
function Grid:movePlayerBlockDown()
	origin = self.playerBlock.origin
	placesToCheck = {}
	for k,v in pairs(self.playerBlock.blockType) do
		v = origin + v + Vector(0,1)
		if v.y > Constants.gridHeight then return false end
		if self.grid[v.y][v.x].occupied == true and self.grid[v.y][v.x].isPlayerBlock == false then return false end
		
	end
	--breaks when i move it up to the top for loop lol
	for k,v in pairs(self.playerBlock.blockType) do
		blockPos = origin + v
		if self.grid[blockPos.y][blockPos.x].newlyPlaced == false then
			self.grid[blockPos.y][blockPos.x] = {occupied=false,BlockType = Blocks.None,isPlayerBlock = false,newlyPlaced = false}
		end
		self.grid[blockPos.y+1][blockPos.x] = {occupied=true,self.playerBlock.blockType, isPlayerBlock = true, newlyPlaced = true}
	end

	self.playerBlock.origin = self.playerBlock.origin + Vector(0,1)
	for k,v in pairs(self.playerBlock.blockType) do
		blockPos = self.playerBlock.origin + v
		self.grid[blockPos.y][blockPos.x].newlyPlaced = false
	end
end

function Grid:movePlayerBlockXAxis(movementAxis)
	origin = self.playerBlock.origin
	placesToCheck = {}
	for k,v in pairs(self.playerBlock.blockType) do
		v = origin + v + movementAxis
		if v.x > Constants.gridWidth or v.x <= 0 then return false end
		if self.grid[v.y][v.x].occupied == true and self.grid[v.y][v.x].isPlayerBlock == false then return false end
		
	end
	--breaks when i move it up to the top for loop lol
	for k,v in pairs(self.playerBlock.blockType) do
		blockPos = origin + v
		if self.grid[blockPos.y][blockPos.x].newlyPlaced == false then
			self.grid[blockPos.y][blockPos.x] = {occupied=false,BlockType = Blocks.None,isPlayerBlock = false,newlyPlaced = false}
		end
		self.grid[blockPos.y][blockPos.x + movementAxis.x] = {occupied=true,self.playerBlock.blockType, isPlayerBlock = true, newlyPlaced = true}
	end

	self.playerBlock.origin = self.playerBlock.origin + movementAxis
	for k,v in pairs(self.playerBlock.blockType) do
		blockPos = self.playerBlock.origin + v
		self.grid[blockPos.y][blockPos.x].newlyPlaced = false
	end
end

function Grid:placePlayerBlock()
	for k,v in pairs(self.playerBlock.blockType) do
		v = origin + v
		self.grid[v.y][v.x].isPlayerBlock = false
		self.grid[v.y][v.x].blockType = self.playerBlock.blockType		
	end
	self:newPlayerBlock()
end

function Grid:checkForCompletedLines() 
	rowsToDelete = {}
	for i=1,Constants.gridHeight do
		local totalBlocks = 0
		for j=1,Constants.gridWidth do
			if self.grid[i][j].occupied == true and self.grid[i][j].isPlayerBlock == false then totalBlocks = totalBlocks + 1 end
		end
		if totalBlocks >= Constants.gridWidth then
			print("added line " .. i)
			table.insert(rowsToDelete,i)
		end
	end

	if #rowsToDelete >= 1 then
		for k,v in pairs(rowsToDelete) do
			newLine = {}
			for col=1, Constants.gridWidth do
				newLine[col] = {occupied = false,BlockType = Blocks.None,isPlayerBlock = false,newlyPlaced = false}
			end
			table.remove(self.grid,v)
			table.insert( self.grid,5,newLine )
			for i=1,4 do	
				for col=1, Constants.gridWidth do
					self.grid[i][col] = {occupied = false,BlockType = Blocks.None,isPlayerBlock = false,newlyPlaced = false}
				end
			end
			print("woohoo line cleared " .. v)
		end
	end
end

return Grid