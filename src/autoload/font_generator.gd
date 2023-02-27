extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var tex = load("res://src/font/morobox8.png")
	var font = BitmapFont.new()
	font.add_texture(tex)
	font.set_height(8)
	for i in range (0, 16):
		for j in range(0, 16):
			font.add_char(i + j * 16, 0, Rect2(8 * i, 8 * j, 8, 8), Vector2(0, 0), 8)
	ResourceSaver.save("res://src/font/morobox8.tres",font)
