class_name Player
extends Actor

export (int) var speed = 120
export (int) var jump_speed = -180
export (int) var gravity = 400
export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.25

var energy: int setget _set_energy, _get_energy
var max_energy: int setget , _get_max_energy

onready var _animation_player = $AnimationPlayer

var velocity = Vector2.ZERO

func _set_energy(val: int) -> void:
	energy = clamp(val, 0, _get_max_energy())

func _get_energy() -> int:
	return energy
	
func _get_max_energy() -> int:
	return 3

func _ready():
	_animation_player.play("idle")
	energy = 0

func get_input():
	var dir = 0
	if input.x > 0:
		dir += 1
	if input.x < 0:
		dir -= 1
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction)

func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	if want_jump:
		if is_on_floor():
			want_jump = false
			velocity.y = jump_speed

func collect_carrot(other) -> bool:
	var old_energy = _get_energy()
	if old_energy >= _get_max_energy():
		return false
	
	_set_energy(old_energy + 1)
	LevelSignals.notify_energy_changed(self, old_energy, _get_energy())
	return true
