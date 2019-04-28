lume = require 'lib.lume.lume'
Blocks = require 'src.entities.blocks'
Input = require 'lib.boipushy.input'

local playerblockmanager = {blockQueue = {}}

function playerblockmanager:init()
    for i= 1 , 5 do
        self:generateNewBlock()
    end
end

function playerblockmanager:popLatestBlock()
    block = self.blockQueue[#self.blockQueue]
    table.remove(self.blockQueue,#self.blockQueue)
    self:generateNewBlock()
    return block
end

function playerblockmanager:generateNewBlock()
    blockIndex = love.math.random(2,8)
    i = 2
    for k,v in pairs(Blocks) do
        if k == 'None' then i = i - 1 end
        if i == blockIndex then
            table.insert( self.blockQueue,1,Blocks[k])
            return
        end
        i = i + 1
    end
end

function playerblockmanager:purchaseBlock(blockType)
    self.blockQueue[#self.blockQueue] = blockType
end

return playerblockmanager