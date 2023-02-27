# Root scene for loading everything
extends ViewportContainer

# Game data configuration
export(Resource) var _game_sheet

# The root node to hide when the home menu is loaded
export(NodePath) var root_node
onready var _root = get_node(root_node)

var _current_scene
var _level_index: int

func _get_game_sheet() -> GameSheet:
	return _game_sheet

func _ready():
	GameSignals._get_game_sheet = funcref(self, "_get_game_sheet")
	GameSignals.connect("level_selected", self, "_on_level_selected")
	GameSignals.connect("test_level_selected", self, "_on_test_level_selected")
	LevelSignals.connect("reset_pressed", self, "_on_reset_pressed")
	LevelSignals.connect("load_next_level", self, "_on_load_next_level")
	# Display the home menu when ready
	_current_scene = _load_home_scene()
	_root.queue_free()
	
func _load_scene(scene: PackedScene) -> Node:
	var instance = scene.instance()
	add_child(instance)
	return instance

# Load the home scene and bind events
func _load_home_scene() -> Node:
	var instance = _load_scene(_game_sheet.home_scene)
	instance.connect("play", self, "_on_play")
	return instance
	
func _load_level_scene(index: int) -> Node:
	index = clamp(index, 0, len(_game_sheet.levels) - 1)
	var instance = _load_scene(_game_sheet.levels[index].scene)
	_level_index = index
	# do something
	return instance
	
func _load_test_level_scene() -> Node:
	var instance = _load_scene(_game_sheet.test_level.scene)
	_level_index = -1
	# do something
	return instance
	
func _remove_current_scene():
	_current_scene.queue_free()
	_current_scene = null

func _on_level_selected(index: int):
	_remove_current_scene()
	_current_scene = _load_level_scene(index)
	
func _on_test_level_selected():
	_remove_current_scene()
	_current_scene = _load_test_level_scene()
	
func _on_reset_pressed(player: Player):
	_remove_current_scene()
	_current_scene = _load_level_scene(_level_index)
	
func _on_load_next_level():
	_remove_current_scene()
	if _level_index + 1 < len(_game_sheet.levels):
		_current_scene = _load_level_scene(_level_index + 1)
	else:
		_current_scene = _load_home_scene()
