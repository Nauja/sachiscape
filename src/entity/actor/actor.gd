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

var dig_speed: int:
	get:
		return actor_sheet.dig_speed

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

# Animation player
@onready var animation_player: AnimationPlayer = %AnimationPlayer:
	get:
		return animation_player

# Collision shape used for the physics
@onready var _physics_collision_shape: CollisionShape2D = %PhysicsCollisionShape

# Input values assigned from controller
var input: Vector2
# Does the actor want to jump, including a slight delay
var _want_jump_timer: float
var want_jump:
	get:
		return _want_jump_timer > 0.0
	set(value):
		_want_jump_timer = jump_input_delay if value else 0.0
# Is the jump input pressed this frame
var is_jump_pressed: bool
# Is the actor currently jumping
var is_jumping: bool
# Is the actor on ground, including a slight delay
var is_on_ground_timer: float
var is_on_ground: bool:
	get:
		return is_on_ground_timer > 0.0
	set(value):
		is_on_ground_timer = 0.1 if value else 0.0
# Gravity multiplier for when falling
var gravity_multiplier: float = 1
# Does the actor want to do an action, including a slight delay
var _want_action_timer: float
var want_action:
	get:
		return _want_action_timer > 0.0
	set(value):
		_want_action_timer = action_input_delay if value else 0.0
# Is the action input pressed this frame
var is_action_pressed: bool
# Actor when digging
var digger: Digger:
	get:
		return digger

var direction: Enums.EDirection:
	get = _get_direction,
	set = _set_direction


func _get_direction() -> Enums.EDirection:
	return direction


func _set_direction(value: Enums.EDirection) -> void:
	direction = value


func _ready():
	if actor_sheet.digger_sheet:
		digger = actor_sheet.digger_sheet.scene.instantiate()
		digger.actor_sheet = actor_sheet.digger_sheet
		digger.owner_actor = self
		get_parent().add_child.call_deferred(digger)


# Return if the actor can move during this action
func can_move() -> bool:
	return true


func _process(delta):
	if _want_jump_timer > 0.0:
		_want_jump_timer -= delta
	if _want_action_timer > 0.0:
		_want_action_timer -= delta
