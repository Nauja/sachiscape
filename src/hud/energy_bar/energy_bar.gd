class_name EnergyBar
extends Sprite2D

# The progress bar
@onready var _progress_bar: TextureProgressBar = %ProgressBar
# Textures for the two cases
@export var normal_texture: Texture2D
@export var super_texture: Texture2D
# If player has the super carrot energy
var _has_super_carrot_energy: bool
var _max_energy: int


func _set_energy(value: int, max_value: int) -> void:
	_max_energy = max_value
	_progress_bar.value = value
	_progress_bar.max_value = max_value
	_progress_bar.texture_progress = super_texture if _has_super_carrot_energy else normal_texture


func _set_power(value: PowerSheet) -> void:
	if value:
		texture = value.energy_bar_texture


func _ready():
	PlayerSignals.connect("energy_changed", _on_energy_changed)
	PlayerSignals.connect("power_changed", _on_power_changed)
	_set_power(PlayerSignals.get_power())
	_set_energy(PlayerSignals.get_energy(), PlayerSignals.get_max_energy())


func _on_energy_changed(player, old_value: int, new_value: int) -> void:
	_has_super_carrot_energy = player.has_super_carrot_energy()
	_set_energy(new_value, _max_energy)


func _on_power_changed(player, old_value: PowerSheet, new_value: PowerSheet) -> void:
	_set_power(new_value)
