class_name SettingsPopup
extends CenterContainer

signal closed

@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_slider: HSlider = %SFXSlider
@onready var voice_slider: HSlider = %VoiceSlider

@onready var fullscreen_check_box: CheckBox = %FullscreenCheckBox



func open():
	music_slider.value= GameSettings.music_volume
	sfx_slider.value= GameSettings.sfx_volume
	voice_slider.value= GameSettings.voice_volume
	fullscreen_check_box.button_pressed= GameSettings.fullscreen
	show()


func _on_save_button_pressed() -> void:
	GameSettings.music_volume= music_slider.value
	GameSettings.sfx_volume= sfx_slider.value
	GameSettings.voice_volume= voice_slider.value
	GameSettings.fullscreen= fullscreen_check_box.button_pressed
	GameSettings.save_settings()
	hide()
	closed.emit()


func _on_cancel_button_pressed() -> void:
	hide()
	closed.emit()
