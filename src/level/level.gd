class_name Level
extends Node2D

# Instance of the player located in the generic scene
@onready var _player = %Player
# Instance of the 2D camera
@onready var _camera: Camera2D = %Camera
# Instance of the player controller located in the generic scene
@onready var _player_controller: PlayerController = %PlayerController
# Instance of the player start located in the level specific scene
@onready var _player_start: Node2D = find_child("PlayerStart", true, false)
# Main tilemap of the level
@onready var _level_tilemap: TileMap = find_child("LevelTileMap", true, false)


func _ready():
	LevelSignals.connect("carrot_collected", _on_carrot_collected)
	LevelSignals.connect("energy_changed", _on_energy_changed)
	LevelSignals.connect("goal_reached", _on_goal_reached)
	LevelSignals.connect("player_detected", _on_player_detected)
	LevelSignals.connect("reset_pressed", _on_reset_pressed)
	assert(_player, "level must contain a Player node")
	assert(_player_controller, "level must contain a PlayerController node")
	assert(_player_start, "level must contain a PlayerStart node")
	assert(_level_tilemap, "missing LevelTileMap")
	_player_controller.actor = _player
	_player.position = _player_start.position
	_player_start.queue_free()
	_camera.limit_left = 0
	_camera.limit_top = 0
	var bounds = _level_tilemap.get_used_rect()
	_camera.limit_right = bounds.size.x * _level_tilemap.cell_quadrant_size
	_camera.limit_bottom = bounds.size.y * _level_tilemap.cell_quadrant_size


func _on_carrot_collected(player, carrot: Carrot):
	print("player ", player, " collected ", carrot)


func _on_energy_changed(player, old_value: int, new_value: int):
	print("player ", player, " energy changed ", old_value, " -> ", new_value)


func _on_goal_reached(player, goal: Goal):
	print("player ", player, " reached goal ", goal)
	LevelSignals.notify_load_next_level()


func _on_player_detected(player, other: Actor):
	LevelSignals.notify_reset_pressed(player)


func _on_reset_pressed(player):
	print("reset level")
