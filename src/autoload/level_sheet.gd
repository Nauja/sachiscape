extends Resource

# Scene to load
@export var scene: PackedScene
# Initial player energy
@export var energy: int
# Override initial power of the player
@export var _power: Resource
var power: PowerSheet:
	get:
		return _power
