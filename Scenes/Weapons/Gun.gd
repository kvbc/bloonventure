class_name Gun
extends Weapon

const BULLET_SPEED = 500
const FIRE_DELAY = 0.25 # seconds

var last_fire_msec = Time.get_ticks_msec()

# Called when the node enters the scene tree for the first time.
func _ready():
	z_index = 1

func _process(delta):
	var bar: ProgressBar = ALGlobal.World.Player.ReloadBar
	var msec = Time.get_ticks_msec()
	if msec - last_fire_msec >= FIRE_DELAY * 1000:
		bar.visible = false
	else:
		bar.visible = true
		bar.value = (1 - (msec - last_fire_msec) / (FIRE_DELAY * 1000.0)) * bar.max_value

func Fire():
	var msec = Time.get_ticks_msec()
	if msec - last_fire_msec >= FIRE_DELAY * 1000:
		last_fire_msec = msec
		var bullet = preload("res://Scenes/Bullets/PlayerBullet.tscn").instantiate()
		bullet.global_position = global_position
		bullet.velocity = Vector2.RIGHT.rotated(global_rotation) * BULLET_SPEED
		get_tree().current_scene.add_child(bullet)
