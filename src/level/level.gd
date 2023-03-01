class_name Level
extends Node2D

# Instance of the player located in the generic scene
onready var _player: Player = get_node("%Player")
# Instance of the player controller located in the generic scene
onready var _player_controller: PlayerController = get_node("%PlayerController")
# Instance of the player start located in the level specific scene
onready var _player_start: Node2D = find_node("PlayerStart", true, false)

func _ready():
	LevelSignals.connect("carrot_collected", self, "_on_carrot_collected")
	LevelSignals.connect("energy_changed", self, "_on_energy_changed")
	LevelSignals.connect("goal_reached", self, "_on_goal_reached")
	LevelSignals.connect("reset_pressed", self, "_on_reset_pressed")
	assert(_player, "level must contain a Player node")
	assert(_player_controller, "level must contain a PlayerController node")
	assert(_player_start, "level must contain a PlayerStart node")
	_player_controller.actor = _player
	_player.position = _player_start.position
	_player_start.queue_free()

func _on_carrot_collected(player: Player, carrot: Carrot):
	print("player ", player, " collected ", carrot)

func _on_energy_changed(player: Player, old_value: int, new_value: int):
	print("player ", player, " energy changed ", old_value, " -> ", new_value)

func _on_goal_reached(player: Player, goal: Goal):
	print("player ", player, " reached goal ", goal)
	LevelSignals.notify_load_next_level()

func _on_reset_pressed(player: Player):
	print("reset level")
	
