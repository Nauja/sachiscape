class_name Level
extends Node2D

func _ready():
	LevelSignals.connect("carrot_collected", self, "_on_carrot_collected")
	LevelSignals.connect("energy_changed", self, "_on_energy_changed")
	LevelSignals.connect("goal_reached", self, "_on_goal_reached")
	LevelSignals.connect("reset_pressed", self, "_on_reset_pressed")
	get_node("%PlayerController").actor = get_node("%Player")

func _on_carrot_collected(player: Player, carrot: Carrot):
	print("player ", player, " collected ", carrot)

func _on_energy_changed(player: Player, old_value: int, new_value: int):
	print("player ", player, " energy changed ", old_value, " -> ", new_value)

func _on_goal_reached(player: Player, goal: Goal):
	print("player ", player, " reached goal ", goal)

func _on_reset_pressed(player: Player):
	print("reset level")
	
