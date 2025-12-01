class_name SolutionSlot
extends Label

signal remove_clue(button: ClueButton)

@export var stage: int= 0
@export var frame_stylebox: StyleBoxFlat

var clue_button: ClueButton



func fill(button: ClueButton):
	clue_button= button
	text= clue_button.label.text.to_upper()


func _on_mouse_entered() -> void:
	add_theme_stylebox_override("normal", frame_stylebox)


func _on_mouse_exited() -> void:
	add_theme_stylebox_override("normal", StyleBoxEmpty.new())


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			if clue_button:
				remove_clue.emit(clue_button)
				clue_button= null
				text= ""
