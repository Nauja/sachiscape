extends Node

var _get_game_sheet: FuncRef

# A level has been selected in the main menu
signal level_selected(index)

# The test level has been selected in the main menu
signal test_level_selected()

func get_game_sheet() -> GameSheet:
	return _get_game_sheet.call_func() if _get_game_sheet else null
	
func notify_level_selected(index: int) -> void:
	emit_signal("level_selected", index)
	
func notify_test_level_selected() -> void:
	emit_signal("test_level_selected")
