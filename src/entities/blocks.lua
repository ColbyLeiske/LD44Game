Sprites = require 'src.util.spriteloader'

local Blocks = {
	None = {},
	LLeft = {
		blocks = {
			Vector(0, 0),
			Vector(0, 1),
			Vector(0, 2),
			Vector(1, 2),
		},
		blockSprite = Sprites.blueBlock,
		blockHeight = 3
	},
	LRight = {
		blocks = {
			Vector(1,0),
			Vector(1,1),
			Vector(1,2),
			Vector(0,2),
		},
		blockSprite = Sprites.brownBlock,
		blockHeight = 3
	},
	Straight = {
		blocks = {
			Vector(0,0),
			Vector(0,1),
			Vector(0,2),
			Vector(0,3),
		},
		blockSprite = Sprites.lightBlueBlock,
		blockHeight = 4
	},
	Square = {
		blocks = {
			Vector(0,0),
			Vector(1,1),
			Vector(0,1),
			Vector(1,0),
		},
		blockSprite = Sprites.tanBlock,
		blockHeight = 2
	},
	SLeft = {
		blocks = {
			Vector(0,1),
			Vector(1,1),
			Vector(1,0),
			Vector(2,0),
		},
		blockSprite = Sprites.redBlock,
		blockHeight = 2
	},
	SRight = {
		blocks = {
			Vector(0,0),
			Vector(1,0),
			Vector(1,1),
			Vector(2,1),
		},
		blockSprite = Sprites.oliveBlock,
		blockHeight = 2
	},--Z lol
	TShape = {
		blocks = {
			Vector(-1,0),
			Vector(0,0),
			Vector(1,0),
			Vector(0,1),
		},
		blockSprite = Sprites.greenBlock,
		blockHeight = 2
	}
}
return Blocks
