extends Node

const FADE_DURATION= 1.0

var players: Array[AudioStreamPlayer]



func _ready() -> void:
	for child in get_children():
		players.append(child)


func play(player: AudioStreamPlayer):
	if player.playing:
		return
	
	for other_player in players:
		if other_player.playing:
			var fade_out:= create_tween()
			fade_out.tween_property(other_player, "volume_linear", 0.0, FADE_DURATION)
			fade_out.tween_callback(other_player.stop)
			break

	player.volume_linear= 0
	var fade_in:= create_tween()
	player.play()
	fade_in.tween_property(player, "volume_linear", 1.0, FADE_DURATION)


func play_menu():
	play($Menu)


func play_game():
	play($Game)


func play_sentence():
	play($Sentence)
