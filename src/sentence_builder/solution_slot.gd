class_name SolutionSlot
extends Label

@export var frame_stylebox: StyleBoxFlat

var clue_button: ClueButton



func fill(button: ClueButton):
	clue_button= button
	text= clue_button.label.text.to_upper()


func _on_mouse_entered() -> void:
	add_theme_stylebox_override("normal", frame_stylebox)


func _on_mouse_exited() -> void:
	add_theme_stylebox_override("normal", StyleBoxEmpty.new())
