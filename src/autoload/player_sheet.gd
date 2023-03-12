# Player specific configuration
extends ActorSheet

# Texture for the player
@export var texture: Texture2D
# Texture for the invisible player
@export var invisible_texture: Texture2D
# Maximum energy
@export var max_energy: int
# Energy consummed to dig
@export var dig_energy_cost: int = 1
# Energy consummed to chew
@export var chew_energy_cost: int = 0
