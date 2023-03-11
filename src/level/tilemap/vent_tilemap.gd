class_name VentTileMap
extends TileMap

# Fading speed when an actor enter/leave the vent
@export var fade_speed: float

enum _EState { VISIBLE, HIDDEN, FADE_IN, FADE_OUT }

# Current fading state
var _state: _EState = _EState.VISIBLE
# Is there an actor inside the vent
var _is_actor_inside: int


func _process(delta):
	match _state:
		_EState.VISIBLE:
			if _is_actor_inside > 0:
				_state = _EState.FADE_OUT
		_EState.HIDDEN:
			if _is_actor_inside <= 0:
				_state = _EState.FADE_IN
		_EState.FADE_OUT:
			if _fade(-1, 0.0, delta):
				_state = _EState.HIDDEN
		_EState.FADE_IN:
			if _fade(1, 1.0, delta):
				_state = _EState.VISIBLE


func _fade(direction: int, alpha: float, delta: float) -> bool:
	var color = get_layer_modulate(0)
	color.a += direction * fade_speed * delta
	set_layer_modulate(0, color)
	return (direction > 0 and color.a >= 1.0) or (direction < 0 and color.a <= 0.0)


# Driven by the actor entering
func on_body_entered(body) -> void:
	_is_actor_inside += 1


# Driven by the actor exiting
func on_body_exited(body) -> void:
	_is_actor_inside -= 1
