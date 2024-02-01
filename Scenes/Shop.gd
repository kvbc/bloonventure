extends NinePatchRect


# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_ESCAPE:
				%Shop.visible = not %Shop.visible
				get_tree().paused = not get_tree().paused
