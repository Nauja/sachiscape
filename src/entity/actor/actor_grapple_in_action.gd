class_name ActorGrappleInAction
extends ActorAction

# Grapple node
@export var _grapple_path: NodePath
@onready var _grapple: Grapple = get_node(_grapple_path)

# Speed of the grapple (divided by 100)
var grapple_speed: int
# Maximum length of the cable
var grapple_max_length: int
# Length of the cable
var _length: float
# Current state
enum EState { IN, OUT, MOVE }
var _state: EState
# Grabbed object
var _target: Post


func _ready():
	super()
	assert(_grapple)
	_grapple.length = 0
	_grapple.connect("object_hooked", _on_object_hooked)


func _do_start():
	super()
	_grapple.length = 0
	_length = 0.0
	_state = EState.IN
	actor.velocity = Vector2(0.0, 0.0)


func _physics_process(delta):
	if not is_playing():
		return

	var dir = 1.0 if _state == EState.IN else -1.0
	_length += grapple_speed * 100.0 * delta * dir
	if _state == EState.IN and _length > grapple_max_length:
		_length = grapple_max_length
		_state = EState.OUT
	elif _state != EState.IN and _length < 0.0:
		_length = 0.0
		actor.push_action(actor.move_action)

	if _state == EState.MOVE:
		var dx = abs(_grapple.length - int(_length))
		actor.position.x += dx * sign(_target.position.x - actor.position.x)

	_grapple.length = int(_length)


func _on_object_hooked(other):
	if not is_playing():
		return

	if other is Post:
		_target = other
		_state = EState.MOVE
	else:
		_state = EState.OUT
