extends Node2D

func _ready():
	ALGlobal.PlayAudio(preload("res://Assets/SFX/explosion.wav"), "SFX", 0, 25)
	$AnimatedSprite2D.animation_finished.connect(queue_free)
	$AnimatedSprite2D.play()
