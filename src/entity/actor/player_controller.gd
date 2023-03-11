# Controller with player inputs
class_name PlayerController
extends ActorController

# Unique id
var id: int:
	get = get_id,
	set = set_id

# Connected input device
@onready var input_device: InputDevice = %InputDevice

var was_reset_pressed: bool
var _was_jump_pressed: bool
var _was_action_pressed: bool


func set_id(val: int) -> void:
	id = val
	name = "PlayerController" + str(val)


func get_id() -> int:
	return id


func _process(delta):
	if not actor:
		return

	if not input_device:
		actor.input.x = 0
		actor.input.y = 0
		actor.want_jump_timer = 0.0
		return

	if input_device.is_action_pressed("move_right"):
		actor.input.x = 1
	elif input_device.is_action_pressed("move_left"):
		actor.input.x = -1
	else:
		actor.input.x = 0

	if input_device.is_action_pressed("move_up"):
		actor.input.y = -1
	elif input_device.is_action_pressed("move_down"):
		actor.input.y = 1
	else:
		actor.input.y = 0

	if input_device.is_action_pressed("jump"):
		actor.is_jump_pressed = true
		if not _was_jump_pressed:
			actor.want_jump_timer = actor.jump_input_delay
			_was_jump_pressed = true
	else:
		actor.is_jump_pressed = false
		_was_jump_pressed = false

	if input_device.is_action_pressed("action"):
		actor.is_action_pressed = true
		if not _was_action_pressed:
			actor.want_action_timer = actor.action_input_delay
			_was_action_pressed = true
	else:
		actor.is_action_pressed = false
		_was_action_pressed = false

	if input_device.is_action_just_released("reset"):
		LevelSignals.notify_reset_pressed(actor)
	elif input_device.is_action_just_released("ui_cancel"):
		LevelSignals.notify_back_to_main_menu_pressed(actor)
