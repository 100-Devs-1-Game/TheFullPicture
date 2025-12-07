class_name CluesUI
extends Control

@onready var label: RichTextLabel = %RichTextLabel
@onready var audio_player_open: AudioStreamPlayer = $"AudioStreamPlayer Open"
@onready var audio_player_clue: AudioStreamPlayer = $"AudioStreamPlayer Clue"
@onready var audio_player_voice: AudioStreamPlayer = $"AudioStreamPlayer Voice"

var data: InteractableObjectData
var fade_tween: Tween



func _ready() -> void:
	EventManager.open_clues_ui.connect(on_open)


func update():
	assert(data)
	label.text= data.parse()


func _input(event: InputEvent):
	if not visible:
		return
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			close()


func on_open(p_data: InteractableObjectData):
	assert(not visible)
	data= p_data
	audio_player_open.play()
	update()
	show()
	await get_tree().create_timer(0.25).timeout
	if not visible:
		return
	if fade_tween and fade_tween.is_running():
		fade_tween.kill()
		audio_player_voice.volume_db= 0
	audio_player_voice.stop()
	audio_player_voice.stream= data.audio
	audio_player_voice.play()
	

func close():
	hide()
	EventManager.clues_ui_closed.emit()
	if audio_player_voice.playing:
		assert(not fade_tween or not fade_tween.is_running())
		fade_tween= create_tween()
		fade_tween.tween_property(audio_player_voice, "volume_linear", 0.0, 0.5)
		fade_tween.tween_callback(func(): audio_player_voice.stop())


func _on_rich_text_label_meta_hover_started(_meta: Variant) -> void:
	EventManager.mouse_hover.emit()


func _on_rich_text_label_meta_hover_ended(_meta: Variant) -> void:
	EventManager.mouse_unhover.emit()


func _on_rich_text_label_meta_clicked(meta: Variant) -> void:
	prints("Clicked on clue", meta)
	var clue: ClueData= GameData.clues[meta]
	clue.discovered= true
	audio_player_clue.play()
	update()


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT:
				close()
