extends Control

@onready var settings_popup: SettingsPopup = $SettingsPopup
@onready var tutorial_popup: TutorialPopup = $TutorialPopup
@onready var quit_button: TextureButton = $VBoxContainer/QuitButton
@onready var blocking_overlay: PanelContainer = $BlockingOverlay



func _ready() -> void:
	if OS.get_name() == "Web":
		quit_button.hide()
	
	settings_popup.hide()
	MusicPlayer.play_menu()


func _on_start_button_pressed() -> void:
	SceneLoader.goto_map()


func _on_settings_button_pressed() -> void:
	blocking_overlay.show()
	settings_popup.open()
	settings_popup.closed.connect(on_popup_closed)
	

func _on_tutorial_button_pressed() -> void:
	blocking_overlay.show()
	tutorial_popup.show()
	tutorial_popup.closed.connect(on_popup_closed)


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func on_popup_closed():
	blocking_overlay.hide()
