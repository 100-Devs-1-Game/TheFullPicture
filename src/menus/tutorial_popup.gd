class_name TutorialPopup
extends CenterContainer


signal closed



func _on_close_button_pressed() -> void:
	hide()
	closed.emit()
