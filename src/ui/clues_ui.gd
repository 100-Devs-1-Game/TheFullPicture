class_name CluesUI
extends Control

@onready var label: RichTextLabel = %RichTextLabel
@onready var audio_player_open: AudioStreamPlayer = $"AudioStreamPlayer Open"
@onready var audio_player_clue: AudioStreamPlayer = $"AudioStreamPlayer Clue"

var data: InteractableObjectData



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


func close():
	hide()
	EventManager.clues_ui_closed.emit()


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
