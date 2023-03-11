# Enter dig action generic to all actors
class_name ActorEnterDigAction
extends ActorAction


func _do_start():
	super()
	actor.animation_player.play("enter_dig")
