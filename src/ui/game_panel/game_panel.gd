extends CanvasLayer

@onready var map_button: TextureButton = %"Map Button"


func _on_settings_button_pressed() -> void:
	pass # Replace with function body.


func _on_sentence_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		SceneLoader.goto_sentence_builder()


func _on_map_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		SceneLoader.goto_map()
