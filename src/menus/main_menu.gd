extends Control

@onready var settings_popup: SettingsPopup = $SettingsPopup



func _ready() -> void:
	settings_popup.hide()
	MusicPlayer.play_menu()


func _on_start_button_pressed() -> void:
	SceneLoader.goto_map()


func _on_settings_button_pressed() -> void:
	settings_popup.open()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
