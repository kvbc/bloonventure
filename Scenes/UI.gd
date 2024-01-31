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

	%Shop.visible = false
	%Shop.process_mode = Node.PROCESS_MODE_ALWAYS
	$GameOver.process_mode = Node.PROCESS_MODE_ALWAYS
	$GameOver.visible = false
	$GameOver/MarginContainer/VBoxContainer/MainMenuButton.pressed.connect(func():
		Engine.time_scale = 1
		get_tree().paused = false
		get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	)
	%ShopButton.pressed.connect(func():
		%Shop.visible = true
		get_tree().paused = true
	)
	%ShopCloseButton.pressed.connect(func():
		get_tree().paused = false
		%Shop.visible = false
	)
	%MusicButton.toggled.connect(func(is_toggled):
		%MusicButton.icon = preload("res://Assets/Image/musicOff.png") if is_toggled else preload("res://Assets/Image/musicOn.png")
		AudioServer.set_bus_mute(2, is_toggled)
	)
	%SFXButton.toggled.connect(func(is_toggled):
		%SFXButton.icon = preload("res://Assets/Image/audioOff.png") if is_toggled else preload("res://Assets/Image/audioOn.png")
		AudioServer.set_bus_mute(1, is_toggled)
	)
	$Audio/VBoxContainer/HelpButton.pressed.connect(func():
		$HelpMenu.Show()
	)
	$HelpMenu/MarginContainer/VBoxContainer/CloseButton.pressed.connect(func():
		$HelpMenu.visible = false
		get_tree().paused = false
	)

func _process(delta):
	second = secs_passed % 60
	minute = int(secs_passed / 60) % 60
	hour = int(secs_passed / 3600)
	var str = ""
	if hour > 0:
		str += "%02d:" % hour
	str += "%02d:%02d" % [minute, second]
	(%TimeLabel as Label).text = str
	%AltLabel.text = str((int(ALGlobal.World.background.global_position.y) + 825) / 1) + "m"
	
func _input(event):
	if event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_1:
				ALGlobal.World.Player.SetWeapon("Gun")
			elif event.keycode == KEY_2:
				ALGlobal.World.Player.SetWeapon("Shotgun")

func GameOver(reason: String):
	var dist_traveled = int(ALGlobal.World.DistanceTraveled)
	var dist_travel_str = ""
	if dist_traveled > 1000:
		dist_travel_str += str(dist_traveled / 1000) + "km "
	dist_travel_str += str(dist_traveled % 1000) + "m"
	
	$GameOver.visible = true
	%ReasonLabel.text = reason
	%DescriptionLabel.text = "[center]"
	%DescriptionLabel.text += "\n\n\n\n"
	%DescriptionLabel.text += "Survived for: [color=gold]" + "%dh %dm %ds" % [hour, minute, second] + "[/color]"
	%DescriptionLabel.text += "\nEnemies killed: [color=gold]" + str(ALGlobal.World.EnemiesKilled) + "[/color]"
	%DescriptionLabel.text += "\nDistance traveled: [color=gold]" + dist_travel_str + "[/color]"
	%DescriptionLabel.text += "[/center]"

func AddCurrency(currency, atnode: Node2D):
	var atpos: Vector2 = atnode.get_global_transform_with_canvas().get_origin()
	for i in currency:
		var coin = preload("res://Scenes/UICoin.tscn").instantiate()
		coin.global_position = atpos + Vector2(
			randf_range(-50,50),
			randf_range(-50,50)
		)
		coin.move_to = $Currency/MarginContainer/HBoxContainer/TextureRect.global_position + $Currency/MarginContainer/HBoxContainer/TextureRect.size / 2
		coin.value = currency
		add_child(coin)
		await get_tree().create_timer(0.05).timeout
