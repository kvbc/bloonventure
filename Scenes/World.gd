extends Node2D
class_name World

const BGS_IN_EACH_DIR = 5
const BG_SPEED = 300
const BG_Y_SPEED = 50

@onready var background: Sprite2D = %Background
@onready var backgrounds: Node2D = %Backgrounds

var GoingDown = true
var EnemiesKilled = 0
var DistanceTraveled = 0
var Currency = 0
@onready var Player: Player = $Player
@onready var Balloon: Balloon = $Balloon

var max_enemies = 1
var last_spawned_meteor_msec = Time.get_ticks_msec()
var last_spawned_enemy_msec = Time.get_ticks_msec()
var last_max_enemy = Time.get_ticks_msec()
const MAX_MAX_ENEMIES = 10
var EnemyLevel = 1
var EnemyLevelMarkiplier = 1.25
var HasHook = false

var Stats = {
	"Hook" = {
		Name = "Hook (E)",
		BaseCost = 250,
		Buyed = false
	},
	"MaxHP" = {
		Name = "Max HP",
		ValueFormat = "%d",
		BaseValue = 100,
		BaseCost = 30,
		Level = 0,
		ValueAdd = 25,
		CostAdd = 10
	},
	"HPRegen" = {
		Name = "HP Regen",
		ValueFormat = "%d/s",
		BaseValue = 1,
		BaseCost = 20,
		Level = 0,
		ValueAdd = 1,
		CostAdd = 10
	},
	"DMGMulti" = {
		Name = "DMG Mult.",
		ValueFormat = "%dx",
		BaseValue = 1,
		BaseCost = 40,
		Level = 0,
		ValueAdd = 0.1,
		CostAdd = 30
	},
	"MoveSpeed" = {
		Name = "Move Speed",
		ValueFormat = "%dx",
		BaseValue = 1,
		BaseCost = 35,
		Level = 0,
		ValueAdd = 0.05,
		CostAdd = 15
	},
	"ATKSpeed" = {
		Name = "ATK Speed",
		ValueFormat = "%dx",
		BaseValue = 1,
		BaseCost = 40,
		Level = 0,
		ValueAdd = 0.1,
		CostAdd = 30
	},
	"BulletSpeed" = {
		Name = "Bullet Speed",
		ValueFormat = "%dx",
		BaseValue = 1,
		BaseCost = 15,
		Level = 0,
		ValueAdd = 0.1,
		CostAdd = 10
	},
	"JumpHeight" = {
		Name = "Jump Height",
		ValueFormat = "%dx",
		BaseValue = 1,
		BaseCost = 15,
		Level = 0,
		ValueAdd = 0.1,
		CostAdd = 5
	},
	"JPSpeed" = {
		Name = "Jetpack Speed",
		ValueFormat = "%dx",
		BaseValue = 1,
		BaseCost = 20,
		Level = 0,
		ValueAdd = 0.2,
		CostAdd = 10
	},
	"JPFuelCap" = {
		Name = "Jetpack Cap.",
		ValueFormat = "%dx",
		BaseValue = 1,
		BaseCost = 40,
		Level = 0,
		ValueAdd = 0.15,
		CostAdd = 20
	},
	"JPRegen" = {
		Name = "Jetpack Regen",
		ValueFormat = "%dx/s",
		BaseValue = 1,
		BaseCost = 50,
		Level = 0,
		ValueAdd = 0.2,
		CostAdd = 15
	}
}

func GetStatValue(stat_name: String):
	var stat = ALGlobal.World.Stats[stat_name]
	var value = stat.BaseValue
	for i in stat.Level:
		value += stat.BaseValue * stat.ValueMultiplier
	return value

func UpgradeStat(stat_name: String):
	if "Level" in Stats[stat_name]:
		Stats[stat_name].Level += 1
		var value = GetStatValue(stat_name)
		
		match stat_name:
			"MaxHP":
				var ehc = Player.get_node("EntityHealthComponent")
				var mh = ehc.MaxHealth
				ehc.MaxHealth = value
				ehc.Health += value - mh
	else:
		HasHook = true
		Stats[stat_name].Buyed = true
		print("buy hook")

