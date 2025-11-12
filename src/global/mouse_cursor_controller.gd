extends Node

@export var icon_default: Texture2D
@export var icon_hover: Texture2D
@export var icon_drag: Texture2D



func _ready() -> void:
	EventManager.mouse_hover.connect(on_mouse_hover)
	EventManager.mouse_unhover.connect(on_mouse_reset)
	EventManager.mouse_drag.connect(on_mouse_drag)
	EventManager.mouse_release.connect(on_mouse_reset)


func on_mouse_hover():
	Input.set_custom_mouse_cursor(icon_hover)


func on_mouse_drag():
	Input.set_custom_mouse_cursor(icon_drag)


func on_mouse_reset():
	Input.set_custom_mouse_cursor(icon_default)
