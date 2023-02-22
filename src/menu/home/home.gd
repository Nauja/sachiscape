extends Menu

# Emitted when the play button is clicked
signal play

func _on_PlayButton_pressed():
	emit_signal("play")
