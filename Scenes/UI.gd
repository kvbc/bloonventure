extends CanvasLayer

var secs_passed = 0
var minute = 0
var second = 0
var hour = 0

func _ready():
	var timer = Timer.new()
	timer.autostart = true
	timer.wait_time = 1
	timer.timeout.connect(func():
		secs_passed += 1
	)
	add_child(timer)

	$GameOver.process_mode = Node.PROCESS_MODE_ALWAYS
	$GameOver.visible = false
	$GameOver/MarginContainer/VBoxContainer/MainMenuButton.pressed.connect(func():
		get_tree().paused = false
		get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	)

func _process(delta):
	second = secs_passed % 60
	minute = int(secs_passed / 60) % 60
	hour = int(secs_passed / 3600)
	var str = ""
	if hour > 0:
		str += "%02d:" % hour
	str += "%02d:%02d" % [minute, second]
	($TimeLabel as Label).text = str
	
func _input(event):
	if event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_1:
				ALGlobal.World.Player.SetWeapon("Gun")
			elif event.keycode == KEY_2:
				ALGlobal.World.Player.SetWeapon("Shotgun")

func GameOver(reason: String):
	$GameOver.visible = true
	%ReasonLabel.text = reason
	%DescriptionLabel.text = "[center]"
	%DescriptionLabel.text += "\n\n\n\n"
	%DescriptionLabel.text += "Survived for: [color=gold]" + "%dh %dm %ds" % [hour, minute, second] + "[/color]"
	%DescriptionLabel.text += "\nEnemies killed: [color=gold]" + str(ALGlobal.World.EnemiesKilled) + "[/color]"
	%DescriptionLabel.text += "\nDistance traveled: [color=gold]" + str(int(ALGlobal.World.DistanceTraveled)) + "m[/color]"
	%DescriptionLabel.text += "[/center]"
