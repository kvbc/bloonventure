extends Enemy

const BULLET_SPEED = 200
const FIRE_DELAY = 2.5

func _ready():
	var timer = Timer.new()
	timer.autostart = true
	timer.wait_time = FIRE_DELAY
	timer.timeout.connect(func():
		if is_instance_valid(ALGlobal.World.Player):
			var bullet = preload("res://Scenes/Bullets/EnemyBullet.tscn").instantiate()
			bullet.global_position = global_position
			bullet.velocity = global_position.direction_to(ALGlobal.World.Player.global_position) * BULLET_SPEED
			get_tree().current_scene.add_child(bullet)
	)
	add_child(timer)

	$playerArea.body_entered.connect(func(body):
		if body is Player:
			body.get_node("EntityHealthComponent").Health -= 25
	)
