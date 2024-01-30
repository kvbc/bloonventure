extends Node2D
class_name World

const BGS_IN_EACH_DIR = 5
const BG_SPEED = 300
const BG_Y_SPEED = 50

@onready var background: Sprite2D = %Background
@onready var backgrounds: Node2D = %Backgrounds

var GoingDown = false
var EnemiesKilled = 0
var DistanceTraveled = 0
var Currency = 0
@onready var Player: Player = $Player
@onready var Balloon: Balloon = $Balloon

var last_spawned_meteor_msec = Time.get_ticks_msec()

var Stats = {
	"MaxHP" = {
		Name = "Max HP",
		ValueFormat = "%d",
		BaseValue = 100,
		BaseCost = 10,
		Level = 0,
		ValueMultiplier = 1.25,
		CostMultiplier = 1.25
	},
	"HPRegen" = {
		Name = "HP Regen",
		ValueFormat = "%d/s",
		BaseValue = 1,
		BaseCost = 10,
		Level = 0,
		ValueMultiplier = 1.25,
		CostMultiplier = 1.25
	},
	"DMGMulti" = {
		Name = "DMG Mult.",
		ValueFormat = "%dx",
		BaseValue = 1,
		BaseCost = 10,
		Level = 0,
		ValueMultiplier = 1.25,
		CostMultiplier = 1.25
	},
	"MoveSpeed" = {
		Name = "Move Speed",
		ValueFormat = "%dx",
		BaseValue = 1,
		BaseCost = 10,
		Level = 0,
		ValueMultiplier = 1.25,
		CostMultiplier = 1.25
	},
	"ATKSpeed" = {
		Name = "ATK Speed",
		ValueFormat = "%dx",
		BaseValue = 1,
		BaseCost = 10,
		Level = 0,
		ValueMultiplier = 1.25,
		CostMultiplier = 1.25
	},
	"BulletSpeed" = {
		Name = "Bullet Speed",
		ValueFormat = "%dx",
		BaseValue = 1,
		BaseCost = 10,
		Level = 0,
		ValueMultiplier = 1.25,
		CostMultiplier = 1.25
	}
}

func GetStatValue(stat_name: String):
	var stat = ALGlobal.World.Stats[stat_name]
	var value = stat.BaseValue
	for i in stat.Level:
		value += stat.BaseValue * stat.ValueMultiplier
	return value

func UpgradeStat(stat_name: String):
	Stats[stat_name].Level += 1
	var value = GetStatValue(stat_name)
	
	match stat_name:
		"MaxHP":
			var ehc = Player.get_node("EntityHealthComponent")
			ehc.Health += value - ehc.MaxHealth
			ehc.MaxHealth = value
		"HPRegen":
			pass # handled in Player.gd
		"DMGMulti":
			pass # handled in player bullet
		"MoveSpeed":
			pass # handled in player
		"ATKSpeed":
			pass # handled in player
		"BulletSpeed":
			pass # handled in bullet
		_:
			assert(false, "wtf brah")

func _process(delta):
	DistanceTraveled += delta * BG_SPEED / 10
	for bg: Sprite2D in backgrounds.get_children():
		if not bg.has_meta("moved_dist"):
			bg.set_meta("moved_dist", 0)
		var moved_dist = bg.get_meta("moved_dist")
		if moved_dist >= bg.texture.get_size().x * bg.scale.x:
			bg.position += Vector2(moved_dist, 0)
			moved_dist = 0
		var dx = delta * BG_SPEED
		moved_dist += dx
		bg.position.x += Vector2.LEFT.x * dx
		bg.set_meta("moved_dist", moved_dist)

		var dy = (1 if GoingDown else -1) * delta * BG_Y_SPEED
		bg.position.y += dy
		
	if Player.global_position.y < %MeteorSpawnPoint.global_position.y:
		var msec = Time.get_ticks_msec()
		if (msec - last_spawned_meteor_msec) >= 3000:
			last_spawned_meteor_msec = msec
			var meteor = preload("res://Scenes/Meteor.tscn").instantiate()
			meteor.global_position = Vector2(
				Player.global_position.x + [-2000, 2000][randi_range(0,1)],
				Player.global_position.y - randf_range(100,300)
			)
			add_child(meteor)

func _ready():
	ALGlobal.World = self
	for i in [-1, 1]:
		for j in range(1, BGS_IN_EACH_DIR + 1):
			var bg: Sprite2D = background.duplicate()
			bg.position = background.position + Vector2(background.texture.get_size().x  * background.scale.x, 0) * i * j
			background.get_parent().add_child(bg)
			
	for bg in backgrounds.get_children():
		var area: Area2D = bg.get_node("dedArea")
		area.body_entered.connect(func(body):
			assert(body is Balloon)
			GameOver("your bloon sank!")
		)

func GameOver(reason: String):
	$UI.GameOver(reason)
	get_tree().paused = true

func AddCurrency(currency: int):
	Currency += currency
