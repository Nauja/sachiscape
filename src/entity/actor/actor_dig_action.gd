# Dig action generic to all actors
class_name ActorDigAction
extends ActorAction

# Target tile
var target: Vector2

var digger: Digger:
	get:
		return entity


func _do_start():
	super()
	digger.animation_player.play("dig")
	digger.motion_mode = CharacterBody2D.MotionMode.MOTION_MODE_FLOATING
	digger.gravity = 0.0
	digger.position = target


func get_input():
	var dir = Vector2(0, 0)
	if digger.owner_actor.input.x > 0:
		dir.x += 1
	if digger.owner_actor.input.x < 0:
		dir.x -= 1
	if digger.owner_actor.input.y > 0:
		dir.y += 1
	if digger.owner_actor.input.y < 0:
		dir.y -= 1
	if dir.x != 0:
		digger.velocity.x = dir.x * digger.speed
	else:
		digger.velocity.x = 0.0
	if dir.y != 0:
		digger.velocity.y = dir.y * digger.speed
	else:
		digger.velocity.y = 0.0


func _physics_process(delta):
	if not is_playing():
		return

	get_input()
	digger.set_up_direction(Vector2.UP)
	digger.move_and_slide()
	digger.owner_actor.position = digger.position

	if digger.owner_actor.want_action and digger.can_dig_out:
		digger.owner_actor.dig_out()
