# Player specific configuration
class_name PlayerSheet
extends ActorSheet

# Maximum energy
@export var max_energy: int
# Initial power
@export var _power: Resource
var power: PowerSheet:
	get:
		return _power
