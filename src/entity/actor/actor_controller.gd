class_name ActorController
extends Node2D

var actor: Actor:
	get = get_actor,
	set = set_actor


func set_actor(other):
	actor = other


func get_actor():
	return actor
