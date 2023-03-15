extends Node2D

# Return the player max energy
var _get_max_energy: Callable

# Return the player energy
var _get_energy: Callable

# Return the player power
var _get_power: Callable

# Player energy changed
signal energy_changed(player, old_value, new_value)

# Player power changed
signal power_changed(player, old_value, new_value)


func get_max_energy() -> int:
	return _get_max_energy.call() if _get_max_energy else 0


func get_energy() -> int:
	return _get_energy.call() if _get_energy else 0


func get_power() -> PowerSheet:
	return _get_power.call() if _get_power else null


func notify_energy_changed(player, old_value: int, new_value: int):
	emit_signal("energy_changed", player, old_value, new_value)


func notify_power_changed(player, old_value: PowerSheet, new_value: PowerSheet):
	emit_signal("power_changed", player, old_value, new_value)
