class_name Saw
extends Node2D

# Start and destination nodes
@export var _from_path: NodePath
@onready var _from: Node2D = get_node(_from_path)
@export var _to_path: NodePath
@onready var _to: Node2D = get_node(_to_path)
# Initial direction
@export var _direction: Enums.EDirection
# Movement speed (divided by 100)
@export var _move_speed: float
# Rotation speed of the sprite (divided by 100)
@export var _rotation_speed: float
# Nodes
@onready var _sprite: Sprite2D = %Sprite2D

# Target saw position
var _target_node: Node2D:
	get:
		if _direction == Enums.EDirection.LEFT or _direction == Enums.EDirection.UP:
			return _from
		else:
			return _to

var _target: float:
	get:
		if _direction == Enums.EDirection.LEFT or _direction == Enums.EDirection.RIGHT:
			return _target_node.position.x

		return _target_node.position.y

# Current saw position
var _current: float:
	get:
		if _direction == Enums.EDirection.LEFT or _direction == Enums.EDirection.RIGHT:
			return position.x

		return position.y
	set(val):
		if _direction == Enums.EDirection.LEFT or _direction == Enums.EDirection.RIGHT:
			position.x = val
		else:
			position.y = val

# Direction where the saw must go
var _dir: int:
	get:
		if _direction == Enums.EDirection.LEFT or _direction == Enums.EDirection.UP:
			return -1

		return 1


func _target_reached() -> bool:
	if _direction == Enums.EDirection.LEFT or _direction == Enums.EDirection.UP:
		return _current <= _target

	return _current >= _target


func _inverse_direction() -> int:
	match _direction:
		Enums.EDirection.LEFT:
			return Enums.EDirection.RIGHT
		Enums.EDirection.RIGHT:
			return Enums.EDirection.LEFT
		Enums.EDirection.UP:
			return Enums.EDirection.DOWN
		_:
			return Enums.EDirection.UP


func _physics_process(delta):
	_sprite.rotation_degrees += _rotation_speed * 100.0 * delta
	_current += _move_speed * 100.0 * delta * _dir
	if _target_reached():
		_direction = _inverse_direction()
		print("new direction ", _direction)
