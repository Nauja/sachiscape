# Cables that can be cut by chewing them
class_name Cable
extends Entity

# Frame displayed when uncut
@export var _frame_coords_uncut: Vector2i
# Frame displayed when cut
@export var _frame_coords_cut: Vector2i
# Event to trigger when cut
@export_node_path("Trigger") var _cut_trigger_path: NodePath
@onready var _cut_trigger: Trigger = get_node(_cut_trigger_path)
# Event to trigger when uncut
@export_node_path("Trigger") var _uncut_trigger_path: NodePath
@onready var _uncut_trigger: Trigger = get_node(_uncut_trigger_path)

@onready var _sprite: Sprite2D = %Sprite2D

# If the cables are cut
var _is_cut: bool


func _ready():
	assert(_sprite)
	_sprite.frame_coords = _frame_coords_uncut


func is_cut() -> bool:
	return _is_cut


# Cut the cables
func cut() -> void:
	if _is_cut:
		return

	_is_cut = true
	_sprite.frame_coords = _frame_coords_cut
	if _cut_trigger:
		_cut_trigger.trigger()


# Uncut the cables
func uncut() -> void:
	if not _is_cut:
		return

	_is_cut = false
	_sprite.frame_coords = _frame_coords_uncut
	if _uncut_trigger:
		_uncut_trigger.trigger()
