tool
class_name LevelCard
extends Node

# Button to listen for selecting the level
onready var _button: Button = get_node("%Button")
# Label displaying the level number
onready var _label: Label = get_node("%Label")

export (int) var index: int setget _set_index

# Set the level index and update label
func _set_index(val: int) -> void:
	index = val
	if _label:
		_label.text = "TEST" if val < 0 else str(val + 1) 

func _ready():
	_button.connect("button_up", self, "_on_button_up")
	_set_index(index)

# On click notify the level has been selected
func _on_button_up():
	if index < 0:
		GameSignals.notify_test_level_selected()
	else:
		GameSignals.notify_level_selected(index)
