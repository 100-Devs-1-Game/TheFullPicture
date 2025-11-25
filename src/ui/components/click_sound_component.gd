class_name ClickSoundComponent
extends Node

@export var click_sound: AudioStream
@export var release_sound: AudioStream

@onready var click_sound_player: AudioStreamPlayer = $ClickSoundPlayer
@onready var release_sound_player: AudioStreamPlayer = $ReleaseSoundPlayer



func _ready() -> void:
	get_parent().tree_exiting.connect(on_delete)

	if click_sound:
		initialize_player(click_sound_player, click_sound)

		var sig: Signal
		if get_parent() is BaseButton:
			sig= (get_parent() as BaseButton).pressed
		elif get_parent() is Slider:
			sig= (get_parent() as Slider).drag_started
		else:
			assert(false)
			
		sig.connect(func(): click_sound_player.play())
	
	if release_sound:
		initialize_player(release_sound_player, release_sound)

		var sig: Signal
		if get_parent() is Slider:
			sig= (get_parent() as Slider).drag_ended
		else:
			assert(false)
		
		sig.connect(func(_p): release_sound_player.play())


func initialize_player(player: AudioStreamPlayer, sound: AudioStream):
	# HACK this is dirty but shouldnt cause any issues
	# ( low effort way to ensure sound keeps playing on scene switch )
	player.owner= null
	player.reparent.call_deferred(get_tree().root)

	player.stream= sound


func on_delete():
	# HACK ..continued
	if click_sound and click_sound_player.playing:
		click_sound_player.finished.connect(func():
			if is_instance_valid(click_sound_player):
				click_sound_player.queue_free())
	else:
		click_sound_player.queue_free()
	release_sound_player.queue_free()
