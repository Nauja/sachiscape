class_name Entity
extends CharacterBody2D

# Action currently playing
var _current_action: EntityAction
var current_action: EntityAction:
	get:
		return _current_action


func _process(delta):
	if _current_action and _current_action.is_done():
		_current_action = null


# Push a new action to the entity
func push_action(action: EntityAction):
	print(action)
	if _current_action:
		_current_action.cancel()

	_current_action = action
	if action:
		action.start()
