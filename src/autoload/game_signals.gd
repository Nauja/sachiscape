extends Node

var _get_game_sheet: FuncRef

var _is_level_unlocked: FuncRef

# A level has been selected in the main menu
signal level_selected(index)

# The test level has been selected in the main menu
signal test_level_selected()

# Reset the savegame
signal reset_save()

func get_game_sheet() -> GameSheet:
	return _get_game_sheet.call_func() if _get_game_sheet else null

func is_level_unlocked(index: int) -> bool:
	return _is_level_unlocked.call_func(index) if _is_level_unlocked else false
	
func notify_level_selected(index: int) -> void:
	emit_signal("level_selected", index)
	
func notify_test_level_selected() -> void:
	emit_signal("test_level_selected")
	
func notify_reset_save() -> void:
	emit_signal("reset_save")
