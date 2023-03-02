# Root scene for loading everything
extends SubViewportContainer

# Game data configuration
@export var _game_sheet: Resource

# The root node to hide when the home menu is loaded
@export var root_node: NodePath
@onready var _root = get_node(root_node)

var _current_scene
# Index of the current level
var _level_index: int
var _game_state: SaveManager.GameState

func _get_game_sheet() -> GameSheet:
	return _game_sheet
	
func _is_level_unlocked(index: int) -> bool:
	return _game_state.level_progress >= index if _game_state else false

func _ready():
	GameSignals._get_game_sheet = _get_game_sheet
	GameSignals._is_level_unlocked = _is_level_unlocked
	GameSignals.connect("level_selected", _on_level_selected)
	GameSignals.connect("test_level_selected", _on_test_level_selected)
	GameSignals.connect("reset_save", _on_reset_save)
	LevelSignals.connect("reset_pressed", _on_reset_pressed)
	LevelSignals.connect("back_to_main_menu_pressed", _on_back_to_main_menu_pressed)
	LevelSignals.connect("goal_reached", _on_goal_reached)
	LevelSignals.connect("load_next_level", _on_load_next_level)
	_game_state = SaveManager.load()
	# Display the home menu when ready
	_load_home()
	_root.queue_free()

# Load the home scene and bind events
func _load_home() -> Node:
	assert(_game_sheet.home_scene)
	var instance = _game_sheet.home_scene.instantiate()
	assert(instance)
	_current_scene = instance
	add_child(instance)
	return instance
	
# Load a level from a PackedScene
func _load_level_scene(scene: PackedScene) -> Node:
	# Load the generic scene
	assert(_game_sheet.level_scene)
	var instance = _game_sheet.level_scene.instantiate()
	assert(instance)
	# Load the level specific scene
	var sublevel = scene.instantiate()
	print("sublevel scene ", sublevel)
	assert(sublevel)
	instance.add_child(sublevel)
	add_child(instance)
	return instance
	
# Load a level by index
func _load_level(index: int) -> Node:
	assert(_game_sheet.level_scene)
	assert(index >= 0 and index < len(_game_sheet.levels))
	assert(_game_sheet.levels[index].scene)
	index = clamp(index, 0, len(_game_sheet.levels) - 1)
	var instance = _load_level_scene(_game_sheet.levels[index].scene)
	if instance:
		_level_index = index
		_current_scene = instance
	return instance
	
# Reload the current level
func _reload_level() -> Node:
	return _load_level(_level_index)
	
# Load the level at next index
func _load_next_level() -> Node:
	return _load_level(_level_index + 1)
	
func _load_test_level() -> Node:
	var instance = _load_level_scene(_game_sheet.test_level.scene)
	if instance:
		_level_index = -1
		_current_scene = instance
	return instance
	
func _remove_current_scene():
	_current_scene.queue_free()
	_current_scene = null

func _on_level_selected(index: int):
	_remove_current_scene()
	_load_level(index)
	
func _on_test_level_selected():
	_remove_current_scene()
	_load_test_level()

func _on_reset_save():
	_game_state.level_progress = 0
	SaveManager.save(_game_state)
	
func _on_reset_pressed(player: Player):
	_remove_current_scene()
	_reload_level()
	
func _on_back_to_main_menu_pressed(player: Player):
	_remove_current_scene()
	_load_home()
	
func _on_goal_reached(player: Player, goal: Goal):
	if _level_index >= _game_state.level_progress:
		_game_state.level_progress = _level_index + 1
		print("level ", _game_state.level_progress, " unlocked")
		SaveManager.save(_game_state)
	
func _on_load_next_level():
	_remove_current_scene()
	if _level_index + 1 < len(_game_sheet.levels):
		_load_next_level()
	else:
		_load_home()
