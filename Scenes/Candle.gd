class_name Candle
extends Area2D

var can_interact = false
@onready var interact_sprite: Sprite2D = get_node("InteractSprite")
var fire_anim = 0

func SetCanInteract(can: bool):
	can_interact = can
	interact_sprite.visible = can

func _ready():
	$fire.visible = false
	$fire.animation_finished.connect(func():
		if $fire.animation.begins_with("start"):
			$fire.play("loop_" + str(fire_anim))
			ALGlobal.PlayAudio(preload("res://Assets/SFX/candle_loop.wav"), "SFX", 0, 3)
		elif $fire.animation.begins_with("end"):
			$fire.visible = false
	)

func _process(delta):
	if can_interact:
		if Input.is_action_just_pressed("interact"):
			#ALGlobal.PlayAudio(preload("res://Assets/SFX/Candle.wav"), "SFX")
			ALGlobal.World.GoingDown = not ALGlobal.World.GoingDown
			if not ALGlobal.World.GoingDown:
				fire_anim = randi_range(1,3)
				$fire.visible = true
				$fire.play("start_" + str(fire_anim))
				ALGlobal.PlayAudio(preload("res://Assets/SFX/candle_start.wav"), "SFX", 0.9, 20)
			else:
				ALGlobal.PlayAudio(preload("res://Assets/SFX/candle_end.wav"), "SFX", 1.1, 10)
				$fire.play("end_" + str(fire_anim))
