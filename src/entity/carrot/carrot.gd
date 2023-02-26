class_name Carrot
extends Area2D

onready var _animation_player = get_node("%AnimationPlayer")

func _ready():
	_animation_player.play("idle")
	self.connect("body_entered", self, "_on_body_entered")	

func _on_body_entered(body):
	if body.collect_carrot(self):
		LevelSignals.notify_carrot_collected(body, self)
		queue_free()
