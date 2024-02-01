extends Node2D
class_name EntityHealthComponent

@onready var bar: ProgressBar = $ProgressBar
var last_hpup_msec = Time.get_ticks_msec()

func _process(delta):
	var msec = Time.get_ticks_msec()
	($Label as Label).self_modulate.a = 1 - ((msec - last_hpup_msec) / 2000.0)

var Health = 100:
	set(v):
		if v > MaxHealth:
			v = MaxHealth
		
		if v < Health:
			if(get_parent() is Enemy):
				ALGlobal.PlayAudio(preload("res://Assets/SFX/EnemyHurt.wav"), "SFX")
			elif(get_parent() is Player):
				ALGlobal.PlayAudio(preload("res://Assets/SFX/PlayerHurt.wav"), "SFX")
				Engine.time_scale = 0.5
			var dmg_ind = DamageIndicator.New(Health - v)
			dmg_ind.global_position = get_parent().global_position
			get_tree().current_scene.add_child(dmg_ind)
			get_parent().modulate = Color.RED
			get_tree().create_timer(0.1).timeout.connect(func():
				get_parent().modulate = Color.WHITE
				Engine.time_scale = 1
			)
		elif v > Health:
			var msec = Time.get_ticks_msec()
			last_hpup_msec = msec
			$Label.text = "+" + str(v - Health)
			$Label.rotation_degrees = randf_range(-15, 15)
		if v <= 0 and Health > 0:
			if(get_parent() is Enemy):
				ALGlobal.World.EnemiesKilled += 1
				ALGlobal.World.AddCurrency(5, get_parent())
			
			if(get_parent() is Player):
				var explosion = preload("res://Scenes/Effects/Explosion.tscn").instantiate()
				explosion.global_position = get_parent().global_position
				get_tree().current_scene.add_child(explosion)
				ALGlobal.World.GameOver("you died!")
			else:
				get_parent().queue_free()
		Health = v
		bar.value = v
var MaxHealth = 100:
	set(v):
		MaxHealth = v
		bar.max_value = v
