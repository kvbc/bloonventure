extends Node2D
class_name Meteor

const SPEED = 800

@onready var dir = global_position.direction_to(ALGlobal.World.Player.global_position)

func _ready():
	ALGlobal.PlayAudio(preload("res://Assets/SFX/meteor.mp3"), "SFX",0)
	get_tree().create_timer(15).timeout.connect(queue_free)

	$playerArea.body_entered.connect(func(body):
		if body is Player:
			body.get_node("EntityHealthComponent").Health -= 35
			body.AddVelocity(dir * SPEED / 2)
	)
	
	$fire_left.visible = dir.x < 0 
	$fire_right.visible = dir.x > 0 
	
func _process(delta):
	$Sprites.rotation_degrees += delta * 250
	global_position += dir * SPEED * delta
