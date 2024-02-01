extends Enemy

var SPEED = 100
var CHARGE_SPEED = 600
var CHARGE_DELAY = 2 # sec

func charge():
	ALGlobal.PlayAudio(preload("res://Assets/SFX/scream.wav"), "SFX",0,-5)
	velocity = global_position.direction_to(ALGlobal.World.Player.global_position) * CHARGE_SPEED

func _process(delta):
	if velocity.x < 0:
		$Sprite2D.flip_h = false
	elif velocity.x > 0:
		$Sprite2D.flip_h = true
	$PointLight2D.rotation_degrees += delta * 100

func _physics_process(delta):
	move_and_slide()
	velocity = velocity.move_toward(Vector2.ZERO, delta * CHARGE_SPEED)

func _ready():
	var lvl = ALGlobal.World.EnemyLevel
	$level.text = "" if lvl == 1 else str(lvl)
	var mult = pow(ALGlobal.World.EnemyLevelMarkiplier, lvl)
	SPEED *= mult
	CHARGE_DELAY *= mult
	CHARGE_DELAY /= mult
	
	var timer = Timer.new()
	timer.autostart = true
	timer.wait_time = CHARGE_DELAY
	timer.timeout.connect(func():
		charge()
	)
	add_child(timer)
	
	$playerArea.body_entered.connect(func(body):
		if body is Player:
			body.get_node("EntityHealthComponent").Health -= 30
			body.AddVelocity(velocity)
	)
