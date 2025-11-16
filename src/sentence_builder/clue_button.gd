class_name ClueButton
extends TextureRect

signal start_dragging(clue_button: ClueButton)

@onready var label: Label = %Label



func set_clue(clue: ClueData):
	label.text= clue.word


func return_button():
	modulate= Color.WHITE


func _on_label_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			start_dragging.emit(self)
			modulate= Color.TRANSPARENT
