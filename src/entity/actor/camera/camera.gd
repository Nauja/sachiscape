class_name Camera
extends Actor

@export var _cone_area_path: NodePath
@onready var _cone_area: Area2D = get_node(_cone_area_path)

var _is_player_inside: bool
var _timer: float


func _ready():
	_cone_area.connect("body_entered", _on_body_entered)
	_cone_area.connect("body_exited", _on_body_exited)


func _process(deltaTime: float):
	if _is_player_inside:
		_timer += deltaTime
		if _timer > 1.0:
			LevelSignals.notify_player_detected(null, self)


func _on_body_entered(body):
	_is_player_inside = true
	_timer = 0.0


func _on_body_exited(body):
	_is_player_inside = false
