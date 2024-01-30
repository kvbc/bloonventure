extends Control

func _ready():
	$PlayButton.pressed.connect(func():
		ALGlobal.PlayAudio(preload("res://Assets/SFX/Click.wav"))
		get_tree().change_scene_to_file("res://Scenes/World.tscn")	
	)
