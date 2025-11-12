extends Node

@export var skip_main_menu: bool= false

@export var main_menu_scene: PackedScene
@export var map_scene: PackedScene

@export var game_panel_scene: PackedScene


var game_panel: CanvasLayer



func _ready() -> void:
	if OS.is_debug_build() and skip_main_menu:
		goto_map.call_deferred()


func goto_map():
	game_panel= game_panel_scene.instantiate()
	get_tree().root.add_child(game_panel)
	get_tree().change_scene_to_packed(map_scene)
