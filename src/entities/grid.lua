Blocks = require 'src.entities.blocks'
PlayerBlock = require 'src.entities.playerblock'
PlayerBlockManager = require 'src.entities.playerblockmanager'
PlayerInputManager = require 'src.entities.playerinputmanager'
Input = require 'lib.boipushy.input'
lume = require 'lib.lume.lume'
sprites = require 'src.util.spriteloader'
Vector = require 'lib.hump.vector'
ScoreManager = require 'src.entities.scoremanager'
Keybinds = require 'src.states.keybinds'

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
	PlayerBlockManager:init() -- get the manager ready for block manipulation
	ScoreManager:init()

	self.input:bind('.', 'counterClockwise')
	self.input:bind('/', 'clockwise')

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
	font = love.graphics.newFont(10)
	font:setFilter('nearest','nearest',1)
	love.graphics.setFont(font)
	
	menu = require 'src.states.menu'
end

function Grid:update(dt)

	if PlayerInputManager.input:down('soft', 0.12) then self:movePlayerBlockDown() end
	if PlayerInputManager.input:down('right', 0.12) then self:movePlayerBlockXAxis(Vector(1,0)) end
	if PlayerInputManager.input:down('left', 0.12) then self:movePlayerBlockXAxis(Vector(-1,0)) end
	if PlayerInputManager.input:pressed('hard') then 
		for i=1,Constants.gridHeight do
			self:movePlayerBlockDown()
		end
		self:placePlayerBlock()
	end
	self:checkForCompletedLines()

	if self.input:pressed('counterClockwise') then self:rotate(-1) end
	if self.input:pressed('clockwise') then self:rotate(1) end

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
	--print(self.playerBlock.origin.y)
	if didMove == false then
		if self.playerBlock.origin.y == 1 then
			Gamestate.switch(menu)
		end
		self:placePlayerBlock()
		
		
	end

	--self:fixStraglers()
end

