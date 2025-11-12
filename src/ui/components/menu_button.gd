extends TextureButton

@export var label_hover_color: Color= Color.RED

@onready var label: Label = $Label
@onready var label_default_color: Color= label.label_settings.font_color



func _on_mouse_entered() -> void:
	label.label_settings.font_color= label_hover_color


func _on_mouse_exited() -> void:
	label.label_settings.font_color= label_default_color
