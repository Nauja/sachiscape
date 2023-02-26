class_name LocalInputDevice
extends InputDevice

func is_action_pressed(name: String) -> bool:
	return Input.is_action_pressed(name)

func is_action_just_released(name: String) -> bool:
	return Input.is_action_just_released(name)
