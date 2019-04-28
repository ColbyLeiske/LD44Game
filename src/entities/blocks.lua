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
		blockSprite = Sprites.blueBlock
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
		blockSprite = Sprites.brownBlock
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
		blockSprite = Sprites.lightBlueBlock
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
		blockSprite = Sprites.tanBlock
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
		blockSprite = Sprites.redBlock
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
		blockSprite = Sprites.oliveBlock
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
		blockSprite = Sprites.greenBlock
	}
}
return Blocks
