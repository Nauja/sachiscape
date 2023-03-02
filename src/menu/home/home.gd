extends Menu

# Emitted when the play button is clicked
signal play

func _ready():
	%ResetSaveButton.connect("pressed", _on_reset_save_pressed)

func _on_PlayButton_pressed():
	emit_signal("play")
	
func _on_reset_save_pressed():
	GameSignals.notify_reset_save()
