Sprites = require 'src.util.spriteloader'

local Blocks = {
	None = {},
	LLeft = {
		currentRotation = 1,
		drawRotation = 2,
		blocks = {
			{
				Vector(0, -1),
				Vector(0, 0),
				Vector(0, 1),
				Vector(1, 1)},
			{
				Vector(-1,0),
				Vector(0,0),
				Vector(1,0),
				Vector(1,-1)},
			{
				Vector(0,-1),
				Vector(0,1),
				Vector(0,0),
				Vector(-1,-1)},
			{
				Vector(-1,0),
				Vector(0,0),
				Vector(1,0),
				Vector(-1,1)},
		},
		blockSprite = Sprites.blueBlock,
		blockHeight = 3
	},
	LRight = {
		currentRotation = 1,
		drawRotation = 2,

		blocks = {
			{
				Vector(0,0),
				Vector(0,1),
				Vector(0,-1),
				Vector(-1,1),
			},
			{
				Vector(-1,-1),
				Vector(0,0),
				Vector(-1,0),
				Vector(1,0)
			},
			{
				Vector(0,1),
				Vector(1,-1),
				Vector(0,0),
				Vector(0,-1)
			},
			{
				Vector(-1,0),
				Vector(0,0),
				Vector(1,0),
				Vector(1,1)
			},
		},
		blockSprite = Sprites.brownBlock,
		blockHeight = 3
	},
	Straight = {
		currentRotation = 1,
		drawRotation = 2,

		blocks = {
			{
				Vector(0,0),
				Vector(0,-1),
				Vector(0,1),
				Vector(0,2),
			},
			{
				Vector(-2,0),
				Vector(0,0),
				Vector(-1,0),
				Vector(1,0),
			},
		},
		blockSprite = Sprites.lightBlueBlock,
		blockHeight = 4
	},
	Square = {
		currentRotation = 1,
		drawRotation = 1,

		blocks = {
			{
				Vector(-1,0),
				Vector(0,1),
				Vector(-1,1),
				Vector(0,0),
			},
		},
		blockSprite = Sprites.tanBlock,
		blockHeight = 2
	},
	SLeft = {
		currentRotation = 1,
		drawRotation = 1,

		blocks = {
			{
				Vector(-1,2),
				Vector(0,2),
				Vector(0,1),
				Vector(1,1),
			},
			{
				Vector(0,2),
				Vector(0,1),
				Vector(-1,1),
				Vector(-1,0),
			},
			{
				Vector(-1,2),
				Vector(0,2),
				Vector(0,1),
				Vector(1,1),
			},
			{
				Vector(0,2),
				Vector(0,1),
				Vector(-1,1),
				Vector(-1,0),
			},
		},
		blockSprite = Sprites.redBlock,
		blockHeight = 2
	},
	SRight = {
		currentRotation = 1,
		drawRotation = 1,

		blocks = {
			{
				Vector(-1,1),
				Vector(0,1),
				Vector(0,2),
				Vector(1,2),
			},
			{
				Vector(0,0),
				Vector(0,1),
				Vector(-1,1),
				Vector(-1,2),
			},
			{
				Vector(-1,1),
				Vector(0,1),
				Vector(0,2),
				Vector(1,2),
			},
			{
				Vector(0,0),
				Vector(0,1),
				Vector(-1,1),
				Vector(-1,2),
			},
		},
		blockSprite = Sprites.oliveBlock,
		blockHeight = 2
	},--Z lol
	TShape = {
		currentRotation = 1,
		drawRotation = 1,

		blocks = {
			{Vector(-1,0),
			Vector(0,0),
			Vector(1,0),
			Vector(0,1),},
			{Vector(0,1),
			Vector(0,0),
			Vector(1,0),
			Vector(0,-1),},
			{Vector(-1,0),
			Vector(0,0),
			Vector(1,0),
			Vector(0,-1),},
			{Vector(-1,0),
			Vector(0,0),
			Vector(0,1),
			Vector(0,-1),},
		},
		blockSprite = Sprites.greenBlock,
		blockHeight = 2
	}
}
return Blocks
