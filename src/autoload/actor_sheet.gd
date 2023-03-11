# Generic actor configuration
extends Resource

# The scene to spawn
@export var scene: PackedScene

# Physics
@export var speed: int = 120
@export var jump_speed: int = -180
@export var gravity: int = 400
@export var gravity_multiplier_falling: float = 1.5
@export_range(0, 1.0) var friction: float = 0.1
@export_range(0, 1.0) var acceleration: float = 0.25

# Input
@export var jump_input_delay: float = 0.1
@export var action_input_delay: float = 0.1

# Scene to spawn when digging
@export var _digger_sheet: Resource
var digger_sheet: ActorSheet:
	get:
		return _digger_sheet
