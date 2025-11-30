class_name CreditsPopup
extends CenterContainer

signal closed



func _on_panel_container_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		hide()
		closed.emit()
