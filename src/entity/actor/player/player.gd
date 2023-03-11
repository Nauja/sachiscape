class_name Player
extends Actor

@export var speed: int = 120
@export var jump_speed: int = -180
@export var gravity: int = 400
@export var gravity_multiplier_falling: float = 1.5
@export_range(0, 1.0) var friction: float = 0.1
@export_range(0, 1.0) var acceleration: float = 0.25

var is_jumping: bool
var gravity_multiplier: float = 1

var energy: int:
	get = _get_energy,
	set = _set_energy
var max_energy: int:
	get = _get_max_energy

var is_on_ground_timer: float
var is_on_ground: bool:
	get:
		return is_on_ground_timer > 0.0

@onready var _animation_player = %AnimationPlayer
@onready var _area2d = %Area2D


func _set_energy(val: int) -> void:
	var old_energy = energy
	energy = clamp(val, 0, _get_max_energy())
	LevelSignals.notify_energy_changed(self, old_energy, energy)


func _get_energy() -> int:
	return energy


func _get_max_energy() -> int:
	return 3


func _ready():
	LevelSignals._get_energy = Callable(self, "_get_energy")
	_animation_player.play("idle")
	_area2d.connect("area_entered", _on_area_entered)
	_area2d.connect("area_exited", _on_area_exited)
	_area2d.connect("body_entered", _on_body_entered)
	_area2d.connect("body_exited", _on_body_exited)
	_set_energy(1)


func get_input():
	var dir = 0
	if input.x > 0:
		dir += 1
	if input.x < 0:
		dir -= 1
	if dir != 0:
		velocity.x = lerp(velocity.x, float(dir * speed), float(acceleration))
	else:
		velocity.x = lerp(velocity.x, float(0), friction)


func _physics_process(delta):
	get_input()
	velocity.y += gravity * gravity_multiplier * delta
	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()

	if is_on_floor():
		is_on_ground_timer = 0.1

	if is_jumping:
		if is_on_floor():
			is_jumping = false
			gravity_multiplier = 1
		elif not is_jump_pressed or velocity.y >= 0:
			gravity_multiplier = gravity_multiplier_falling
	if want_jump:
		if is_on_ground:
			want_jump_timer = 0.0
			velocity.y = jump_speed
			is_jumping = true
			is_on_ground_timer = 0.0


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


func _on_body_exited(body) -> void:
	if body is VentTileMap:
		body.on_body_exited(self)


func collect_carrot(other) -> bool:
	var old_energy = _get_energy()
	if old_energy >= _get_max_energy():
		return false

	_set_energy(old_energy + 1)
	return true
