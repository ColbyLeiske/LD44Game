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
    block = self.blockQueue[#self.blockQueue].blockType
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
            table.insert( self.blockQueue,1,{blockType = Blocks[k],purchased = false})
            return
        end
        i = i + 1
    end
end

function playerblockmanager:purchaseBlock(blockType)
    for i = #self.blockQueue,1,-1 do
        if self.blockQueue[i].purchased == false then
            self.blockQueue[i] = {blockType = blockType,purchased = true}
            TimeManager.time = TimeManager.time-blockType.cost
            return
        end
    end

end

return playerblockmanager