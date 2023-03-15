class_name Player
extends Actor

# Player sheet accessors
var player_sheet: PlayerSheet:
	get:
		return actor_sheet

var max_energy: int:
	get = _get_max_energy

# Power sheet accessors
var _override_power: PowerSheet
var power: PowerSheet:
	get = _get_power,
	set = _set_power

# Current energy level
var energy: int:
	get = _get_energy,
	set = _set_energy

# Remaining duration of the super carrot effect
var super_carrot_timer: float
# If player is invisible
var _was_invisible: bool
var invisible: bool

# If on a diggable surface
var _can_dig: bool
# Chewable entity near the player
var _can_chew: Cable
var can_chew: bool:
	get:
		return _current_action == move_action and _can_chew and not _can_chew.is_cut()

@onready var sprite: Sprite2D = %Sprite2D:
	get:
		return sprite
@onready var _interaction_area: Area2D = %InteractionArea
@onready var move_action: ActorAction = %MoveAction:
	get:
		return move_action
@onready var dig_in_action: ActorDigInAction = %DigInAction:
	get:
		return dig_in_action
@onready var dig_action: ActorDigAction = %DigAction:
	get:
		return dig_action
@onready var dig_out_action: ActorDigOutAction = %DigOutAction:
	get:
		return dig_out_action


func _set_direction(value: Enums.EDirection) -> void:
	super(value)
	sprite.flip_h = value == Enums.EDirection.LEFT


func can_collect_carrot() -> bool:
	return true


# If the player has the super carrot effect
func has_super_carrot_energy() -> bool:
	return super_carrot_timer > 0.0


# If the player is invisible
func has_invisibility() -> bool:
	return invisible


func add_super_carrot_duration(value: float) -> void:
	super_carrot_timer = max(super_carrot_timer, value)
	PlayerSignals.notify_energy_changed(self, energy, energy)


func _get_power() -> PowerSheet:
	return _override_power if _override_power else player_sheet.power


func _set_power(value: PowerSheet) -> void:
	if power == value:
		return

	print("set power ", value)
	var old_power = power
	_override_power = value
	PlayerSignals.notify_power_changed(self, old_power, value)


func _get_max_energy() -> int:
	return player_sheet.max_energy


func _get_energy() -> int:
	return max_energy if has_super_carrot_energy() else energy


func _set_energy(val: int) -> void:
	if has_super_carrot_energy():
		return

	var old_energy = energy
	energy = clamp(val, 0, max_energy)
	PlayerSignals.notify_energy_changed(self, old_energy, energy)


func _ready():
	actor_sheet = GameSignals.get_game_sheet().player_sheet
	assert(actor_sheet)
	assert(sprite)
	assert(_interaction_area)
	assert(move_action)
	super()
	PlayerSignals._get_max_energy = _get_max_energy
	PlayerSignals._get_energy = _get_energy
	PlayerSignals._get_power = _get_power
	_interaction_area.connect("body_entered", _on_body_entered)
	_interaction_area.connect("body_exited", _on_body_exited)
	var level_sheet = LevelSignals.get_level_sheet()
	_set_energy(level_sheet.energy)
	power = level_sheet.power
	push_action(move_action)


func _physics_process(delta):
	if super_carrot_timer > 0.0:
		var old_energy = energy
		super_carrot_timer -= delta
		PlayerSignals.notify_energy_changed(self, old_energy, energy)

	if want_action:
		if can_chew:
			chew()
		elif power:
			power.activate(self)

	if power:
		power.physics_update(self, delta)


func _process(delta):
	super(delta)

	if power:
		power.update(self, delta)


func dig_in() -> bool:
	var enter_tile = LevelSignals.find_diggable_tile(global_position)
	if enter_tile:
		want_action = false
		dig_in_action.target = enter_tile
		push_action(dig_in_action)
		return true

	return false


func dig_out() -> bool:
	var exit_tile = LevelSignals.find_exit_dirt_tile(digger.global_position)
	if exit_tile:
		want_action = false
		dig_out_action.target = exit_tile
		push_action(dig_out_action)
		return true

	return false


func chew() -> void:
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
