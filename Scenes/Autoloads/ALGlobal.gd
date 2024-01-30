extends Node

var World: World

func PlayAudio(stream: AudioStream):
	var audio_player = AudioStreamPlayer.new()
	audio_player.autoplay = true
	audio_player.finished.connect(audio_player.queue_free)
	audio_player.stream = stream
	add_child(audio_player)
