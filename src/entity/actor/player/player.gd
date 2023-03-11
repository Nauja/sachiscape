class_name Player
extends Actor

# Player sheet accessors
var player_sheet: PlayerSheet:
	get:
		return actor_sheet

var max_energy: int:
	get:
		return player_sheet.max_energy

#
var energy: int:
	get = _get_energy,
	set = _set_energy

@onready var animation_player: AnimationPlayer = %AnimationPlayer:
	get:
		return animation_player
@onready var _area = %Area2D
@onready var _move_action = %MoveAction
@onready var _enter_dig_action = %EnterDigAction
@onready var _dig_action = %DigAction


func _set_energy(val: int) -> void:
	var old_energy = energy
	energy = clamp(val, 0, max_energy)
	LevelSignals.notify_energy_changed(self, old_energy, energy)


func _get_energy() -> int:
	return energy


func _ready():
	actor_sheet = GameSignals.get_game_sheet().player_sheet
	assert(actor_sheet)
	assert(_area)
	assert(_move_action)
	LevelSignals._get_energy = Callable(self, "_get_energy")
	_area.connect("area_entered", _on_area_entered)
	_area.connect("area_exited", _on_area_exited)
	_area.connect("body_entered", _on_body_entered)
	_area.connect("body_exited", _on_body_exited)
	_set_energy(1)
	push_action(_move_action)


func _on_area_entered(area) -> void:
	print(area)


func _on_area_exited(area) -> void:
	pass


func _on_body_entered(body) -> void:
	print(body)
	if body.is_in_group("spike"):
		LevelSignals.notify_reset_pressed(self)
	elif body is VentTileMap:
		body.on_body_entered(self)
	elif body is DirtTileMap:
		body.on_body_entered(self)


func _on_body_exited(body) -> void:
	if body is VentTileMap:
		body.on_body_exited(self)
	elif body is DirtTileMap:
		body.on_body_exited(self)


func collect_carrot(other) -> bool:
	var old_energy = _get_energy()
	if old_energy >= max_energy:
		return false

	_set_energy(old_energy + 1)
	return true
