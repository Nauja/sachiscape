class_name Entity
extends KinematicBody2D

var _name:String = 'entity'

var _attibutes = {
	health = -1,
}

func _ready():
	print("Entity Init : ")

func get_name() -> String:
	return _name
