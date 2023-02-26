class_name Actor
extends Entity

# Input values assigned from controller
var input: Vector2

var want_jump: bool

# Return if the actor can move during this action
func can_move() -> bool:
	return true
