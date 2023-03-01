extends Resource

# Reference to scene containing the home menu
export(PackedScene) var home_scene
# Reference to scene containing the loading screen
export(PackedScene) var loading_scene
# Reference to the generic level scene
export(PackedScene) var level_scene
# List of levels
export(Array, Resource) var levels
# The test level
export(Resource) var test_level
