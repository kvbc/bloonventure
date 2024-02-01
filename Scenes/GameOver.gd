extends NinePatchRect


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_R and visible:
				Engine.time_scale = 1
				get_tree().paused = false
				get_tree().change_scene_to_file("res://Scenes/World.tscn")
