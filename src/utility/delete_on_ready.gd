extends Node2D

export(NodePath) var _target_path

func _ready():
	var target = get_node(_target_path)
	if target:
		target.visible = false
		target.queue_free()
