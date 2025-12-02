class_name ClueButton
extends TextureRect

signal start_dragging(clue_button: ClueButton)

@onready var label: Label = %Label
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

var data: ClueData



func set_clue(clue: ClueData):
	data= clue
	label.text= clue.word.to_upper()


func return_button():
	modulate= Color.WHITE


func _on_label_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			start_dragging.emit(self)
			modulate= Color.TRANSPARENT
			audio_player.play()
