Sprites = require 'src.util.spriteloader'

local Blocks = {
	None = {},
	LLeft = {
		currentRotation = 1,
		blocks = {
			{Vector(1, 0),
			Vector(1, 1),
			Vector(1, 2),
			Vector(2, 2)},
			{Vector(2,1),
			Vector(1,1),
			Vector(0,1),
			Vector(0,2)},
			{Vector(1,2),
			Vector(1,1),
			Vector(1,0),
			Vector(0,0)},
			{Vector(0,1),
			Vector(1,1),
			Vector(2,1),
			Vector(2,0)},
		},
		blockSprite = Sprites.blueBlock
	},
	LRight = {
		blocks = {
			Vector(1,0),
			Vector(1,1),
			Vector(1,2),
			Vector(0,2),
		},
		blockSprite = Sprites.brownBlock
	},
	Straight = {
		blocks = {
			Vector(0,0),
			Vector(0,1),
			Vector(0,2),
			Vector(0,3),
		},
		blockSprite = Sprites.lightBlueBlock
	},
	Square = {
		currentRotation = 1,
		blocks = {
			{Vector(0,0),
			Vector(1,1),
			Vector(0,1),
			Vector(1,0),},
		},
		blockSprite = Sprites.tanBlock
	},
	SLeft = {
		blocks = {
			Vector(0,1),
			Vector(1,1),
			Vector(1,0),
			Vector(2,0),
		},
		blockSprite = Sprites.redBlock
	},
	SRight = {
		blocks = {
			Vector(0,0),
			Vector(1,0),
			Vector(1,1),
			Vector(2,1),
		},
		blockSprite = Sprites.oliveBlock
	},--Z lol
}
return Blocks
