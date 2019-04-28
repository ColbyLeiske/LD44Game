local Blocks = {
	None = {},
	LLeft = {
		Vector(0, 0),
		Vector(0, 1),
		Vector(0, 2),
		Vector(1, 2)
	},
	LRight = {
		Vector(1,0),
		Vector(1,1),
		Vector(1,2),
		Vector(0,2),
	},
	Straight = {
		Vector(0,0),
		Vector(0,1),
		Vector(0,2),
		Vector(0,3),
	},
	Square = {
		Vector(0,0),
		Vector(1,1),
		Vector(0,1),
		Vector(1,0),
	},
	SLeft = {
		Vector(0,1),
		Vector(1,1),
		Vector(1,0),
		Vector(2,0),
	},
	SRight = {
		Vector(0,0),
		Vector(1,0),
		Vector(1,1),
		Vector(2,1),
	},--Z lol
}
return Blocks
