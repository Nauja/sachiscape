class_name LevelChooser
extends Node

@export var _level_card_scene: PackedScene

@onready var _grid: GridContainer = %GridContainer

func _ready():
	_populate()

func _populate() -> void:
	var game_sheet = GameSignals.get_game_sheet()
	for i in range(len(game_sheet.levels)):
		print("instance")
		var card = _level_card_scene.instantiate()
		card.index = i
		_grid.add_child(card)
