# A carrot that grants energy to the player
@tool
class_name Carrot
extends Area2D

# Carrot configuration
@export var _carrot_sheet: Resource
var carrot_sheet: CarrotSheet:
	get = _get_carrot_sheet,
	set = _set_carrot_sheet

var energy: int:
	get:
		return carrot_sheet.energy

var super_carrot_duration: float:
	get:
		return carrot_sheet.super_carrot_duration

var power: PowerSheet:
	get:
		return carrot_sheet.power

# Components
@onready var _sprite: Sprite2D = %Sprite2D
@onready var _animation_player: AnimationPlayer = %AnimationPlayer


func _get_carrot_sheet() -> CarrotSheet:
	return _carrot_sheet


func _set_carrot_sheet(val: CarrotSheet) -> void:
	_carrot_sheet = val
	if _sprite:
		_sprite.texture = val.texture


# If the carrot is a super carrot
func is_super_carrot() -> bool:
	return super_carrot_duration > 0.0


func _ready():
	carrot_sheet = carrot_sheet
	if Engine.is_editor_hint():
		return

	_animation_player.play("idle")
	connect("body_entered", _on_body_entered)


func _on_body_entered(body):
	if Engine.is_editor_hint() or not body.can_collect_carrot():
		return

	if not is_super_carrot() and not power and body.energy >= body.max_energy:
		return

	if not is_super_carrot():
		body.energy += energy

	if power:
		body.power = power

	body.add_super_carrot_duration(super_carrot_duration)
	LevelSignals.notify_carrot_collected(body, self)

	var sheet = LevelSignals.get_level_sheet()
	if not power or not sheet.power_carrot_respawn:
		queue_free()
