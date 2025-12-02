extends Node

const FADE_DURATION= 1.0

var players: Array[AudioStreamPlayer]
var tweens: Dictionary[AudioStreamPlayer, Tween]



func _ready() -> void:
	for child in get_children():
		players.append(child)
		#tweens[child as AudioStreamPlayer]= null


func play(player: AudioStreamPlayer):
	for every_player in players:
		every_player.stop()
	player.play()

	#if player.playing:
		#return
	#
	#for other_player in players:
		#if other_player != player and other_player.playing:
			#if tweens[other_player] and tweens[other_player].is_running():
				#tweens[other_player].kill()
			#tweens[other_player]= create_tween()
			#tweens[other_player].tween_property(other_player, "volume_linear", 0.0, FADE_DURATION)
			#tweens[other_player].tween_callback(other_player.stop)
			#break
#
	#player.volume_linear= 0
	#if tweens[player] and tweens[player].is_running():
		#tweens[player].kill()
	#tweens[player]= create_tween()
	#player.play()
	#tweens[player].tween_property(player, "volume_linear", 1.0, FADE_DURATION)


func play_menu():
	play($Menu)


func play_game():
	play($Game)


func play_sentence():
	play($Sentence)
