class_name SentenceBuilder
extends Control

@export var clue_button_scene: PackedScene

@onready var clues: GridContainer = %Clues
@onready var solution: Control = %Solution

var solution_items: Array[Label]
var dragging_button: ClueButton
var drag_texture: TextureRect
var hover_slot: SolutionSlot



func _ready() -> void:
	for slot: SolutionSlot in solution.get_children():
		slot.mouse_entered.connect(on_hover_slot.bind(slot))
		slot.mouse_exited.connect(func(): hover_slot= null)
		slot.text= ""
		solution_items.append(slot)

	for child in clues.get_children():
		clues.remove_child(child)
		child.queue_free()
	
	var grid_pos: Vector2i
	for clue in GameData.current_stage.clues:
		@warning_ignore("integer_division")
		while (grid_pos.x + grid_pos.y) % 2 > 0:
			clues.add_child(Control.new())
			grid_pos= advance_grid_pos(grid_pos)
			
		var button: ClueButton= clue_button_scene.instantiate()
		clues.add_child(button)
		button.set_clue(clue)
		button.start_dragging.connect(on_start_dragging)
		grid_pos= advance_grid_pos(grid_pos)


func _process(_delta: float) -> void:
	if dragging_button:
		if Input.is_action_just_released("drag"):
			if hover_slot:
				hover_slot.fill(dragging_button)
			else:
				dragging_button.return_button()
			drag_texture.queue_free()
			dragging_button= null
		else:
			drag_texture.position= get_global_mouse_position()


func advance_grid_pos(grid_pos: Vector2i)-> Vector2i:
	grid_pos.x+= 1
	if grid_pos.x > 1:
		grid_pos.y+= 1
		grid_pos.x= 0
	return grid_pos


func on_start_dragging(button: ClueButton):
	dragging_button= button
	drag_texture= button.duplicate(0)
	drag_texture.z_index= 100
	drag_texture.mouse_filter= Control.MOUSE_FILTER_IGNORE
	get_tree().root.add_child(drag_texture)
	EventManager.mouse_drag.emit()


func on_hover_slot(slot: SolutionSlot):
	hover_slot= slot
	
