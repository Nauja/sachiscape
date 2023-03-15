# Configuration of a power usable by the player
extends Resource

# Texture for the player
@export var player_texture: Texture2D
# Texture for the energy bar
@export var energy_bar_texture: Texture2D


# Power added to the actor
func on_equipped(actor: Actor) -> void:
	actor.sprite.texture = player_texture


# Power removed from the actor
func on_unequipped(actor: Actor) -> void:
	pass


# Activate the power on an actor
func activate(actor: Actor) -> bool:
	return false


# Update the power on an actor
func update(actor: Actor, delta: float) -> void:
	pass


func physics_update(actor: Actor, delta: float) -> void:
	pass
