class_name Goal
extends Area2D


func _ready():
	connect("body_entered", _on_body_entered)


func _on_body_entered(body):
	LevelSignals.notify_goal_reached(body, self)
