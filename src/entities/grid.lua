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
TimeManager = require 'src.entities.timemanager'
SoundEffects = require 'src.util.soundeffects'

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
	TimeManager:init()

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
	if ScoreManager.score >= 15 and ScoreManager.score < 25 then
		self.timerThreshold = .3
	elseif ScoreManager.score >= 25 and ScoreManager.score < 35 then
		self.timerThreshold = .25
	elseif ScoreManager.score >= 35 and ScoreManager.score < 45 then
		self.timerThreshold = .2
	elseif ScoreManager.score >= 45 and ScoreManager.score < 55 then
		self.timerThreshold = .18
	elseif ScoreManager.score >= 55 and ScoreManager.score < 65 then
		self.timerThreshold = .15
	elseif ScoreManager.score >= 65 and ScoreManager.score < 100 then
		self.timerThreshold = .13
	elseif ScoreManager.score >= 100  then
		self.timerThreshold = .1
	end

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

	if PlayerInputManager.input:pressed('buyLLeft') or PlayerInputManager.input:pressed('buyLLeftAlt') then PlayerBlockManager:purchaseBlock(Blocks.TShape) 
	elseif PlayerInputManager.input:pressed('buyLRight') or PlayerInputManager.input:pressed('buyLRightAlt') then PlayerBlockManager:purchaseBlock(Blocks.Straight)
	elseif PlayerInputManager.input:pressed('buyStraight') or PlayerInputManager.input:pressed('buyStraightAlt') then PlayerBlockManager:purchaseBlock(Blocks.SLeft)
	elseif PlayerInputManager.input:pressed('buySquare') or PlayerInputManager.input:pressed('buySquareAlt') then PlayerBlockManager:purchaseBlock(Blocks.LLeft)
	elseif PlayerInputManager.input:pressed('buySLeft') or PlayerInputManager.input:pressed('buySLeftAlt') then PlayerBlockManager:purchaseBlock(Blocks.LRight)
	elseif PlayerInputManager.input:pressed('buySRight') or PlayerInputManager.input:pressed('buySRightAlt') then PlayerBlockManager:purchaseBlock(Blocks.Square)
	elseif PlayerInputManager.input:pressed('buyTShape') or PlayerInputManager.input:pressed('buyTShapeAlt') then PlayerBlockManager:purchaseBlock(Blocks.SRight)
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

	TimeManager.time = TimeManager.time - self.timerThreshold
	if TimeManager.time <= 0 then Gamestate.switch(gameover) end
end

function Grid:draw() 
	minutes = math.floor(TimeManager.time/60)
	secondsTensPlace = math.floor((TimeManager.time%60)/10)
	secondsOnesPlace = math.floor((TimeManager.time%60) - (secondsTensPlace*10))
	love.graphics.print(minutes .. ":" .. secondsTensPlace .. secondsOnesPlace,66,100) -- render time left	
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

	topBlock = PlayerBlockManager.blockQueue[#PlayerBlockManager.blockQueue].blockType
	offsetX = (4-topBlock.blockWidth)/2
	offsetY = (3-topBlock.blockHeight)/2
	if topBlock.blockSprite == Blocks.SLeft.blockSprite or topBlock.blockSprite == Blocks.SRight.blockSprite then offsetY = offsetY-1
	elseif topBlock.blockSprite == Blocks.Straight.blockSprite then offsetX = offsetX+1 end
	self:DrawShape(topBlock,Vector(18+offsetX,1+offsetY))

	scale = 0.75
	for i = (5-1),1,-1 do
		currentBlock = PlayerBlockManager.blockQueue[i].blockType
		offsetX = (4-currentBlock.blockWidth)/2
		offsetY = (3-currentBlock.blockHeight)/2
		if currentBlock.blockSprite == Blocks.SLeft.blockSprite or currentBlock.blockSprite == Blocks.SRight.blockSprite then offsetY = offsetY-1
		elseif currentBlock.blockSprite == Blocks.Straight.blockSprite then offsetX = offsetX+1 end
		--self:DrawShape(currentBlock,Vector(24.5+offsetX, i*4+4+offsetY),scale,scale)
		self:DrawShape(currentBlock,Vector(24.5+offsetX, (math.abs(i-5))*4+4+offsetY),scale,scale)
		
	end

	i = 0
	scale = 0.5
	for k,v in pairs(Blocks) do
		if k == 'None' then 
		elseif k == 'SLeft' then 
			self:DrawShape(v, Vector(5,(i*3.5 + 11)), scale, scale)
			i = i + 1
		else 
			self:DrawShape(v, Vector(5,(i*3.5 + 12)), scale, scale) 
			i = i + 1
		end
	end
	
	love.graphics.print('Key:', Constants.tileWidth,42,0,.12,.12)
	love.graphics.print('Cost:', Constants.tileWidth*4-5,42,0,.12,.12)

	i = 1
	for k,v in pairs(Blocks) do 
		if k == 'None' then
		else
			love.graphics.print(i .. ".", Constants.tileWidth, (15*i)+33,0,.1,.1)
			love.graphics.print("- " .. v.cost,Constants.tileWidth*4, (15*i)+33,0,.12,.12)
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
	self:movePlayerBlockDown()
	self:movePlayerBlockDown()

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
		if #rowsToDelete >= 4 then
			ScoreManager:setMultiplier(1.5)
			TimeManager:setMultiplier(1.5)
		end
		for k,v in pairs(rowsToDelete) do
			newLine = {}
			for col=1, Constants.gridWidth do
				newLine[col] = {occupied = false,BlockType = Blocks.None,isPlayerBlock = false,newlyPlaced = false}
			end
			table.remove(self.grid,v)
			table.insert(self.grid,5,newLine ) -- the 5 keeps the phantom floaters from appearing.... awesome right?
			ScoreManager:clearedLine()
			TimeManager:clearedLine()
		end
		if #rowsToDelete >= 4 then
			ScoreManager:setMultiplier(1)
			TimeManager:setMultiplier(1)
			love.audio.play(SoundEffects.plop)
		else
			love.audio.play(SoundEffects.pling)
		end
	end
end

return Grid