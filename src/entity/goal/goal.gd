class_name Goal
extends Area2D

func _ready():
	self.connect("body_entered", self, "_on_body_entered")	

func _on_body_entered(body):
	LevelSignals.notify_goal_reached(body, self)
