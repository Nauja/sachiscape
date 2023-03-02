class_name Player
extends Actor

@export var speed: int = 120
@export var jump_speed: int = -180
@export var gravity: int = 400
@export_range(0, 1.0) var friction: float = 0.1
@export_range(0, 1.0) var acceleration: float = 0.25

var energy: int : get = _get_energy, set = _set_energy
var max_energy: int : get = _get_max_energy

@onready var _animation_player = %AnimationPlayer

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
	velocity.y += gravity * delta
	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()
	velocity = velocity
	if want_jump:
		if is_on_floor():
			want_jump = false
			velocity.y = jump_speed

func collect_carrot(other) -> bool:
	var old_energy = _get_energy()
	if old_energy >= _get_max_energy():
		return false
	
	_set_energy(old_energy + 1)
	return true
