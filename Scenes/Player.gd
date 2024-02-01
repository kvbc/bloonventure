extends CharacterBody2D
class_name Player

const SPEED = 300.0
const JUMP_VELOCITY = -500.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var weapon: Weapon = $Gun
@onready var candle_area: Area2D = %CandleArea
@onready var ReloadBar: ProgressBar = $ReloadBar
var added_velocity = Vector2.ZERO
var max_jetpack_fuel = 100:
	set(v):
		max_jetpack_fuel = v
		$JetpackBar.max_value = v
var jetpack_fuel = max_jetpack_fuel:
	set(v):
		jetpack_fuel = v
		$JetpackBar.value = v
var can_double_jump = false
var last_dash_msec = Time.get_ticks_msec()
var last_step_msec = Time.get_ticks_msec()

func SetWeapon(name):
	$Gun.visible = false
	$Shotgun.visible = false
	weapon = get_node(name)
	weapon.visible = true

func _ready():
	$JetpackBar.visible = true
	$JetpackBar.max_value = max_jetpack_fuel
	$JetpackBar.value = max_jetpack_fuel
	
	candle_area.area_entered.connect(func(area):
		if area is Candle:
			area.SetCanInteract(true)
	)
	candle_area.area_exited.connect(func(area):
		if area is Candle:
			area.SetCanInteract(false)
	)
	
	var hpregen_timer = Timer.new()
	hpregen_timer.wait_time = 1
	hpregen_timer.autostart = true
	hpregen_timer.timeout.connect(func():
		var ehc = $EntityHealthComponent
		ehc.Health += ALGlobal.World.GetStatValue("HPRegen")
		if is_on_floor():
			jetpack_fuel += ALGlobal.World.GetStatValue("JPRegen")
			jetpack_fuel = min(jetpack_fuel, max_jetpack_fuel)
	)
	add_child(hpregen_timer)

func _process(delta):
	var msec = Time.get_ticks_msec()
	$DashBar.value = (1 - ((msec - last_dash_msec) / 3000.0)) * $DashBar.max_value
	$DashBar.visible = $DashBar.value > 0
	weapon.look_at(get_global_mouse_position())
	if Input.is_action_pressed("fire"):
		weapon.Fire()
	if is_on_floor():
		can_double_jump = true

func AddVelocity(vel):
	added_velocity += vel

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		can_double_jump = true

	if Input.is_action_just_pressed("jump") and (is_on_floor() or can_double_jump): # and is_on_floor():
		if not is_on_floor():
			can_double_jump = false
		ALGlobal.PlayAudio(preload("res://Assets/SFX/PlayerJump.wav"), "SFX")
		velocity.y += JUMP_VELOCITY * ALGlobal.World.GetStatValue("JumpHeight")
	
		
	if Input.is_action_pressed("jetpack") and jetpack_fuel > 0:
		velocity.y += -35 * ALGlobal.World.GetStatValue("JPSpeed")
		jetpack_fuel -= 1
	
	var direction = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		direction += Vector2.LEFT
	if Input.is_action_pressed("move_right"):
		direction += Vector2.RIGHT
	if Input.is_action_pressed("move_down"):
		direction += Vector2.DOWN
		
	if true:
		var msec = Time.get_ticks_msec()
		if is_on_floor() and (not direction.is_zero_approx()) and (msec - last_step_msec >= 400):
			last_step_msec = msec
			ALGlobal.PlayAudio(preload("res://Assets/SFX/footstep.wav"), "SFX")
		
	if Input.is_action_just_pressed("dash"):
		var msec = Time.get_ticks_msec()
		if (msec - last_dash_msec) >= 3000:
			last_dash_msec = msec
			ALGlobal.PlayAudio(preload("res://Assets/SFX/dash.wav"), "SFX")
			var vel = Vector2.ZERO
			if Input.is_action_pressed("move_left"):
				vel += Vector2.LEFT
			if Input.is_action_pressed("move_right"):
				vel += Vector2.RIGHT
			if Input.is_action_pressed("jetpack"):
				vel += Vector2.UP
			if Input.is_action_pressed("move_down"):
				vel += Vector2.DOWN
			vel *= 500
			added_velocity += vel
			velocity.y = vel.y
			#if Input.is_action_pressed("jetpack"):
				#velocity.y = -1000
		
	var speed = SPEED * ALGlobal.World.GetStatValue("MoveSpeed")
	velocity.x = added_velocity.x
	if not direction.is_zero_approx():
		velocity.x += direction.x * speed
		#added_velocity.y += direction.y * speed
	#else:
	
		#velocity.x = move_toward(velocity.x, 0, speed)
		#velocity.y = move_toward(velocity.y, 0, speed)
		
	added_velocity = added_velocity.move_toward(Vector2.ZERO, delta * SPEED * 2)

	move_and_slide()
