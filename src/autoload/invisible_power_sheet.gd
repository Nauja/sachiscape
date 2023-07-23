class_name InvisiblePowerSheet
extends PowerSheet

# Texture for the player when invisible
@export var invisible_player_texture: Texture2D


func activate(actor: Actor) -> bool:
	actor.want_action = false
	actor.invisible = not actor.invisible
	actor.sprite.texture = invisible_player_texture if actor.invisible else player_texture
	return false


func physics_update(actor: Actor, delta: float) -> void:
	if actor.invisible:
		actor.energy -= 1 * delta
		if actor.energy <= 0:
			activate(actor)
