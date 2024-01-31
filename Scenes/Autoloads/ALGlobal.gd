extends Node

var World: World

func _ready():
	pass
	#get_tree().debug_collisions_hint = true

func PlayAudio(stream: AudioStream, bus_name: String, ofs = 0, vol = null):
	var audio_player = AudioStreamPlayer.new()
	audio_player.finished.connect(audio_player.queue_free)
	audio_player.stream = stream
	audio_player.bus = bus_name
	if vol != null:
		audio_player.volume_db = vol
	add_child(audio_player)
	audio_player.play(ofs)
