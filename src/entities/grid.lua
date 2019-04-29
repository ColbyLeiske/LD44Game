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

	for row=1, Constants.gridHeight do
		self.grid[row] = {}
		for col=1, Constants.gridWidth do
			self.grid[row][col] = {occupied = false,BlockType = Blocks.None,isPlayerBlock = false}
		end
	end

	self:newPlayerBlock() -- for testing
    font = love.graphics.newFont("res/fonts/goodbyeDespair.ttf", 32) -- the number denotes the font size
	font:setFilter('nearest','nearest',1)
	love.graphics.setFont(font)
	
	menu = require 'src.states.menu'
	gameover = require 'src.states.gameover'
end

function Grid:resume()
	font = love.graphics.newFont("res/fonts/goodbyeDespair.ttf", 32) -- the number denotes the font size
	font:setFilter('nearest','nearest',1)
	love.graphics.setFont(font)
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
	
	if PlayerInputManager.input:down('counter',.25) then self:rotate(-1) end
	if PlayerInputManager.input:down('clockwise',.25) then self:rotate(1) end

	self:checkForCompletedLines()


	self.currentTime = love.timer.getTime()
	if self.currentTime - self.startTime >= self.timerThreshold then
		self:tick()
		self.startTime = self.currentTime
	end

	if PlayerInputManager.input:pressed('buyLLeft') then PlayerBlockManager:purchaseBlock(Blocks.TShape) 
	elseif PlayerInputManager.input:pressed('buyLRight') then PlayerBlockManager:purchaseBlock(Blocks.Straight)
	elseif PlayerInputManager.input:pressed('buyStraight') then PlayerBlockManager:purchaseBlock(Blocks.SLeft)
	elseif PlayerInputManager.input:pressed('buySquare') then PlayerBlockManager:purchaseBlock(Blocks.LLeft)
	elseif PlayerInputManager.input:pressed('buySLeft') then PlayerBlockManager:purchaseBlock(Blocks.LRight)
	elseif PlayerInputManager.input:pressed('buySRight') then PlayerBlockManager:purchaseBlock(Blocks.Square)
	elseif PlayerInputManager.input:pressed('buyTShape') then PlayerBlockManager:purchaseBlock(Blocks.SRight)
	end
end

function Grid:tick()
	if self.playerBlock then 
		didMove = self:movePlayerBlockDown() 
	end
	--print(self.playerBlock.origin.y)
	if didMove == false then
		if self.playerBlock.origin.y == 2 then
			Gamestate.push(gameover)
		end
		self:placePlayerBlock()	
	end
end

function Grid:draw()	
	love.graphics.print(ScoreManager.score,88,34) -- render score -- needs to account for left right justificaiton
	love.graphics.scale(Constants.windowScaleFactor,Constants.windowScaleFactor)
	love.graphics.draw(sprites.gamebackground,0,0)

	--render game board
	for j=1 , Constants.gridHeight do
		for i=1, Constants.gridWidth do
			if self.grid[j][i].occupied then
				love.graphics.draw(self.grid[j][i].BlockType.blockSprite,(i-1)*Constants.tileWidth + (Constants.gameLeftOffset * Constants.tileWidth),(j-1-Constants.gridHeightBuffer)*Constants.tileHeight)
			end
		end
	end

	--render queue of blocks
	self:DrawShape(PlayerBlockManager.blockQueue[#PlayerBlockManager.blockQueue],Vector(18,1))

	for i = (#PlayerBlockManager.blockQueue-1),1,-1 do
		self:DrawShape(PlayerBlockManager.blockQueue[i],Vector(18,2+((math.abs(i-#PlayerBlockManager.blockQueue))*3.5)))
	end

	i = 0
	scale = 0.75
	for k,v in pairs(Blocks) do
		if k == 'None' then 
		else 
			self:DrawShape(v, Vector(4,(i*3 + 7)), scale, scale) 
			i = i + 1
		end
	end
end

function Grid:DrawShape(blockType,origin,sx,sy) 
	sx = sx or 1
	sy = sy or 1

	for k,v in pairs(blockType.blocks[blockType.drawRotation]) do
		blockPos = v + origin
		love.graphics.draw(blockType.blockSprite,blockPos.x * Constants.tileWidth*sx ,blockPos.y * Constants.tileHeight*sy, 0, sx, sy)
	end

end

function Grid:newPlayerBlock() 
	blockShape = PlayerBlockManager:popLatestBlock()
	self.playerBlock = PlayerBlock(Vector(Constants.gridWidth/2,2),blockShape)
	for k,v in pairs(self.playerBlock.blockType.blocks[self.playerBlock.blockType.currentRotation]) do
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

	return true
end

function Grid:rotate(rotationDirection)
	index = self.playerBlock.blockType.currentRotation + rotationDirection
	if index == 0 then index = #self.playerBlock.blockType.blocks 
	else if index == #self.playerBlock.blockType.blocks + 1 then index = 1 end end
	origin = self.playerBlock.origin
	
	--are any places occupied? if so, rotate cannot happen
	for k,v in pairs(self.playerBlock.blockType.blocks[index]) do
		blockPos = origin + v
		if self.grid[blockPos.y][blockPos.x] == nil then 
			if blockPos.x < 1 then 
				didMove = self:movePlayerBlockXAxis(Vector(1,0))
				if didMove == true then
					self:rotate(rotationDirection)
				end
				return
			else 
				didMove = self:movePlayerBlockXAxis(Vector(-1,0))
				if didMove == true then
					self:rotate(rotationDirection)
				end
				return
			end
			blockPos = origin+v
		end
		if self.grid[blockPos.y][blockPos.x].occupied and self.grid[blockPos.y][blockPos.x].isPlayerBlock == false then 
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