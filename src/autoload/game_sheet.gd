extends Resource

# RefCounted to scene containing the home menu
@export var home_scene: PackedScene
# RefCounted to scene containing the loading screen
@export var loading_scene: PackedScene
# RefCounted to the generic level scene
@export var level_scene: PackedScene
# List of levels
@export var _levels: Array[Resource]
var levels: Array[LevelSheet]:
	get:
		var l: Array[LevelSheet] = []
		for level in _levels:
			l.append(level)
		return l
# The test level
@export var _test_level: Resource
var test_level: LevelSheet:
	get:
		return _test_level
# The player configuration
@export var _player_sheet: Resource
var player_sheet: PlayerSheet:
	get:
		return _player_sheet
