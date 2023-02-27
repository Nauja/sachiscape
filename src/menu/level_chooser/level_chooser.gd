class_name LevelChooser
extends Node

export(PackedScene) var _level_card_scene

onready var _grid: GridContainer = get_node("%GridContainer")

func _ready():
	_populate()

func _populate() -> void:
	var game_sheet = GameSignals.get_game_sheet()
	for i in range(len(game_sheet.levels)):
		var card = _level_card_scene.instance()
		card.index = i
		_grid.add_child(card)
