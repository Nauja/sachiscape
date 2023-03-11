class_name HUD
extends CanvasLayer

@onready var _energy_bar: EnergyBar = %EnergyBar
@onready var _action_input: Sprite2D = %ActionInput


func _ready():
	_action_input.visible = false
	LevelSignals.connect("action_available", _on_action_available)
	LevelSignals.connect("action_unavailable", _on_action_unavailable)


# An action is available at a specific position
func _on_action_available(player, target: Entity) -> void:
	_action_input.visible = true
	_action_input


# The action is no longer available
func _on_action_unavailable(player, target: Entity) -> void:
	_action_input.visible = false
