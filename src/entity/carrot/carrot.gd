# A carrot that grants energy to the player
@tool
class_name Carrot
extends Area2D

# Carrot configuration
@export var _carrot_sheet: Resource
var carrot_sheet: CarrotSheet:
	get:
		return _carrot_sheet

var is_super_carrot: bool:
	get:
		return carrot_sheet.is_super_carrot

var energy: int:
	get:
		return carrot_sheet.energy

var super_carrot_duration: float:
	get:
		return carrot_sheet.super_carrot_duration

# Frame coords for editor rendering only
@export var _frame_coords: Vector2i:
	get:
		return _frame_coords
	set(value):
		_frame_coords = value
		if _sprite:
			_sprite.frame_coords = _frame_coords

# Components
@onready var _sprite: Sprite2D = %Sprite2D
@onready var _animation_player: AnimationPlayer = %AnimationPlayer


func _ready():
	_frame_coords = _frame_coords
	if Engine.is_editor_hint():
		return

	_animation_player.play("idle")
	connect("body_entered", _on_body_entered)


func _on_body_entered(body):
	if Engine.is_editor_hint() or not body.can_collect_carrot():
		return

	if not is_super_carrot and body.energy >= body.max_energy:
		return

	if not is_super_carrot:
		body.energy += energy

	body.add_super_carrot_duration(super_carrot_duration)
	LevelSignals.notify_carrot_collected(body, self)
	queue_free()
