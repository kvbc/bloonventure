extends Panel

var pages = [
	[
		"""[color=gold]WASD/Arrows[/color] to move
[color=gold]SPACE      [/color] to (double) jump
[color=gold]W/Up       [/color] to jetpack
[color=gold]LShift     [/color] to dash
[color=gold]E          [/color] to interact""",
		preload("res://icon.svg")
	],
	[
		"Steer the ballon by interacting with the candle",
		preload("res://icon.svg")
	],
	[
		"Don't let the balloon sink \n or get too high up in the sky!",
		preload("res://icon.svg")
	],
	[
		"Fight off progressively harder and harder \n hordes of enemies!",
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
