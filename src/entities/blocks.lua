Sprites = require 'src.util.spriteloader'

local Blocks = {
	None = {},
	LLeft = {
		currentRotation = 1,
		drawRotation = 4,
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
		cost = 5
	},
	LRight = {
		currentRotation = 1,
		drawRotation = 4,

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
		cost = 5
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
		cost = 5
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
		cost = 5
	},
	SLeft = {
		currentRotation = 1,
		drawRotation = 3,

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
		cost = 5
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
		cost = 5
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
		cost = 5
	}
}
return Blocks
