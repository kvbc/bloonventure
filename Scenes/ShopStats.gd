extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().current_scene.ready.connect(func():
		update_stats()
	)

	visibility_changed.connect(func():
		if visible and get_tree().current_scene.is_node_ready():
			update_stats()
	)

func _process(delta):
	pass

func update_stats():
	for child in get_children():
		update_stat(child.name)

func update_stat(stat_name: String):
	var hbox = get_node(stat_name).get_node_or_null("HBoxContainer")
	if hbox == null:
		hbox = get_node(stat_name).get_node("MarginContainer").get_node("HBoxContainer")
	var vbox = hbox.get_node("VBoxContainer")
	var label = vbox.get_node("RichTextLabel")
	var button = vbox.get_node("Button")
	var lvl_label = hbox.get_node("TextureRect").get_node("LevelLabel")
	
	var stat = ALGlobal.World.Stats[stat_name]
	var cost = stat.BaseCost
	if "Level" in stat:
		var value = stat.BaseValue
		for i in stat.Level:
			value += stat.ValueAdd #* stat.ValueMultiplier
			cost += stat.CostAdd #* stat.CostMultiplier
		var next_value = value + stat.ValueAdd #* stat.ValueMultiplier
		
		lvl_label.text = "" if stat.Level == 0 else str(stat.Level + 1)
		label.text = "[center]%s\n%s >> [color=green]%s[/color][/center]" % [stat.Name, stat.ValueFormat % value, stat.ValueFormat % next_value]
	else:
		if stat.Buyed:
			get_node(stat_name).queue_free()
		else:
			label.text = "[center]Grappling Hook (C)[/center]"
	button.text = str(cost)
	
	button.self_modulate = Color.GREEN if ALGlobal.World.Currency >= cost else Color.RED
	
	var button_con = func():
		if ALGlobal.World.Currency >= cost:
			ALGlobal.World.Currency -= cost
			# stat.Level += 1
			ALGlobal.World.UpgradeStat(stat_name)
			update_stats()
	
	if button.has_meta("con"):
		button.pressed.disconnect(button.get_meta("con"))
	button.set_meta("con", button_con)
	button.pressed.connect(button_con, CONNECT_ONE_SHOT)
