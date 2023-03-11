class_name Actor
extends Entity

# Actor sheet accessors
var actor_sheet: ActorSheet

var speed: int:
	get:
		return actor_sheet.speed

var jump_speed: int:
	get:
		return actor_sheet.jump_speed

var gravity: int:
	get:
		return actor_sheet.gravity

var gravity_multiplier_falling: float:
	get:
		return actor_sheet.gravity_multiplier_falling

var friction: float:
	get:
		return actor_sheet.friction

var acceleration: float:
	get:
		return actor_sheet.acceleration

var jump_input_delay: float:
	get:
		return actor_sheet.jump_input_delay

var action_input_delay: float:
	get:
		return actor_sheet.action_input_delay

# Input values assigned from controller
var input: Vector2
# Does the actor want to jump, including a slight delay
var want_jump_timer: float
var want_jump:
	get:
		return want_jump_timer > 0.0
# Is the jump input pressed this frame
var is_jump_pressed: bool
# Is the actor currently jumping
var is_jumping: bool
# Is the actor on ground, including a slight delay
var is_on_ground_timer: float
var is_on_ground: bool:
	get:
		return is_on_ground_timer > 0.0
# Gravity multiplier for when falling
var gravity_multiplier: float = 1
# Does the actor want to do an action, including a slight delay
var want_action_timer: float
var want_action:
	get:
		return want_action_timer > 0.0
# Is the action input pressed this frame
var is_action_pressed: bool


# Return if the actor can move during this action
func can_move() -> bool:
	return true


func _process(delta):
	if want_jump_timer > 0.0:
		want_jump_timer -= delta
	if want_action_timer > 0.0:
		want_action_timer -= delta
