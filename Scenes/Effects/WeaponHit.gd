extends Node2D

func _ready():
	$AnimatedSprite2D.animation_finished.connect(queue_free)
	$AnimatedSprite2D.play()
