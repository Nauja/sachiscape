class_name Player
extends Actor

# Player sheet accessors
var player_sheet: PlayerSheet:
	get:
		return actor_sheet

var max_energy: int:
	get:
		return player_sheet.max_energy

# Current energy level
var energy: int:
	get = _get_energy,
	set = _set_energy

# If on a diggable surface
var _can_dig: bool
var can_dig: bool:
	get:
		return _current_action == _move_action and _can_dig and energy > 0

@onready var _interaction_area = %InteractionArea
@onready var _move_action = %MoveAction
@onready var _enter_dig_action = %EnterDigAction
@onready var _dig_action = %DigAction


func _get_energy() -> int:
	return energy


func _set_energy(val: int) -> void:
	var old_energy = energy
	energy = clamp(val, 0, max_energy)
	LevelSignals.notify_energy_changed(self, old_energy, energy)


func _ready():
	actor_sheet = GameSignals.get_game_sheet().player_sheet
	assert(actor_sheet)
	assert(_interaction_area)
	assert(_move_action)
	super()
	LevelSignals._get_energy = _get_energy
	_interaction_area.connect("body_entered", _on_body_entered)
	_interaction_area.connect("body_exited", _on_body_exited)
	_set_energy(1)
	push_action(_move_action)


func _physics_process(delta):
	if want_action:
		if can_dig:
			dig()


# Find the nearest diggable tile around player
func find_diggable_tile() -> Vector2i:
	return LevelSignals.find_diggable_tile(global_position)


func dig() -> void:
	var diggable_tile = find_diggable_tile()
	energy -= 1
	want_action = false
	_enter_dig_action.target = diggable_tile
	push_action(_enter_dig_action)


func _on_body_entered(body) -> void:
	print("entered ", body)
	if body.is_in_group("spike"):
		LevelSignals.notify_reset_pressed(self)
	elif body is VentTileMap:
		body.on_body_entered(self)
	elif body is DirtTileMap:
		_can_dig = true


func _on_body_exited(body) -> void:
	print("exited ", body)
	if body is VentTileMap:
		body.on_body_exited(self)
	elif body is DirtTileMap:
		_can_dig = false


func collect_carrot(other) -> bool:
	var old_energy = energy
	if old_energy >= max_energy:
		return false

	_set_energy(old_energy + 1)
	return true
