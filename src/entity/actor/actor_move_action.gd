# Move action generic to all actors
class_name ActorMoveAction
extends ActorAction


func _do_start():
	super()
	actor.animation_player.play("idle")


func get_input():
	var dir = 0
	if actor.input.x > 0:
		dir += 1
	if actor.input.x < 0:
		dir -= 1
	if dir != 0:
		actor.velocity.x = lerp(
			actor.velocity.x, float(dir * actor.speed), float(actor.acceleration)
		)
	else:
		actor.velocity.x = lerp(actor.velocity.x, float(0), actor.friction)


func _physics_process(delta):
	if not is_playing():
		return

	get_input()
	actor.velocity.y += actor.gravity * actor.gravity_multiplier * delta
	actor.set_up_direction(Vector2.UP)
	actor.move_and_slide()

	if actor.is_on_floor():
		actor.is_on_ground_timer = 0.1

	if actor.is_jumping:
		if actor.is_on_floor():
			actor.is_jumping = false
			actor.gravity_multiplier = 1
		elif not actor.is_jump_pressed or actor.velocity.y >= 0:
			actor.gravity_multiplier = actor.gravity_multiplier_falling
	if actor.want_jump:
		jump()


func jump() -> void:
	if actor.is_on_ground:
		actor.want_jump_timer = 0.0
		actor.velocity.y = actor.jump_speed
		actor.is_jumping = true
		actor.is_on_ground_timer = 0.0
