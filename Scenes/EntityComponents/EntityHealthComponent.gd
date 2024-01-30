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
			var dmg_ind = DamageIndicator.New(Health - v)
			dmg_ind.global_position = get_parent().global_position
			get_tree().current_scene.add_child(dmg_ind)
		Health = v
		bar.value = v
		if v <= 0:
			if(get_parent() is ShooterEnemy):
				ALGlobal.World.EnemiesKilled += 1
				ALGlobal.World.AddCurrency(5)
			
			if(get_parent() is Player):
				ALGlobal.World.GameOver("you died!")
			else:
				get_parent().queue_free()
var MaxHealth = 100:
	set(v):
		MaxHealth = v
		bar.max_value = v
