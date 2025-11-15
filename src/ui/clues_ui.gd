class_name CluesUI
extends Control

@onready var label: RichTextLabel = %RichTextLabel

var data: InteractableObjectData



func _ready() -> void:
	EventManager.open_clues_ui.connect(on_open)


func update():
	assert(data)
	label.text= data.parse()


func _input(event: InputEvent):
	if not visible:
		return
		
	if event is InputEventMouseButton:
		if event.pressed:
			hide()
			EventManager.clues_ui_closed.emit()


func on_open(p_data: InteractableObjectData):
	assert(not visible)
	data= p_data
	update()
	show()


func _on_rich_text_label_meta_hover_started(_meta: Variant) -> void:
	EventManager.mouse_hover.emit()


func _on_rich_text_label_meta_hover_ended(_meta: Variant) -> void:
	EventManager.mouse_unhover.emit()


func _on_rich_text_label_meta_clicked(meta: Variant) -> void:
	pass # Replace with function body.
