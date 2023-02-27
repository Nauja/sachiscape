# Root scene for loading everything
extends ViewportContainer

# Game data configuration
export(Resource) var game_data

# The root node to hide when the home menu is loaded
export(NodePath) var root_node
onready var _root = get_node(root_node)

var _current_scene
var _level_index: int

func _ready():
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
	var instance = _load_scene(game_data.home_scene)
	instance.connect("play", self, "_on_play")
	return instance
	
func _load_level_scene(index: int) -> Node:
	index = clamp(index, 0, len(game_data.levels) - 1)
	var instance = _load_scene(game_data.levels[index].scene)
	_level_index = index
	# do something
	return instance
	
func _remove_current_scene():
	_current_scene.queue_free()
	_current_scene = null

# Called from home menu when the play button is clicked
func _on_play():
	_remove_current_scene()
	_current_scene = _load_level_scene(0)
	
func _on_reset_pressed(player: Player):
	_remove_current_scene()
	_current_scene = _load_level_scene(_level_index)
	
func _on_load_next_level():
	_remove_current_scene()
	_current_scene = _load_level_scene(_level_index + 1)
