class_name Actor
extends Entity

# Input values assigned from controller
var input: Vector2

var want_jump_timer: float
var want_jump:
	get:
		return want_jump_timer > 0.0
var is_jump_pressed: bool


# Return if the actor can move during this action
func can_move() -> bool:
	return true


func _process(delta):
	if want_jump_timer > 0.0:
		want_jump_timer -= delta
