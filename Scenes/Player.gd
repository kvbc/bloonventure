extends CharacterBody2D
class_name Player

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var weapon: Weapon = $Gun
@onready var candle_area: Area2D = %CandleArea
@onready var ReloadBar: ProgressBar = $ReloadBar

func SetWeapon(name):
	$Gun.visible = false
	$Shotgun.visible = false
	weapon = get_node(name)
	weapon.visible = true

func _ready():
	candle_area.area_entered.connect(func(area):
		if area is Candle:
			area.SetCanInteract(true)
	)
	candle_area.area_exited.connect(func(area):
		if area is Candle:
			area.SetCanInteract(false)
	)

func _process(delta):
	weapon.look_at(get_global_mouse_position())
	if Input.is_action_pressed("fire"):
		weapon.Fire()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump"): # and is_on_floor():
		ALGlobal.PlayAudio(preload("res://Assets/SFX/PlayerJump.wav"))
		velocity.y = JUMP_VELOCITY
	
	var direction = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		direction += Vector2.LEFT
	if Input.is_action_pressed("move_right"):
		direction += Vector2.RIGHT
	if Input.is_action_pressed("move_down"):
		direction += Vector2.DOWN
	if not direction.is_zero_approx():
		velocity.x = direction.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
