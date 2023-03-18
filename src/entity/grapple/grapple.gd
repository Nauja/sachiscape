class_name Grapple
extends Node2D

# The grapple hooked something
signal object_hooked(other)

# Nodes
@onready var _cable: Sprite2D = %Cable
@onready var _hook: Sprite2D = %Hook
@export var _area_path: NodePath
@onready var _area: Area2D = get_node(_area_path)

# Length of the cable
@export var length: int:
	get = _get_length,
	set = _set_length


func _get_length() -> int:
	return length


func _set_length(val: int) -> void:
	length = val
	if _cable:
		_cable.visible = length > 0
		_cable.global_scale = Vector2(length / 64.0, 16.0 / 128.0)
		_cable.material.set_shader_parameter("repeat", Vector2(length / 16.0, 1.0))
	if _hook:
		_hook.visible = length > 0
		_hook.position = Vector2(length, -8.0)


func _ready():
	length = length
	if _area:
		_area.connect("area_entered", _on_area_entered)
		_area.connect("body_entered", _on_body_entered)


func _on_area_entered(area: Area2D) -> void:
	emit_signal("object_hooked", area)


func _on_body_entered(body: Node2D) -> void:
	emit_signal("object_hooked", body)
