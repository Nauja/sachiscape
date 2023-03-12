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
# Dirt tilemap of the level
@onready var _dirt_tilemap: TileMap = find_child("DirtTileMap", true, false)
# Exit dirt tilemap of the level
@onready var _exit_dirt_tilemap: TileMap = find_child("ExitDirtTileMap", true, false)


func _ready():
	LevelSignals._find_diggable_tile = find_diggable_tile
	LevelSignals._find_exit_dirt_tile = find_exit_dirt_tile
	LevelSignals.connect("carrot_collected", _on_carrot_collected)
	LevelSignals.connect("energy_changed", _on_energy_changed)
	LevelSignals.connect("goal_reached", _on_goal_reached)
	LevelSignals.connect("player_detected", _on_player_detected)
	LevelSignals.connect("reset_pressed", _on_reset_pressed)
	assert(_player, "level must contain a Player node")
	assert(_player_controller, "level must contain a PlayerController node")
	assert(_player_start, "level must contain a PlayerStart node")
	assert(_level_tilemap, "missing LevelTileMap")
	if _exit_dirt_tilemap:
		_exit_dirt_tilemap.visible = false
	_player_controller.actor = _player
	_player.position = _player_start.position
	_player_start.queue_free()
	_camera.limit_left = 0
	_camera.limit_top = 0
	var bounds = _level_tilemap.get_used_rect()
	_camera.limit_right = bounds.size.x * _level_tilemap.cell_quadrant_size
	_camera.limit_bottom = bounds.size.y * _level_tilemap.cell_quadrant_size


func find_diggable_tile(pos: Vector2) -> Vector2:
	return find_nearest_tile(pos, _dirt_tilemap)


func find_exit_dirt_tile(pos: Vector2) -> Vector2:
	return find_nearest_tile(pos, _exit_dirt_tilemap)


func find_nearest_tile(pos: Vector2, tilemap: TileMap) -> Vector2:
	var cell_size = tilemap.cell_quadrant_size
	var rel_pos = pos - tilemap.global_position
	var player_pos = Vector2i(int(rel_pos.x / cell_size), int(rel_pos.y / cell_size))
	if rel_pos.x < 0:
		player_pos.x -= 1
	if rel_pos.y < 0:
		player_pos.y -= 1
	var cell_pos = Vector2i(player_pos)
	var min_length = 100000.0
	var nearest_cell = Vector2(0, 0)
	var found = false
	for i in range(-1, 2):
		cell_pos.x = player_pos.x + i
		for j in range(-1, 2):
			cell_pos.y = player_pos.y + j
			if tilemap.get_cell_source_id(0, cell_pos) != -1:
				var length = (
					Vector2(
						abs(cell_pos.x * cell_size - rel_pos.x),
						abs(cell_pos.y * cell_size - rel_pos.y)
					)
					. length()
				)
				if length < min_length:
					min_length = length
					nearest_cell.x = cell_pos.x
					nearest_cell.y = cell_pos.y
					found = true

	return (
		(
			Vector2(
				nearest_cell.x * cell_size + cell_size / 2.0,
				nearest_cell.y * cell_size + cell_size / 2.0
			)
			+ tilemap.global_position
		)
		if found
		else null
	)


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
