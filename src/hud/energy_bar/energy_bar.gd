class_name EnergyBar
extends Sprite2D

# Segments of the energy bar
@export var _fills_paths: Array[NodePath]
var _fills: Array[Sprite2D]
# Sprite regions to display
@export var _region_normal: Rect2
@export var _region_super_carrot: Rect2
# If player has the super carrot energy
var _has_super_carrot_enery: bool


func _set_energy(val: int) -> void:
	for i in range(len(self._fills)):
		_fills[i].visible = i + 1 <= val
		_fills[i].region_rect = _region_super_carrot if _has_super_carrot_enery else _region_normal


func _ready():
	_fills = []
	for i in range(len(_fills_paths)):
		_fills.append(get_node(_fills_paths[i]))
		_fills[i].visible = false

	LevelSignals.connect("energy_changed", _on_energy_changed)
	_set_energy(LevelSignals.get_energy())


func _on_energy_changed(player, old_value: int, new_value: int) -> void:
	_has_super_carrot_enery = player.has_super_carrot_energy()
	_set_energy(new_value)
