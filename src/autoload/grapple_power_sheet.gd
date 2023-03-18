extends PowerSheet

# Energy cost
@export var energy_cost: int
# Speed of the grapple (divided by 100)
@export var grapple_speed: int
# Maximum length of the cable (in pixels)
@export var grapple_max_length: int


func activate(actor: Actor) -> bool:
	if actor.current_action != actor.move_action:
		return false

	if actor.energy < energy_cost:
		return false

	actor.grapple(grapple_speed, grapple_max_length)
	actor.energy -= energy_cost
	return true
