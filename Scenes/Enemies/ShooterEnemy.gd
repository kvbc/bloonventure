extends Enemy

var BULLET_SPEED = 200
var FIRE_DELAY = 2
var SPEED = 100

func _physics_process(delta):
	velocity = Vector2.ZERO
	var dist = global_position.distance_to(ALGlobal.World.Player.global_position)
	var dir = global_position.direction_to(ALGlobal.World.Player.global_position)
	if dist > 500:
		velocity = dir * SPEED
	elif dist < 400:
		velocity = -dir * SPEED
	move_and_slide()

func _ready():
	$EntityHealthComponent.MaxHealth = 150
	$EntityHealthComponent.Health = 150
	
	var lvl = ALGlobal.World.EnemyLevel
	$level.text = "" if lvl == 1 else str(lvl)
	var mult = pow(ALGlobal.World.EnemyLevelMarkiplier, lvl)
	SPEED *= mult
	BULLET_SPEED *= mult
	FIRE_DELAY /= mult
	
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
			body.get_node("EntityHealthComponent").Health -= 15
	)
