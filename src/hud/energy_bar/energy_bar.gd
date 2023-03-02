class_name EnergyBar
extends Sprite2D

@export var _fills_paths: Array[NodePath]
var _fills: Array

func _set_energy(val: int) -> void:
	for i in range(len(self._fills)):
		_fills[i].visible = i + 1 <= val

func _ready():
	_fills = []
	for i in range(len(_fills_paths)):
		_fills.append(get_node(_fills_paths[i]))
		_fills[i].visible = false
		
	LevelSignals.connect("energy_changed", _on_energy_changed)
	_set_energy(LevelSignals.get_energy())
	
func _on_energy_changed(player: Player, old_value: int, new_value: int) -> void:
	_set_energy(new_value)
