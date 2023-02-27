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
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	var d = _to_dict(state)
	print("saving save: ", d)
	save_game.store_line(to_json(d))
	save_game.close()
	
func load() -> GameState:
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		var state = GameState.new()
		save(state)
		return state
	
	save_game.open("user://savegame.save", File.READ)
	var d = parse_json(save_game.get_line())
	print("loaded save: ", d)
	var state = _from_dict(d)
	save_game.close()
	return state
