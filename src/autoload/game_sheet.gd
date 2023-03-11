extends Resource

# RefCounted to scene containing the home menu
@export var home_scene: PackedScene
# RefCounted to scene containing the loading screen
@export var loading_scene: PackedScene
# RefCounted to the generic level scene
@export var level_scene: PackedScene
# List of levels
@export var levels: Array[Resource]
# The test level
@export var test_level: Resource
# The player configuration
@export var player_sheet: Resource
