extends Node

# Return the sheet of current level
var _get_level_sheet: Callable

# Return the nearest diggable tile around a position or null
var _find_diggable_tile: Callable

# Return the nearest exit dirt tile around a position or null
var _find_exit_dirt_tile: Callable

# A carrot has been collected by the player
signal carrot_collected(player, carrot)

# Player reached the goal
signal goal_reached(player, goal)

# Player detected by an enemy
signal player_detected(player, other)

# Player pressed the reset button
signal reset_pressed(player)

# Player pressed the back to main menu button
signal back_to_main_menu_pressed(player)

# Request to load the next level
signal load_next_level

# A player action is available
signal action_available(player, target)

# The action is no longer available
signal action_unavailable(player, target)


func get_level_sheet():
	return _get_level_sheet.call() if _get_level_sheet else null


func find_diggable_tile(pos: Vector2):
	return _find_diggable_tile.call(pos) if _find_diggable_tile else null


func find_exit_dirt_tile(pos: Vector2):
	return _find_exit_dirt_tile.call(pos) if _find_exit_dirt_tile else null


func notify_carrot_collected(player, carrot):
	emit_signal("carrot_collected", player, carrot)


func notify_goal_reached(player, goal):
	emit_signal("goal_reached", player, goal)


func notify_player_detected(player, other):
	emit_signal("player_detected", player, other)


func notify_reset_pressed(player):
	emit_signal("reset_pressed", player)


func notify_back_to_main_menu_pressed(player):
	emit_signal("back_to_main_menu_pressed", player)


func notify_load_next_level():
	emit_signal("load_next_level")


func notify_action_available(player, target):
	emit_signal("action_available", player, target)


func notify_action_unavailable(player, target):
	emit_signal("action_unavailable", player, target)
