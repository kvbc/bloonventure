extends Node2D
class_name DamageIndicator

@onready var target_y = global_position.y + randf_range(-50, -25)
var target_angle = randf_range(-25, 25)
var msec_start = Time.get_ticks_msec()

func _ready():
	global_position += Vector2(
		randf_range(-25, 25),
		randf_range(-25, 25),
	)

func _process(delta):
	var msec = Time.get_ticks_msec()
	if (msec - msec_start) >= 1000:
		queue_free()
	else:
		modulate.a = 1 - (msec - msec_start) / 1000.0
	rotation_degrees = move_toward(rotation_degrees, target_angle, delta * 20)
	global_position.y = move_toward(global_position.y, target_y, delta * 50)

static func New(dmg: int):
	var ind = preload("res://Scenes/DamageIndicator.tscn").instantiate()
	ind.get_node("Label").text = str(dmg)
	return ind
