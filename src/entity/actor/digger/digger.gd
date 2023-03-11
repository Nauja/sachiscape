class_name Digger
extends Actor

# Actor owning this digger
var owner_actor: Actor

# Area detecting interactions
@onready var _interaction_area = %InteractionArea

# If can exit the dirt
var _can_dig_out: bool
var can_dig_out: bool:
	get:
		return _can_dig_out


func _ready():
	super()
	hide()
	_interaction_area.connect("body_entered", _on_body_entered)
	_interaction_area.connect("body_exited", _on_body_exited)


func _on_body_entered(body) -> void:
	print("entered ", body)
	if body is ExitDirtTileMap:
		_can_dig_out = true


func _on_body_exited(body) -> void:
	print("exited ", body)
	if body is ExitDirtTileMap:
		_can_dig_out = false
