extends Node

@export var disable_start: bool= false
@export var skip_main_menu: bool= false
@export var disable_music: bool= false

@export var main_menu_scene: PackedScene
@export var map_scene: PackedScene
@export var sentence_builder_scene: PackedScene

@export var game_panel_scene: PackedScene


var game_panel: CanvasLayer



func _ready() -> void:
	if disable_start:
		return

	if OS.is_debug_build():
		if disable_music:
			AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), true)
		if skip_main_menu:
			goto_map()


func goto_main_menu():
	if game_panel:
		game_panel.queue_free()
	get_tree().change_scene_to_packed.call_deferred(main_menu_scene)


func goto_map():
	ensure_game_panel()
	get_tree().change_scene_to_packed.call_deferred(map_scene)
	MusicPlayer.play_game()
	

func goto_sentence_builder():
	get_tree().change_scene_to_packed.call_deferred(sentence_builder_scene)


func ensure_game_panel():
	if game_panel: return
	game_panel= game_panel_scene.instantiate()
	get_tree().root.add_child.call_deferred(game_panel)
	