function Grid:draw()
	love.graphics.scale(Constants.windowScaleFactor,Constants.windowScaleFactor)
	love.graphics.draw(sprites.gamebackground,0,0)

	love.graphics.print(ScoreManager.score,20,5) -- render score
												 -- render time left
	--render game board
	for j=1 , Constants.gridHeight do
		for i=1, Constants.gridWidth do
			if self.grid[j][i].occupied then
				love.graphics.draw(self.grid[j][i].BlockType.blockSprite,(i-1)*Constants.tileWidth + (Constants.gameLeftOffset * Constants.tileWidth),(j-1-Constants.gridHeightBuffer)*Constants.tileHeight)
			end
		end
	end

	--render queue of blocks ahead
	--love.graphics.draw(PlayerBlockManager.blockQueue[#PlayerBlockManager.blockQueue].blockSprite,50,50)
	self:DrawShape(PlayerBlockManager.blockQueue[#PlayerBlockManager.blockQueue],Vector(18,1))

	for i = (#PlayerBlockManager.blockQueue-1),1,-1 do
		self:DrawShape(PlayerBlockManager.blockQueue[i],Vector(18,2+((math.abs(i-#PlayerBlockManager.blockQueue))*3.5)))
	end
end

function Grid:DrawShape(blockType,origin) 
	for k,v in pairs(blockType.blocks) do
		blockPos = v + origin
		love.graphics.draw(blockType.blockSprite,blockPos.x * Constants.tileWidth,blockPos.y * Constants.tileHeight)
	end

end

function Grid:newPlayerBlock() 

	blockShape = PlayerBlockManager:popLatestBlock()
	self.playerBlock = PlayerBlock(Vector(Constants.gridWidth/2,1),blockShape)
	for k,v in pairs(self.playerBlock.blockType.blocks) do
		blockPos = v + self.playerBlock.origin
		self.grid[blockPos.y][blockPos.x] = {occupied = true, BlockType = self.playerBlock.blockType, isPlayerBlock = true, newlyPlaced = false}
	end
end

--refactor to take any axis into account, and go from there for left and right block movement, except if you can't move left we won't place.
function Grid:movePlayerBlockDown()
	origin = self.playerBlock.origin
	placesToCheck = {}
	for k,v in pairs(self.playerBlock.blockType.blocks[self.playerBlock.blockType.currentRotation]) do
		v = origin + v + Vector(0,1)
		if v.y > Constants.gridHeight then return false end
		if self.grid[v.y][v.x].occupied == true and self.grid[v.y][v.x].isPlayerBlock == false then return false end
		
	end
	--breaks when i move it up to the top for loop lol
	for k,v in pairs(self.playerBlock.blockType.blocks[self.playerBlock.blockType.currentRotation]) do
		blockPos = origin + v
		if self.grid[blockPos.y][blockPos.x].newlyPlaced == false then
			self.grid[blockPos.y][blockPos.x] = {occupied=false,BlockType = Blocks.None,isPlayerBlock = false,newlyPlaced = false}
		end
		self.grid[blockPos.y+1][blockPos.x] = {occupied=true,BlockType = self.playerBlock.blockType, isPlayerBlock = true, newlyPlaced = true}
	end

	self.playerBlock.origin = self.playerBlock.origin + Vector(0,1)
	for k,v in pairs(self.playerBlock.blockType.blocks[self.playerBlock.blockType.currentRotation]) do
		blockPos = self.playerBlock.origin + v
		self.grid[blockPos.y][blockPos.x].newlyPlaced = false
	end
end

function Grid:movePlayerBlockXAxis(movementAxis)
	origin = self.playerBlock.origin
	placesToCheck = {}
	for k,v in pairs(self.playerBlock.blockType.blocks[self.playerBlock.blockType.currentRotation]) do
		v = origin + v + movementAxis
		if v.x > Constants.gridWidth or v.x <= 0 then return false end
		if self.grid[v.y][v.x].occupied == true and self.grid[v.y][v.x].isPlayerBlock == false then return false end
		
	end
	--breaks when i move it up to the top for loop lol
	for k,v in pairs(self.playerBlock.blockType.blocks[self.playerBlock.blockType.currentRotation]) do
		blockPos = origin + v
		if self.grid[blockPos.y][blockPos.x].newlyPlaced == false then
			self.grid[blockPos.y][blockPos.x] = {occupied=false,BlockType = Blocks.None,isPlayerBlock = false,newlyPlaced = false}
		end
		self.grid[blockPos.y][blockPos.x + movementAxis.x] = {occupied=true,BlockType = self.playerBlock.blockType, isPlayerBlock = true, newlyPlaced = true}
	end

	self.playerBlock.origin = self.playerBlock.origin + movementAxis
	for k,v in pairs(self.playerBlock.blockType.blocks[self.playerBlock.blockType.currentRotation]) do
		blockPos = self.playerBlock.origin + v
		self.grid[blockPos.y][blockPos.x].newlyPlaced = false
	end
end

function Grid:rotate(rotationDirection)
	index = self.playerBlock.blockType.currentRotation + rotationDirection
	if index == 0 then index = 4 
	else if index == 5 then index = 1 end end
	origin = self.playerBlock.origin
	print(index)
	
	--are any places occupied? if so, rotate cannot happen
	for k,v in pairs(self.playerBlock.blockType.blocks[index]) do
		blockPos = origin + v
		if self.grid[blockPos.y][blockPos.x] == nil then 
			if blockPos.x < 1 then 
				for k,v in pairs(self.playerBlock.blockType.blocks[index]) do
					self.playerBlock.origin.x = self.playerBlock.origin.x+1 
				end
			else 
				for k,v in pairs(self.playerBlock.blockType.blocks[index]) do
					self.playerBlock.origin.x = self.playerBlock.origin.x-1 
				end 
			end
			print('there is a wall') 
			blockPos = origin+v
		end
		if self.grid[blockPos.y][blockPos.x].occupied and self.grid[blockPos.y][blockPos.x].isPlayerBlock == false then 
			print('occupied ... cannot rotate') 
			return
		end
	end

	--Delete old blocks
	for k,v in pairs(self.playerBlock.blockType.blocks[self.playerBlock.blockType.currentRotation]) do
		blockPos = origin + v
		self.grid[blockPos.y][blockPos.x] = {occupied=false,BlockType = Blocks.None,isPlayerBlock = false,newlyPlaced = false}
	end

	--Rotate block
	for k,v in pairs(self.playerBlock.blockType.blocks[index]) do
		blockPos = origin + v
		self.grid[blockPos.y][blockPos.x] = {occupied = true, BlockType = self.playerBlock.blockType, isPlayerBlock = true, newlyPlaced = false}
	end

	self.playerBlock.blockType.currentRotation = index
end

function Grid:placePlayerBlock()
	for k,v in pairs(self.playerBlock.blockType.blocks[self.playerBlock.blockType.currentRotation]) do
		v = origin + v
		self.grid[v.y][v.x].isPlayerBlock = false
		self.grid[v.y][v.x].BlockType = self.playerBlock.blockType		
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
			table.insert(self.grid,5,newLine ) -- the 5 keeps the phantom floaters from appearing.... awesome right?
			ScoreManager:clearedLine()
		end
	end
end

return Grid