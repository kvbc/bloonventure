extends CharacterBody2D
class_name Balloon

#func GetSize():
	#return $Sprite2D.texture.get_size() * $Sprite2D.scale

var died = false

func IsOnScreen():
	return $VisibleOnScreenNotifier2D.is_on_screen()

func Die():
	if not died:
		died = true
		ALGlobal.World.StopMusic()
		Engine.time_scale = 0.25
		var explosion = preload("res://Scenes/Effects/Explosion.tscn").instantiate()
		explosion.global_position = global_position
		get_tree().current_scene.add_child(explosion)
		await get_tree().create_timer(1).timeout
		ALGlobal.World.GameOver("Your bloon exploded due to high pressure!")
