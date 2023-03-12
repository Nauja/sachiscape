class_name Player
extends Actor

# Player sheet accessors
var player_sheet: PlayerSheet:
	get:
		return actor_sheet

var texture: Texture2D:
	get:
		return player_sheet.texture

var invisible_texture: Texture2D:
	get:
		return player_sheet.invisible_texture

var max_energy: int:
	get:
		return player_sheet.max_energy

var dig_energy_cost: int:
	get:
		return player_sheet.dig_energy_cost

var chew_energy_cost: int:
	get:
		return player_sheet.chew_energy_cost

# Current energy level
var energy: int:
	get = _get_energy,
	set = _set_energy

# Remaining duration of the super carrot effect
var super_carrot_timer: float
# Remaining duration of the invisibility effect
var invisibility_timer: float
var _was_invisible: bool

# If on a diggable surface
var _can_dig: bool
var can_dig: bool:
	get:
		return _current_action == _move_action and _can_dig and energy >= dig_energy_cost

# Chewable entity near the player
var _can_chew: Cable
var can_chew: bool:
	get:
		return (
			_current_action == _move_action
			and _can_chew
			and not _can_chew.is_cut()
			and energy >= chew_energy_cost
		)

@onready var _sprite: Sprite2D = %Sprite2D
@onready var _interaction_area: Area2D = %InteractionArea
@onready var _move_action: ActorAction = %MoveAction
@onready var _enter_dig_action: ActorAction = %EnterDigAction
@onready var _dig_action: ActorAction = %DigAction


func _set_direction(value: Enums.EDirection) -> void:
	super(value)
	_sprite.flip_h = value == Enums.EDirection.LEFT


func can_collect_carrot() -> bool:
	return true


# If the player has the super carrot effect
func has_super_carrot_energy() -> bool:
	return super_carrot_timer > 0.0


# If the player is invisible
func has_invisibility() -> bool:
	return invisibility_timer > 0.0


func add_super_carrot_duration(value: float) -> void:
	super_carrot_timer = max(super_carrot_timer, value)


func add_invisibility_duration(value: float) -> void:
	invisibility_timer = max(invisibility_timer, value)


func _get_energy() -> int:
	return max_energy if has_super_carrot_energy() else energy


func _set_energy(val: int) -> void:
	if has_super_carrot_energy():
		return

	var old_energy = energy
	energy = clamp(val, 0, max_energy)
	LevelSignals.notify_energy_changed(self, old_energy, energy)


func _ready():
	actor_sheet = GameSignals.get_game_sheet().player_sheet
	assert(actor_sheet)
	assert(_sprite)
	assert(_interaction_area)
	assert(_move_action)
	super()
	LevelSignals._get_energy = _get_energy
	_interaction_area.connect("body_entered", _on_body_entered)
	_interaction_area.connect("body_exited", _on_body_exited)
	_set_energy(1)
	_sprite.texture = texture
	push_action(_move_action)


func _physics_process(delta):
	if super_carrot_timer > 0.0:
		var old_energy = energy
		super_carrot_timer -= delta
		LevelSignals.notify_energy_changed(self, old_energy, energy)

	if invisibility_timer > 0.0:
		invisibility_timer -= delta
		if not _was_invisible:
			_sprite.texture = invisible_texture
			_was_invisible = true
	elif _was_invisible:
		_sprite.texture = texture
		_was_invisible = false

	if want_action:
		if can_dig:
			dig()
		elif can_chew:
			chew()


# Find the nearest diggable tile around player
func find_diggable_tile() -> Vector2i:
	return LevelSignals.find_diggable_tile(global_position)


func dig() -> void:
	var diggable_tile = find_diggable_tile()
	energy -= dig_energy_cost
	want_action = false
	_enter_dig_action.target = diggable_tile
	push_action(_enter_dig_action)


func chew() -> void:
	energy -= chew_energy_cost
	want_action = false
	_can_chew.cut()


func _on_body_entered(body) -> void:
	print("entered ", body)
	if body.is_in_group("spike"):
		LevelSignals.notify_reset_pressed(self)
	elif body is VentTileMap:
		body.on_body_entered(self)
	elif body is DirtTileMap:
		_can_dig = true
	elif body is Cable:
		_can_chew = body


func _on_body_exited(body) -> void:
	print("exited ", body)
	if body is VentTileMap:
		body.on_body_exited(self)
	elif body is DirtTileMap:
		_can_dig = false
	elif body is Cable:
		if _can_chew == body:
			_can_chew = null
