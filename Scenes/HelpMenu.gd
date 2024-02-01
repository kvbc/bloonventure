extends NinePatchRect

var pages = [
	[
		"""[color=darkgreen]WASD/Arrows[/color] to move
[color=darkgreen]SPACE   [/color] to (double) jump
[color=darkgreen]W/Up    [/color] to jetpack
[color=darkgreen]LShift/L[/color] to dash
[color=darkgreen]E       [/color] to interact
[color=darkgreen]LMB     [/color] to attack
[color=darkgreen]1,2     [/color] to switch weapons
[color=darkgreen]C       [/color] to grapple""",
		null
	],
	[
		"Steer the ballon by interacting with the candle",
		preload("res://Assets/Image/help/candle.PNG")
	],
	[
		"Don't let the balloon sink or get too high up in the sky!",
		preload("res://Assets/Image/help/sink.PNG")
	],
	[
		"Fight off progressively harder and harder hordes of enemies!",
		preload("res://Assets/Image/help/hordes.PNG")
	],
	[
		"Upgrade your character to get stronger",
		preload("res://Assets/Image/help/stronger3.PNG")
	],
	[
		"How long can you survive?",
		preload("res://Assets/Image/help/survive.PNG")
	],
]
@onready var page_num = 1:
	set(v):
		page_num = v
		$MarginContainer/VBoxContainer/Pages/HBoxContainer/PrevButton.disabled = page_num == 1
		$MarginContainer/VBoxContainer/Pages/HBoxContainer/NextButton.disabled = page_num == pages.size()
		$MarginContainer/VBoxContainer/Label.text = str(page_num) + " / " + str(pages.size())
		$MarginContainer/VBoxContainer/Pages/HBoxContainer/Content/VBoxContainer/Label.text = pages[page_num - 1][0]
		var txtrect = $MarginContainer/VBoxContainer/Pages/HBoxContainer/Content/VBoxContainer/TextureRect
		var txt = pages[page_num - 1][1]
		txtrect.texture = txt
		if txt == null:
			txtrect.visible = false
		else:
			txtrect.visible = true


func Show():
	if ALGlobal.FirstPlay:
		ALGlobal.FirstPlay = false
		visible = true
		get_tree().paused = true

func _ready():
	visible = false
	Show()
	page_num = 1
	$MarginContainer/VBoxContainer/Pages/HBoxContainer/PrevButton.pressed.connect(func():
		if page_num > 1:
			page_num -= 1
	)
	$MarginContainer/VBoxContainer/Pages/HBoxContainer/NextButton.pressed.connect(func():
		if page_num < pages.size():
			page_num += 1
	)
	visibility_changed.connect(func():
		if visible:
			page_num = 1
	)
