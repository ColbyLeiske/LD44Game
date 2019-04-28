Input = require('lib.boipushy.Input')
GameObject = require 'src.entities.gameobject'

local StaticBlock = GameObject:extend()


function StaticBlock:new(origin, blockType, opts)
	StaticBlock.super.new(self, position, opts)
	self.input = Input()

	self.width = Constants.tileWidth*Constants.windowScaleFactor
	self.height = Constants.tileHeight*Constants.windowScaleFactor

	self.origin = origin
	self.blockType = blockType
end

return StaticBlock

