extends Node

class GameState:
	# Index of the last unlocked level
	var level_progress: int
	
func _to_dict(state: GameState) -> Dictionary:
	return {
		"level_progress": state.level_progress
	}
	
func _from_dict(state: Dictionary) -> GameState:
	var s = GameState.new()
	s.level_progress = state["level_progress"]	
	return s

func save(state: GameState) -> void:
	var save_game = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var d = _to_dict(state)
	print("saving save: ", d)
	save_game.store_line(JSON.new().stringify(d))
	save_game.close()
	
func load() -> GameState:
	if not FileAccess.file_exists("user://savegame.save"):
		var state = GameState.new()
		save(state)
		return state
	
	var save_game = FileAccess.open("user://savegame.save", FileAccess.READ)
	var test_json_conv = JSON.new()
	test_json_conv.parse(save_game.get_line())
	var d = test_json_conv.get_data()
	print("loaded save: ", d)
	var state = _from_dict(d)
	save_game.close()
	return state
