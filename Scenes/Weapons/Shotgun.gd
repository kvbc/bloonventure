class_name Shotgun
extends Weapon

const BULLET_SPEED = 500
const FIRE_DELAY = 1 # seconds

var last_fire_msec = Time.get_ticks_msec()

# Called when the node enters the scene tree for the first time.
func _ready():
	z_index = 1

func fire_delay_msec():
	return FIRE_DELAY * 1000.0 / ALGlobal.World.GetStatValue("ATKSpeed")

func _process(delta):
	if visible:
		var bar: ProgressBar = ALGlobal.World.Player.ReloadBar
		var msec = Time.get_ticks_msec()
		if msec - last_fire_msec >= fire_delay_msec():
			bar.visible = false
		else:
			bar.visible = true
			bar.value = (1 - ((msec - last_fire_msec) / fire_delay_msec())) * bar.max_value

func Fire():
	var msec = Time.get_ticks_msec()
	if msec - last_fire_msec >= fire_delay_msec():
		last_fire_msec = msec
		ALGlobal.PlayAudio(preload("res://Assets/SFX/shotgun.wav"), "SFX")
		for angle in [-10, -5, 5, 10]:
			var bullet = preload("res://Scenes/Bullets/PlayerBullet.tscn").instantiate()
			bullet.global_position = global_position
			bullet.dmg = 10
			bullet.velocity = Vector2.RIGHT.rotated(global_rotation + deg_to_rad(angle)) * BULLET_SPEED * ALGlobal.World.GetStatValue("BulletSpeed")
			get_tree().current_scene.add_child(bullet)
