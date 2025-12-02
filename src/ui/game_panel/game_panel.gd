class_name GamePanel
extends CanvasLayer

@export var checkbox_scene: PackedScene

@onready var map_button: TextureButton = %"Map Button"
@onready var checkbox_grid: GridContainer = %"Checkbox GridContainer"



func _ready() -> void:
	EventManager.entered_next_stage.connect(update_check_boxes)
	update_check_boxes()


func update_check_boxes():
	for child in checkbox_grid.get_children():
		checkbox_grid.remove_child(child)
		child.queue_free()

	var current_stage:= GameData.current_stage
	
	for i in current_stage.clues.size() - current_stage.initially_discovered_clues:
		var child: CheckBox= checkbox_scene.instantiate()
		checkbox_grid.add_child(child)
		if i in GameData.saved_checkboxes:
			child.button_pressed= true


func _on_sentence_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		SceneLoader.goto_sentence_builder()


func _on_map_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		SceneLoader.goto_map()


func _on_menu_button_pressed() -> void:
	SceneLoader.goto_main_menu()
