extends Control

var move_to = Vector2.ZERO
var value = 0

func _ready():
	#set_process(false)
	rotation_degrees = randf_range(-25, 25)
	#await get_tree().create_timer(randf_range(0.1,0.4)).timeout
	#set_process(true)

func _process(delta):
	if global_position.is_equal_approx(move_to):
		set_process(false)
		ALGlobal.World.Currency += 1
		ALGlobal.PlayAudio(preload("res://Assets/SFX/coin.wav"), "SFX",0,-5)
		queue_free()
	global_position = global_position.move_toward(move_to, delta * 1500)
