class_name CarrotSheet
extends Resource

# Carrot texture
@export var texture: Texture2D
# Energy granted
@export var energy: int
# Duration of the super carrot effect
@export var super_carrot_duration: float
# Power granted by the carrot
@export var _power: Resource
var power: PowerSheet:
	get:
		return _power
