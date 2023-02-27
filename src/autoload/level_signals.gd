extends Node2D

# A carrot has been collected by the player
signal carrot_collected(player, carrot)

# Player energy changed
signal energy_changed(player, old_value, new_value)

# Player reached the goal
signal goal_reached(player, goal)

# Player pressed the reset button
signal reset_pressed(player)

# Request to load the next level
signal load_next_level()

func notify_carrot_collected(player, carrot):
	emit_signal("carrot_collected", player, carrot)
	
func notify_energy_changed(player, old_value, new_value):
	emit_signal("energy_changed", player, old_value, new_value)
	
func notify_goal_reached(player, goal):
	emit_signal("goal_reached", player, goal)
	
func notify_reset_pressed(player):
	emit_signal("reset_pressed", player)
	
func notify_load_next_level():
	emit_signal("load_next_level")
