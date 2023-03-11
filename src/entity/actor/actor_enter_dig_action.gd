# Enter dig action generic to all actors
class_name ActorEnterDigAction
extends ActorAction

@export var _dig_action_node: NodePath
@onready var _dig_action: EntityAction = get_node(_dig_action_node)

# Target tile
var target: Vector2


func _do_start():
	super()
	assert(actor.digger)
	actor.animation_player.play("enter_dig")


func _physics_process(delta):
	if not is_playing():
		return

	_dig_action.target = target
	actor.digger.position = target
	actor.digger.show()
	actor.hide()
	_dig_action.entity = actor.digger
	actor.push_action(_dig_action)
