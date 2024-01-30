extends CharacterBody2D
class_name EnemyBullet

func _physics_process(delta):
	move_and_slide()
	var col = get_last_slide_collision()
	if col != null:
		var collider = col.get_collider()
		if collider is Player:
			var health_comp = collider.get_node("EntityHealthComponent") as EntityHealthComponent
			health_comp.Health -= 30
		elif collider is PlayerBullet:
			collider.queue_free()
		queue_free()

func _ready():
	ALGlobal.PlayAudio(preload("res://Assets/SFX/EnemyShoot.wav"))
	get_tree().create_timer(5).timeout.connect(queue_free)
