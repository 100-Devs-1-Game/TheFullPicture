class_name VoiceTracker
extends Node

@onready var audio_player: AudioStreamPlayer= get_parent()

var playing: bool= false
var tween: Tween
var music_volume: float:
	set(f):
		AudioServer.set_bus_volume_linear(get_music_bus(), f)



func _ready() -> void:
	assert(audio_player)
	audio_player.finished.connect(on_finished)
	tree_exiting.connect(func(): music_volume= GameSettings.music_volume)


func _process(_delta: float) -> void:
	if not playing and audio_player.playing:
		if tween and tween.is_running():
			tween.kill()
		tween= create_tween()
		music_volume= GameSettings.music_volume
		tween.tween_property(self, "music_volume", 0.1, 0.25)
		playing= true
	elif playing and not audio_player.playing:
		on_finished()

func on_finished():
		if tween and tween.is_running():
			tween.kill()
		tween= create_tween()
		music_volume= 0.1
		tween.tween_property(self, "music_volume", GameSettings.music_volume, 0.25)
		playing= false


func get_music_bus()-> int:
	return AudioServer.get_bus_index("Music")
