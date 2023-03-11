# Dig action generic to all actors
class_name ActorDigAction
extends ActorAction


func _do_start():
	super()
	actor.animation_player.play("dig")
