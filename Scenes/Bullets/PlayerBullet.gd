extends CharacterBody2D
class_name PlayerBullet

var dmg = 1

func _process(delta):
	look_at(global_position + velocity)

func _physics_process(delta):
	move_and_slide()
	var col = get_last_slide_collision()
	if col != null:
		var collider = col.get_collider()
		if collider is Enemy:
			var health_comp = collider.get_node("EntityHealthComponent") as EntityHealthComponent
			health_comp.Health -= dmg * ALGlobal.World.GetStatValue("DMGMulti")
		elif collider is EnemyBullet:
			collider.queue_free()
			
		var effect = preload("res://Scenes/Effects/WeaponHit.tscn").instantiate()
		effect.global_position = global_position
		get_tree().current_scene.add_child(effect)
			
		queue_free()

func _ready():
	ALGlobal.PlayAudio(preload("res://Assets/SFX/PlayerShoot.wav"), "SFX")
	get_tree().create_timer(5).timeout.connect(queue_free)
