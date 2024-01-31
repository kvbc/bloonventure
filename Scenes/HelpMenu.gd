extends NinePatchRect

var pages = [
	[
		"""[color=darkgreen]WASD/Arrows[/color] to move
[color=darkgreen]SPACE      [/color] to (double) jump
[color=darkgreen]W/Up       [/color] to jetpack
[color=darkgreen]LShift     [/color] to dash
[color=darkgreen]E          [/color] to interact
[color=darkgreen]LMB        [/color] to attack
[color=darkgreen]1,2        [/color] to switch weapons""",
		preload("res://icon.svg")
	],
	[
		"Steer the ballon by interacting with the candle",
		preload("res://icon.svg")
	],
	[
		"Don't let the balloon sink or get too high up in the sky!",
		preload("res://icon.svg")
	],
	[
		"Fight off progressively harder and harder hordes of enemies!",
		preload("res://icon.svg")
	],
	[
		"Upgrade your character to get stronger",
		preload("res://icon.svg")
	],
	[
		"How long can you survive?",
		preload("res://icon.svg")
	],
]
@onready var page_num = 1:
	set(v):
		page_num = v
		$MarginContainer/VBoxContainer/Pages/HBoxContainer/PrevButton.disabled = page_num == 1
		$MarginContainer/VBoxContainer/Pages/HBoxContainer/NextButton.disabled = page_num == pages.size()
		$MarginContainer/VBoxContainer/Label.text = str(page_num) + " / " + str(pages.size())
		$MarginContainer/VBoxContainer/Pages/HBoxContainer/Content/VBoxContainer/Label.text = pages[page_num - 1][0]
		$MarginContainer/VBoxContainer/Pages/HBoxContainer/Content/VBoxContainer/TextureRect.texture = pages[page_num - 1][1]

func Show():
	visible = true
	get_tree().paused = true

func _ready():
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
