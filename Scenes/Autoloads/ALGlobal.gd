extends Node

var World: World

func _ready():
	get_tree().debug_collisions_hint = true

func PlayAudio(stream: AudioStream):
	var audio_player = AudioStreamPlayer.new()
	audio_player.autoplay = true
	audio_player.finished.connect(audio_player.queue_free)
	audio_player.stream = stream
	add_child(audio_player)
