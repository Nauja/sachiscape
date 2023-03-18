# Event that deactivate a camera
class_name DeactivateCameraTrigger
extends Trigger

@export_node_path("Camera") var _camera_path: NodePath
@onready var camera: Camera = get_node(_camera_path):
	get:
		return camera


func trigger() -> void:
	if camera:
		camera.turn_off()
