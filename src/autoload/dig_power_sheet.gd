class_name DigPowerSheet
extends PowerSheet

# Energy cost for entering dirt
@export var energy_cost: int


func _dig_in(actor: Actor) -> bool:
	if actor.energy < energy_cost:
		return false

	if not actor.dig_in():
		return false

	actor.energy -= energy_cost
	return true


func _dig_out(actor: Actor) -> bool:
	return actor.dig_out()


func activate(actor: Actor) -> bool:
	if actor.current_action == actor.move_action:
		return _dig_in(actor)
	elif actor.current_action == actor.dig_action:
		return _dig_out(actor)

	return false
