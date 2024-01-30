class_name Candle
extends Area2D

var can_interact = false
@onready var interact_sprite: Sprite2D = get_node("InteractSprite")

func SetCanInteract(can: bool):
	can_interact = can
	interact_sprite.visible = can

func _process(delta):
	if can_interact:
		if Input.is_action_just_pressed("interact"):
			ALGlobal.PlayAudio(preload("res://Assets/SFX/Candle.wav"))
			ALGlobal.World.GoingDown = not ALGlobal.World.GoingDown
