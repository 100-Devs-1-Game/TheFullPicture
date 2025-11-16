extends Node

@export var icon_default: Texture2D
@export var icon_hover: Texture2D
@export var icon_drag: Texture2D



func _ready() -> void:
	EventManager.mouse_hover.connect(on_mouse_hover)
	EventManager.mouse_unhover.connect(on_mouse_reset)
	EventManager.mouse_drag.connect(on_mouse_drag)
	EventManager.mouse_release.connect(on_mouse_reset)

	Input.set_custom_mouse_cursor(icon_hover, Input.CURSOR_POINTING_HAND)


func _process(_delta: float) -> void:
	if Input.is_action_just_released("drag"):
		on_mouse_reset()


func on_mouse_hover():
	if Input.is_action_pressed("drag"):
		return
	Input.set_custom_mouse_cursor(icon_hover)


func on_mouse_drag():
	Input.set_custom_mouse_cursor(icon_drag)


func on_mouse_reset():
	if Input.is_action_pressed("drag"):
		return
	Input.set_custom_mouse_cursor(icon_default)
