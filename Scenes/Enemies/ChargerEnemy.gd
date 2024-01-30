extends Enemy

const SPEED = 100
const CHARGE_SPEED = 600
const CHARGE_DELAY = 3 # sec

func charge():
	velocity = global_position.direction_to(ALGlobal.World.Player.global_position) * CHARGE_SPEED

func _physics_process(delta):
	move_and_slide()
	velocity = velocity.move_toward(Vector2.ZERO, delta * CHARGE_SPEED)

func _ready():
	var timer = Timer.new()
	timer.autostart = true
	timer.wait_time = CHARGE_DELAY
	timer.timeout.connect(func():
		charge()
	)
	add_child(timer)
	
	$playerArea.body_entered.connect(func(body):
		if body is Player:
			body.get_node("EntityHealthComponent").Health -= 25
			body.velocity += velocity
	)
