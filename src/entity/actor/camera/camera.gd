@tool
class_name Camera
extends Actor

@export var _cone_node: NodePath
@onready var _cone: Node2D = get_node(_cone_node)
@export var _cone_area_path: NodePath
@onready var _cone_area: Area2D = get_node(_cone_area_path)
# If the camera is on by default
@export var is_on: bool:
	get:
		return is_on
	set(value):
		is_on = value
		if value:
			if _cone:
				_cone.show()
		else:
			if _cone:
				_cone.hide()
			_timer = 0.0

var _player
var _timer: float


func _ready():
	if _cone_area:
		_cone_area.connect("body_entered", _on_body_entered)
		_cone_area.connect("body_exited", _on_body_exited)
	is_on = is_on


func _process(delta):
	if is_on and _player:
		if _player.has_invisibility():
			_timer = 0.0
		else:
			_timer += delta
			if _timer > 1.0:
				LevelSignals.notify_player_detected(null, self)


func _on_body_entered(body):
	_player = body
	_timer = 0.0


func _on_body_exited(body):
	_player = null


func turn_on() -> void:
	is_on = true


func turn_off() -> void:
	is_on = false
