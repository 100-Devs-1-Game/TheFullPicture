class_name HoverComponent
extends Node



func _ready() -> void:
	var control: Control= get_parent()
	assert(control)
	control.mouse_entered.connect(on_mouse_entered)
	control.mouse_exited.connect(on_mouse_exited)


func on_mouse_entered():
	EventManager.mouse_hover.emit()


func on_mouse_exited():
	EventManager.mouse_unhover.emit()
