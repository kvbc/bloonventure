extends Node2D
class_name EntityHealthComponent

@onready var bar: ProgressBar = $ProgressBar

var Health = 100:
	set(v):
		if v < Health:
			if(get_parent() is ShooterEnemy):
				ALGlobal.PlayAudio(preload("res://Assets/SFX/EnemyHurt.wav"))
			elif(get_parent() is Player):
				ALGlobal.PlayAudio(preload("res://Assets/SFX/PlayerHurt.wav"))
		Health = v
		bar.value = v
		if v <= 0:
			if(get_parent() is ShooterEnemy):
				ALGlobal.World.EnemiesKilled += 1
			
			if(get_parent() is Player):
				ALGlobal.World.GameOver("you died!")
			else:
				get_parent().queue_free()
var MaxHealth = 100:
	set(v):
		MaxHealth = v
		bar.max_value = v
