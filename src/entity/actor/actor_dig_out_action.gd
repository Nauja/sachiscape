# Exit dig action generic to all actors
class_name ActorDigOutAction
extends ActorAction

@export var _move_action_node: NodePath
@onready var _move_action: EntityAction = get_node(_move_action_node)

# Target tile
var target: Vector2


func _do_start():
	super()
	assert(actor.digger)
	actor.animation_player.play("dig_out")


func _physics_process(delta):
	if not is_playing():
		return

	actor.position = target
	actor.digger.hide()
	actor.push_action(_move_action)
