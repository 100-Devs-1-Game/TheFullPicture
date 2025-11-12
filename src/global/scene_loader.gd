extends Node

@export var skip_main_menu: bool= false

@export var main_menu_scene: PackedScene
@export var map_scene: PackedScene

@export var game_panel_scene: PackedScene


var game_panel: CanvasLayer



func _ready() -> void:
	if OS.is_debug_build() and skip_main_menu:
		goto_map()


func goto_map():
	game_panel= game_panel_scene.instantiate()
	get_tree().root.add_child.call_deferred(game_panel)
	get_tree().change_scene_to_packed.call_deferred(map_scene)