func _process(delta):
	DistanceTraveled += delta * BG_SPEED / 10
	for bg: Sprite2D in backgrounds.get_children():
		if not bg.has_meta("moved_dist"):
			bg.set_meta("moved_dist", 0)
		var moved_dist = bg.get_meta("moved_dist")
		if moved_dist >= bg.texture.get_size().x * bg.scale.x:
			bg.position += Vector2(moved_dist, 0)
			bg.flip_h = not bg.flip_h
			moved_dist = 0
		var dx = delta * BG_SPEED
		moved_dist += dx
		bg.position.x += Vector2.LEFT.x * dx
		bg.set_meta("moved_dist", moved_dist)

		var dy = (-1 if GoingDown else 1) * delta * BG_Y_SPEED
		bg.position.y += dy
		
	if $Enemies.get_child_count() < max_enemies:
		var msec = Time.get_ticks_msec()
		if (msec - last_spawned_enemy_msec) >= 3000:
			last_spawned_enemy_msec = msec
			spawn_enemy(([
				preload("res://Scenes/Enemies/ChargerEnemy.tscn"),
				preload("res://Scenes/Enemies/ShooterEnemy.tscn")
			].pick_random()).instantiate())
		
	if Balloon.global_position.y < %BloonDiePoint.global_position.y:
		Balloon.Die()
	
	if Player.global_position.y < %MeteorSpawnPoint.global_position.y:
		var msec = Time.get_ticks_msec()
		if (msec - last_spawned_meteor_msec) >= 10000:
			last_spawned_meteor_msec = msec
			ShakeCamera(5)
			var meteor = preload("res://Scenes/Meteor.tscn").instantiate()
			meteor.global_position = Vector2(
				Player.global_position.x + [-2000, 2000][randi_range(0,1)],
				Player.global_position.y - randf_range(100,300)
			)
			add_child(meteor)
			
	if true:
		var msec = Time.get_ticks_msec()
		if msec - last_max_enemy >= (60 * 1000) / 2:
		#if msec - last_max_enemy >= 3000:
			last_max_enemy = msec
			if max_enemies >= MAX_MAX_ENEMIES:
				EnemyLevel += 1
			else:
				max_enemies += 1
		
	#var btm_limit = background.global_position.y + background.texture.get_size().y * background.scale.y
	#($Camera2D as Camera2D).limit_bottom = btm_limit
	#($Player/PhantomCamera2D as PhantomCamera2D).limit_bottom = btm_limit

func _ready():
	#($Player/PhantomCamera2D as PhantomCamera2D).
	
	ALGlobal.World = self
	for i in [-1, 1]:
		for j in range(1, BGS_IN_EACH_DIR + 1):
			var bg: Sprite2D = background.duplicate()
			if j % 2 == 1:
				bg.flip_h = true
			bg.position = background.position + Vector2(background.texture.get_size().x  * background.scale.x, 0) * i * j
			background.get_parent().add_child(bg)
			
	for bg in backgrounds.get_children():
		var area: Area2D = bg.get_node("dedArea")
		area.body_entered.connect(func(body):
			if body is Balloon:
				GameOver("your bloon sank!")
			elif body is Player:
				GameOver("you sank!")
			#else:
				#assert(false)
		)

func spawn_enemy(enem):
	enem.global_position = Player.global_position + Vector2([-1000,1000].pick_random(), randf_range(-500,500))
	$Enemies.add_child(enem)

func GameOver(reason: String):
	$AudioStreamPlayer.stop()
	$AudioStreamPlayer.stream = preload("res://Assets/SFX/game_over.wav")
	$AudioStreamPlayer.bus = "SFX"
	$AudioStreamPlayer.play()
	$UI.GameOver(reason)
	Engine.time_scale = 0.25
	get_tree().paused = true

func ShakeCamera(dur):
	var shaker: Shaker = $Camera2D/Shaker
	#shaker.start()
	shaker.duration = dur
	shaker.start()

func StopMusic():
	$AudioStreamPlayer.stop()

func AddCurrency(currency: int, atnode):
	#Currency += currency
	# coin adds
	$UI.AddCurrency(currency, atnode)
