# Move action generic to all actors
class_name ActorMoveAction
extends ActorAction


func _do_start():
	super()
	actor.show()
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
		actor.direction = Enums.EDirection.RIGHT if dir > 0 else Enums.EDirection.LEFT
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
		# Landed on floor
		actor.is_on_ground = true
		if actor.is_jumping:
			# Stop jump
			actor.is_jumping = false
			actor.gravity_multiplier = 1

	if actor.is_jumping:
		if not actor.is_jump_pressed or actor.velocity.y >= 0:
			# Increase gravity when falling
			actor.gravity_multiplier = actor.gravity_multiplier_falling

	if actor.want_drop:
		# Drop through platform
		actor.fall_through()
	else:
		actor.cancel_fall_through()

	if actor.want_jump:
		jump()


func jump() -> void:
	if actor.is_on_ground:
		actor.want_jump = false
		actor.velocity.y = actor.jump_speed
		actor.is_jumping = true
		actor.is_on_ground = false
