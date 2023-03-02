class_name LevelCard
extends Node

# Button to listen for selecting the level
@onready var _button: Button = %Button
# Label displaying the level number
@onready var _label: Label = %Label
@onready var _animation_player: AnimationPlayer = %AnimationPlayer

# Index of the level
@export var index: int : set = _set_index
# If the level is locked
@export var locked: bool : set = _set_locked

func _set_index(val: int) -> void:
	index = val
	if _label:
		_label.text = "TEST" if val < 0 else str(val + 1) 
	_set_locked(not GameSignals.is_level_unlocked(val))

func _set_locked(val: bool) -> void:
	locked = val
	if _animation_player:
		_animation_player.play("locked" if locked else "unlocked")

func _ready():
	_button.connect("button_up", _on_button_up)
	_set_index(index)

# On click notify the level has been selected
func _on_button_up():
	if locked:
		return
		
	if index < 0:
		GameSignals.notify_test_level_selected()
	else:
		GameSignals.notify_level_selected(index)
